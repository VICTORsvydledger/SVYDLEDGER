/**
 * Journal Entries Page
 */

import React from 'react'
import { Typography, Button, Table } from 'antd'
import { PlusOutlined } from '@ant-design/icons'

const { Title } = Typography

const JournalEntriesPage: React.FC = () => {
  // TODO: Obtener asientos del Accounting Service

  const columns = [
    {
      title: 'Fecha',
      dataIndex: 'date',
      key: 'date',
    },
    {
      title: 'Descripción',
      dataIndex: 'description',
      key: 'description',
    },
    {
      title: 'Referencia',
      dataIndex: 'reference',
      key: 'reference',
    },
    {
      title: 'Estado',
      dataIndex: 'isPosted',
      key: 'isPosted',
      render: (isPosted: boolean) => (isPosted ? 'Contabilizado' : 'Borrador'),
    },
  ]

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 16 }}>
        <Title level={2}>Asientos Contables</Title>
        <Button type="primary" icon={<PlusOutlined />}>
          Nuevo Asiento
        </Button>
      </div>

      <Table columns={columns} dataSource={[]} />
    </div>
  )
}

export default JournalEntriesPage
