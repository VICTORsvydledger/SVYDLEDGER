/**
 * Auth Service - Identity Service API
 */

import apiClient from './apiClient'

const API_VERSION = 'v1'

export interface LoginRequest {
  username: string
  password: string
}

export interface RegisterRequest {
  email: string
  username: string
  fullName: string
  password: string
}

export interface AuthResponse {
  access_token: string
  token_type: string
  expires_in: number
}

export interface User {
  id: number
  email: string
  username: string
  full_name: string
  is_active: boolean
  roles: string[]
}

export const authService = {
  login: async (credentials: LoginRequest): Promise<AuthResponse> => {
    const formData = new URLSearchParams()
    formData.append('username', credentials.username)
    formData.append('password', credentials.password)

    const response = await apiClient.post(`/api/${API_VERSION}/auth/token`, formData, {
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    })
    return response.data
  },

  register: async (data: RegisterRequest): Promise<User> => {
    const response = await apiClient.post(`/api/${API_VERSION}/auth/register`, {
      email: data.email,
      username: data.username,
      full_name: data.fullName,
      password: data.password,
    })
    return response.data
  },

  getCurrentUser: async (): Promise<User> => {
    const response = await apiClient.get(`/api/${API_VERSION}/auth/me`)
    return response.data
  },

  logout: () => {
    localStorage.removeItem('token')
  },
}
