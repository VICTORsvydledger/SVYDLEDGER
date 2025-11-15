/**
 * Settings Page
 */

import React from 'react'
import { Typography, Card, Tabs, Form, Input, Button, Select, Switch } from 'antd'

const { Title } = Typography

const SettingsPage: React.FC = () => {
  const items = [
    {
      key: 'company',
      label: 'Empresa',
      children: (
        <Form layout="vertical">
          <Form.Item label="Nombre de la Empresa" name="companyName">
            <Input />
          </Form.Item>
          <Form.Item label="País" name="country">
            <Select
              options={[
                { label: 'México', value: 'MX' },
                { label: 'Estados Unidos', value: 'US' },
                { label: 'Colombia', value: 'CO' },
                { label: 'España', value: 'ES' },
              ]}
            />
          </Form.Item>
          <Form.Item label="Moneda" name="currency">
            <Select
              options={[
                { label: 'USD - Dólar', value: 'USD' },
                { label: 'MXN - Peso Mexicano', value: 'MXN' },
                { label: 'EUR - Euro', value: 'EUR' },
              ]}
            />
          </Form.Item>
          <Form.Item>
            <Button type="primary">Guardar Cambios</Button>
          </Form.Item>
        </Form>
      ),
    },
    {
      key: 'accounting',
      label: 'Contabilidad',
      children: (
        <Form layout="vertical">
          <Form.Item label="Año Fiscal Comienza" name="fiscalYearStart">
            <Select
              options={Array.from({ length: 12 }, (_, i) => ({
                label: new Date(2000, i).toLocaleString('es', { month: 'long' }),
                value: i + 1,
              }))}
            />
          </Form.Item>
          <Form.Item label="Norma Contable" name="accountingStandard">
            <Select
              options={[
                { label: 'IFRS - Estándares Internacionales', value: 'IFRS' },
                { label: 'US GAAP', value: 'GAAP_US' },
                { label: 'GAAP Local', value: 'GAAP_LOCAL' },
              ]}
            />
          </Form.Item>
          <Form.Item label="Decimales" name="decimals">
            <Select
              options={[
                { label: '2 decimales', value: 2 },
                { label: '4 decimales', value: 4 },
              ]}
            />
          </Form.Item>
          <Form.Item>
            <Button type="primary">Guardar Cambios</Button>
          </Form.Item>
        </Form>
      ),
    },
    {
      key: 'profile',
      label: 'Perfil',
      children: (
        <Form layout="vertical">
          <Form.Item label="Nombre Completo" name="fullName">
            <Input />
          </Form.Item>
          <Form.Item label="Email" name="email">
            <Input type="email" />
          </Form.Item>
          <Form.Item label="Idioma" name="language">
            <Select
              options={[
                { label: 'Español', value: 'es' },
                { label: 'English', value: 'en' },
                { label: 'Português', value: 'pt' },
              ]}
            />
          </Form.Item>
          <Form.Item>
            <Button type="primary">Guardar Cambios</Button>
          </Form.Item>
        </Form>
      ),
    },
    {
      key: 'notifications',
      label: 'Notificaciones',
      children: (
        <Form layout="vertical">
          <Form.Item label="Email de Notificaciones" name="emailNotifications">
            <Switch defaultChecked />
          </Form.Item>
          <Form.Item label="Reportes Automáticos" name="autoReports">
            <Switch />
          </Form.Item>
          <Form.Item label="Alertas de Vencimiento" name="dueAlerts">
            <Switch defaultChecked />
          </Form.Item>
          <Form.Item>
            <Button type="primary">Guardar Cambios</Button>
          </Form.Item>
        </Form>
      ),
    },
  ]

  return (
    <div>
      <Title level={2}>Configuración</Title>
      <Card>
        <Tabs items={items} />
      </Card>
    </div>
  )
}

export default SettingsPage
