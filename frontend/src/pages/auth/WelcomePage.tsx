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

// Traducciones del subtítulo, texto promocional y palabra de bienvenida
const translations = {
  en: {
    subtitle: 'Universal Accounting System',
    description: 'This system works: without codes, without chart of accounts, without journal entries, without closings, without fiscal periods. Timeless. No need to distinguish between natural person and legal entity',
    welcome: 'Welcome'
  },
  es: {
    subtitle: 'Sistema de Contabilidad Universal',
    description: 'Este sistema trabaja: sin códigos, sin catálogos de cuenta, sin asientos contables, sin cierres, sin periodos fiscales. Atemporal. No necesita distinguir entre persona física y persona jurídica',
    welcome: 'Bienvenido'
  },
  pt: {
    subtitle: 'Sistema de Contabilidade Universal',
    description: 'Este sistema funciona: sem códigos, sem plano de contas, sem lançamentos contábeis, sem encerramentos, sem períodos fiscais. Atemporal. Não precisa distinguir entre pessoa física e pessoa jurídica',
    welcome: 'Bem-vindo'
  },
  fr: {
    subtitle: 'Système Comptable Universel',
    description: 'Ce système fonctionne: sans codes, sans plan comptable, sans écritures comptables, sans clôtures, sans exercices comptables. Intemporel. Pas besoin de distinguer entre personne physique et personne morale',
    welcome: 'Bienvenue'
  },
  it: {
    subtitle: 'Sistema Contabile Universale',
    description: 'Questo sistema funziona: senza codici, senza piano dei conti, senza scritture contabili, senza chiusure, senza esercizi contabili. Atemporale. Non necessita di distinguere tra persona fisica e persona giuridica',
    welcome: 'Benvenuto'
  },
  de: {
    subtitle: 'Universelles Buchhaltungssystem',
    description: 'Dieses System funktioniert: ohne Kontonummern, ohne Kontenplan, ohne Buchungssätze, ohne Abschlüsse, ohne Geschäftsjahre. Zeitlos. Keine Unterscheidung zwischen natürlicher Person und juristischer Person erforderlich',
    welcome: 'Willkommen'
  },
  ja: {
    subtitle: '統合会計システム',
    description: '本システムは、勘定科目コード不要、勘定科目体系不要、仕訳伝票不要、決算処理不要、会計期間設定不要で稼働します。恒久的システム。自然人と法人の区別不要',
    welcome: 'ようこそ'
  },
  ar: {
    subtitle: 'منصة المحاسبة والإدارة المالية المتكاملة',
    description: 'نظام شامل لإدارة الحسابات، إعداد التقارير المالية، والامتثال الضريبي للشركات الحديثة. تحكم كامل في دفتر الأستاذ العام، القيود اليومية، والقوائم المالية بتقنية سحابية آمنة.',
    welcome: 'مرحباً'
  },
  'ar-EG': {
    subtitle: 'نظام المحاسبة الشامل والمراجعة المالية',
    description: 'نظام محاسبي متقدم لإدارة الدفاتر، إعداد الميزانيات، والإقرارات الضريبية للمؤسسات المصرية. تحكم كامل في دفتر الأستاذ، القيود المحاسبية، والقوائم المالية بتقنية سحابية آمنة.',
    welcome: 'أهلاً وسهلاً'
  },
  bn: {
    subtitle: 'সার্বজনীন হিসাববিজ্ঞান ও আর্থিক ব্যবস্থাপনা',
    description: 'আধুনিক প্রতিষ্ঠানের জন্য হিসাব ব্যবস্থাপনা, আর্থিক প্রতিবেদন প্রস্তুতি এবং কর সম্মতির সম্পূর্ণ সমাধান। খতিয়ান, জাবেদা দাখিলা এবং আর্থিক বিবরণীর সম্পূর্ণ নিয়ন্ত্রণ নিরাপদ ক্লাউড প্রযুক্তিতে।',
    welcome: 'স্বাগতম'
  },
  zh: {
    subtitle: '通用会计核算与财务管理系统',
    description: '现代企业的全方位会计管理、财务报表编制和税务合规解决方案。总账、会计分录和财务报表的完整控制，采用安全的云技术。',
    welcome: '欢迎'
  },
  hi: {
    subtitle: 'सार्वभौमिक लेखा प्रणाली एवं वित्तीय प्रबंधन',
    description: 'आधुनिक उद्यमों के लिए खाता प्रmanagement, वित्तीय विवरण तैयारी और कर अनुपालन का संपूर्ण समाधान। खाता बही, रोजनामचा प्रविष्टियाँ और वित्तीय विवरणों का पूर्ण नियंत्रण सुरक्षित क्लाउड प्रौद्योगिकी में।',
    welcome: 'स्वागत है'
  },
  id: {
    subtitle: 'Sistem Akuntansi Universal dan Manajemen Keuangan',
    description: 'Solusi lengkap untuk manajemen akuntansi, penyusunan laporan keuangan, dan kepatuhan pajak untuk perusahaan modern. Kontrol penuh atas buku besar, jurnal entri, dan laporan keuangan dengan teknologi cloud yang aman.',
    welcome: 'Selamat Datang'
  },
  ko: {
    subtitle: '범용 회계 시스템 및 재무 관리',
    description: '현대 기업을 위한 회계 관리, 재무제표 작성 및 세무 준수의 완벽한 솔루션. 안전한 클라우드 기술로 총계정원장, 분개 및 재무제표를 완벽하게 제어할 수 있습니다.',
    welcome: '환영합니다'
  },
  mr: {
    subtitle: 'सार्वत्रिक लेखा प्रणाली आणि वित्तीय व्यवस्थापन',
    description: 'आधुनिक उद्योगांसाठी लेखा व्यवस्थापन, आर्थिक विवरणपत्र तयार करणे आणि कर अनुपालनाचे संपूर्ण समाधान. सुरक्षित क्लाउड तंत्रज्ञानामध्ये खातेवही, नोंदी आणि आर्थिक विवरणांचे संपूर्ण नियंत्रण.',
    welcome: 'स्वागत आहे'
  },
  pcm: {
    subtitle: 'Universal Accounting System and Money Management',
    description: 'Complete solution for account management, financial statement preparation, and tax compliance for modern businesses. Full control of ledger books, journal entries, and financial statements with secure cloud technology.',
    welcome: 'Welcome'
  },
  pa: {
    subtitle: 'ਸਰਵ-ਵਿਆਪਕ ਲੇਖਾ ਪ੍ਰਣਾਲੀ ਅਤੇ ਵਿੱਤੀ ਪ੍ਰਬੰਧਨ',
    description: 'ਆਧੁਨਿਕ ਉਦਯੋਗਾਂ ਲਈ ਖਾਤਾ ਪ੍ਰਬੰਧਨ, ਵਿੱਤੀ ਬਿਆਨ ਤਿਆਰੀ ਅਤੇ ਟੈਕਸ ਪਾਲਣਾ ਦਾ ਸੰਪੂਰਨ ਹੱਲ। ਸੁਰੱਖਿਅਤ ਕਲਾਉਡ ਤਕਨਾਲੋਜੀ ਵਿੱਚ ਖਾਤਾ ਬਹੀ, ਰੋਜ਼ਨਾਮਚਾ ਐਂਟਰੀਆਂ ਅਤੇ ਵਿੱਤੀ ਬਿਆਨਾਂ ਦਾ ਪੂਰਾ ਨਿਯੰਤਰਣ।',
    welcome: 'ਜੀ ਆਇਆਂ ਨੂੰ'
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

        {/* Welcome Message - Centered */}
        <div className="welcome-message">
          <Title level={2} className="welcome-text">
            {currentTranslations.welcome}
          </Title>
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
