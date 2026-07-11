import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../models/dipendente.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pinController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (_pinController.text.isEmpty) {
      setState(() => _errorMessage = 'Inserisci il PIN');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // 1. Prova prima il login online
    Dipendente? dipendente = await ApiService.login(_pinController.text);

    // 2. Se online fallisce, prova il login offline
    if (dipendente == null) {
      dipendente = await DatabaseService.getUtenteLocale(_pinController.text);
      
      if (dipendente != null) {
        // Login offline riuscito
        print('Login offline riuscito per ${dipendente.nomeCompleto}');
      }
    } else {
      // Login online riuscito, salva in locale per il prossimo accesso offline
      await DatabaseService.salvaUtenteLocale(dipendente, _pinController.text);
    }

    setState(() => _isLoading = false);

    if (dipendente != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(dipendente: dipendente!),
        ),
      );
    } else {
      setState(() => _errorMessage = 'PIN non valido o errore di connessione');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.access_time_filled,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              const Text(
                'Fenice - Gestione Presenze',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'PIN',
                  hintText: 'Inserisci il tuo PIN',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('ACCEDI'),
              ),
              const SizedBox(height: 16),
              const Text(
                '💡 Se non c\'è connessione, puoi accedere con il PIN usato l\'ultima volta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}
