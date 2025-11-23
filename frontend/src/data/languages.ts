// Lista de 27 idiomas del sistema (igual que WelcomePage)
// English primero, luego Español, Portugués, Francés, Italiano, Alemán, Japonés, y resto alfabético

export interface Language {
  code: string
  name: string
  nativeName: string
}

export const languages: Language[] = [
  // Prioridad 1: Idiomas principales en orden específico
  { code: 'en', name: 'English', nativeName: 'English' },
  { code: 'es', name: 'Spanish', nativeName: 'Espanol' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Portugues' },
  { code: 'fr', name: 'French', nativeName: 'Francais' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano' },
  { code: 'de', name: 'German', nativeName: 'Deutsch' },
  { code: 'ja', name: 'Japanese', nativeName: 'Japanese' },
  
  // Resto alfabético por nombre en inglés
  { code: 'ar', name: 'Arabic', nativeName: 'Arabic' },
  { code: 'ar-EG', name: 'Arabic (Egyptian)', nativeName: 'Arabic (Egyptian)' },
  { code: 'bn', name: 'Bengali', nativeName: 'Bengali' },
  { code: 'zh', name: 'Chinese (Mandarin)', nativeName: 'Chinese (Mandarin)' },
  { code: 'hi', name: 'Hindi', nativeName: 'Hindi' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia' },
  { code: 'ko', name: 'Korean', nativeName: 'Korean' },
  { code: 'mr', name: 'Marathi', nativeName: 'Marathi' },
  { code: 'pcm', name: 'Nigerian Pidgin', nativeName: 'Nigerian Pidgin' },
  { code: 'pa', name: 'Panjabi', nativeName: 'Panjabi' },
  { code: 'fa', name: 'Persian', nativeName: 'Persian' },
  { code: 'ru', name: 'Russian', nativeName: 'Russian' },
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili' },
  { code: 'tl', name: 'Tagalog', nativeName: 'Tagalog' },
  { code: 'ta', name: 'Tamil', nativeName: 'Tamil' },
  { code: 'te', name: 'Telugu', nativeName: 'Telugu' },
  { code: 'tr', name: 'Turkish', nativeName: 'Turkce' },
  { code: 'uk', name: 'Ukrainian', nativeName: 'Ukrainian' },
  { code: 'ur', name: 'Urdu', nativeName: 'Urdu' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tieng Viet' }
]

export default languages
