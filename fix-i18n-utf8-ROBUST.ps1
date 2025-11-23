# ==============================================================================
# Script: fix-i18n-utf8-ROBUST.ps1
# Descripci�n: Regenera TODOS los archivos i18n con UTF-8 BOM GARANTIZADO
# Fecha: 2025-01-15
# M�todo: Usar StreamWriter con UTF8Encoding($true) para forzar BOM
# ==============================================================================

Write-Host "?? REGENERACI�N ROBUSTA CON UTF-8 BOM..." -ForegroundColor Cyan
Write-Host ""

$localesPath = "frontend/src/i18n/locales"

# Crear directorio si no existe
if (!(Test-Path $localesPath)) {
    New-Item -ItemType Directory -Path $localesPath -Force | Out-Null
}

# Funci�n para escribir archivo con UTF-8 BOM garantizado
function Write-Utf8BomFile {
    param(
        [string]$Path,
        [string]$Content
    )
    $utf8BOM = New-Object System.Text.UTF8Encoding $true
    $writer = New-Object System.IO.StreamWriter($Path, $false, $utf8BOM)
    try {
        $writer.Write($Content)
    }
    finally {
        $writer.Close()
    }
}

# ==============================================================================
# 1. INGL�S (en.json)
# ==============================================================================
Write-Host "? en.json (English)" -ForegroundColor Green
$enContent = @'
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
      "minimumPayment": "Minimum payment amount $10",
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
      "saldo": "$"
    }
  }
}
'@
Write-Utf8BomFile -Path "$localesPath/en.json" -Content $enContent

# ==============================================================================
# 2. ESPA�OL (es.json)
# ==============================================================================
Write-Host "? es.json (Espa�ol)" -ForegroundColor Green
$esContent = @'
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
      "minimumPayment": "Monto m�nimo a pagar $10",
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
      "saldo": "$"
    }
  }
}
'@
Write-Utf8BomFile -Path "$localesPath/es.json" -Content $esContent

# ==============================================================================
# 3. PORTUGU�S (pt.json)
# ==============================================================================
Write-Host "? pt.json (Portugu�s)" -ForegroundColor Green
$ptContent = @'
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
      "minimumPayment": "Valor m�nimo a pagar $10",
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
      "saldo": "$"
    }
  }
}
'@
Write-Utf8BomFile -Path "$localesPath/pt.json" -Content $ptContent

Write-Host ""
Write-Host "? Primeros 3 idiomas generados - Presiona Enter para continuar..." -ForegroundColor Yellow
Read-Host
