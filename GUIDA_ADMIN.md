# GUIDA ADMIN - Pannello Web Timbrature Fenice

Benvenuto nel pannello di amministrazione! Questa guida ti spiega come gestire dipendenti, ferie, timbrature e configurazioni.

## Indice
1. [Accesso al Pannello](#accesso-al-pannello)
2. [Dashboard](#dashboard)
3. [Gestione Dipendenti](#gestione-dipendenti)
4. [Gestione Ferie/Permessi](#gestione-feriepermessi)
5. [Calendario Ferie](#calendario-ferie)
6. [Mappa Timbrature](#mappa-timbrature)
7. [Statistiche](#statistiche)
8. [Configurazione Maturazione](#configurazione-maturazione)
9. [Configurazione Azienda](#configurazione-azienda)
10. [Notifiche](#notifiche)

---

## 🔐 Accesso al Pannello

### URL di Accesso




### Credenziali
- **Username**: admin
- **Password**: Fenice2026

### Sicurezza
- La sessione dura 8 ore
- Dopo l'accesso, puoi navigare liberamente tra le pagine
- Per uscire, clicca il pulsante "Esci" in alto a destra

---

## 🏠 Dashboard

La dashboard mostra una panoramica completa della situazione aziendale.

### Statistiche Rapide
- **Timbrature Totali**: numero di tutte le timbrature registrate
- **Dipendenti**: numero di dipendenti attivi
- **In Ferie/Permesso**: dipendenti attualmente in ferie o permesso
- **Da Approvare**: richieste di ferie in attesa di approvazione

### Filtri Timbrature
Puoi filtrare le timbrature per:
- **Nome Dipendente**: cerca per nome o cognome
- **Data**: seleziona una data specifica

### Tabella Timbrature
Mostra tutte le timbrature con:
- **Dipendente**: nome e cognome
- **Stato**: 
  - 🟢 Normale
  - 🟡 Timbratura durante ferie (anomalia)
- **Tipo**: Entrata/Uscita/Inizio Pausa/Fine Pausa
- **Data e Ora**
- **Posizione**: indirizzo completo (se disponibile)

### Azioni Rapide
- **Export CSV**: esporta le timbrature filtrate in formato CSV

---

## 👥 Gestione Dipendenti

### Visualizzare Dipendenti
Lista completa di tutti i dipendenti con:
- Nome e cognome
- PIN di accesso
- Ruolo
- Azioni disponibili

### Aggiungere un Nuovo Dipendente
1. Clicca **"Aggiungi Dipendente"**
2. Compila i campi:
   - **Nome** (obbligatorio)
   - **Cognome** (obbligatorio)
   - **PIN** (obbligatorio, alfanumerico)
   - **Ruolo** (es. Operaio, Impiegato, Manager)
3. Clicca **"Aggiungi"**

### Modificare un Dipendente
1. Clicca l'icona **matita** 🖊️ sul dipendente
2. Modifica i campi necessari
3. Clicca **"Salva"**

### Eliminare un Dipendente
1. Clicca l'icona **cestino** 🗑️ sul dipendente
2. Conferma l'eliminazione

⚠️ **Attenzione**: L'eliminazione è permanente e rimuove tutte le timbrature associate.

### Configurare Maturazione Ferie
1. Clicca l'icona **grafico** 📊 sul dipendente
2. Verrai portato alla pagina "Configurazione Maturazione"
3. Vedi sezione [Configurazione Maturazione](#configurazione-maturazione)

---

## 🏖️ Gestione Ferie/Permessi

### Visualizzare Ferie
Lista completa di tutte le ferie/permessi con:
- **Dipendente**
- **Tipo**: Ferie/Permesso/Malattia
- **Date**: dal/al
- **Giorni**: numero di giorni
- **Stato**: 
  - 🟡 In Attesa (richiesta da approvare)
  - 🟢 Approvata
  - 🔴 Rifiutata
- **Note**
- **Azioni**

### Filtri
- **Dipendente**: filtra per dipendente specifico
- **Stato**: filtra per stato (In Attesa/Approvate/Rifiutate)
- **Anno**: seleziona l'anno

### Aggiungere Ferie/Permessi
1. Nella colonna di sinistra, compila il form:
   - **Dipendente**: seleziona il dipendente
   - **Tipo**: Ferie/Permesso/Malattia
   - **Data inizio**
   - **Data fine**
   - **Stato iniziale**:
     - "Richiesta" (da approvare)
     - "Approvata direttamente" (se vuoi approvarla subito)
   - **Note** (opzionale)
2. Clicca **"Aggiungi"**

### Approvare una Richiesta
1. Trova la richiesta con stato "In Attesa" (giallo)
2. Clicca l'icona **check** ✅
3. Conferma l'approvazione
4. Il dipendente riceverà una notifica

### Rifiutare una Richiesta
1. Trova la richiesta con stato "In Attesa" (giallo)
2. Clicca l'icona **X** ❌
3. Inserisci il **motivo del rifiuto** (opzionale ma consigliato)
4. Clicca **"Rifiuta"**
5. Il dipendente riceverà una notifica con il motivo

### Modificare Ferie
1. Clicca l'icona **matita** 🖊️ sulla ferie
2. Modifica i campi necessari (dipendente, tipo, date, stato, note)
3. Clicca **"Salva Modifiche"**

### Eliminare Ferie
1. Clicca l'icona **cestino** 🗑️ sulla ferie
2. Conferma l'eliminazione

### Statistiche Dipendente
Quando selezioni un dipendente nei filtri, vedi sulla destra:
- **Ferie**: giorni usati/max con barra di progresso
- **Permessi**: ore usate/max con barra di progresso
- **Malattia**: giorni usati

---

## 📅 Calendario Ferie

Vista mensile di tutte le ferie/permessi approvati.

### Navigazione
- **Freccia sinistra**: mese precedente
- **Freccia destra**: mese successivo
- **Titolo**: mese e anno corrente

### Visualizzazione
- Ogni giorno mostra i dipendenti in ferie con colori unici
- **Colori diversi** per ogni dipendente (generati automaticamente)
- **Emoji** per tipo di assenza:
  - 🏖️ Ferie
  - ⏰ Permesso
  - 🏥 Malattia

### Legenda
In basso vedi:
- **Legenda Dipendenti**: tutti i dipendenti con i loro colori
- **Legenda Tipi**: significato delle emoji

### Giorno Corrente
Il giorno odierno è evidenziato in giallo

---

## 🗺️ Mappa Timbrature

Visualizza tutte le timbrature geolocalizzate sulla mappa.

### Filtri
- **Periodo**: 
  - Ultimi 7 giorni
  - Ultimi 30 giorni
  - Ultimi 3 mesi
  - Ultimo anno
- **Dipendente**: filtra per dipendente specifico o tutti
- **Tipo**: filtra per tipo di timbratura (Entrata/Uscita/Pausa)

### Mappa Interattiva
- **Marker colorati**:
  - 🟢 Verde = Entrata
  - 🔴 Rosso = Uscita
  - 🟠 Arancione = Inizio Pausa
  - 🔵 Blu = Fine Pausa

### Dettagli Timbratura
Clicca su un marker per vedere:
- Tipo di timbratura
- Dipendente
- Data e ora
- Indirizzo completo
- Coordinate GPS

### Lista Laterale
- **Statistiche**: totale timbrature visualizzate
- **Ultime 10**: lista delle ultime timbrature
- Clicca su una timbratura nella lista per centrare la mappa su quel punto

---

## 📊 Statistiche

Report dettagliato delle presenze e ferie.

### Filtro Anno
Seleziona l'anno per cui vuoi vedere le statistiche.

### Statistiche Globali
- **Ferie Totali Azienda**: giorni usati/max totali
- **Permessi Totali**: ore usate/max totali
- **Malattia**: giorni totali
- **Timbrature Totali**: nell'anno selezionato

### Grafico Timbrature per Mese
Grafico a barre che mostra il numero di timbrature per ogni mese dell'anno.

### Dettaglio per Dipendente
Tabella con:
- **Dipendente**: nome e cognome
- **Ferie Usate**: barra di progresso con giorni usati/max
- **Ferie Rimanenti**: giorni disponibili
- **Permessi Usati**: barra di progresso con ore usate/max
- **Permessi Rimanenti**: ore disponibili
- **Malattia**: giorni usati
- **Stato**: 
  - 🟢 OK (meno del 60% delle ferie usate)
  - 🟡 Attenzione (tra 60% e 80%)
  - 🔴 Critico (più dell'80% delle ferie usate)

---

## ⚙️ Configurazione Maturazione

Configura come maturano le ferie e i permessi per ogni dipendente.

### Concetto
Il saldo ferie/permessi si calcola così:

Saldo Attuale = Saldo Iniziale + (maturazione mensile x Mesi della Configurazione) - Giorni Usati



### Configurazione per Dipendente
1. Seleziona il dipendente dal menu a tendina
2. Compila i campi:

#### Data Assunzione
- Data di inizio rapporto di lavoro
- Usata solo come informazione, non per il calcolo

#### Ferie
- **Ferie iniziali (giorni)**: giorni di ferie disponibili al momento della configurazione (es. dall'ultima busta paga)
- **Maturazione mensile (giorni)**: quanti giorni di ferie maturano ogni mese (es. 30/12 = 2.5)

#### Permessi (ROL)
- **Permessi iniziali (ore)**: ore di permesso disponibili al momento della configurazione
- **Maturazione mensile (ore)**: quante ore di permesso maturano ogni mese (es. 76/12 = 6.33)

### Anteprima Calcolo
Sulla destra vedi in tempo reale:
- Data assunzione
- Data inserimento configurazione
- Mesi dalla configurazione
- **Ferie**:
  - Saldo iniziale
  - Maturazione mensile
  - Maturati dalla configurazione
  - Totale disponibile
  - Usati dalla configurazione
  - **DISPONIBILI ORA**
- **Permessi**:
  - Saldo iniziale
  - Maturazione mensile
  - Maturati dalla configurazione
  - Totale disponibile
  - Usati dalla configurazione
  - **DISPONIBILI ORA**

### Salvataggio
Clicca **"Salva Configurazione"** per applicare le modifiche.

---

## 🔧 Configurazione Azienda

Imposta i limiti massimi aziendali per ferie e permessi.

### Parametri
- **Max giorni di ferie per dipendente/anno**: limite massimo di ferie concedibili annualmente (default: 30)
- **Max ore di permesso per dipendente/anno**: limite massimo di ore di permesso concedibili annualmente (default: 40)
- **Anno di riferimento**: anno per il calcolo delle ferie/permessi (default: anno corrente)

### Salvataggio
Clicca **"Salva Configurazione"** per applicare le modifiche.

---

## 🔔 Notifiche

Visualizza tutte le notifiche generate dal sistema.

### Tipi di Notifiche
- **Ferie richieste**: quando un dipendente richiede ferie
- **Ferie approvate**: quando approvi una richiesta
- **Ferie rifiutate**: quando rifiuti una richiesta

### Gestione
- **Notifiche non lette**: sfondo giallo
- **Notifiche lette**: sfondo bianco
- Clicca **"Segna tutte come lette"** per marcare tutte le notifiche come lette

### Informazioni per Notifica
- Tipo di notifica (con icona)
- Titolo
- Messaggio dettagliato
- Dipendente coinvolto
- Data e ora

---

## 💡 Consigli Utili

### Gestione Ferie
- Approva/rifiuta le richieste tempestivamente
- Inserisci sempre il motivo del rifiuto per trasparenza
- Controlla il calendario per evitare sovrapposizioni

### Monitoraggio
- Controlla regolarmente la dashboard per anomalie (timbrature durante ferie)
- Usa la mappa per verificare la correttezza delle posizioni
- Monitora le statistiche per identificare dipendenti con poche ferie rimanenti

### Configurazione
- Configura la maturazione per ogni nuovo dipendente
- Aggiorna il saldo iniziale quando necessario (es. inizio anno)
- Controlla che i limiti aziendali siano corretti

### Backup
- Esporta regolarmente le timbrature in CSV
- Fai backup del database MySQL periodicamente

---

## 🆘 Problemi Comuni

### "Errore di connessione al database"
- Verifica che il database MySQL sia attivo
- Controlla le credenziali in `login.php`
- Verifica la connessione tra server web e database

### "Sessione scaduta"
- La sessione dura 8 ore
- Effettua nuovamente il login

### "PIN non valido"
- Verifica che il PIN sia corretto
- Controlla che il dipendente sia attivo nel database

### Timbrature non sincronizzate
- Verifica la connessione internet dell'app
- Chiedi al dipendente di premere "SINCRONIZZA ORA"
- Controlla i log dell'API con `pm2 logs timbrature-api`

### Mappa vuota
- Verifica che le timbrature abbiano coordinate GPS
- Controlla che il servizio di geocoding (Nominatim) sia raggiungibile

---

## 📞 Supporto Tecnico

Per problemi tecnici o malfunzionamenti:
- Controlla i log dell'API: `pm2 logs timbrature-api`
- Controlla i log di Apache: `sudo tail -f /var/log/apache2/error.log`
- Verifica lo stato dei servizi: `pm2 status`

---

**Buon lavoro! 🚀**
