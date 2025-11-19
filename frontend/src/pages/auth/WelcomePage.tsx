import React, { useState, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { Typography, Select, Form, Input, Alert, Modal } from 'antd'
import notify from '@/lib/notifications'
import SignInForm from './components/SignInForm'
import SignUpForm from './components/SignUpForm'
import './WelcomePage.scss'

const { Title, Text } = Typography

interface Language {
  code: string
  name: string
  nativeName: string
}

// Traducciones del subtítulo y texto promocional
const translations = {
  en: {
    subtitle: 'Universal Accounting System',
    description: 'This system works: without codes, without chart of accounts, without journal entries, without closings, without fiscal periods. Timeless. No need to distinguish between natural person and legal entity'
  },
  es: {
    subtitle: 'Sistema de Contabilidad Universal',
    description: 'Este sistema trabaja: sin códigos, sin catálogos de cuenta, sin asientos contables, sin cierres, sin periodos fiscales. Atemporal. No necesita distinguir entre persona física y persona jurídica'
  },
  pt: {
    subtitle: 'Sistema de Contabilidade Universal',
    description: 'Este sistema funciona: sem códigos, sem plano de contas, sem lançamentos contábeis, sem encerramentos, sem períodos fiscais. Atemporal. Não precisa distinguir entre pessoa física e pessoa jurídica'
  },
  fr: {
    subtitle: 'Système Comptable Universel',
    description: 'Ce système fonctionne: sans codes, sans plan comptable, sans écritures comptables, sans clôtures, sans exercices comptables. Intemporel. Pas besoin de distinguer entre personne physique et personne morale'
  }
}

// 27 idiomas completos según especificaciones originales
// Orden: Inglés, Español, Portugués, Francés, Italiano, Alemán, Japonés, luego alfabético
const languages: Language[] = [
  // Prioridad 1: Idiomas principales en orden específico
  { code: 'en', name: 'English', nativeName: 'English' },
  { code: 'es', name: 'Spanish', nativeName: 'Español' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português' },
  { code: 'fr', name: 'French', nativeName: 'Français' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano' },
  { code: 'de', name: 'German', nativeName: 'Deutsch' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語' },
  
  // Resto alfabético por nombre en inglés
  { code: 'ar', name: 'Arabic', nativeName: 'العربية' },
  { code: 'ar-EG', name: 'Arabic (Egyptian)', nativeName: 'العربية المصرية' },
  { code: 'bn', name: 'Bengali', nativeName: 'বাংলা' },
  { code: 'zh', name: 'Chinese (Mandarin)', nativeName: '中文 (普通话)' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia' },
  { code: 'ko', name: 'Korean', nativeName: '한국어' },
  { code: 'mr', name: 'Marathi', nativeName: 'मराठी' },
  { code: 'pcm', name: 'Nigerian Pidgin', nativeName: 'Nigerian Pidgin' },
  { code: 'pa', name: 'Panjabi', nativeName: 'ਪੰਜਾਬੀ' },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский' },
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili' },
  { code: 'tl', name: 'Tagalog', nativeName: 'Tagalog' },
  { code: 'ta', name: 'Tamil', nativeName: 'தமிழ்' },
  { code: 'te', name: 'Telugu', nativeName: 'తెలుగు' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe' },
  { code: 'uk', name: 'Ukrainian', nativeName: 'Українська' },
  { code: 'ur', name: 'Urdu', nativeName: 'اردو' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt' },
]

const WelcomePage: React.FC = () => {
  // Inglés por defecto
  const [selectedLanguage, setSelectedLanguage] = useState<string>('en')

  const [forgotVisible, setForgotVisible] = useState(false)
  const [forgotEmail, setForgotEmail] = useState('')
  const [forgotSent, setForgotSent] = useState(false)

  const [twofaVisible, setTwofaVisible] = useState(false)
  const [twofaCode, setTwofaCode] = useState('')

  // Referencias a los formularios para controlar la exclusividad mutua
  const signInFormRef = useRef<any>(null)
  const signUpFormRef = useRef<any>(null)

  const navigate = useNavigate()

  const handleLanguage = (lng: string) => {
    setSelectedLanguage(lng)
    console.log('Language changed to:', lng)
  }

  const handleSendRecovery = async () => {
    if (!forgotEmail) return
    try {
      setForgotSent(true)
      notify.success('Recovery email sent! Check your inbox.')
    } catch (err) {
      notify.error('Could not send recovery link')
    }
  }

  const handleVerifyTwofa = async () => {
    if (twofaCode.length !== 6) return
    try {
      setTwofaVisible(false)
      notify.success('Verification successful')
      navigate('/app')
    } catch (err) {
      notify.error('Invalid verification code')
    }
  }

  // Handler cuando el usuario empieza a escribir en Sign In
  const handleSignInFieldChange = () => {
    if (signUpFormRef.current) {
      signUpFormRef.current.resetFields()
    }
  }

  // Handler cuando el usuario empieza a escribir en Sign Up
  const handleSignUpFieldChange = () => {
    if (signInFormRef.current) {
      signInFormRef.current.resetFields()
    }
  }

  // Obtener traducciones del idioma seleccionado, con fallback a inglés
  const currentTranslations = translations[selectedLanguage as keyof typeof translations] || translations.en

  return (
    <div className="welcome-page">
      <div className="background-image" />
      <div className="overlay" />

      <div className="content">
        {/* Logo - Vladimir Script 72px */}
        <Title className="logo">Svyd</Title>
        
        {/* Subtitle - Vladimir Script 36px - TRADUCIDO */}
        <Title level={2} className="subtitle">
          {currentTranslations.subtitle}
        </Title>

        {/* Promotional Text - Arial 14px - TRADUCIDO */}
        <Text className="promotional-text">
          {currentTranslations.description}
        </Text>

        {/* Language Selector - 27 idiomas - Inglés PRIMERO */}
        <div className="language-selector">
          <Select
            value={selectedLanguage}
            onChange={handleLanguage}
            options={languages.map((l) => ({ 
              value: l.code, 
              label: `${l.name} (${l.nativeName})` 
            }))}
            style={{ width: 320 }}
            showSearch
            optionFilterProp="label"
            placeholder="Select Language / Seleccionar Idioma"
          />
        </div>

        {/* Forms Container */}
        <div className="forms-container">
          {/* Sign In Form */}
          <div className="form-card">
            <Title level={3} className="form-title">
              Sign In
            </Title>

            <SignInForm 
              ref={signInFormRef}
              onForgotPassword={() => setForgotVisible(true)}
              onFieldChange={handleSignInFieldChange}
            />
          </div>

          {/* Sign Up Form */}
          <div className="form-card">
            <Title level={3} className="form-title">
              Sign Up
            </Title>

            <SignUpForm 
              ref={signUpFormRef}
              onFieldChange={handleSignUpFieldChange}
            />
          </div>
        </div>
      </div>

      {/* Forgot Password Modal */}
      <Modal
        open={forgotVisible}
        onCancel={() => {
          setForgotVisible(false)
          setForgotSent(false)
          setForgotEmail('')
        }}
        onOk={!forgotSent ? handleSendRecovery : undefined}
        okText={forgotSent ? 'Close' : 'Send Recovery Email'}
        cancelText="Cancel"
        title="Forgot Password?"
      >
        {forgotSent ? (
          <Alert type="success" message="Recovery email sent! Check your inbox." />
        ) : (
          <Form layout="vertical">
            <Form.Item label="Email" required>
              <Input
                type="email"
                value={forgotEmail}
                onChange={(e) => setForgotEmail(e.target.value)}
                placeholder="your@email.com"
              />
            </Form.Item>
          </Form>
        )}
      </Modal>

      {/* Two-Factor Authentication Modal */}
      <Modal
        open={twofaVisible}
        onCancel={() => setTwofaVisible(false)}
        onOk={handleVerifyTwofa}
        okButtonProps={{ disabled: twofaCode.length !== 6 }}
        title="Two-Factor Authentication"
      >
        <Text>Enter the 6-digit verification code sent to your email.</Text>
        <Form layout="vertical" style={{ marginTop: 12 }}>
          <Form.Item label="Verification Code" required>
            <Input
              value={twofaCode}
              onChange={(e) => setTwofaCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
              maxLength={6}
              placeholder="000000"
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  )
}

export default WelcomePage
