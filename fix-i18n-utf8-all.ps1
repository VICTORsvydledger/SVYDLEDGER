# ==============================================================================
# Script: fix-i18n-utf8-all.ps1
# Descripci�n: Regenera TODOS los archivos i18n con UTF-8 BOM correcto
# Fecha: 2025-01-15
# ==============================================================================

Write-Host "?? Regenerando archivos i18n con UTF-8 correcto..." -ForegroundColor Cyan
Write-Host ""

$localesPath = "frontend/src/i18n/locales"

# Crear directorio si no existe
if (!(Test-Path $localesPath)) {
    New-Item -ItemType Directory -Path $localesPath -Force | Out-Null
}

# ==============================================================================
# IDIOMAS PRINCIPALES (1-7)
# ==============================================================================

# 1. INGL�S (en.json)
Write-Host "? Generando en.json (English)..." -ForegroundColor Green
$enContent = @"
{
  "welcome": {
    "title": "Welcome",
    "subtitle": "Universal Accounting System",
    "tagline": "This system works: without codes, without chart of accounts, without journal entries, without closings, without fiscal periods. Timeless. No need to distinguish between natural person and legal entity",
    "signIn": "Sign In",
    "signUp": "Sign Up"
  },
  "postAuth": {
    "backButton": "Back to Welcome",
    "loggedInAs": "Logged in as:",
    "adminOnly": "Only the administrator can edit this block",
    "headers": {
      "createUser": "Create New User",
      "userList": "User List",
      "authorizedEmails": "AUTHORIZED EMAILS",
      "password": "PASSWORD"
    },
    "labels": {
      "nombre": "Name",
      "id": "Id",
      "idTributario": "Tax ID",
      "pais": "Country",
      "moneda": "Currency",
      "idioma": "Language"
    },
    "buttons": {
      "entrar": "ENTER",
      "editar": "EDIT",
      "papelera": "TRASH",
      "pagar": "PAY",
      "saldo": "BALANCE",
      "pagarRegistro": "Pay for new user registration"
    },
    "messages": {
      "minimumPayment": "Minimum payment amount `$10",
      "selectUser": "Please select a user from the list",
      "selectUserEdit": "Please select a user to edit",
      "selectUserDelete": "Please select a user to delete",
      "selectUserPay": "Please select a user to pay",
      "entering": "Entering system with user ID:",
      "editing": "Editing user ID:",
      "movedToTrash": "User ID: {id} moved to trash",
      "processingPayment": "Processing payment for user ID:"
    },
    "tableColumns": {
      "nombre": "NAME",
      "id": "ID",
      "saldo": "`$"
    }
  }
}
"@
[System.IO.File]::WriteAllText("$localesPath/en.json", $enContent, [System.Text.Encoding]::UTF8)

# 2. ESPA�OL (es.json)
Write-Host "? Generando es.json (Espa�ol)..." -ForegroundColor Green
$esContent = @"
{
  "welcome": {
    "title": "Bienvenido",
    "subtitle": "Sistema de Contabilidad Universal",
    "tagline": "Este sistema trabaja: sin c�digos, sin cat�logos de cuenta, sin asientos contables, sin cierres, sin periodos fiscales. Atemporal. No necesita distinguir entre persona f�sica y persona jur�dica",
    "signIn": "Iniciar Sesi�n",
    "signUp": "Registrarse"
  },
  "postAuth": {
    "backButton": "Volver a Bienvenida",
    "loggedInAs": "Sesi�n iniciada como:",
    "adminOnly": "Solo el administrador puede editar este bloque",
    "headers": {
      "createUser": "Crear Usuario Nuevo",
      "userList": "Lista de Usuarios",
      "authorizedEmails": "CORREOS AUTORIZADOS",
      "password": "CONTRASE�A"
    },
    "labels": {
      "nombre": "Nombre",
      "id": "Id",
      "idTributario": "Id Tributario",
      "pais": "Pa�s",
      "moneda": "Moneda",
      "idioma": "Idioma"
    },
    "buttons": {
      "entrar": "ENTRAR",
      "editar": "EDITAR",
      "papelera": "PAPELERA",
      "pagar": "PAGAR",
      "saldo": "SALDO",
      "pagarRegistro": "Pagar registro de usuario nuevo"
    },
    "messages": {
      "minimumPayment": "Monto m�nimo a pagar `$10",
      "selectUser": "Por favor selecciona un usuario de la lista",
      "selectUserEdit": "Por favor selecciona un usuario para editar",
      "selectUserDelete": "Por favor selecciona un usuario para eliminar",
      "selectUserPay": "Por favor selecciona un usuario para pagar",
      "entering": "Entrando al sistema con usuario ID:",
      "editing": "Editando usuario ID:",
      "movedToTrash": "Usuario ID: {id} movido a la papelera",
      "processingPayment": "Procesando pago para usuario ID:"
    },
    "tableColumns": {
      "nombre": "NOMBRE",
      "id": "ID",
      "saldo": "`$"
    }
  }
}
"@
[System.IO.File]::WriteAllText("$localesPath/es.json", $esContent, [System.Text.Encoding]::UTF8)

