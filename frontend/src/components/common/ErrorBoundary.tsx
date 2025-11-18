/**
 * Simple Error Boundary component
 */
import React from 'react'
import { Button, Result } from 'antd'

type Props = { children: React.ReactNode }

type State = { hasError: boolean }

export class ErrorBoundary extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { hasError: false }
  }

  static getDerivedStateFromError(): State {
    return { hasError: true }
  }

  componentDidCatch(error: any, info: any) {
    // eslint-disable-next-line no-console
    console.error('UI ErrorBoundary caught:', error, info)
  }

  handleReload = () => {
    location.reload()
  }

  render() {
    if (this.state.hasError) {
      return (
        <Result
          status="error"
          title="Algo salió mal"
          subTitle="Ocurrió un error inesperado en la interfaz."
          extra={<Button onClick={this.handleReload}>Recargar</Button>}
        />
      )
    }

    return this.props.children
  }
}

export default ErrorBoundary
