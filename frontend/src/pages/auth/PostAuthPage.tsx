import { Button, Input, Table, message, Select } from 'antd'
import { ArrowLeftOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons'
import { useState, useEffect } from 'react'
import { useTranslation } from 'react-i18next'
import countries from '@/data/countries'
import currencies from '@/data/currencies'
import './PostAuthPage.scss'

interface PostAuthPageProps {
  onBack: () => void
  userEmail?: string
  selectedLanguage?: string
}

const PostAuthPage = ({ onBack, userEmail, selectedLanguage = 'en' }: PostAuthPageProps) => {
  // Usar el sistema i18n
  const { t, i18n } = useTranslation()

  // Cambiar idioma cuando selectedLanguage cambia
  useEffect(() => {
    if (selectedLanguage && i18n.language !== selectedLanguage) {
      i18n.changeLanguage(selectedLanguage)
    }
  }, [selectedLanguage, i18n])

  // Estado para el formulario de crear usuario
  const [newUser, setNewUser] = useState({
    nombre: '',
    id: '',
    idTributario: '',
    pais: 'US', // United States por defecto
    moneda: 'USD', // US Dollar por defecto
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
      title: t('postAuth.tableColumns.nombre'),
      dataIndex: 'nombre',
      key: 'nombre',
      className: 'nombre-column'
    },
    {
      title: t('postAuth.tableColumns.id'),
      dataIndex: 'id',
      key: 'id',
      className: 'id-column'
    },
    {
      title: t('postAuth.tableColumns.saldo'),
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
      message.warning(t('postAuth.messages.selectUser'))
      return
    }
    message.success(`${t('postAuth.messages.entering')} ${selectedUser}`)
    // TODO: Implementar lógica de entrada al sistema
  }

  const handleEditar = () => {
    if (selectedUser === null) {
      message.warning(t('postAuth.messages.selectUserEdit'))
      return
    }
    message.info(`${t('postAuth.messages.editing')} ${selectedUser}`)
    // TODO: Implementar lógica de edición
  }

  const handlePapelera = () => {
    if (selectedUser === null) {
      message.warning(t('postAuth.messages.selectUserDelete'))
      return
    }
    message.warning(t('postAuth.messages.movedToTrash', { id: String(selectedUser) }))
    setSelectedUser(null)
    // TODO: Implementar lógica de eliminación
  }

  const handlePagar = () => {
    if (selectedUser === null) {
      message.warning(t('postAuth.messages.selectUserPay'))
      return
    }
    message.success(`${t('postAuth.messages.processingPayment')} ${selectedUser}`)
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
            {t('postAuth.backButton')}
          </Button>
        </div>

        {/* Logo Svyd centrado */}
        <div className="logo-container">
          <h1 className="logo">Svyd</h1>
          
          {/* Email del usuario debajo del logo */}
          {userEmail && (
            <p className="user-email">{t('postAuth.loggedInAs')} {userEmail}</p>
          )}
        </div>

        {/* Bloques reorganizados */}
        <div className="main-blocks-container">
          {/* PRIMERA FILA: Crear Usuario Nuevo + Lista de Usuarios */}
          <div className="top-row">
            {/* Bloque 1: Crear Usuario Nuevo */}
            <div className="block create-user-block">
              <div className="block-header">{t('postAuth.headers.createUser')}</div>
              <div className="form-fields">
                <div className="form-field">
                  <label>{t('postAuth.labels.nombre')}</label>
                  <Input
                    value={newUser.nombre}
                    onChange={(e) => setNewUser({ ...newUser, nombre: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{t('postAuth.labels.id')}</label>
                  <Input
                    value={newUser.id}
                    onChange={(e) => setNewUser({ ...newUser, id: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{t('postAuth.labels.idTributario')}</label>
                  <Input
                    value={newUser.idTributario}
                    onChange={(e) => setNewUser({ ...newUser, idTributario: e.target.value })}
                  />
                </div>
                <div className="form-field">
                  <label>{t('postAuth.labels.pais')}</label>
                  <Select
                    value={newUser.pais}
                    onChange={(value) => setNewUser({ ...newUser, pais: value })}
                    showSearch
                    optionFilterProp="label"
                    placeholder="Select country"
                    style={{ width: '100%' }}
                    options={countries.map(country => ({
                      value: country.code,
                      label: country.name
                    }))}
                  />
                </div>
                <div className="form-field">
                  <label>{t('postAuth.labels.moneda')}</label>
                  <Select
                    value={newUser.moneda}
                    onChange={(value) => setNewUser({ ...newUser, moneda: value })}
                    showSearch
                    optionFilterProp="label"
                    placeholder="Select currency"
                    style={{ width: '100%' }}
                    options={currencies.map(currency => ({
                      value: currency.code,
                      label: `${currency.code} - ${currency.name} (${currency.symbol})`
                    }))}
                  />
                </div>
                <div className="form-field">
                  <label>{t('postAuth.labels.idioma')}</label>
                  <Input
                    value={newUser.idioma}
                    onChange={(e) => setNewUser({ ...newUser, idioma: e.target.value })}
                  />
                </div>
              </div>
              <Button className="pay-button">
                {t('postAuth.buttons.pagarRegistro')}
              </Button>
              <div className="minimum-payment">
                {t('postAuth.messages.minimumPayment')}
              </div>
            </div>

            {/* Bloque 2: Lista de Usuarios */}
            <div className="block users-list-block">
              <div className="block-header-with-buttons">
                <span className="header-title">{t('postAuth.headers.userList')}</span>
                <div className="header-buttons">
                  <Button 
                    className="action-btn entrar-btn"
                    onClick={handleEntrar}
                  >
                    {t('postAuth.buttons.entrar')}
                  </Button>
                  <Button 
                    className="action-btn editar-btn"
                    onClick={handleEditar}
                    icon={<EditOutlined />}
                  >
                    {t('postAuth.buttons.editar')}
                  </Button>
                  <Button 
                    className="action-btn papelera-btn"
                    onClick={handlePapelera}
                    icon={<DeleteOutlined />}
                  >
                    {t('postAuth.buttons.papelera')}
                  </Button>
                  <Button 
                    className="action-btn pagar-btn"
                    onClick={handlePagar}
                  >
                    {t('postAuth.buttons.pagar')}
                  </Button>
                  <Button className="action-btn saldo-btn">{t('postAuth.buttons.saldo')}</Button>
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
              {t('postAuth.adminOnly')}
            </div>
            
            {/* Bloque 3: Correos Autorizados y Password */}
            <div className="block bottom-tables-block">
              <div className="tables-container">
                <div className="table-section">
                  <div className="table-header correos-header">{t('postAuth.headers.authorizedEmails')}</div>
                  <Table
                    dataSource={correosData}
                    columns={correosColumns}
                    pagination={false}
                    showHeader={false}
                    className="correos-table"
                  />
                </div>
                <div className="table-section">
                  <div className="table-header password-header">{t('postAuth.headers.password')}</div>
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
