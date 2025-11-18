/**
 * Redux Store Configuration
 */

import { configureStore } from '@reduxjs/toolkit'
import authReducer from './slices/authSlice'
import accountsReducer from './slices/accountsSlice'
import journalReducer from './slices/journalSlice'
import reportsReducer from './slices/reportsSlice'
import { rtkQueryErrorLogger } from './notificationsMiddleware'

const env = (import.meta as any).env || {}

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
        ignoredPaths: ['auth.user'],
      },
      immutableCheck: true,
      thunk: true,
    }).concat(rtkQueryErrorLogger as any),
  devTools: env.MODE !== 'production',
})

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
