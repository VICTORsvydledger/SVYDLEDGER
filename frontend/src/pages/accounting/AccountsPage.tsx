/**
 * Accounts Page - Chart of Accounts
 */

import React from 'react'
import { Typography, Button, Table } from 'antd'
import { PlusOutlined } from '@ant-design/icons'

const { Title } = Typography

const AccountsPage: React.FC = () => {
  // TODO: Obtener cuentas del Accounting Service

  const columns = [
    {
      title: 'Código',
      dataIndex: 'code',
      key: 'code',
    },
    {
      title: 'Nombre',
      dataIndex: 'name',
      key: 'name',
    },
    {
      title: 'Tipo',
      dataIndex: 'type',
      key: 'type',
    },
    {
      title: 'Balance',
      dataIndex: 'balance',
      key: 'balance',
      render: (value: number) => `$${value.toFixed(2)}`,
    },
  ]

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 16 }}>
        <Title level={2}>Plan de Cuentas</Title>
        <Button type="primary" icon={<PlusOutlined />}>
          Nueva Cuenta
        </Button>
      </div>

      <Table columns={columns} dataSource={[]} />
    </div>
  )
}

export default AccountsPage
