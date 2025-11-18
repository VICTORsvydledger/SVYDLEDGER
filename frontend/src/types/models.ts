// Centralized domain models for the frontend

// Auth
export interface User {
  id: number
  email: string
  username: string
  full_name: string
  is_active: boolean
  roles: string[]
}

export interface AuthResponse {
  access_token: string
  token_type: string
  expires_in: number
}

// Accounting
export enum AccountType {
  ASSET = 'ASSET',
  LIABILITY = 'LIABILITY',
  EQUITY = 'EQUITY',
  REVENUE = 'REVENUE',
  EXPENSE = 'EXPENSE',
  COST = 'COST',
}

export interface Account {
  id: number
  code: string
  name: string
  type: AccountType
  parentId?: number
  balance: number
  isActive: boolean
}

export interface JournalEntryLine {
  id?: number
  accountId: number
  accountCode?: string
  accountName?: string
  debit: number
  credit: number
  description?: string
}

export interface JournalEntry {
  id?: number
  date: string
  description: string
  reference?: string
  lines: JournalEntryLine[]
  isPosted?: boolean
}

// Reports
export enum ReportType {
  BALANCE_SHEET = 'balance_sheet',
  INCOME_STATEMENT = 'income_statement',
  CASH_FLOW = 'cash_flow',
  TRIAL_BALANCE = 'trial_balance',
}

export enum ReportFormat {
  PDF = 'pdf',
  EXCEL = 'excel',
  CSV = 'csv',
  JSON = 'json',
}

export interface Report {
  reportId: string
  type: ReportType
  format: ReportFormat
  status: 'generating' | 'completed' | 'failed'
  createdAt: string
  downloadUrl?: string
}
