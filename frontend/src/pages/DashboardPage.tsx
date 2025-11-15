/**
 * Dashboard Page
 */

import React from 'react'
import { Row, Col, Card, Statistic, Typography } from 'antd'
import {
  DollarOutlined,
  RiseOutlined,
  FallOutlined,
  FileTextOutlined,
} from '@ant-design/icons'

const { Title } = Typography

const DashboardPage: React.FC = () => {
  return (
    <div>
      <Title level={2}>Dashboard</Title>

      <Row gutter={[16, 16]}>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="Activos Totales"
              value={1234567.89}
              precision={2}
              valueStyle={{ color: '#3f8600' }}
              prefix={<DollarOutlined />}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="Pasivos Totales"
              value={567890.12}
              precision={2}
              valueStyle={{ color: '#cf1322' }}
              prefix={<FallOutlined />}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="Ingresos del Mes"
              value={98765.43}
              precision={2}
              valueStyle={{ color: '#1890ff' }}
              prefix={<RiseOutlined />}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="Asientos Contables"
              value={156}
              prefix={<FileTextOutlined />}
            />
          </Card>
        </Col>
      </Row>

      <Row gutter={[16, 16]} style={{ marginTop: 24 }}>
        <Col xs={24} lg={12}>
          <Card title="Últimas Transacciones">
            <p>TODO: Tabla de últimas transacciones</p>
          </Card>
        </Col>
        <Col xs={24} lg={12}>
          <Card title="Estados Financieros">
            <p>TODO: Gráficos de estados financieros</p>
          </Card>
        </Col>
      </Row>
    </div>
  )
}

export default DashboardPage