# 3. PORTUGU�S (pt.json)
Write-Host "? Generando pt.json (Portugu�s)..." -ForegroundColor Green
$ptContent = @"
{
  "welcome": {
    "title": "Bem-vindo",
    "subtitle": "Sistema de Contabilidade Universal",
    "tagline": "Este sistema funciona: sem c�digos, sem plano de contas, sem lan�amentos cont�beis, sem encerramentos, sem per�odos fiscais. Atemporal. N�o precisa distinguir entre pessoa f�sica e pessoa jur�dica",
    "signIn": "Entrar",
    "signUp": "Cadastrar"
  },
  "postAuth": {
    "backButton": "Voltar � Boas-vindas",
    "loggedInAs": "Conectado como:",
    "adminOnly": "Apenas o administrador pode editar este bloco",
    "headers": {
      "createUser": "Criar Novo Usu�rio",
      "userList": "Lista de Usu�rios",
      "authorizedEmails": "E-MAILS AUTORIZADOS",
      "password": "SENHA"
    },
    "labels": {
      "nombre": "Nome",
      "id": "Id",
      "idTributario": "Id Tribut�rio",
      "pais": "Pa�s",
      "moneda": "Moeda",
      "idioma": "Idioma"
    },
    "buttons": {
      "entrar": "ENTRAR",
      "editar": "EDITAR",
      "papelera": "LIXEIRA",
      "pagar": "PAGAR",
      "saldo": "SALDO",
      "pagarRegistro": "Pagar registro de novo usu�rio"
    },
    "messages": {
      "minimumPayment": "Valor m�nimo a pagar `$10",
      "selectUser": "Por favor selecione um usu�rio da lista",
      "selectUserEdit": "Por favor selecione um usu�rio para editar",
      "selectUserDelete": "Por favor selecione um usu�rio para excluir",
      "selectUserPay": "Por favor selecione um usu�rio para pagar",
      "entering": "Entrando no sistema com usu�rio ID:",
      "editing": "Editando usu�rio ID:",
      "movedToTrash": "Usu�rio ID: {id} movido para a lixeira",
      "processingPayment": "Processando pagamento para usu�rio ID:"
    },
    "tableColumns": {
      "nombre": "NOME",
      "id": "ID",
      "saldo": "`$"
    }
  }
}
"@
[System.IO.File]::WriteAllText("$localesPath/pt.json", $ptContent, [System.Text.Encoding]::UTF8)

