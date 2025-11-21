import { useState } from 'react'
import { Button } from 'antd'
import { ArrowLeftOutlined, ArrowRightOutlined } from '@ant-design/icons'
import './PostAuthPage.scss'

interface PostAuthPageProps {
  onBack: () => void
  userEmail?: string
}

const PostAuthPage = ({ onBack, userEmail }: PostAuthPageProps) => {
  const [loading, setLoading] = useState(false)

  const handleNext = async () => {
    setLoading(true)
    try {
      // TODO: Implementar lógica de "siguiente paso"
      console.log('Proceeding to next step...')
      await new Promise((resolve) => setTimeout(resolve, 500))
      
      // Aquí se implementará la navegación futura
    } catch (error) {
      console.error('Error:', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="post-auth-page">
      {/* Fondo con background-2.png */}
      <div className="post-auth-background" />
      
      {/* Contenido principal */}
      <div className="post-auth-content">
        <div className="post-auth-container">
          {/* Header con información del usuario */}
          <div className="post-auth-header">
            <h1>Welcome!</h1>
            {userEmail && (
              <p className="user-email">Logged in as: {userEmail}</p>
            )}
          </div>

          {/* Área de contenido central (preparada para iteraciones) */}
          <div className="post-auth-main">
            <div className="success-message">
              <div className="success-icon">?</div>
              <h2>Authentication Successful</h2>
              <p>You are now ready to proceed to the next step.</p>
            </div>
          </div>

          {/* Botones de navegación */}
          <div className="post-auth-navigation">
            <Button
              type="default"
              size="large"
              icon={<ArrowLeftOutlined />}
              onClick={onBack}
              className="nav-button back-button"
            >
              Back to Welcome
            </Button>
            
            <Button
              type="primary"
              size="large"
              icon={<ArrowRightOutlined />}
              iconPosition="end"
              onClick={handleNext}
              loading={loading}
              className="nav-button next-button"
            >
              Continue
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default PostAuthPage
