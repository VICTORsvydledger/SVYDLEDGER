/**
 * Accounting Service API
 */

import apiClient from './apiClient'
import { Account, JournalEntry } from '@/store/slices/accountsSlice'

const API_VERSION = 'v1'

export const accountingService = {
  // Accounts
  getAccounts: async (): Promise<Account[]> => {
    const response = await apiClient.get(`/api/${API_VERSION}/accounts`)
    return response.data
  },

  getAccount: async (id: number): Promise<Account> => {
    const response = await apiClient.get(`/api/${API_VERSION}/accounts/${id}`)
    return response.data
  },

  createAccount: async (data: Partial<Account>): Promise<Account> => {
    const response = await apiClient.post(`/api/${API_VERSION}/accounts`, data)
    return response.data
  },

  updateAccount: async (id: number, data: Partial<Account>): Promise<Account> => {
    const response = await apiClient.put(`/api/${API_VERSION}/accounts/${id}`, data)
    return response.data
  },

  // Journal Entries
  getJournalEntries: async (params?: {
    startDate?: string
    endDate?: string
    page?: number
    limit?: number
  }): Promise<{ data: JournalEntry[]; pagination: any }> => {
    const response = await apiClient.get(`/api/${API_VERSION}/journal-entries`, { params })
    return response.data
  },

  createJournalEntry: async (data: JournalEntry): Promise<JournalEntry> => {
    const response = await apiClient.post(`/api/${API_VERSION}/journal-entries`, data)
    return response.data
  },

  // Balances
  getTrialBalance: async (asOfDate?: string): Promise<any> => {
    const response = await apiClient.get(`/api/${API_VERSION}/balances/trial-balance`, {
      params: { asOfDate },
    })
    return response.data
  },

  getBalanceSheet: async (asOfDate?: string): Promise<any> => {
    const response = await apiClient.get(`/api/${API_VERSION}/balances/balance-sheet`, {
      params: { asOfDate },
    })
    return response.data
  },

  getIncomeStatement: async (startDate: string, endDate: string): Promise<any> => {
    const response = await apiClient.get(`/api/${API_VERSION}/balances/income-statement`, {
      params: { startDate, endDate },
    })
    return response.data
  },
}
