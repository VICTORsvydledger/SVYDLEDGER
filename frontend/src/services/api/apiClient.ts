/**
 * API Client Configuration
 * Axios instance with interceptors
 */

import axios, { AxiosInstance, AxiosError } from 'axios'
import notify from '@/lib/notifications'

// Prefer env var, fallback to relative '/api' so dev proxy works
const env = (import.meta as any).env || {}
const API_BASE_URL: string = env.VITE_API_URL ? String(env.VITE_API_URL) : '/api'

// Crear instancia de Axios
export const apiClient: AxiosInstance = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor - agregar token
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers = config.headers ?? {}
      ;(config.headers as any).Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error)
)

// Response interceptor - manejo de errores
apiClient.interceptors.response.use(
  (response) => response,
  (error: AxiosError<any>) => {
    const status = error.response?.status

    // Evitar toasts para 401 (ya se maneja redirección)
    if (status === 401) {
      localStorage.removeItem('token')
      if (!location.pathname.includes('/login')) {
        window.location.href = '/login'
      }
      return Promise.reject(error)
    }

    // Mostrar toast de error para 4xx/5xx
    const backendMsg = error.response?.data
    const fallback = status ? `Error ${status}` : 'Error de red'
    notify.error(backendMsg, error.message || fallback)

    return Promise.reject(error)
  }
)

export default apiClient
