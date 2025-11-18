# ?? SVYD LEDGER - Frontend Installation Guide

## ?? Prerequisites

### 1. Node.js Installation (REQUIRED)

**Download and Install Node.js:**
- Go to: https://nodejs.org/
- Download the **LTS version** (v20.x or higher)
- Run the installer
- During installation:
  - ? Accept license terms
  - ? Check "Automatically install the necessary tools"
  - ? Complete the installation

**Verify Installation:**
```powershell
node --version
# Should show: v20.x.x or higher

npm --version
# Should show: 10.x.x or higher
```

## ??? Frontend Setup

### 2. Install Dependencies

```powershell
# Navigate to frontend directory
cd frontend

# Install all dependencies
npm install
```

This will install:
- React 18 + TypeScript
- Redux Toolkit
- Material-UI (MUI)
- Ant Design
- React Router DOM
- Axios
- And all other dependencies

### 3. Run Development Server

```powershell
# Start the development server
npm run dev
```

The application will be available at:
- **Local**: http://localhost:3000
- **Network**: http://192.168.x.x:3000

## ?? Access the Welcome Page

Once the server is running, open your browser and navigate to:
```
http://localhost:3000
```

You should see the **Svyd** welcome page with:
- ? Beautiful background image
- ?? Language selector
- ?? Sign In form
- ?? Sign Up form
- ?? Two-factor authentication dialogs

## ?? Project Structure

```
frontend/
??? public/
?   ??? images/
?       ??? backgrounds/
?           ??? background-1.png.png
?           ??? background-2.png.png
?           ??? background-3.png.png
?           ??? background-4.png.png
?           ??? background-5.png.png
?           ??? background-6.png.png
??? src/
?   ??? pages/
?   ?   ??? auth/
?   ?       ??? WelcomePage.tsx      # Main welcome page
?   ?       ??? WelcomePage.scss     # Styles for welcome page
?   ??? App.tsx                      # Main app with routes
?   ??? main.tsx                     # Entry point
??? package.json
```

## ?? Design Features

### Logo and Typography
- **Logo**: "Svyd" in Carattere font (white, bold, 72px)
- **Subtitle**: "Sistema de Contabilidad Universal" (Carattere, 36px)
- **Fonts**: Google Fonts loaded automatically

### Responsive Design
- ? Desktop (1920x1080 and higher)
- ? Tablet (768px - 1024px)
- ? Mobile (320px - 767px)

### Visual Effects
- ?? Backdrop blur on forms
- ?? Smooth transitions
- ?? Hover animations
- ?? Loading states
- ? Professional UI/UX

## ?? Troubleshooting

### Issue: "Cannot find module 'react'"
**Solution**: Run `npm install` in the frontend directory

### Issue: Port 3000 already in use
**Solution**: 
```powershell
# Stop the process using port 3000
Get-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess | Stop-Process -Force

# Or use a different port
npm run dev -- --port 3001
```

### Issue: Images not loading
**Solution**: Verify that images are in `frontend/public/images/backgrounds/`

## ?? Build for Production

```powershell
# Build optimized production bundle
npm run build

# Preview production build
npm run preview
```

Build output will be in `frontend/dist/`

## ?? Supported Languages

The language selector includes 27 languages:
1. English (default)
2. Spanish (Español)
3. French (Français)
4. Italian (Italiano)
5. German (Deutsch)
6. Arabic (???????)
7. Bengali (?????)
8. Chinese Mandarin (??)
9. Egyptian Arabic (??????? ???????)
10. Hindi (??????)
... and 17 more languages

## ?? Security Features

- ? JWT Authentication
- ? Two-Factor Authentication (2FA)
- ? Password strength validation
- ? Email verification
- ? Secure password recovery
- ? HTTPS/TLS communication

## ?? Next Steps

1. ? **COMPLETED**: Welcome page with forms
2. ?? **TODO**: Connect to Identity Service API
3. ?? **TODO**: Deploy to Azure (www.svydledger.com)
4. ?? **TODO**: Configure DNS and SSL
5. ?? **TODO**: Add multi-language translations

## ?? Need Help?

If you encounter any issues:
1. Close and reopen Visual Studio Code
2. Delete `node_modules` and `package-lock.json`
3. Run `npm install` again
4. Clear browser cache
5. Check console for errors (F12)

---

**Project**: SVYD LEDGER  
**Version**: 1.0.0  
**Region**: Central US  
**Repository**: github.com/VICTORsvydledger/SVYDLEDGER
