# Script para crear archivos i18n JSON con codificación UTF-8
# SVYD Ledger - PostAuth i18n Implementation

$localesPath = "frontend/src/i18n/locales"

# Francés
$frContent = @'
{
  "welcome": {
    "title": "Bienvenue",
    "subtitle": "Système Comptable Universel",
    "tagline": "Ce système fonctionne: sans codes, sans plan comptable, sans écritures comptables, sans clôtures, sans exercices comptables. Intemporel. Pas besoin de distinguer entre personne physique et personne morale",
    "signIn": "Se Connecter",
    "signUp": "S'inscrire"
  },
  "postAuth": {
    "backButton": "Retour à l'accueil",
    "loggedInAs": "Connecté en tant que:",
    "adminOnly": "Seul l'administrateur peut modifier ce bloc",
    "headers": {
      "createUser": "Créer un Nouvel Utilisateur",
      "userList": "Liste des Utilisateurs",
      "authorizedEmails": "E-MAILS AUTORISÉS",
      "password": "MOT DE PASSE"
    },
    "labels": {
      "nombre": "Nom",
      "id": "Id",
      "idTributario": "ID Fiscal",
      "pais": "Pays",
      "moneda": "Devise",
      "idioma": "Langue"
    },
    "buttons": {
      "entrar": "ENTRER",
      "editar": "MODIFIER",
      "papelera": "CORBEILLE",
      "pagar": "PAYER",
      "saldo": "SOLDE",
      "pagarRegistro": "Payer l'inscription du nouvel utilisateur"
    },
    "messages": {
      "minimumPayment": "Montant minimum de paiement $10",
      "selectUser": "Veuillez sélectionner un utilisateur dans la liste",
      "selectUserEdit": "Veuillez sélectionner un utilisateur à modifier",
      "selectUserDelete": "Veuillez sélectionner un utilisateur à supprimer",
      "selectUserPay": "Veuillez sélectionner un utilisateur à payer",
      "entering": "Entrée dans le système avec l'utilisateur ID:",
      "editing": "Modification de l'utilisateur ID:",
      "movedToTrash": "Utilisateur ID: {id} déplacé vers la corbeille",
      "processingPayment": "Traitement du paiement pour l'utilisateur ID:"
    },
    "tableColumns": {
      "nombre": "NOM",
      "id": "ID",
      "saldo": "$"
    }
  }
}
'@

# Italiano
$itContent = @'
{
  "welcome": {
    "title": "Benvenuto",
    "subtitle": "Sistema Contabile Universale",
    "tagline": "Questo sistema funziona: senza codici, senza piano dei conti, senza scritture contabili, senza chiusure, senza esercizi contabili. Atemporale. Non necessita di distinguere tra persona fisica e persona giuridica",
    "signIn": "Accedi",
    "signUp": "Registrati"
  },
  "postAuth": {
    "backButton": "Torna al Benvenuto",
    "loggedInAs": "Connesso come:",
    "adminOnly": "Solo l'amministratore può modificare questo blocco",
    "headers": {
      "createUser": "Crea Nuovo Utente",
      "userList": "Elenco Utenti",
      "authorizedEmails": "E-MAIL AUTORIZZATE",
      "password": "PASSWORD"
    },
    "labels": {
      "nombre": "Nome",
      "id": "Id",
      "idTributario": "ID Fiscale",
      "pais": "Paese",
      "moneda": "Valuta",
      "idioma": "Lingua"
    },
    "buttons": {
      "entrar": "ENTRA",
      "editar": "MODIFICA",
      "papelera": "CESTINO",
      "pagar": "PAGA",
      "saldo": "SALDO",
      "pagarRegistro": "Paga registrazione nuovo utente"
    },
    "messages": {
      "minimumPayment": "Importo minimo di pagamento $10",
      "selectUser": "Seleziona un utente dall'elenco",
      "selectUserEdit": "Seleziona un utente da modificare",
      "selectUserDelete": "Seleziona un utente da eliminare",
      "selectUserPay": "Seleziona un utente da pagare",
      "entering": "Accesso al sistema con utente ID:",
      "editing": "Modifica utente ID:",
      "movedToTrash": "Utente ID: {id} spostato nel cestino",
      "processingPayment": "Elaborazione pagamento per utente ID:"
    },
    "tableColumns": {
      "nombre": "NOME",
      "id": "ID",
      "saldo": "$"
    }
  }
}
'@

# Alemán
$deContent = @'
{
  "welcome": {
    "title": "Willkommen",
    "subtitle": "Universelles Buchhaltungssystem",
    "tagline": "Dieses System funktioniert: ohne Kontonummern, ohne Kontenplan, ohne Buchungssätze, ohne Abschlüsse, ohne Geschäftsjahre. Zeitlos. Keine Unterscheidung zwischen natürlicher Person und juristischer Person erforderlich",
    "signIn": "Anmelden",
    "signUp": "Registrieren"
  },
  "postAuth": {
    "backButton": "Zurück zur Willkommensseite",
    "loggedInAs": "Angemeldet als:",
    "adminOnly": "Nur der Administrator kann diesen Block bearbeiten",
    "headers": {
      "createUser": "Neuen Benutzer Erstellen",
      "userList": "Benutzerliste",
      "authorizedEmails": "AUTORISIERTE E-MAILS",
      "password": "PASSWORT"
    },
    "labels": {
      "nombre": "Name",
      "id": "Id",
      "idTributario": "Steuernummer",
      "pais": "Land",
      "moneda": "Währung",
      "idioma": "Sprache"
    },
    "buttons": {
      "entrar": "BETRETEN",
      "editar": "BEARBEITEN",
      "papelera": "PAPIERKORB",
      "pagar": "BEZAHLEN",
      "saldo": "SALDO",
      "pagarRegistro": "Registrierung des neuen Benutzers bezahlen"
    },
    "messages": {
      "minimumPayment": "Mindestbetrag $10",
      "selectUser": "Bitte wählen Sie einen Benutzer aus der Liste",
      "selectUserEdit": "Bitte wählen Sie einen Benutzer zum Bearbeiten",
      "selectUserDelete": "Bitte wählen Sie einen Benutzer zum Löschen",
      "selectUserPay": "Bitte wählen Sie einen Benutzer zum Bezahlen",
      "entering": "Systemzugriff mit Benutzer ID:",
      "editing": "Bearbeitung Benutzer ID:",
      "movedToTrash": "Benutzer ID: {id} in den Papierkorb verschoben",
      "processingPayment": "Zahlungsabwicklung für Benutzer ID:"
    },
    "tableColumns": {
      "nombre": "NAME",
      "id": "ID",
      "saldo": "$"
    }
  }
}
'@

# Crear archivos con codificación UTF-8
[System.IO.File]::WriteAllText("$localesPath/fr.json", $frContent, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText("$localesPath/it.json", $itContent, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText("$localesPath/de.json", $deContent, [System.Text.Encoding]::UTF8)

Write-Host "? Created: fr.json, it.json, de.json with UTF-8 encoding" -ForegroundColor Green
