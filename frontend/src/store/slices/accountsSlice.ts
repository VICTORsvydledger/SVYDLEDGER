/**
 * Accounts Slice - Chart of Accounts State Management
 */

import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import type { Account } from '@/types/models'

interface AccountsState {
  accounts: Account[]
  loading: boolean
  error: string | null
  selectedAccount: Account | null
}

const initialState: AccountsState = {
  accounts: [],
  loading: false,
  error: null,
  selectedAccount: null,
}

const accountsSlice = createSlice({
  name: 'accounts',
  initialState,
  reducers: {
    fetchAccountsStart: (state) => {
      state.loading = true
      state.error = null
    },
    fetchAccountsSuccess: (state, action: PayloadAction<Account[]>) => {
      state.accounts = action.payload
      state.loading = false
    },
    fetchAccountsFailure: (state, action: PayloadAction<string>) => {
      state.loading = false
      state.error = action.payload
    },
    addAccount: (state, action: PayloadAction<Account>) => {
      state.accounts.push(action.payload)
    },
    updateAccount: (state, action: PayloadAction<Account>) => {
      const index = state.accounts.findIndex((a) => a.id === action.payload.id)
      if (index !== -1) {
        state.accounts[index] = action.payload
      }
    },
    selectAccount: (state, action: PayloadAction<Account | null>) => {
      state.selectedAccount = action.payload
    },
  },
})

export const {
  fetchAccountsStart,
  fetchAccountsSuccess,
  fetchAccountsFailure,
  addAccount,
  updateAccount,
  selectAccount,
} = accountsSlice.actions

export default accountsSlice.reducer
