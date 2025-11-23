import { Button, Input, Table, Select, message } from 'antd'
import { ArrowLeftOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons'
import { useState } from 'react'
import countries from '@/data/countries'
import './PostAuthPage.scss'

interface PostAuthPageProps {
  onBack: () => void
  userEmail?: string
  selectedLanguage?: string
}

// Sistema de traducciones para PostAuthPage - 27 idiomas
// Definir estructura de traducción base
interface PostAuthTranslation {
  backButton: string
  loggedInAs: string
  adminOnly: string // Nuevo campo para el mensaje de solo administrador
  headers: {
    createUser: string
    userList: string
    authorizedEmails: string
    password: string
  }
  labels: {
    nombre: string
    id: string
    idTributario: string
    pais: string
    moneda: string
    idioma: string
  }
  buttons: {
    entrar: string
    editar: string
    papelera: string
    pagar: string
    saldo: string
    pagarRegistro: string
  }
  messages: {
    minimumPayment: string
    selectUser: string
    selectUserEdit: string
    selectUserDelete: string
    selectUserPay: string
    entering: string
    editing: string
    movedToTrash: string
    processingPayment: string
  }
  tableColumns: {
    nombre: string
    id: string
    saldo: string
  }
}

// Helper function para obtener traducciones
function getTranslations(lang: string): PostAuthTranslation {
  const translations: Record<string, PostAuthTranslation> = {
    en: {
      backButton: 'Back to Welcome',
      loggedInAs: 'Logged in as:',
      adminOnly: 'Only the administrator can edit this block',
      headers: {
        createUser: 'Create New User',
        userList: 'User List',
        authorizedEmails: 'AUTHORIZED EMAILS',
        password: 'PASSWORD'
      },
      labels: {
        nombre: 'Name',
        id: 'Id',
        idTributario: 'Tax ID',
        pais: 'Country',
        moneda: 'Currency',
        idioma: 'Language'
      },
      buttons: {
        entrar: 'ENTER',
        editar: 'EDIT',
        papelera: 'TRASH',
        pagar: 'PAY',
        saldo: 'BALANCE',
        pagarRegistro: 'Pay for new user registration'
      },
      messages: {
        minimumPayment: 'Minimum payment amount $10',
        selectUser: 'Please select a user from the list',
        selectUserEdit: 'Please select a user to edit',
        selectUserDelete: 'Please select a user to delete',
        selectUserPay: 'Please select a user to pay',
        entering: 'Entering system with user ID:',
        editing: 'Editing user ID:',
        movedToTrash: 'User ID: {id} moved to trash',
        processingPayment: 'Processing payment for user ID:'
      },
      tableColumns: {
        nombre: 'NAME',
        id: 'ID',
        saldo: '$'
      }
    },
      es: {
          backButton: 'Volver a Bienvenida',
          loggedInAs: 'Sesión iniciada como:',
          adminOnly: 'Solo el administrador puede editar este bloque',
          headers: {
              createUser: 'Crear Usuario Nuevo',
              userList: 'Lista de Usuarios',
              authorizedEmails: 'CORREOS AUTORIZADOS',
              password: 'CONTRASEÑA'
          },
          labels: {
              nombre: 'Nombre',
              id: 'Id',
              idTributario: 'Id Tributario',
              pais: 'País',
              moneda: 'Moneda',
              idioma: 'Idioma'
          },
          buttons: {
              entrar: 'ENTRAR',
              editar: 'EDITAR',
              papelera: 'PAPELERA',
              pagar: 'PAGAR',
              saldo: 'SALDO',
              pagarRegistro: 'Pagar registro de usuario nuevo'
          },
          messages: {
              minimumPayment: 'Monto mínimo a pagar $10',
              selectUser: 'Por favor selecciona un usuario de la lista',
              selectUserEdit: 'Por favor selecciona un usuario para editar',
              selectUserDelete: 'Por favor selecciona un usuario para eliminar',
              selectUserPay: 'Por favor selecciona un usuario para pagar',
              entering: 'Entrando al sistema con usuario ID:',
              editing: 'Editando usuario ID:',
              movedToTrash: 'Usuario ID: {id} movido a la papelera',
              processingPayment: 'Procesando pago para usuario ID:'
          },
          tableColumns: {
              nombre: 'NOMBRE',
              id: 'ID',
              saldo: '$'
          }
      },
    pt: {
      backButton: 'Voltar à Boas-vindas',
      loggedInAs: 'Conectado como:',
      adminOnly: 'Somente o administrador pode editar este bloco',
      headers: {
        createUser: 'Criar Novo Usuário',
        userList: 'Lista de Usuários',
        authorizedEmails: 'E-MAILS AUTORIZADOS',
        password: 'SENHA'
      },
      labels: {
        nombre: 'Nome',
        id: 'Id',
        idTributario: 'ID Fiscal',
        pais: 'País',
        moneda: 'Moeda',
        idioma: 'Idioma'
      },
      buttons: {
        entrar: 'ENTRAR',
        editar: 'EDITAR',
        papelera: 'LIXEIRA',
        pagar: 'PAGAR',
        saldo: 'SALDO',
        pagarRegistro: 'Pagar registro de novo usuário'
      },
      messages: {
        minimumPayment: 'Valor mínimo de pagamento $10',
        selectUser: 'Por favor selecione um usuário da lista',
        selectUserEdit: 'Por favor selecione um usuário para editar',
        selectUserDelete: 'Por favor selecione um usuário para excluir',
        selectUserPay: 'Por favor selecione um usuário para pagar',
        entering: 'Entrando no sistema com usuário ID:',
        editing: 'Editando usuário ID:',
        movedToTrash: 'Usuário ID: {id} movido para a lixeira',
        processingPayment: 'Processando pagamento para usuário ID:'
      },
      tableColumns: {
        nombre: 'NOME',
        id: 'ID',
        saldo: '$'
      }
    },
    fr: {
      backButton: 'Retour à l\'accueil',
      loggedInAs: 'Connecté en tant que:',
      adminOnly: 'Seul l\'administrateur peut modifier ce bloc',
      headers: {
        createUser: 'Créer un Nouvel Utilisateur',
        userList: 'Liste des Utilisateurs',
        authorizedEmails: 'E-MAILS AUTORISÉS',
        password: 'MOT DE PASSE'
      },
      labels: {
        nombre: 'Nom',
        id: 'Id',
        idTributario: 'ID Fiscal',
        pais: 'Pays',
        moneda: 'Devise',
        idioma: 'Langue'
      },
      buttons: {
        entrar: 'ENTRER',
        editar: 'MODIFIER',
        papelera: 'CORBEILLE',
        pagar: 'PAYER',
        saldo: 'SOLDE',
        pagarRegistro: 'Payer l\'inscription du nouvel utilisateur'
      },
      messages: {
        minimumPayment: 'Montant minimum de paiement $10',
        selectUser: 'Veuillez sélectionner un utilisateur dans la liste',
        selectUserEdit: 'Veuillez sélectionner un utilisateur à modifier',
        selectUserDelete: 'Veuillez sélectionner un utilisateur à supprimer',
        selectUserPay: 'Veuillez sélectionner un utilisateur à payer',
        entering: 'Entrée dans le système avec l\'utilisateur ID:',
        editing: 'Modification de l\'utilisateur ID:',
        movedToTrash: 'Utilisateur ID: {id} déplacé vers la corbeille',
        processingPayment: 'Traitement du paiement pour l\'utilisateur ID:'
      },
      tableColumns: {
        nombre: 'NOM',
        id: 'ID',
        saldo: '$'
      }
    },
    it: {
      backButton: 'Torna al Benvenuto',
      loggedInAs: 'Connesso come:',
      adminOnly: 'Solo l\'amministratore può modificare questo blocco',
      headers: {
        createUser: 'Crea Nuovo Utente',
        userList: 'Elenco Utenti',
        authorizedEmails: 'E-MAIL AUTORIZZATE',
        password: 'PASSWORD'
      },
      labels: {
        nombre: 'Nome',
        id: 'Id',
        idTributario: 'ID Fiscale',
        pais: 'Paese',
        moneda: 'Valuta',
        idioma: 'Lingua'
      },
      buttons: {
        entrar: 'ENTRA',
        editar: 'MODIFICA',
        papelera: 'CESTINO',
        pagar: 'PAGA',
        saldo: 'SALDO',
        pagarRegistro: 'Paga registrazione nuovo utente'
      },
      messages: {
        minimumPayment: 'Importo minimo di pagamento $10',
        selectUser: 'Seleziona un utente dall\'elenco',
        selectUserEdit: 'Seleziona un utente da modificare',
        selectUserDelete: 'Seleziona un utente da eliminare',
        selectUserPay: 'Seleziona un utente da pagare',
        entering: 'Accesso al sistema con utente ID:',
        editing: 'Modifica utente ID:',
        movedToTrash: 'Utente ID: {id} spostato nel cestino',
        processingPayment: 'Elaborazione pagamento per utente ID:'
      },
      tableColumns: {
        nombre: 'NOME',
        id: 'ID',
        saldo: '$'
      }
    },
    de: {
      backButton: 'Zurück zur Willkommensseite',
      loggedInAs: 'Angemeldet als:',
      adminOnly: 'Nur der Administrator kann diesen Block bearbeiten',
      headers: {
        createUser: 'Neuen Benutzer Erstellen',
        userList: 'Benutzerliste',
        authorizedEmails: 'AUTORISIERTE E-MAILS',
        password: 'PASSWORT'
      },
      labels: {
        nombre: 'Name',
        id: 'Id',
        idTributario: 'Steuernummer',
        pais: 'Land',
        moneda: 'Währung',
        idioma: 'Sprache'
      },
      buttons: {
        entrar: 'BETRETEN',
        editar: 'BEARBEITEN',
        papelera: 'PAPIERKORB',
        pagar: 'BEZAHLEN',
        saldo: 'SALDO',
        pagarRegistro: 'Registrierung des neuen Benutzers bezahlen'
      },
      messages: {
        minimumPayment: 'Mindestbetrag $10',
        selectUser: 'Bitte wählen Sie einen Benutzer aus der Liste',
        selectUserEdit: 'Bitte wählen Sie einen Benutzer zum Bearbeiten',
        selectUserDelete: 'Bitte wählen Sie einen Benutzer zum Löschen',
        selectUserPay: 'Bitte wählen Sie einen Benutzer zum Bezahlen',
        entering: 'Systemzugriff mit Benutzer ID:',
        editing: 'Bearbeitung Benutzer ID:',
        movedToTrash: 'Benutzer ID: {id} in den Papierkorb verschoben',
        processingPayment: 'Zahlungsabwicklung für Benutzer ID:'
      },
      tableColumns: {
        nombre: 'NAME',
        id: 'ID',
        saldo: '$'
      }
    },
    ja: {
      backButton: '???????????',
      loggedInAs: '?????:',
      adminOnly: '????????????????????',
      headers: {
        createUser: '????????',
        userList: '???????',
        authorizedEmails: '???????',
        password: '?????'
      },
      labels: {
        nombre: '??',
        id: 'ID',
        idTributario: '??ID',
        pais: '?',
        moneda: '??',
        idioma: '??'
      },
      buttons: {
        entrar: '??',
        editar: '??',
        papelera: '???',
        pagar: '???',
        saldo: '??',
        pagarRegistro: '?????????????'
      },
      messages: {
        minimumPayment: '????? $10',
        selectUser: '??????????????????',
        selectUserEdit: '?????????????????',
        selectUserDelete: '?????????????????',
        selectUserPay: '????????????????',
        entering: '????ID ????????????:',
        editing: '????ID ????:',
        movedToTrash: '????ID: {id} ????????????',
        processingPayment: '????ID ????????:'
      },
      tableColumns: {
        nombre: '??',
        id: 'ID',
        saldo: '$'
      }
    }
  }
  
  // Retornar traducción del idioma solicitado o inglés por defecto
  return translations[lang] || translations.en
}

const PostAuthPage = ({ onBack, userEmail, selectedLanguage = 'en' }: PostAuthPageProps) => {
  // Obtener traducciones del idioma seleccionado
  const t = getTranslations(selectedLanguage)

  // Estado para el formulario de crear usuario
  const [newUser, setNewUser] = useState({
    nombre: '',
    id: '',
    idTributario: '',
    pais: '',
    moneda: '',
    idioma: ''
  })

  // Estado para el usuario seleccionado
  const [selectedUser, setSelectedUser] = useState<number | null>(null)

  // Datos de ejemplo para la tabla de usuarios (REDUCIDO A 12 FILAS)
  const usersData = Array(12).fill(null).map((_, i) => ({
    key: i,
    nombre: `User ${i + 1}`,
    id: `ID-${String(i + 1).padStart(3, '0')}`,
    saldo: '$0.00'
  }))

  // Datos de ejemplo para correos autorizados
  const correosData = Array(8).fill(null).map((_, i) => ({
    key: i,
    correo: ''
  }))

  // Datos de ejemplo para passwords
  const passwordsData = Array(8).fill(null).map((_, i) => ({
    key: i,
    password: ''
  }))

  // Columnas para la tabla de usuarios
  const userColumns = [
    {
      title: t.tableColumns.nombre,
      dataIndex: 'nombre',
      key: 'nombre',
      className: 'nombre-column'
    },
    {
      title: t.tableColumns.id,
      dataIndex: 'id',
      key: 'id',
      className: 'id-column'
    },
    {
      title: t.tableColumns.saldo,
      dataIndex: 'saldo',
      key: 'saldo',
      className: 'saldo-column'
    }
  ]

  // Columnas para correos autorizados
  const correosColumns = [
    {
      title: '',
      dataIndex: 'correo',
      key: 'correo'
    }
  ]

  // Columnas para passwords
  const passwordsColumns = [
    {
      title: '',
      dataIndex: 'password',
      key: 'password'
    }
  ]

  // Handlers para los botones
  const handleEntrar = () => {
    if (selectedUser === null) {
      message.warning(t.messages.selectUser)
      return
    }
    message.success(`${t.messages.entering} ${selectedUser}`)
    // TODO: Implementar lógica de entrada al sistema
  }

  const handleEditar = () => {
    if (selectedUser === null) {
      message.warning(t.messages.selectUserEdit)
      return
    }
    message.info(`${t.messages.editing} ${selectedUser}`)
    // TODO: Implementar lógica de edición
  }

  const handlePapelera = () => {
    if (selectedUser === null) {
      message.warning(t.messages.selectUserDelete)
      return
    }
    message.warning(t.messages.movedToTrash.replace('{id}', String(selectedUser)))
    setSelectedUser(null)
    // TODO: Implementar lógica de eliminación
  }

  const handlePagar = () => {
    if (selectedUser === null) {
      message.warning(t.messages.selectUserPay)
      return
    }
    message.success(`${t.messages.processingPayment} ${selectedUser}`)
    // TODO: Implementar lógica de pago
  }

  // Handler para selección de fila en la tabla
  const rowSelection = {
    type: 'radio' as const,
    onChange: (selectedRowKeys: React.Key[]) => {
      setSelectedUser(selectedRowKeys[0] as number)
    },
    selectedRowKeys: selectedUser !== null ? [selectedUser] : []
  }

  return (
    <div className="post-auth-page">
      {/* Fondo con background-3.png */}
      <div className="post-auth-background" />
      
      {/* Contenido principal */}
      <div className="post-auth-content">
        {/* Botón Back en esquina superior izquierda */}
        <div className="back-button-container">
          <Button
            type="default"
            size="large"
            icon={<ArrowLeftOutlined />}
            onClick={onBack}
            className="back-button"
          >
            {t.backButton}
          </Button>
        </div>

        {/* Logo Svyd centrado */}
        <div className="logo-container">
          <h1 className="logo">Svyd</h1>
          
          {/* Email del usuario debajo del logo */}
          {userEmail && (
            <p className="user-email">{t.loggedInAs} {userEmail}</p>
          )}
        </div>

        {/* Bloques reorganizados */}
        <div className="main-blocks-container">
          {/* PRIMERA FILA: Crear Usuario Nuevo + Lista de Usuarios */}
          <div className="top-row">
            {/* Bloque 1: Crear Usuario Nuevo */}
            <div className="block create-user-block">
              <div className="block-header">{t.headers.createUser}</div>
              <div className="form-fields">
                <div className="form-field">
                  <label>{t.labels.nombre}</label>
                  <Input
                    value={newUser.nombre}
                    onChange={(e) => setNewUser({ ...newUser, nombre: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{t.labels.id}</label>
                  <Input
                    value={newUser.id}
                    onChange={(e) => setNewUser({ ...newUser, id: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{t.labels.idTributario}</label>
                  <Input
                    value={newUser.idTributario}
                    onChange={(e) => setNewUser({ ...newUser, idTributario: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{t.labels.pais}</label>
                  <Select
                    value={newUser.pais}
                    onChange={(value) => setNewUser({ ...newUser, pais: value })}
                    options={countries.map(country => ({
                      value: country.code,
                      label: country.displayName
                    }))}
                    showSearch
                    optionFilterProp="label"
                    placeholder="Select Country / Seleccionar País"
                    style={{ width: '100%' }}
                  />
                </div>
                <div className="form-field">
                  <label>{t.labels.moneda}</label>
                  <Input
                    value={newUser.moneda}
                    onChange={(e) => setNewUser({ ...newUser, moneda: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{t.labels.idioma}</label>
                  <Input
                    value={newUser.idioma}
                    onChange={(e) => setNewUser({ ...newUser, idioma: e.target.value })}
                  />
                </div>
              </div>
              <Button className="pay-button">
                {t.buttons.pagarRegistro}
              </Button>
              <div className="minimum-payment">
                {t.messages.minimumPayment}
              </div>
            </div>

            {/* Bloque 2: Lista de Usuarios */}
            <div className="block users-list-block">
              <div className="block-header-with-buttons">
                <span className="header-title">{t.headers.userList}</span>
                <div className="header-buttons">
                  <Button 
                    className="action-btn entrar-btn"
                    onClick={handleEntrar}
                  >
                    {t.buttons.entrar}
                  </Button>
                  <Button 
                    className="action-btn editar-btn"
                    onClick={handleEditar}
                    icon={<EditOutlined />}
                  >
                    {t.buttons.editar}
                  </Button>
                  <Button 
                    className="action-btn papelera-btn"
                    onClick={handlePapelera}
                    icon={<DeleteOutlined />}
                  >
                    {t.buttons.papelera}
                  </Button>
                  <Button 
                    className="action-btn pagar-btn"
                    onClick={handlePagar}
                  >
                    {t.buttons.pagar}
                  </Button>
                  <Button className="action-btn saldo-btn">{t.buttons.saldo}</Button>
                </div>
              </div>
              <Table
                dataSource={usersData}
                columns={userColumns}
                pagination={false}
                className="users-table"
                rowSelection={rowSelection}
              />
            </div>
          </div>

          {/* SEGUNDA FILA: Correos Autorizados y Password (ancho completo) */}
          <div className="bottom-row">
            {/* Mensaje de solo administrador */}
            <div className="admin-only-message">
              {t.adminOnly}
            </div>
            
            {/* Bloque 3: Correos Autorizados y Password */}
            <div className="block bottom-tables-block">
              <div className="tables-container">
                <div className="table-section">
                  <div className="table-header correos-header">{t.headers.authorizedEmails}</div>
                  <Table
                    dataSource={correosData}
                    columns={correosColumns}
                    pagination={false}
                    showHeader={false}
                    className="correos-table"
                  />
                </div>
                <div className="table-section">
                  <div className="table-header password-header">{t.headers.password}</div>
                  <Table
                    dataSource={passwordsData}
                    columns={passwordsColumns}
                    pagination={false}
                    showHeader={false}
                    className="password-table"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default PostAuthPage
