/**
 * Reports Slice - Financial Reports State Management
 */

import { createSlice, PayloadAction } from '@reduxjs/toolkit'

export enum ReportType {
  BALANCE_SHEET = 'balance_sheet',
  INCOME_STATEMENT = 'income_statement',
  CASH_FLOW = 'cash_flow',
  TRIAL_BALANCE = 'trial_balance',
}

export interface Report {
  id: string
  type: ReportType
  format: string
  status: 'generating' | 'completed' | 'failed'
  createdAt: string
  downloadUrl?: string
}

interface ReportsState {
  reports: Report[]
  loading: boolean
  error: string | null
  generatingReport: boolean
}

const initialState: ReportsState = {
  reports: [],
  loading: false,
  error: null,
  generatingReport: false,
}

const reportsSlice = createSlice({
  name: 'reports',
  initialState,
  reducers: {
    fetchReportsStart: (state) => {
      state.loading = true
      state.error = null
    },
    fetchReportsSuccess: (state, action: PayloadAction<Report[]>) => {
      state.reports = action.payload
      state.loading = false
    },
    fetchReportsFailure: (state, action: PayloadAction<string>) => {
      state.loading = false
      state.error = action.payload
    },
    generateReportStart: (state) => {
      state.generatingReport = true
      state.error = null
    },
    generateReportSuccess: (state, action: PayloadAction<Report>) => {
      state.reports.unshift(action.payload)
      state.generatingReport = false
    },
    generateReportFailure: (state, action: PayloadAction<string>) => {
      state.generatingReport = false
      state.error = action.payload
    },
  },
})

export const {
  fetchReportsStart,
  fetchReportsSuccess,
  fetchReportsFailure,
  generateReportStart,
  generateReportSuccess,
  generateReportFailure,
} = reportsSlice.actions

export default reportsSlice.reducer
