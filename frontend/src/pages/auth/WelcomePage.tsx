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
    description: 'আধুনিক প্রতিষ্ঠানের জন্য হিসাব ব্যবস্থা, আর্থিক প্রতিবেদন প্রস্তুতি এবং কর সম্মতির সম্পূর্ণ সমাধান। খতিয়ান, জাবেদা দাখিলা এবং আর্থিক বিবরণীর সম্পূর্ণ নিয়ন্ত্রণ নিরাপদ ক্লাউড প্রযুক্তিতে।',
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
    description: 'आधुनिक उद्योगांसाठी लेखा व्यवस्थापन, आर्थिक विवरणपत्र तयार करणे आणि कर अनुपालनाचे संपूर्ण समाधान. सुरक्षित क्लाउड तंत्रज्ञानामध्ये kontoवही, नोंदी आणि आर्थिक विवरणांचे संपूर्ण नियंत्रण.',
    welcome: 'स्वागत आहे'
  },
  pcm: {
    subtitle: 'Universal Accounting System and Money Management',
    description: 'Complete solution for account management, financial statement preparation, and tax compliance for modern businesses. Full control of ledger books, journal entries, and financial statements with secure cloud technology.',
    welcome: 'Welcome'
  },
  pa: {
    subtitle: 'ਸਰਵ-ਵਿਆਪਕ ਲੇਖਾ ਪ੍ਰਣਾਲੀ ਅਤੇ ਵਿੱਤੀ ਪ੍ਰਬੰਧਨ',
    description: 'ਆਧੁਨਿਕ Udਯੋਗਾਂ ਲਈ ਖਾਤਾ ਪ੍ਰਬੰਧਨ, ਵਿੱਤੀ ਬਿਆਨ ਤਿਆਰੀ ਅਤੇ ਟੈਕਸ ਪਾਲਣਾ ਦਾ ਸੰਪੂਰਨ ਹੱਲ। ਸੁਰੱਖਿਅਤ ਕਲਾਉਡ ਤਕਨਾਲੋਜੀ ਵਿੱਚ ਖਾਤਾ ਬਹੀ, ਰੋਜ਼ਨਾਮਚਾ ਐਂਟਰੀਆਂ ਅਤੇ ਵਿੱਤੀ ਬਿਆਨਾਂ ਦਾ ਪੂਰਾ ਨਿਯੰਤਰਣ।',
    welcome: 'ਜੀ ਆਇਆਂ ਨੂੰ'
  },
  fa: {
    subtitle: 'سیستم حسابداری جامع و مدیریت مالی',
    description: 'راه‌حل کامل برای مدیریت حساب‌ها، تهیه صورت‌های مالی و رعایت مقررات مالیاتی برای کسب‌وکارهای مدرن. کنترل کامل دفتر کل، ثبت‌های روزنامه و صورت‌های مالی با فناوری ابری امن.',
    welcome: 'خوش آمدید'
  },
  ru: {
    subtitle: 'Универсальная система бухгалтерского учёта и финансового управления',
    description: 'Комплексное решение для управления счетами, подготовки финансовой отчётности и налогового соответствия для современных предприятий. Полный контроль главной книги, журнальных записей и финансовых отчётов в безопасной облачной технологии.',
    welcome: 'Добро пожаловать'
  },
  sw: {
    subtitle: 'Mfumo wa Uhasibu wa Ulimwengu na Usimamizi wa Fedha',
    description: 'Suluhisho kamili kwa usimamizi wa akaunti, uandaaji wa taarifa za kifedha, na utii wa kodi kwa biashara za kisasa. Udhibiti kamili wa daftari kuu, maingizo ya jarida, na taarifa za kifedha kwa teknolojia salama ya wingu.',
    welcome: 'Karibu'
  },
  tl: {
    subtitle: 'Pandaigdigang Sistema ng Accounting at Pamamahala ng Pananalapi',
    description: 'Ang sistemang ito ay gumagana: walang mga account codes, walang chart of accounts, walang mga journal entries, walang mga fiscal closing, walang mga fiscal periods. Walang panahon. Hindi kailangang magtangi sa pagitan ng natural person at juridical person',
    welcome: 'Maligayang Pagdating'
  },
  ta: {
    subtitle: 'உலகளாவிய கணக்கியல் அமைப்பு மற்றும் நிதி மேலாண்மை',
    description: 'இந்த அமைப்பு செயல்படுகிறது: கணக்கு குறியீடுகள் இல்லாமல், கணக்கு விளக்கப்படம் இல்லாமல், இதழ் பதிவுகள் இல்லாமல், நிதியாண்டு முடிவுகள் இல்லாமல், நிதி காலங்கள் இல்லாமல். காலவரையற்றது. இயற்கை நபர் மற்றும் சட்ட நிறுவனம் இடையே வேறுபடுத்த தேவையில்லை',
    welcome: 'வரவேற்கிறோம்'
  },
  te: {
    subtitle: 'సార్వత్రిక అకౌంటింగ్ వ్యవస్ధ మరియు ఆర్థిక నిర్వహణ',
    description: 'ఈ వ్యవస్థ పనిచేస్తుంది: ఖాతా కోడ్‌లు లేకుండా, ఖాతాల చార్ట్ లేకుండా, జర్నల్ ఎంట్రీలు లేకుండా, ఆర్థిక మూసివేతలు లేకుండా, ఆర్థిక కాలాలు లేకుండా. కాలరహితం. సహజ వ్యక్తి మరియు చట్టపరమైన సంస్థ మధ్య వేరు చేయవలసిన అవసరం లేదు',
    welcome: 'స్వాగతం'
  },
  tr: {
    subtitle: 'Evrensel Muhasebe Sistemi ve Finansal Yönetim',
    description: 'Bu sistem çalışır: hesap kodları olmadan, hesap planı olmadan, yevmiye kayıtları olmadan, mali kapanışlar olmadan, mali dönemler olmadan. Zamansız. Gerçek kişi ile tüzel kişi arasında ayrım yapma gereği yok',
    welcome: 'Hoş Geldiniz'
  },
  uk: {
    subtitle: 'Універсальна система бухгалтерського обліку та фінансового управління',
    description: 'Комплексне рішення для управління рахунками, підготовки фінансової звітності та податкового відповідності для сучасних підприємств. Повний контроль головної книги, журнальних записів і фінансових звітів у безпечній хмарній технології.',
    welcome: 'Ласкаво просимо'
  },
  ur: {
    subtitle: 'یونیورسل اکاؤنٹنگ سسٹم اور مالیاتی انتظام',
    description: 'جدیدی کاروباروں کے لئے اکاؤنٹ منیجمنٹ، مالیاتی بیان کی تیاری اور ٹیکس کی تعمیل کے لئے مکمل حل۔ محفوظ کلاؤڈ ٹیکنالوجی کے ساتھ لیجر کی کتابوں، جریدے کی اندراجات، اور مالیاتی بیانات پر مکمل کنٹرول۔',
    welcome: 'خوش آمدید'
  },
  vi: {
    subtitle: 'Hệ thống Kế toán và Quản lý Tài chính Toàn cầu',
    description: 'Giải pháp toàn diện cho quản lý tài khoản, lập báo cáo tài chính và tuân thủ thuế cho các doanh nghiệp hiện đại. Kiểm soát hoàn toàn sổ cái, nhật ký giao dịch và báo cáo tài chính với công nghệ đám mây an toàn.',
    welcome: 'Chào mừng'
  }
}

// 27 idiomas completos según especificaciones originales
// Orden: Inglés, Español, Portugués, Francés, Italiano, Alemán, Japonés, luego alfabético
const languages: Language[] = [
