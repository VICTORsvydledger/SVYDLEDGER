// Lista de monedas principales del mundo
// USD primero, después las demás en orden alfabético por código
// Formato: Código ISO 4217 - Nombre en inglés

export interface Currency {
  code: string
  name: string
  symbol: string
}

export const currencies: Currency[] = [
  // USD primero (moneda por defecto)
  { code: 'USD', name: 'US Dollar', symbol: '$' },
  
  // Resto en orden alfabético por código
  { code: 'AED', name: 'UAE Dirham', symbol: '?.?' },
  { code: 'ARS', name: 'Argentine Peso', symbol: '$' },
  { code: 'AUD', name: 'Australian Dollar', symbol: 'A$' },
  { code: 'BDT', name: 'Bangladeshi Taka', symbol: '?' },
  { code: 'BRL', name: 'Brazilian Real', symbol: 'R$' },
  { code: 'CAD', name: 'Canadian Dollar', symbol: 'C$' },
  { code: 'CHF', name: 'Swiss Franc', symbol: 'CHF' },
  { code: 'CLP', name: 'Chilean Peso', symbol: '$' },
  { code: 'CNY', name: 'Chinese Yuan', symbol: '¥' },
  { code: 'COP', name: 'Colombian Peso', symbol: '$' },
  { code: 'CZK', name: 'Czech Koruna', symbol: 'K?' },
  { code: 'DKK', name: 'Danish Krone', symbol: 'kr' },
  { code: 'EGP', name: 'Egyptian Pound', symbol: '£' },
  { code: 'EUR', name: 'Euro', symbol: '€' },
  { code: 'GBP', name: 'British Pound', symbol: '£' },
  { code: 'HKD', name: 'Hong Kong Dollar', symbol: 'HK$' },
  { code: 'HUF', name: 'Hungarian Forint', symbol: 'Ft' },
  { code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp' },
  { code: 'ILS', name: 'Israeli Shekel', symbol: '?' },
  { code: 'INR', name: 'Indian Rupee', symbol: '?' },
  { code: 'JPY', name: 'Japanese Yen', symbol: '¥' },
  { code: 'KRW', name: 'South Korean Won', symbol: '?' },
  { code: 'MXN', name: 'Mexican Peso', symbol: '$' },
  { code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM' },
  { code: 'NOK', name: 'Norwegian Krone', symbol: 'kr' },
  { code: 'NZD', name: 'New Zealand Dollar', symbol: 'NZ$' },
  { code: 'PHP', name: 'Philippine Peso', symbol: '?' },
  { code: 'PKR', name: 'Pakistani Rupee', symbol: '?' },
  { code: 'PLN', name: 'Polish Zloty', symbol: 'z?' },
  { code: 'RUB', name: 'Russian Ruble', symbol: '?' },
  { code: 'SAR', name: 'Saudi Riyal', symbol: '?' },
  { code: 'SEK', name: 'Swedish Krona', symbol: 'kr' },
  { code: 'SGD', name: 'Singapore Dollar', symbol: 'S$' },
  { code: 'THB', name: 'Thai Baht', symbol: '?' },
  { code: 'TRY', name: 'Turkish Lira', symbol: '?' },
  { code: 'TWD', name: 'Taiwan Dollar', symbol: 'NT$' },
  { code: 'UAH', name: 'Ukrainian Hryvnia', symbol: '?' },
  { code: 'VND', name: 'Vietnamese Dong', symbol: '?' },
  { code: 'ZAR', name: 'South African Rand', symbol: 'R' }
]

export default currencies
