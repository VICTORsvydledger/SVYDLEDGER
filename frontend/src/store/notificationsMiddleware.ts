/**
 * Global Redux listener middleware for toasts
 */
import { createListenerMiddleware, isRejectedWithValue } from '@reduxjs/toolkit'
import notify from '@/lib/notifications'

export const notificationsMiddleware = createListenerMiddleware()

notificationsMiddleware.startListening({
  predicate: (_action) => false,
  effect: async () => {},
})

// Generic rejected action handler (for thunks)
export const rtkQueryErrorLogger = () => (next: any) => (action: any) => {
  if (isRejectedWithValue(action)) {
    const err = action?.payload || action?.error
    notify.error(err?.message || 'Operación fallida')
  }
  return next(action)
}

export default notificationsMiddleware
