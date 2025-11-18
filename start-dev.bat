@echo off
echo ========================================
echo   SVYD LEDGER - Starting Frontend
echo ========================================
echo.
cd /d "%~dp0frontend"
echo Starting development server...
echo.
echo Open your browser at: http://localhost:3000
echo.
echo Press Ctrl+C to stop the server
echo.
npm run dev
pause
