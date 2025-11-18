/**
 * Notifications wrapper (Ant Design)
 * Uso consistente para success/info/warning/error
 */
import { notification } from 'antd'

type Placement = 'topLeft' | 'topRight' | 'bottomLeft' | 'bottomRight'

const defaultPlacement: Placement = 'topRight'

function parseMessage(msg: unknown, fallback: string): string {
  if (typeof msg === 'string' && msg.trim()) return msg
  if (msg && typeof msg === 'object') {
    const anyMsg = msg as any
    return (
      anyMsg?.message || anyMsg?.error || anyMsg?.detail || anyMsg?.title || fallback
    )
  }
  return fallback
}

export const notify = {
  success(message?: unknown, description?: unknown, placement: Placement = defaultPlacement) {
    notification.success({
      message: parseMessage(message, 'Operación exitosa'),
      description: typeof description === 'string' ? description : undefined,
      placement,
    })
  },
  info(message?: unknown, description?: unknown, placement: Placement = defaultPlacement) {
    notification.info({
      message: parseMessage(message, 'Información'),
      description: typeof description === 'string' ? description : undefined,
      placement,
    })
  },
  warning(message?: unknown, description?: unknown, placement: Placement = defaultPlacement) {
    notification.warning({
      message: parseMessage(message, 'Advertencia'),
      description: typeof description === 'string' ? description : undefined,
      placement,
    })
  },
  error(message?: unknown, description?: unknown, placement: Placement = defaultPlacement) {
    notification.error({
      message: parseMessage(message, 'Error'),
      description: typeof description === 'string' ? description : undefined,
      placement,
    })
  },
}

export default notify
