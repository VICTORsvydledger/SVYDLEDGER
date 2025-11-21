import { Button } from 'antd'
import { ArrowLeftOutlined } from '@ant-design/icons'
import './PostAuthPage.scss'

interface PostAuthPageProps {
  onBack: () => void
  userEmail?: string
}

const PostAuthPage = ({ onBack, userEmail }: PostAuthPageProps) => {
  return (
    <div className="post-auth-page">
      {/* Fondo con background-2.png */}
      <div className="post-auth-background" />
      
      {/* Contenido principal */}
      <div className="post-auth-content">
        {/* Botón Back en esquina superior izquierda */}
        <div className="back-button-container">
          <Button
            type="default"
            size="large"
            icon={<ArrowLeftOutlined />}
            onClick={onBack}
            className="back-button"
          >
            Back to Welcome
          </Button>
        </div>

        {/* Logo Svyd centrado */}
        <div className="logo-container">
          <h1 className="logo">Svyd</h1>
          
          {/* Email del usuario debajo del logo */}
          {userEmail && (
            <p className="user-email">Logged in as: {userEmail}</p>
          )}
        </div>
      </div>
    </div>
  )
}

export default PostAuthPage
