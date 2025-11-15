/**
 * Login Page
 */

import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Form, Input, Button, Card, Typography, message } from 'antd'
import { UserOutlined, LockOutlined } from '@ant-design/icons'
import { useAppDispatch } from '@/store/hooks'
import { loginSuccess } from '@/store/slices/authSlice'
import './AuthPages.scss'

const { Title, Text, Link } = Typography

const LoginPage: React.FC = () => {
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()
  const dispatch = useAppDispatch()

  const onFinish = async (values: any) => {
    setLoading(true)
    try {
      // TODO: Llamar al Identity Service
      // Por ahora, simulamos el login
      setTimeout(() => {
        dispatch(
          loginSuccess({
            user: {
              id: 1,
              email: values.username,
              username: values.username,
              fullName: 'Usuario Demo',
              roles: ['user'],
            },
            token: 'mock-jwt-token',
          })
        )
        message.success('Login exitoso')
        navigate('/dashboard')
        setLoading(false)
      }, 1000)
    } catch (error) {
      message.error('Error al iniciar sesión')
      setLoading(false)
    }
  }

  return (
    <div className="auth-page">
      <Card className="auth-card">
        <div className="auth-header">
          <Title level={2}>SVYD LEDGER</Title>
          <Text type="secondary">Sistema de Contabilidad Universal</Text>
        </div>

        <Form
          name="login"
          onFinish={onFinish}
          autoComplete="off"
          layout="vertical"
          size="large"
        >
          <Form.Item
            name="username"
            rules={[{ required: true, message: 'Por favor ingrese su usuario o email' }]}
          >
            <Input prefix={<UserOutlined />} placeholder="Usuario o Email" />
          </Form.Item>

          <Form.Item
            name="password"
            rules={[{ required: true, message: 'Por favor ingrese su contraseña' }]}
          >
            <Input.Password prefix={<LockOutlined />} placeholder="Contraseña" />
          </Form.Item>

          <Form.Item>
            <Button type="primary" htmlType="submit" block loading={loading}>
              Iniciar Sesión
            </Button>
          </Form.Item>

          <div className="auth-footer">
            <Text>
              ¿No tienes cuenta? <Link onClick={() => navigate('/register')}>Regístrate</Link>
            </Text>
          </div>
        </Form>
      </Card>
    </div>
  )
}

export default LoginPage
