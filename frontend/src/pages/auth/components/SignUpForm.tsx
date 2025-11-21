import { useState, forwardRef, useImperativeHandle, useEffect } from 'react'
import { Form, Input, Button } from 'antd'
import { UserOutlined, LockOutlined } from '@ant-design/icons'
import notify from '@/lib/notifications'

interface SignUpFormProps {
  onFieldChange?: () => void
  onSuccess?: (email: string) => void // Nueva prop para manejar el éxito
}

const SignUpForm = forwardRef<any, SignUpFormProps>(({ onFieldChange, onSuccess }, ref) => {
  const [form] = Form.useForm()
  const [loading, setLoading] = useState(false)
  const [hasContent, setHasContent] = useState(false)

  // Exponer el método resetFields al componente padre
  useImperativeHandle(ref, () => ({
    resetFields: () => {
      form.resetFields()
      setHasContent(false) // Resetear también el estado del contenido
    }
  }))

  // Verificar si hay contenido en los campos
  useEffect(() => {
    const checkContent = () => {
      const values = form.getFieldsValue()
      const hasAnyContent = Object.values(values).some(value => value && String(value).trim() !== '')
      setHasContent(hasAnyContent)
    }

    // Verificar contenido inicial
    checkContent()
  }, [form])

  const handleSubmit = async (values: { 
    email: string
    password: string
    confirmPassword: string 
  }) => {
    setLoading(true)
    try {
      // TODO: Implement real registration service
      console.log('Sign Up attempt:', values.email)
      
      // Simulación temporal
      await new Promise((resolve) => setTimeout(resolve, 1000))
      
      notify.success('Account created successfully!')
      
      // Navegar a PostAuthPage
      if (onSuccess) {
        onSuccess(values.email)
      }
      
      form.resetFields()
      setHasContent(false)
    } catch (error) {
      notify.error('Could not create account. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  // Handler para detectar cambios en los campos
  const handleFieldsChange = () => {
    if (onFieldChange) {
      onFieldChange()
    }
    
    // Verificar si hay contenido
    const values = form.getFieldsValue()
    const hasAnyContent = Object.values(values).some(value => value && String(value).trim() !== '')
    setHasContent(hasAnyContent)
  }

  return (
    <Form
      form={form}
      layout="vertical"
      onFinish={handleSubmit}
      onFieldsChange={handleFieldsChange}
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
          { min: 8, message: 'Password must be at least 8 characters' },
          {
            pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
            message: 'Password must contain uppercase, lowercase, and number',
          },
        ]}
      >
        <Input.Password
          prefix={<LockOutlined />}
          placeholder=""
          size="large"
        />
      </Form.Item>

      <Form.Item
        label="Confirm Password"
        name="confirmPassword"
        dependencies={['password']}
        rules={[
          { required: true, message: 'Please confirm your password' },
          ({ getFieldValue }) => ({
            validator(_, value) {
              if (!value || getFieldValue('password') === value) {
                return Promise.resolve()
              }
              return Promise.reject(new Error('Passwords do not match'))
            },
          }),
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
          type="primary"
          htmlType="submit"
          loading={loading}
          block
          size="large"
          className={hasContent ? 'has-content' : ''}
        >
          Create Account
        </Button>
      </Form.Item>
    </Form>
  )
})

SignUpForm.displayName = 'SignUpForm'

export default SignUpForm
