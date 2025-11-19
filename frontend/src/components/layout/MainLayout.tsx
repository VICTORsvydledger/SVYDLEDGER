/**
 * Main Layout Component
 */

import React, { useState } from 'react'
import { Outlet, useNavigate } from 'react-router-dom'
import { Layout, Menu, Avatar, Dropdown, Typography, Select } from 'antd'
import {
  DashboardOutlined,
  FileTextOutlined,
  BarChartOutlined,
  SettingOutlined,
  LogoutOutlined,
  UserOutlined,
  MenuFoldOutlined,
  MenuUnfoldOutlined,
} from '@ant-design/icons'
import { useAppDispatch, useAppSelector } from '@/store/hooks'
import { logout } from '@/store/slices/authSlice'
import { useTranslation } from 'react-i18next'
import './MainLayout.scss'

const { Header, Sider, Content } = Layout
const { Text } = Typography

const MainLayout: React.FC = () => {
  const [collapsed, setCollapsed] = useState(false)
  const navigate = useNavigate()
  const dispatch = useAppDispatch()
  const { user } = useAppSelector((state) => state.auth)
  const { i18n } = useTranslation()

  const handleLogout = () => {
    dispatch(logout())
    navigate('/login')
  }

  const userMenuItems = [
    {
      key: 'profile',
      icon: <UserOutlined />,
      label: 'Perfil',
      onClick: () => navigate('/app/settings'),
    },
    {
      key: 'logout',
      icon: <LogoutOutlined />,
      label: 'Cerrar sesión',
      onClick: handleLogout,
    },
  ]

  const mainMenuItems = [
    {
      key: 'dashboard',
      icon: <DashboardOutlined />,
      label: 'Dashboard',
      onClick: () => navigate('/app/dashboard'),
    },
    {
      key: 'accounting',
      icon: <FileTextOutlined />,
      label: 'Contabilidad',
      children: [
        {
          key: 'accounts',
          label: 'Plan de Cuentas',
          onClick: () => navigate('/app/accounting/accounts'),
        },
        {
          key: 'journal-entries',
          label: 'Asientos Contables',
          onClick: () => navigate('/app/accounting/journal-entries'),
        },
      ],
    },
    {
      key: 'reports',
      icon: <BarChartOutlined />,
      label: 'Reportes',
      onClick: () => navigate('/app/reports'),
    },
    {
      key: 'settings',
      icon: <SettingOutlined />,
      label: 'Configuración',
      onClick: () => navigate('/app/settings'),
    },
  ]

  return (
    <Layout className="main-layout">
      <Sider trigger={null} collapsible collapsed={collapsed} className="sidebar">
        <div className="logo">
          <Text strong style={{ color: 'white', fontSize: collapsed ? '16px' : '20px' }}>
            {collapsed ? 'SL' : 'SVYD LEDGER'}
          </Text>
        </div>
        <Menu theme="dark" mode="inline" defaultSelectedKeys={['dashboard']} items={mainMenuItems} />
      </Sider>
      <Layout>
        <Header className="header">
          <div className="header-left">
            {React.createElement(collapsed ? MenuUnfoldOutlined : MenuFoldOutlined, {
              className: 'trigger',
              onClick: () => setCollapsed(!collapsed),
            })}
          </div>
          <div className="header-right" style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <Select
              size="small"
              value={i18n.language?.startsWith('en') ? 'en' : 'es'}
              style={{ width: 100 }}
              onChange={(lng) => i18n.changeLanguage(lng)}
              options={[
                { value: 'es', label: 'Español' },
                { value: 'en', label: 'English' },
              ]}
            />
            <Dropdown menu={{ items: userMenuItems }} placement="bottomRight">
              <div className="user-info">
                <Avatar icon={<UserOutlined />} />
                <Text style={{ marginLeft: 8 }}>{user?.full_name || user?.username || 'Usuario'}</Text>
              </div>
            </Dropdown>
          </div>
        </Header>
        <Content className="content">
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  )
}

export default MainLayout
