import { Button, Input, Table, message } from 'antd'
import { ArrowLeftOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons'
import { useState } from 'react'
import './PostAuthPage.scss'

interface PostAuthPageProps {
  onBack: () => void
  userEmail?: string
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
      title: 'NOMBRE',
      dataIndex: 'nombre',
      key: 'nombre',
      className: 'nombre-column'
    },
    {
      title: 'ID',
      dataIndex: 'id',
      key: 'id',
      className: 'id-column'
    },
    {
      title: '$',
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
      message.warning('Por favor selecciona un usuario de la lista')
      return
    }
    message.success(`Entrando al sistema con usuario ID: ${selectedUser}`)
    // TODO: Implementar lógica de entrada al sistema
  }

  const handleEditar = () => {
    if (selectedUser === null) {
      message.warning('Por favor selecciona un usuario para editar')
      return
    }
    message.info(`Editando usuario ID: ${selectedUser}`)
    // TODO: Implementar lógica de edición
  }

  const handlePapelera = () => {
    if (selectedUser === null) {
      message.warning('Por favor selecciona un usuario para eliminar')
      return
    }
    message.warning(`Usuario ID: ${selectedUser} movido a la papelera`)
    setSelectedUser(null)
    // TODO: Implementar lógica de eliminación
  }

  const handlePagar = () => {
    if (selectedUser === null) {
      message.warning('Por favor selecciona un usuario para pagar')
      return
    }
    message.success(`Procesando pago para usuario ID: ${selectedUser}`)
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
            Back to Welcome
          </Button>
        </div>

        {/* Logo Svyd centrado */}
        <div className="logo-container">
          <h1 className="logo">Svyd</h1>
          
          {/* Email del usuario debajo del logo */}
          {userEmail && (
            <p className="user-email">Logged in as: {userEmail}</p>
          )}
        </div>

        {/* Bloques reorganizados */}
        <div className="main-blocks-container">
          {/* PRIMERA FILA: Crear Usuario Nuevo + Lista de Usuarios */}
          <div className="top-row">
            {/* Bloque 1: Crear Usuario Nuevo */}
            <div className="block create-user-block">
              <div className="block-header">Crear Usuario Nuevo</div>
              <div className="form-fields">
                <div className="form-field">
                  <label>Nombre</label>
                  <Input
                    value={newUser.nombre}
                    onChange={(e) => setNewUser({ ...newUser, nombre: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>Id</label>
                  <Input
                    value={newUser.id}
                    onChange={(e) => setNewUser({ ...newUser, id: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>Id Tributario</label>
                  <Input
                    value={newUser.idTributario}
                    onChange={(e) => setNewUser({ ...newUser, idTributario: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>País</label>
                  <Input
                    value={newUser.pais}
                    onChange={(e) => setNewUser({ ...newUser, pais: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>Moneda</label>
                  <Input
                    value={newUser.moneda}
                    onChange={(e) => setNewUser({ ...newUser, moneda: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>Idioma</label>
                  <Input
                    value={newUser.idioma}
                    onChange={(e) => setNewUser({ ...newUser, idioma: e.target.value })}
                  />
                </div>
              </div>
              <Button className="pay-button">
                Pagar registro de usuario nuevo
              </Button>
              <div className="minimum-payment">
                Monto mínimo a pagar $10
              </div>
            </div>

            {/* Bloque 2: Lista de Usuarios */}
            <div className="block users-list-block">
              <div className="block-header-with-buttons">
                <span className="header-title">Lista de Usuarios</span>
                <div className="header-buttons">
                  <Button 
                    className="action-btn entrar-btn"
                    onClick={handleEntrar}
                  >
                    ENTRAR
                  </Button>
                  <Button 
                    className="action-btn editar-btn"
                    onClick={handleEditar}
                    icon={<EditOutlined />}
                  >
                    EDITAR
                  </Button>
                  <Button 
                    className="action-btn papelera-btn"
                    onClick={handlePapelera}
                    icon={<DeleteOutlined />}
                  >
                    PAPELERA
                  </Button>
                  <Button 
                    className="action-btn pagar-btn"
                    onClick={handlePagar}
                  >
                    PAGAR
                  </Button>
                  <Button className="action-btn saldo-btn">SALDO</Button>
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
                  <div className="table-header correos-header">CORREOS AUTORIZADOS</div>
                  <Table
                    dataSource={correosData}
                    columns={correosColumns}
                    pagination={false}
                    showHeader={false}
                    className="correos-table"
                  />
                </div>
                <div className="table-section">
                  <div className="table-header password-header">PASSWORD</div>
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
