class ApiConfig {
  // URL del tuo reverse proxy
  static const String baseUrl = 'https://fenice.freeddns.it/hr';
  
  // Token di sicurezza (deve corrispondere a API_SECRET nel .env del server)
  static const String apiToken = 'Fenice2026_stringa_per_api';
  
  // Timeout per le richieste HTTP
  static const int timeoutSeconds = 30;
}
