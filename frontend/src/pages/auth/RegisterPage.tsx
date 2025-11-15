/**
 * Register Page
 */

import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Form, Input, Button, Card, Typography, message } from 'antd'
import { UserOutlined, LockOutlined, MailOutlined } from '@ant-design/icons'
import './AuthPages.scss'

const { Title, Text, Link } = Typography

const RegisterPage: React.FC = () => {
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()

  const onFinish = async (values: any) => {
    setLoading(true)
    try {
      // TODO: Llamar al Identity Service para registro
      setTimeout(() => {
        message.success('Registro exitoso. Por favor inicia sesión.')
        navigate('/login')
        setLoading(false)
      }, 1000)
    } catch (error) {
      message.error('Error al registrar usuario')
      setLoading(false)
    }
  }

  return (
    <div className="auth-page">
      <Card className="auth-card">
        <div className="auth-header">
          <Title level={2}>Crear Cuenta</Title>
          <Text type="secondary">Sistema de Contabilidad Universal</Text>
        </div>

        <Form
          name="register"
          onFinish={onFinish}
          autoComplete="off"
          layout="vertical"
          size="large"
        >
          <Form.Item
            name="fullName"
            rules={[{ required: true, message: 'Por favor ingrese su nombre completo' }]}
          >
            <Input prefix={<UserOutlined />} placeholder="Nombre Completo" />
          </Form.Item>

          <Form.Item
            name="email"
            rules={[
              { required: true, message: 'Por favor ingrese su email' },
              { type: 'email', message: 'Email no válido' },
            ]}
          >
            <Input prefix={<MailOutlined />} placeholder="Email" />
          </Form.Item>

          <Form.Item
            name="username"
            rules={[{ required: true, message: 'Por favor ingrese un nombre de usuario' }]}
          >
            <Input prefix={<UserOutlined />} placeholder="Nombre de Usuario" />
          </Form.Item>

          <Form.Item
            name="password"
            rules={[
              { required: true, message: 'Por favor ingrese una contraseña' },
              { min: 8, message: 'La contraseña debe tener al menos 8 caracteres' },
            ]}
          >
            <Input.Password prefix={<LockOutlined />} placeholder="Contraseña" />
          </Form.Item>

          <Form.Item
            name="confirmPassword"
            dependencies={['password']}
            rules={[
              { required: true, message: 'Por favor confirme su contraseña' },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue('password') === value) {
                    return Promise.resolve()
                  }
                  return Promise.reject(new Error('Las contraseñas no coinciden'))
                },
              }),
            ]}
          >
            <Input.Password prefix={<LockOutlined />} placeholder="Confirmar Contraseña" />
          </Form.Item>

          <Form.Item>
            <Button type="primary" htmlType="submit" block loading={loading}>
              Registrarse
            </Button>
          </Form.Item>

          <div className="auth-footer">
            <Text>
              ¿Ya tienes cuenta? <Link onClick={() => navigate('/login')}>Inicia sesión</Link>
            </Text>
          </div>
        </Form>
      </Card>
    </div>
  )
}

export default RegisterPage
