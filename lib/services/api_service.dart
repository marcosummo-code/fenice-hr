import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/dipendente.dart';
import '../models/timbratura.dart';

class ApiService {
  static Future<Dipendente?> login(String pin) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/login'),
            headers: {
              'Content-Type': 'application/json',
              'x-api-token': ApiConfig.apiToken,
            },
            body: jsonEncode({'pin': pin}),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['successo'] == true) {
          return Dipendente.fromJson(data['utente']);
        }
      }
      return null;
    } catch (e) {
      print('Errore login: $e');
      return null;
    }
  }

  static Future<bool> inviaTimbratura(Timbratura timbratura) async {
    try {
      print('Chiamata API: ${ApiConfig.baseUrl}/timbra');

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/timbra'),
            headers: {
              'Content-Type': 'application/json',
              'x-api-token': ApiConfig.apiToken,
            },
            body: jsonEncode({
              'dipendente_id': timbratura.dipendenteId,
              'tipo': timbratura.tipo,
              'data_ora_locale': timbratura.dataOra.toIso8601String(),
              'latitudine': timbratura.latitudine,
              'longitudine': timbratura.longitudine,
              'indirizzo': timbratura.indirizzo,
            }),
          )
          .timeout(const Duration(seconds: 5));

      print('Risposta API: ${response.statusCode}');
      print('Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Errore invio timbratura: $e');
      return false;
    }
  }

  // Aggiungi questo metodo per verificare ferie
  static Future<Map<String, dynamic>> verificaFerie(int dipendenteId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/verifica-ferie/$dipendenteId'),
            headers: {'x-api-token': ApiConfig.apiToken},
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'in_ferie': false};
    } catch (e) {
      print('Errore verifica ferie: $e');
      return {'in_ferie': false};
    }
  }

  static Future<List<Timbratura>> getStorico(int dipendenteId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/storico/$dipendenteId'),
            headers: {'x-api-token': ApiConfig.apiToken},
          )
          .timeout(Duration(seconds: ApiConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Timbratura.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Errore recupero storico: $e');
      return [];
    }
  }

  static Future<bool> checkConnessione() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/health'))
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
