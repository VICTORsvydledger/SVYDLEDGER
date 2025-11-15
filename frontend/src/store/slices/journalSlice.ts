/**
 * Journal Slice - Journal Entries State Management
 */

import { createSlice, PayloadAction } from '@reduxjs/toolkit'

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

interface JournalState {
  entries: JournalEntry[]
  loading: boolean
  error: string | null
  selectedEntry: JournalEntry | null
}

const initialState: JournalState = {
  entries: [],
  loading: false,
  error: null,
  selectedEntry: null,
}

const journalSlice = createSlice({
  name: 'journal',
  initialState,
  reducers: {
    fetchEntriesStart: (state) => {
      state.loading = true
      state.error = null
    },
    fetchEntriesSuccess: (state, action: PayloadAction<JournalEntry[]>) => {
      state.entries = action.payload
      state.loading = false
    },
    fetchEntriesFailure: (state, action: PayloadAction<string>) => {
      state.loading = false
      state.error = action.payload
    },
    addEntry: (state, action: PayloadAction<JournalEntry>) => {
      state.entries.unshift(action.payload)
    },
    selectEntry: (state, action: PayloadAction<JournalEntry | null>) => {
      state.selectedEntry = action.payload
    },
  },
})

export const {
  fetchEntriesStart,
  fetchEntriesSuccess,
  fetchEntriesFailure,
  addEntry,
  selectEntry,
} = journalSlice.actions

export default journalSlice.reducer
