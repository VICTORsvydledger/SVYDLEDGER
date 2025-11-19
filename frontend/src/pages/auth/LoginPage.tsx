/**
 * Login Page
 */

import React from 'react'
import { Card, Typography } from 'antd'
import SignInForm from './components/SignInForm'
import './AuthPages.scss'

const { Title, Text } = Typography

const LoginPage: React.FC = () => {
  const handleForgotPassword = () => {
    // TODO: Implement forgot password modal
    console.log('Forgot password clicked')
  }

  return (
    <div className="auth-page">
      <Card className="auth-card">
        <div className="auth-header">
          <Title level={2}>SVYD LEDGER</Title>
          <Text type="secondary">Sistema de Contabilidad Universal</Text>
        </div>

        <SignInForm onForgotPassword={handleForgotPassword} />
      </Card>
    </div>
  )
}

export default LoginPage
