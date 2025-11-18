/**
 * Register Page
 */

import React from 'react'
import { Card, Typography } from 'antd'
import SignUpForm from './components/SignUpForm'
import './AuthPages.scss'

const { Title, Text } = Typography

const RegisterPage: React.FC = () => {
  return (
    <div className="auth-page">
      <Card className="auth-card">
        <div className="auth-header">
          <Title level={2}>Crear Cuenta</Title>
          <Text type="secondary">Sistema de Contabilidad Universal</Text>
        </div>

        <SignUpForm />
      </Card>
    </div>
  )
}

export default RegisterPage
