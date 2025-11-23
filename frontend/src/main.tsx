/**
 * SVYD LEDGER - Main Entry Point
 * Sistema de Contabilidad Universal
 * Region: Central US
 */

import React from 'react'
import ReactDOM from 'react-dom/client'
import { Provider } from 'react-redux'
import { BrowserRouter } from 'react-router-dom'
import { ConfigProvider } from 'antd'
import App from './App'
import { store } from './store'
import './styles/main.scss'
import ErrorBoundary from '@/components/common/ErrorBoundary'
import './i18n/i18n' // Inicializar i18n

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ErrorBoundary>
      <Provider store={store}>
        <BrowserRouter>
          <ConfigProvider
            theme={{
              token: {
                colorPrimary: '#1976d2',
              },
            }}
          >
            <App />
          </ConfigProvider>
        </BrowserRouter>
      </Provider>
    </ErrorBoundary>
  </React.StrictMode>,
)