# 4. FRANC�S (fr.json)
Write-Host "? Generando fr.json (Fran�ais)..." -ForegroundColor Green
$frContent = @"
{
  "welcome": {
    "title": "Bienvenue",
    "subtitle": "Syst�me Comptable Universel",
    "tagline": "Ce syst�me fonctionne: sans codes, sans plan comptable, sans �critures comptables, sans cl�tures, sans exercices comptables. Intemporel. Pas besoin de distinguer entre personne physique et personne morale",
    "signIn": "Se connecter",
    "signUp": "S'inscrire"
  },
  "postAuth": {
    "backButton": "Retour � l'accueil",
    "loggedInAs": "Connect� en tant que:",
    "adminOnly": "Seul l'administrateur peut modifier ce bloc",
    "headers": {
      "createUser": "Cr�er un nouvel utilisateur",
      "userList": "Liste des utilisateurs",
      "authorizedEmails": "E-MAILS AUTORIS�S",
      "password": "MOT DE PASSE"
    },
    "labels": {
      "nombre": "Nom",
      "id": "Id",
      "idTributario": "Id fiscal",
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
      "pagarRegistro": "Payer l'enregistrement du nouvel utilisateur"
    },
    "messages": {
      "minimumPayment": "Montant minimum � payer `$10",
      "selectUser": "Veuillez s�lectionner un utilisateur dans la liste",
      "selectUserEdit": "Veuillez s�lectionner un utilisateur � modifier",
      "selectUserDelete": "Veuillez s�lectionner un utilisateur � supprimer",
      "selectUserPay": "Veuillez s�lectionner un utilisateur pour payer",
      "entering": "Entr�e dans le syst�me avec l'utilisateur ID:",
      "editing": "Modification de l'utilisateur ID:",
      "movedToTrash": "Utilisateur ID: {id} d�plac� vers la corbeille",
      "processingPayment": "Traitement du paiement pour l'utilisateur ID:"
    },
    "tableColumns": {
      "nombre": "NOM",
      "id": "ID",
      "saldo": "`$"
    }
  }
}
"@
[System.IO.File]::WriteAllText("$localesPath/fr.json", $frContent, [System.Text.Encoding]::UTF8)

# 5. ITALIANO (it.json)
Write-Host "? Generando it.json (Italiano)..." -ForegroundColor Green
$itContent = @"
{
  "welcome": {
    "title": "Benvenuto",
    "subtitle": "Sistema Contabile Universale",
    "tagline": "Questo sistema funziona: senza codici, senza piano dei conti, senza scritture contabili, senza chiusure, senza esercizi contabili. Atemporale. Non necessita di distinguere tra persona fisica e persona giuridica",
    "signIn": "Accedi",
    "signUp": "Registrati"
  },
  "postAuth": {
    "backButton": "Torna al benvenuto",
    "loggedInAs": "Connesso come:",
    "adminOnly": "Solo l'amministratore pu� modificare questo blocco",
    "headers": {
      "createUser": "Crea nuovo utente",
      "userList": "Elenco utenti",
      "authorizedEmails": "E-MAIL AUTORIZZATE",
      "password": "PASSWORD"
    },
    "labels": {
      "nombre": "Nome",
      "id": "Id",
      "idTributario": "Id fiscale",
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
      "minimumPayment": "Importo minimo da pagare `$10",
      "selectUser": "Seleziona un utente dall'elenco",
      "selectUserEdit": "Seleziona un utente da modificare",
      "selectUserDelete": "Seleziona un utente da eliminare",
      "selectUserPay": "Seleziona un utente per il pagamento",
      "entering": "Accesso al sistema con utente ID:",
      "editing": "Modifica utente ID:",
      "movedToTrash": "Utente ID: {id} spostato nel cestino",
      "processingPayment": "Elaborazione pagamento per utente ID:"
    },
    "tableColumns": {
      "nombre": "NOME",
      "id": "ID",
      "saldo": "`$"
    }
  }
}
"@
[System.IO.File]::WriteAllText("$localesPath/it.json", $itContent, [System.Text.Encoding]::UTF8)

