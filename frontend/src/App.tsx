/**
 * SVYD LEDGER - Main App Component
 */

import React from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import MainLayout from './components/layout/MainLayout'
import WelcomePage from './pages/auth/WelcomePage'
import LoginPage from './pages/auth/LoginPage'
import RegisterPage from './pages/auth/RegisterPage'
import DashboardPage from './pages/DashboardPage'
import AccountsPage from './pages/accounting/AccountsPage'
import JournalEntriesPage from './pages/accounting/JournalEntriesPage'
import ReportsPage from './pages/reports/ReportsPage'
import SettingsPage from './pages/SettingsPage'
import { useAppSelector } from './store/hooks'

const App: React.FC = () => {
  const { isAuthenticated } = useAppSelector((state) => state.auth)

  return (
    <Routes>
      {/* Public Routes */}
      <Route path="/" element={<WelcomePage />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />

      {/* Protected Routes */}
      <Route
        path="/app"
        element={
          isAuthenticated ? (
            <MainLayout />
          ) : (
            <Navigate to="/" replace />
          )
        }
      >
        <Route index element={<Navigate to="/app/dashboard" replace />} />
        <Route path="dashboard" element={<DashboardPage />} />
        
        {/* Accounting */}
        <Route path="accounting">
          <Route path="accounts" element={<AccountsPage />} />
          <Route path="journal-entries" element={<JournalEntriesPage />} />
        </Route>

        {/* Reports */}
        <Route path="reports" element={<ReportsPage />} />

        {/* Settings */}
        <Route path="settings" element={<SettingsPage />} />
      </Route>

      {/* 404 */}
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}

export default App
