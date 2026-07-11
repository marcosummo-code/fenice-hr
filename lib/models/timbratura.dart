class Timbratura {
  final int? id;
  final int dipendenteId;
  final String tipo;
  final DateTime dataOra;
  final bool sincronizzato;
  final double? latitudine;
  final double? longitudine;
  final String? indirizzo;

  Timbratura({
    this.id,
    required this.dipendenteId,
    required this.tipo,
    required this.dataOra,
    this.sincronizzato = false,
    this.latitudine,
    this.longitudine,
    this.indirizzo,
  });

  factory Timbratura.fromJson(Map<String, dynamic> json) {
    return Timbratura(
      id: json['id'],
      dipendenteId: json['dipendente_id'],
      tipo: json['tipo'],
      dataOra: DateTime.parse(json['data_ora']),
      sincronizzato: true,
      latitudine: json['latitudine']?.toDouble(),
      longitudine: json['longitudine']?.toDouble(),
      indirizzo: json['indirizzo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dipendente_id': dipendenteId,
      'tipo': tipo,
      'data_ora': dataOra.toIso8601String(),
      'latitudine': latitudine,
      'longitudine': longitudine,
      'indirizzo': indirizzo,
    };
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'dipendente_id': dipendenteId,
      'tipo': tipo,
      'data_ora': dataOra.toIso8601String(),
      'sincronizzato': sincronizzato ? 1 : 0,
      'latitudine': latitudine,
      'longitudine': longitudine,
      'indirizzo': indirizzo,
    };
  }

  factory Timbratura.fromLocalJson(Map<String, dynamic> json) {
    return Timbratura(
      id: json['id'],
      dipendenteId: json['dipendente_id'],
      tipo: json['tipo'],
      dataOra: DateTime.parse(json['data_ora']),
      sincronizzato: json['sincronizzato'] == 1,
      latitudine: json['latitudine']?.toDouble(),
      longitudine: json['longitudine']?.toDouble(),
      indirizzo: json['indirizzo'],
    );
  }

  Timbratura copyWith({
    int? id,
    int? dipendenteId,
    String? tipo,
    DateTime? dataOra,
    bool? sincronizzato,
    double? latitudine,
    double? longitudine,
    String? indirizzo,
  }) {
    return Timbratura(
      id: id ?? this.id,
      dipendenteId: dipendenteId ?? this.dipendenteId,
      tipo: tipo ?? this.tipo,
      dataOra: dataOra ?? this.dataOra,
      sincronizzato: sincronizzato ?? this.sincronizzato,
      latitudine: latitudine ?? this.latitudine,
      longitudine: longitudine ?? this.longitudine,
      indirizzo: indirizzo ?? this.indirizzo,
    );
  }

  String get tipoLabel {
    switch (tipo) {
      case 'entrata':
        return 'Entrata';
      case 'uscita':
        return 'Uscita';
      case 'pausa_inizio':
        return 'Inizio Pausa';
      case 'pausa_fine':
        return 'Fine Pausa';
      default:
        return tipo;
    }
  }
}
