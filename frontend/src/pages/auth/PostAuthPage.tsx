import { Button, Input, Table, message } from 'antd'
import { ArrowLeftOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons'
import { useState } from 'react'
import './PostAuthPage.scss'

interface PostAuthPageProps {
  onBack: () => void
  userEmail?: string
}

// Textos de la interfaz - Almacenados como variables JavaScript (UTF-8 seguro)
const UI_TEXTS = {
  backButton: 'Back to Welcome',
  loggedInAs: 'Logged in as:',
  headers: {
    createUser: 'Crear Usuario Nuevo',
    userList: 'Lista de Usuarios',
    authorizedEmails: 'CORREOS AUTORIZADOS',
    password: 'PASSWORD'
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
}

const PostAuthPage = ({ onBack, userEmail }: PostAuthPageProps) => {
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

  // Datos de ejemplo para la tabla de usuarios (reducido a 5 filas)
  const usersData = Array(5).fill(null).map((_, i) => ({
    key: i,
    nombre: '',
    id: '',
    saldo: '$'
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
      title: UI_TEXTS.tableColumns.nombre,
      dataIndex: 'nombre',
      key: 'nombre',
      className: 'nombre-column'
    },
    {
      title: UI_TEXTS.tableColumns.id,
      dataIndex: 'id',
      key: 'id',
      className: 'id-column'
    },
    {
      title: UI_TEXTS.tableColumns.saldo,
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
      message.warning(UI_TEXTS.messages.selectUser)
      return
    }
    message.success(`${UI_TEXTS.messages.entering} ${selectedUser}`)
    // TODO: Implementar lógica de entrada al sistema
  }

  const handleEditar = () => {
    if (selectedUser === null) {
      message.warning(UI_TEXTS.messages.selectUserEdit)
      return
    }
    message.info(`${UI_TEXTS.messages.editing} ${selectedUser}`)
    // TODO: Implementar lógica de edición
  }

  const handlePapelera = () => {
    if (selectedUser === null) {
      message.warning(UI_TEXTS.messages.selectUserDelete)
      return
    }
    message.warning(UI_TEXTS.messages.movedToTrash.replace('{id}', String(selectedUser)))
    setSelectedUser(null)
    // TODO: Implementar lógica de eliminación
  }

  const handlePagar = () => {
    if (selectedUser === null) {
      message.warning(UI_TEXTS.messages.selectUserPay)
      return
    }
    message.success(`${UI_TEXTS.messages.processingPayment} ${selectedUser}`)
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
            {UI_TEXTS.backButton}
          </Button>
        </div>

        {/* Logo Svyd centrado */}
        <div className="logo-container">
          <h1 className="logo">Svyd</h1>
          
          {/* Email del usuario debajo del logo */}
          {userEmail && (
            <p className="user-email">{UI_TEXTS.loggedInAs} {userEmail}</p>
          )}
        </div>

        {/* Bloques reorganizados */}
        <div className="main-blocks-container">
          {/* PRIMERA FILA: Crear Usuario Nuevo + Lista de Usuarios */}
          <div className="top-row">
            {/* Bloque 1: Crear Usuario Nuevo */}
            <div className="block create-user-block">
              <div className="block-header">{UI_TEXTS.headers.createUser}</div>
              <div className="form-fields">
                <div className="form-field">
                  <label>{UI_TEXTS.labels.nombre}</label>
                  <Input
                    value={newUser.nombre}
                    onChange={(e) => setNewUser({ ...newUser, nombre: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{UI_TEXTS.labels.id}</label>
                  <Input
                    value={newUser.id}
                    onChange={(e) => setNewUser({ ...newUser, id: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{UI_TEXTS.labels.idTributario}</label>
                  <Input
                    value={newUser.idTributario}
                    onChange={(e) => setNewUser({ ...newUser, idTributario: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{UI_TEXTS.labels.pais}</label>
                  <Input
                    value={newUser.pais}
                    onChange={(e) => setNewUser({ ...newUser, pais: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{UI_TEXTS.labels.moneda}</label>
                  <Input
                    value={newUser.moneda}
                    onChange={(e) => setNewUser({ ...newUser, moneda: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{UI_TEXTS.labels.idioma}</label>
                  <Input
                    value={newUser.idioma}
                    onChange={(e) => setNewUser({ ...newUser, idioma: e.target.value })}
                  />
                </div>
              </div>
              <Button className="pay-button">
                {UI_TEXTS.buttons.pagarRegistro}
              </Button>
              <div className="minimum-payment">
                {UI_TEXTS.messages.minimumPayment}
              </div>
            </div>

            {/* Bloque 2: Lista de Usuarios */}
            <div className="block users-list-block">
              <div className="block-header-with-buttons">
                <span className="header-title">{UI_TEXTS.headers.userList}</span>
                <div className="header-buttons">
                  <Button 
                    className="action-btn entrar-btn"
                    onClick={handleEntrar}
                  >
                    {UI_TEXTS.buttons.entrar}
                  </Button>
                  <Button 
                    className="action-btn editar-btn"
                    onClick={handleEditar}
                    icon={<EditOutlined />}
                  >
                    {UI_TEXTS.buttons.editar}
                  </Button>
                  <Button 
                    className="action-btn papelera-btn"
                    onClick={handlePapelera}
                    icon={<DeleteOutlined />}
                  >
                    {UI_TEXTS.buttons.papelera}
                  </Button>
                  <Button 
                    className="action-btn pagar-btn"
                    onClick={handlePagar}
                  >
                    {UI_TEXTS.buttons.pagar}
                  </Button>
                  <Button className="action-btn saldo-btn">{UI_TEXTS.buttons.saldo}</Button>
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
            {/* Bloque 3: Correos Autorizados y Password */}
            <div className="block bottom-tables-block">
              <div className="tables-container">
                <div className="table-section">
                  <div className="table-header correos-header">{UI_TEXTS.headers.authorizedEmails}</div>
                  <Table
                    dataSource={correosData}
                    columns={correosColumns}
                    pagination={false}
                    showHeader={false}
                    className="correos-table"
                  />
                </div>
                <div className="table-section">
                  <div className="table-header password-header">{UI_TEXTS.headers.password}</div>
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
