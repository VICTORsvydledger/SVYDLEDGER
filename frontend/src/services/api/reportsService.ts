/**
 * Reports Service API
 */

import apiClient from './apiClient'

const API_VERSION = 'v1'

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

export interface GenerateReportRequest {
  type: ReportType
  format: ReportFormat
  startDate?: string
  endDate?: string
  asOfDate?: string
  parameters?: Record<string, any>
}

export interface Report {
  reportId: string
  type: ReportType
  format: ReportFormat
  status: 'generating' | 'completed' | 'failed'
  createdAt: string
  downloadUrl?: string
}

export const reportsService = {
  generateReport: async (request: GenerateReportRequest): Promise<Report> => {
    const response = await apiClient.post(`/api/${API_VERSION}/reports/generate`, request)
    return response.data
  },

  getReportStatus: async (reportId: string): Promise<Report> => {
    const response = await apiClient.get(`/api/${API_VERSION}/reports/${reportId}/status`)
    return response.data
  },

  downloadReport: async (reportId: string): Promise<Blob> => {
    const response = await apiClient.get(`/api/${API_VERSION}/reports/${reportId}/download`, {
      responseType: 'blob',
    })
    return response.data
  },

  getBalanceSheet: async (asOfDate?: string, format: string = 'json'): Promise<any> => {
    const response = await apiClient.get(`/api/${API_VERSION}/reports/balance-sheet`, {
      params: { asOfDate, format },
    })
    return response.data
  },

  getIncomeStatement: async (
    startDate: string,
    endDate: string,
    format: string = 'json'
  ): Promise<any> => {
    const response = await apiClient.get(`/api/${API_VERSION}/reports/income-statement`, {
      params: { startDate, endDate, format },
    })
    return response.data
  },

  getCashFlow: async (
    startDate: string,
    endDate: string,
    format: string = 'json'
  ): Promise<any> => {
    const response = await apiClient.get(`/api/${API_VERSION}/reports/cash-flow`, {
      params: { startDate, endDate, format },
    })
    return response.data
  },
}
