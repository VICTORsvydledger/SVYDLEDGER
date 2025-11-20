/**
 * Reports Page
 */

import React, { useState } from 'react'
import { Typography, Card, Button, Select, DatePicker, Space, Table, Tag } from 'antd'
import { DownloadOutlined, FileTextOutlined } from '@ant-design/icons'

const { Title } = Typography
const { RangePicker } = DatePicker

const ReportsPage: React.FC = () => {
  const [reportType, setReportType] = useState('balance_sheet')
  const [format, setFormat] = useState('pdf')

  const reportTypes = [
    { label: 'Balance General', value: 'balance_sheet' },
    { label: 'Estado de Resultados', value: 'income_statement' },
    { label: 'Flujo de Efectivo', value: 'cash_flow' },
    { label: 'Balance de Comprobación', value: 'trial_balance' },
  ]

  const formats = [
    { label: 'PDF', value: 'pdf' },
    { label: 'Excel', value: 'excel' },
    { label: 'CSV', value: 'csv' },
  ]

  const columns = [
    {
      title: 'Reporte',
      dataIndex: 'type',
      key: 'type',
      render: (type: string) => reportTypes.find(r => r.value === type)?.label || type,
    },
    {
      title: 'Formato',
      dataIndex: 'format',
      key: 'format',
      render: (format: string) => format.toUpperCase(),
    },
    {
      title: 'Estado',
      dataIndex: 'status',
      key: 'status',
      render: (status: string) => {
        const colors = {
          generating: 'processing',
          completed: 'success',
          failed: 'error',
        }
        return <Tag color={colors[status as keyof typeof colors]}>{status}</Tag>
      },
    },
    {
      title: 'Fecha',
      dataIndex: 'createdAt',
      key: 'createdAt',
    },
    {
      title: 'Acciones',
      key: 'actions',
      render: (_: any, record: any) => (
        <Button
          type="link"
          icon={<DownloadOutlined />}
          disabled={record.status !== 'completed'}
        >
          Descargar
        </Button>
      ),
    },
  ]

  const handleGenerate = () => {
    // TODO: Llamar al Reports Service
    console.log('Generating report:', { reportType, format })
  }

  return (
    <div>
      <Title level={2}>Reportes Financieros</Title>

      <Card title="Generar Reporte" style={{ marginBottom: 24 }}>
        <Space direction="vertical" style={{ width: '100%' }} size="large">
          <Space wrap>
            <Select
              style={{ width: 250 }}
              placeholder="Tipo de Reporte"
              value={reportType}
              onChange={setReportType}
              options={reportTypes}
            />
            <RangePicker placeholder={['Fecha Inicio', 'Fecha Fin']} />
            <Select
              style={{ width: 120 }}
              placeholder="Formato"
              value={format}
              onChange={setFormat}
              options={formats}
            />
            <Button type="primary" icon={<FileTextOutlined />} onClick={handleGenerate}>
              Generar Reporte
            </Button>
          </Space>
        </Space>
      </Card>

      <Card title="Reportes Generados">
        <Table columns={columns} dataSource={[]} />
      </Card>
    </div>
  )
}

export default ReportsPage
