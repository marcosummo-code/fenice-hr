class Dipendente {
  final int id;
  final String nome;
  final String cognome;
  final String pin;  // <-- AGGIUNGI
  final String ruolo;

  Dipendente({
    required this.id,
    required this.nome,
    required this.cognome,
    required this.pin,  // <-- AGGIUNGI
    required this.ruolo,
  });

  factory Dipendente.fromJson(Map<String, dynamic> json) {
    return Dipendente(
      id: json['id'],
      nome: json['nome'],
      cognome: json['cognome'],
      pin: json['pin'] ?? '',  // <-- AGGIUNGI (default vuoto se non presente)
      ruolo: json['ruolo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cognome': cognome,
      'pin': pin,
      'ruolo': ruolo,
    };
  }

  String get nomeCompleto => '$nome $cognome';
}
