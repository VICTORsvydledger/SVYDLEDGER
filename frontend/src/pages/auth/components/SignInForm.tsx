import React, { useState } from 'react'
import { Form, Input, Button } from 'antd'
import { UserOutlined, LockOutlined } from '@ant-design/icons'
import notify from '@/lib/notifications'

interface SignInFormProps {
  onForgotPassword: () => void
}

const SignInForm: React.FC<SignInFormProps> = ({ onForgotPassword }) => {
  const [form] = Form.useForm()
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (values: { email: string; password: string }) => {
    setLoading(true)
    try {
      // TODO: Implement real authentication service
      console.log('Sign In attempt:', values.email)
      
      // Simulación temporal
      await new Promise((resolve) => setTimeout(resolve, 1000))
      
      notify.success('Sign in successful!')
      
      // TODO: Navigate to dashboard or trigger 2FA modal
      // navigate('/app')
    } catch (error) {
      notify.error('Invalid email or password')
    } finally {
      setLoading(false)
    }
  }

  return (
    <Form
      form={form}
      layout="vertical"
      onFinish={handleSubmit}
      autoComplete="off"
      className="auth-form"
    >
      <Form.Item
        label="Email"
        name="email"
        rules={[
          { required: true, message: 'Email is required' },
          { type: 'email', message: 'Invalid email format' },
        ]}
      >
        <Input
          prefix={<UserOutlined />}
          placeholder=""
          size="large"
        />
      </Form.Item>

      <Form.Item
        label="Password"
        name="password"
        rules={[
          { required: true, message: 'Password is required' },
          { min: 6, message: 'Password must be at least 6 characters' },
        ]}
      >
        <Input.Password
          prefix={<LockOutlined />}
          placeholder=""
          size="large"
        />
      </Form.Item>

      <Form.Item>
        <Button
          type="link"
          onClick={onForgotPassword}
          style={{ padding: 0, marginBottom: 12 }}
        >
          Forgot your password?
        </Button>
      </Form.Item>

      <Form.Item>
        <Button
          type="primary"
          htmlType="submit"
          loading={loading}
          block
          size="large"
        >
          Log In
        </Button>
      </Form.Item>
    </Form>
  )
}

export default SignInForm
