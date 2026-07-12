import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/timbratura.dart';
import '../models/dipendente.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'timbrature.db'),
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      singleInstance: true,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE timbrature (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dipendente_id INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        data_ora TEXT NOT NULL,
        sincronizzato INTEGER DEFAULT 0,
        latitudine REAL,
        longitudine REAL,
        indirizzo TEXT
      )
    ''');

    // Tabella per memorizzare l'ultimo utente loggato (login offline)
    await db.execute('''
      CREATE TABLE utente_locale (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        cognome TEXT NOT NULL,
        pin TEXT NOT NULL,
        ruolo TEXT NOT NULL
      )
    ''');
  }

  // Upgrade da versione 1 a 2
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS utente_locale (
          id INTEGER PRIMARY KEY,
          nome TEXT NOT NULL,
          cognome TEXT NOT NULL,
          pin TEXT NOT NULL,
          ruolo TEXT NOT NULL
        )
      ''');
    }
  }

  // ===== TIMBRATURE =====

  static Future<bool> esisteTimbratura(int? id) async {
    if (id == null) return true;

    final db = await database;
    final existing = await db.query(
      'timbrature',
      where: 'id = ?',
      whereArgs: [id],
    );
    return existing.isNotEmpty;
  }

  static Future<void> inserisciTimbraturaSeNonEsiste(
    Timbratura timbratura,
  ) async {
    final db = await database;

    // Verifica se esiste già
    final existing = await db.query(
      'timbrature',
      where: 'id = ?',
      whereArgs: [timbratura.id],
    );

    if (existing.isEmpty) {
      await db.insert('timbrature', timbratura.toLocalJson());
    }
  }

  static Future<int> inserisciTimbratura(Timbratura timbratura) async {
    final db = await database;
    return await db.insert(
      'timbrature',
      timbratura.toLocalJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Timbratura>> getTimbratureNonSincronizzate() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'timbrature',
      where: 'sincronizzato = ?',
      whereArgs: [0],
    );
    return maps.map((json) => Timbratura.fromLocalJson(json)).toList();
  }

  static Future<void> marcaComeSincronizzata(int id) async {
    final db = await database;
    await db.update(
      'timbrature',
      {'sincronizzato': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> aggiornaCoordinateTimbratura(
    int id, {
    double? latitudine,
    double? longitudine,
    String? indirizzo,
  }) async {
    final db = await database;
    final dati = <String, dynamic>{};

    if (latitudine != null) {
      dati['latitudine'] = latitudine;
    }
    if (longitudine != null) {
      dati['longitudine'] = longitudine;
    }
    if (indirizzo != null) {
      dati['indirizzo'] = indirizzo;
    }

    if (dati.isNotEmpty) {
      await db.update('timbrature', dati, where: 'id = ?', whereArgs: [id]);
    }
  }

  static Future<List<Timbratura>> getTutteTimbratureLocali() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'timbrature',
      orderBy: 'data_ora DESC',
    );
    return maps.map((json) => Timbratura.fromLocalJson(json)).toList();
  }

  // Recupera l'ultima timbratura di un dipendente per una data specifica
  static Future<Timbratura?> getUltimaTimbraturaPerData(
    int dipendenteId,
    DateTime data,
  ) async {
    final db = await database;
    final dataInizio = DateTime(data.year, data.month, data.day, 0, 0, 0);
    final dataFine = DateTime(data.year, data.month, data.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      'timbrature',
      where: 'dipendente_id = ? AND data_ora >= ? AND data_ora <= ?',
      whereArgs: [
        dipendenteId,
        dataInizio.toIso8601String(),
        dataFine.toIso8601String(),
      ],
      orderBy: 'data_ora DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Timbratura.fromLocalJson(maps.first);
  }




  // ===== UTENTE LOCALE (per login offline) =====
  static Future<void> salvaUtenteLocale(
    Dipendente dipendente,
    String pin,
  ) async {
    final db = await database;
    // Cancella eventuali utenti precedenti
    await db.delete('utente_locale');
    // Inserisci il nuovo
    await db.insert('utente_locale', {
      'id': dipendente.id,
      'nome': dipendente.nome,
      'cognome': dipendente.cognome,
      'pin': pin,
      'ruolo': dipendente.ruolo,
    });
  }

  static Future<Dipendente?> getUtenteLocale(String pin) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'utente_locale',
      where: 'pin = ?',
      whereArgs: [pin],
    );
    if (maps.isEmpty) return null;
    return Dipendente(
      id: maps[0]['id'],
      nome: maps[0]['nome'],
      cognome: maps[0]['cognome'],
      pin: maps[0]['pin'],
      ruolo: maps[0]['ruolo'],
    );
  }

  static Future<void> clearUtenteLocale() async {
    final db = await database;
    await db.delete('utente_locale');
  }
}