# 6. ALEM�N (de.json)
Write-Host "? Generando de.json (Deutsch)..." -ForegroundColor Green
$deContent = @"
{
  "welcome": {
    "title": "Willkommen",
    "subtitle": "Universelles Buchhaltungssystem",
    "tagline": "Dieses System funktioniert: ohne Kontonummern, ohne Kontenplan, ohne Buchungss�tze, ohne Abschl�sse, ohne Gesch�ftsjahre. Zeitlos. Keine Unterscheidung zwischen nat�rlicher Person und juristischer Person erforderlich",
    "signIn": "Anmelden",
    "signUp": "Registrieren"
  },
  "postAuth": {
    "backButton": "Zur�ck zur Startseite",
    "loggedInAs": "Angemeldet als:",
    "adminOnly": "Nur der Administrator kann diesen Block bearbeiten",
    "headers": {
      "createUser": "Neuen Benutzer erstellen",
      "userList": "Benutzerliste",
      "authorizedEmails": "AUTORISIERTE E-MAILS",
      "password": "PASSWORT"
    },
    "labels": {
      "nombre": "Name",
      "id": "Id",
      "idTributario": "Steuer-ID",
      "pais": "Land",
      "moneda": "W�hrung",
      "idioma": "Sprache"
    },
    "buttons": {
      "entrar": "EINTRETEN",
      "editar": "BEARBEITEN",
      "papelera": "PAPIERKORB",
      "pagar": "BEZAHLEN",
      "saldo": "SALDO",
      "pagarRegistro": "Registrierung neuer Benutzer bezahlen"
    },
    "messages": {
      "minimumPayment": "Mindestbetrag zu zahlen `$10",
      "selectUser": "Bitte w�hlen Sie einen Benutzer aus der Liste",
      "selectUserEdit": "Bitte w�hlen Sie einen Benutzer zum Bearbeiten",
      "selectUserDelete": "Bitte w�hlen Sie einen Benutzer zum L�schen",
      "selectUserPay": "Bitte w�hlen Sie einen Benutzer f�r die Zahlung",
      "entering": "Eintritt ins System mit Benutzer-ID:",
      "editing": "Bearbeitung Benutzer-ID:",
      "movedToTrash": "Benutzer-ID: {id} in den Papierkorb verschoben",
      "processingPayment": "Zahlung wird verarbeitet f�r Benutzer-ID:"
    },
    "tableColumns": {
      "nombre": "NAME",
      "id": "ID",
      "saldo": "`$"
    }
  }
}
"@
[System.IO.File]::WriteAllText("$localesPath/de.json", $deContent, [System.Text.Encoding]::UTF8)

# 7. JAPON�S (ja.json)
Write-Host "? Generando ja.json (???)..." -ForegroundColor Green
$jaContent = @"
{
  "welcome": {
    "title": "????",
    "subtitle": "????????",
    "tagline": "??????????????????????????????????????????????????????????????????????????",
    "signIn": "????",
    "signUp": "????"
  },
  "postAuth": {
    "backButton": "?????????",
    "loggedInAs": "?????:",
    "adminOnly": "???????????????????",
    "headers": {
      "createUser": "????????",
      "userList": "???????",
      "authorizedEmails": "???????????",
      "password": "?????"
    },
    "labels": {
      "nombre": "??",
      "id": "ID",
      "idTributario": "?????",
      "pais": "?",
      "moneda": "??",
      "idioma": "??"
    },
    "buttons": {
      "entrar": "??",
      "editar": "??",
      "papelera": "???",
      "pagar": "???",
      "saldo": "??",
      "pagarRegistro": "?????????????"
    },
    "messages": {
      "minimumPayment": "????? `$10",
      "selectUser": "??????????????????",
      "selectUserEdit": "?????????????????",
      "selectUserDelete": "?????????????????",
      "selectUserPay": "????????????????",
      "entering": "????ID??????????:",
      "editing": "????ID????:",
      "movedToTrash": "????ID: {id} ????????????",
      "processingPayment": "????ID????????:"
    },
    "tableColumns": {
      "nombre": "??",
      "id": "ID",
      "saldo": "`$"
    }
  }
}
"@
[System.IO.File]::WriteAllText("$localesPath/ja.json", $jaContent, [System.Text.Encoding]::UTF8)

Write-Host ""
Write-Host "? Archivos principales (1-7) generados correctamente" -ForegroundColor Green
Write-Host ""
Write-Host "Presiona Enter para continuar con los idiomas adicionales (8-27)..." -ForegroundColor Yellow
Read-Host
