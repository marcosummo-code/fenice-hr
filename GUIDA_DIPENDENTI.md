#  GUIDA ALL'USO - App Timbrature Fenice

Benvenuto nell'app per la gestione delle presenze! Questa guida ti spiega come utilizzare tutte le funzionalità.

##  Indice
1. [Login](#login)
2. [Schermata Principale](#schermata-principale)
3. [Effettuare Timbrature](#effettuare-timbrature)
4. [Turni Multipli](#turni-multipli)
5. [Le Mie Ferie](#le-mie-ferie)
6. [Richiedere Ferie/Permessi](#richiedere-feriepermessi)
7. [Notifiche](#notifiche)
8. [Mappa Timbrature](#mappa-timbrature)
9. [Storico](#storico)
10. [Export Timbrature](#export-timbrature)
11. [Modalità Offline](#modalità-offline)

---

## 🔐 Login

### Primo Accesso
1. Apri l'app
2. Inserisci il **PIN** che ti è stato fornito
3. Premi **ACCEDI**

### Accesso Offline
- Se non c'è connessione internet, puoi accedere comunque
- L'app userà le credenziali dell'ultimo accesso
- Le timbrature verranno salvate e sincronizzate quando tornerà la connessione

---

## 🏠 Schermata Principale

Dopo il login vedrai:

### In Alto
- **Orologio**: ora e data attuali
- **Stato sincronizzazione**: indica se le timbrature sono sincronizzate col server

### Al Centro
- **Card Stato**: mostra la tua situazione attuale
  - "Giornata non iniziata" - Nessun turno oggi
  - "Al lavoro" - Turno in corso
  - "In pausa" - Pausa in corso
  - "Turno terminato" - Turno completato

### Pulsanti Timbratura
- **ENTRATA** (verde): inizia il turno
- **USCITA** (rosso): termina il turno
- **PAUSA** (arancione): inizia pausa
- **FINE PAUSA** (blu): termina pausa

### In Basso
- **Contatore**: numero di timbrature da sincronizzare
- **Pulsante SINCRONIZZA ORA**: forza la sincronizzazione manuale

---

##  Effettuare Timbrature

### Sequenza Corretta

1. **ENTRATA** → Inizia la giornata lavorativa
   - Si attiva il GPS per registrare la posizione
   - La card mostra "Al lavoro" con l'orario di entrata

2. **PAUSA** → Inizia la pausa pranzo/caffè
   - Disponibile solo dopo ENTRATA o FINE PAUSA
   - La card mostra "In pausa"

3. **FINE PAUSA** → Riprendi il lavoro
   - Disponibile solo dopo PAUSA
   - La card mostra "Ripreso lavoro"

4. **USCITA** → Termina la giornata
   - Disponibile solo dopo ENTRATA o FINE PAUSA
   - La card mostra "Turno terminato"

### Regole Importanti
✅ I pulsanti si abilitano/disabilitano automaticamente in base allo stato
✅ Ogni timbratura registra automaticamente:
   - Data e ora
   - Posizione GPS (indirizzo)
   - Tipo di timbratura

❌ Non puoi timbrare se sei in ferie/permesso/malattia
 Non puoi fare ENTRATA se sei già entrato (devi prima fare USCITA)

---

## 🔄 Turni Multipli

Puoi fare **più turni nella stessa giornata**:

### Esempio: Turno Mattina + Turno Pomeridiano

1. **Mattina**:
   - ENTRATA → 08:00
   - PAUSA → 12:00
   - FINE PAUSA → 13:00
   - USCITA → 14:00

2. **Pomeriggio**:
   - ENTRATA → 15:00 (di nuovo attivo!)
   - USCITA → 19:00

La card mostrerà:
- "Turno 1 completato" dopo la prima uscita
- "Turno 2" quando rientri

---

## 🏖️ Le Mie Ferie

Premi l'icona **🏖️** nell'AppBar per vedere:

### Saldo Attuale
- **Ferie**: giorni disponibili, usati e rimanenti
- **Permessi (ROL)**: ore disponibili, usate e rimanenti
- **Malattia**: giorni usati

### Come Funziona il Calcolo
- **Saldo Iniziale**: valore impostato dall'ultima busta paga
- **Maturazione Mensile**: 
  - Ferie: +2.5 giorni/mese
  - Permessi: +6.33 ore/mese
- **Disponibili**: Saldo Iniziale + Maturati - Usati

### Storico Richieste
Vedi tutte le tue richieste con:
- Tipo (Ferie/Permesso/Malattia)
- Date (dal/al)
- Numero di giorni
- Stato:
  - 🟡 **In attesa** - Da approvare
  - 🟢 **Approvata** - Confermata
  - 🔴 **Rifiutata** - Non approvata (con motivo)

---

##  Richiedere Ferie/Permessi

1. Nella schermata "Le mie Ferie", premi **"Nuova richiesta"**
2. Seleziona il **tipo**:
   - 🏖️ Ferie
   - ⏰ Permesso
3. Seleziona le **date**:
   - Data inizio
   - Data fine
   - Vedi automaticamente il totale giorni
4. Aggiungi **note** (opzionale):
   - Es: "Matrimonio", "Visita medica"
5. Premi **"INVIA RICHIESTA"**

### Cosa Succede Dopo
✅ La richiesta viene inviata all'admin
✅ Riceverai una **notifica** quando verrà approvata o rifiutata
✅ Lo stato nella lista cambierà da "In attesa" a "Approvata/Rifiutata"

⚠️ **Importante**: Se sei in ferie approvate, **non puoi timbrare**

---

## 🔔 Notifiche

Premi l'icona **🔔** nell'AppBar per vedere le notifiche.

### Tipi di Notifiche
- ✅ **Ferie approvate**: la tua richiesta è stata accettata
- ❌ **Ferie rifiutate**: la tua richiesta è stata rifiutata (con motivo)
-  **Altre comunicazioni** dall'admin

### Gestione
- Le notifiche **non lette** hanno sfondo colorato
- Premi l'icona ✉️ per segnare come letta
- Il **badge rosso** sull'icona indica quante notifiche non hai letto

---

## 🗺️ Mappa Timbrature

Premi l'icona **🗺️** per vedere sulla mappa dove hai timbrato.

### Funzionalità
- **Marker colorati**:
  -  Verde = ENTRATA
  - 🔴 Rosso = USCITA
  - 🟠 Arancione = INIZIO PAUSA
  - 🔵 Blu = FINE PAUSA

- **Filtra periodo**:
  - Ultimi 7 giorni
  - Ultimi 30 giorni
  - Ultimi 3 mesi
  - Ultimo anno

- **Clicca un marker** per vedere:
  - Tipo di timbratura
  - Data e ora
  - Indirizzo completo
  - Coordinate GPS
  - Stato sincronizzazione

- **Lista in basso**: scorri per vedere tutte le timbrature

---

## 📜 Storico

Premi l'icona **📜** per vedere l'elenco completo delle tue timbrature.

### Visualizzazione
- Ordinate dalla più recente alla più vecchia
- Ogni timbratura mostra:
  - Icona colorata per tipo
  - Tipo (Entrata/Uscita/Pausa)
  - Data e ora
  - Stato sincronizzazione:
    - 🟢 Cloud = sincronizzata
    - 🟠 Cloud off = solo in locale

- **Pull-to-refresh**: trascina giù per aggiornare

---

##  Export Timbrature

Premi l'icona **📥** per esportare le tue timbrature in Excel.

### Procedura
1. Premi l'icona download
2. L'app crea un file Excel (.xlsx) con:
   - Nome file: `Timbrature_COGNOME_GGMMYYYY.xlsx`
   - Colonne: Data, Ora, Tipo, Posizione
3. Si apre la condivisione:
   - Puoi inviare via email
   - Salvare su Google Drive
   - Condividere su WhatsApp
   - ecc.

### Quando Usarlo
✅ Per tenere traccia personale
✅ Per inviare all'ufficio personale
✅ Per verifiche personali

---

## 📴 Modalità Offline

L'app funziona **anche senza internet**!

### Cosa Puoi Fare Offline
✅ Accedere con il PIN (se hai già effettuato almeno un login online)
✅ Effettuare timbrature
✅ Vedere storico locale
✅ Esportare timbrature

### Cosa NON Puoi Fare Offline
❌ Vedere ferie aggiornate
❌ Richiedere nuove ferie
❌ Vedere notifiche nuove
❌ Sincronizzare timbrature

### Sincronizzazione Automatica
Quando torni online:
1. L'app sincronizza automaticamente le timbrature
2. Vedi il contatore delle timbrature in sospeso
3. Premi "SINCRONIZZA ORA" per forzare la sincronizzazione

---

## 💡 Consigli Utili

### GPS
- **Attiva sempre il GPS** prima di timbrare
- Le timbrature senza GPS vengono registrate ma senza posizione
- Per precisione massima, aspetta qualche secondo dopo aver premuto il pulsante

### Connessione
- Se possibile, timbra quando hai connessione internet
- Le timbrature offline sono salvate ma devi ricordarti di sincronizzare

### Turni Multipli
- Dopo USCITA, ENTRATA si riattiva per un nuovo turno
- Puoi fare tutti i turni che vuoi nella stessa giornata

### Ferie
- Richiedi le ferie con anticipo
- Controlla sempre il saldo prima di richiedere
- Se sei in ferie, non puoi timbrare

---

## 🆘 Problemi Comuni

### "PIN non valido"
- Verifica di aver inserito il PIN corretto
- Se non ricordi il PIN, chiedi all'admin

### "Non puoi timbrare: sei in ferie"
- Controlla nella sezione "Le mie Ferie" se hai ferie approvate in questa data
- Se è un errore, contatta l'admin

### "Posizione non disponibile"
- Attiva il GPS nelle impostazioni del telefono
- Riprova la timbratura
- La timbratura viene registrata comunque, ma senza posizione

### Timbrature non sincronizzate
- Verifica la connessione internet
- Premi "SINCRONIZZA ORA"
- Se il problema persiste, riavvia l'app

### App lenta o bloccata
- Chiudi e riapri l'app
- Verifica di avere spazio sul telefono
- Controlla aggiornamenti dell'app

---

## 📞 Supporto

Per problemi o domande:
- Contatta l'ufficio personale
- Contatta l'amministratore del sistema

---

**Buon lavoro! 🚀**
