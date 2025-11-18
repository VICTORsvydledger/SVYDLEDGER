import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Typography, Select, Form, Input, Alert, Modal } from 'antd'
import notify from '@/lib/notifications'
import SignInForm from './components/SignInForm'
import SignUpForm from './components/SignUpForm'
import { useTranslation } from 'react-i18next'
import '@/i18n/i18n'
import './WelcomePage.scss'

const { Title, Text } = Typography

interface Language {
  code: string
  name: string
  nativeName: string
}

const languages: Language[] = [
  { code: 'en', name: 'English', nativeName: 'English' },
  { code: 'es', name: 'Spanish', nativeName: 'Español' },
]

const WelcomePage: React.FC = () => {
  const { t, i18n } = useTranslation()
  const [selectedLanguage, setSelectedLanguage] = useState<string>(i18n.language || 'es')

  const [forgotVisible, setForgotVisible] = useState(false)
  const [forgotEmail, setForgotEmail] = useState('')
  const [forgotSent, setForgotSent] = useState(false)

  const [twofaVisible, setTwofaVisible] = useState(false)
  const [twofaCode, setTwofaCode] = useState('')

  const navigate = useNavigate()

  const handleLanguage = (lng: string) => {
    setSelectedLanguage(lng)
    i18n.changeLanguage(lng).catch(() => {})
  }

  const handleSendRecovery = async () => {
    if (!forgotEmail) return
    try {
      setForgotSent(true)
      notify.success(t('auth.recovery.sent'))
    } catch (err) {
      notify.error('No se pudo enviar el enlace de recuperación')
    }
  }

  const handleVerifyTwofa = async () => {
    if (twofaCode.length !== 6) return
    try {
      setTwofaVisible(false)
      notify.success('Verificación exitosa')
      navigate('/app')
    } catch (err) {
      notify.error('Código de verificación inválido')
    }
  }

  return (
    <div className="welcome-page">
      <div className="background-image" />
      <div className="overlay" />

      <div className="content">
        <Title className="logo">{t('welcome.headline', { defaultValue: 'Svyd' })}</Title>
        <Title level={2} className="subtitle">
          {t('app.subtitle')}
        </Title>

        <Text className="promotional-text">{t('welcome.promo')}</Text>

        <div className="language-selector">
          <Select
            value={selectedLanguage}
            onChange={handleLanguage}
            options={languages.map((l) => ({ value: l.code, label: `${l.name} (${l.nativeName})` }))}
            style={{ width: 320 }}
          />
        </div>

        <div className="forms-container">
          {/* Sign In */}
          <div className="form-card">
            <Title level={3} className="form-title">
              {t('auth.signin')}
            </Title>

            <SignInForm onForgotPassword={() => setForgotVisible(true)} />
          </div>

          {/* Sign Up */}
          <div className="form-card">
            <Title level={3} className="form-title">
              {t('auth.signup')}
            </Title>

            <SignUpForm />
          </div>
        </div>
      </div>

      {/* Forgot Password */}
      <Modal
        open={forgotVisible}
        onCancel={() => {
          setForgotVisible(false)
          setForgotSent(false)
          setForgotEmail('')
        }}
        onOk={!forgotSent ? handleSendRecovery : undefined}
        okText={forgotSent ? t('auth.recovery.cancel') : t('auth.recovery.send')}
        cancelText={t('auth.recovery.cancel')}
        title={t('auth.recovery.title')}
      >
        {forgotSent ? (
          <Alert type="success" message={t('auth.recovery.sent')} />
        ) : (
          <Form layout="vertical">
            <Form.Item label={t('auth.email')} required>
              <Input
                type="email"
                value={forgotEmail}
                onChange={(e) => setForgotEmail(e.target.value)}
                placeholder="tu@email.com"
              />
            </Form.Item>
          </Form>
        )}
      </Modal>

      {/* Two-Factor */}
      <Modal
        open={twofaVisible}
        onCancel={() => setTwofaVisible(false)}
        onOk={handleVerifyTwofa}
        okButtonProps={{ disabled: twofaCode.length !== 6 }}
        title={t('auth.2fa.title')}
      >
        <Text>{t('auth.2fa.text')}</Text>
        <Form layout="vertical" style={{ marginTop: 12 }}>
          <Form.Item label="Código de verificación" required>
            <Input
              value={twofaCode}
              onChange={(e) => setTwofaCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
              maxLength={6}
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  )
}

export default WelcomePage
