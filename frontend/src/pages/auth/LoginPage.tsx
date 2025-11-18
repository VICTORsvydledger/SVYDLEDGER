/**
 * Login Page
 */

import React from 'react'
import { Card, Typography } from 'antd'
import SignInForm from './components/SignInForm'
import './AuthPages.scss'

const { Title, Text } = Typography

const LoginPage: React.FC = () => {
  return (
    <div className="auth-page">
      <Card className="auth-card">
        <div className="auth-header">
          <Title level={2}>SVYD LEDGER</Title>
          <Text type="secondary">Sistema de Contabilidad Universal</Text>
        </div>

        <SignInForm buttonText="Iniciar sesión" />
      </Card>
    </div>
  )
}

export default LoginPage
