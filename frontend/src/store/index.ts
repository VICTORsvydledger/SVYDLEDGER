/**
 * Redux Store Configuration
 */

import { configureStore } from '@reduxjs/toolkit'
import authReducer from './slices/authSlice'
import accountsReducer from './slices/accountsSlice'
import journalReducer from './slices/journalSlice'
import reportsReducer from './slices/reportsSlice'

export const store = configureStore({
  reducer: {
    auth: authReducer,
    accounts: accountsReducer,
    journal: journalReducer,
    reports: reportsReducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        // Ignore these action types
        ignoredActions: ['journal/addEntry'],
      },
    }),
})

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
