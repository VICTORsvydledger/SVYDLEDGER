import { useState, forwardRef, useImperativeHandle, useEffect } from 'react'
import { Form, Input, Button } from 'antd'
import notify from '@/lib/notifications'

interface SignInFormProps {
  onForgotPassword: () => void
  onFieldChange?: () => void
  onSuccess?: (email: string) => void // Nueva prop para manejar el éxito
}

const SignInForm = forwardRef<any, SignInFormProps>(({ onForgotPassword, onFieldChange, onSuccess }, ref) => {
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

  const handleSubmit = async (values: { email: string; password: string }) => {
    setLoading(true)
    try {
      // TODO: Implement real authentication service
      console.log('Sign In attempt:', values.email)
      
      // Simulación temporal
      await new Promise((resolve) => setTimeout(resolve, 1000))
      
      notify.success('Sign in successful!')
      
      // Navegar a PostAuthPage
      if (onSuccess) {
        onSuccess(values.email)
      }
    } catch (error) {
      notify.error('Invalid email or password')
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
          className={hasContent ? 'has-content' : ''}
        >
          Log In
        </Button>
      </Form.Item>
    </Form>
  )
})

SignInForm.displayName = 'SignInForm'

export default SignInForm
