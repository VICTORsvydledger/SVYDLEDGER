/**
 * SVYD LEDGER - Accounting Service
 * Servicio de Contabilidad: Gestión de cuentas contables, asientos, balances
 * Node.js + TypeScript + Express + Prisma
 */

import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { config } from 'dotenv';

// Cargar variables de entorno
config();

// Configuración
const API_VERSION = 'v1';
const SERVICE_NAME = 'Accounting Service';
const REGION = 'centralus'; // Región parametrizada Central US
const PORT = process.env.PORT || 8004;

// Crear app Express
const app = express();

// Middleware de seguridad
app.use(helmet());
app.use(cors({
  origin: ['https://www.svydledger.com', 'https://svydledger.com'],
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100 // límite de 100 requests por ventana
});
app.use(limiter);

// Middleware de parsing
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Tipos
interface Account {
  id: number;
  code: string;
  name: string;
  type: AccountType;
  parentId?: number;
  balance: number;
  isActive: boolean;
}

enum AccountType {
  ASSET = 'ASSET',
  LIABILITY = 'LIABILITY',
  EQUITY = 'EQUITY',
  REVENUE = 'REVENUE',
  EXPENSE = 'EXPENSE',
  COST = 'COST'
}

interface JournalEntry {
  id: number;
  date: Date;
  description: string;
  reference?: string;
  lines: JournalEntryLine[];
}

interface JournalEntryLine {
  id: number;
  accountId: number;
  debit: number;
  credit: number;
  description?: string;
}

// Middleware de autenticación (simplificado)
const authenticateToken = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  // TODO: Verificar token JWT con Azure Key Vault
  // Por ahora, solo verificamos que exista
  next();
};

// Health Check
app.get('/health', (req: Request, res: Response) => {
  res.json({
    status: 'healthy',
    service: SERVICE_NAME,
    version: API_VERSION,
    region: REGION,
    timestamp: new Date().toISOString()
  });
});

// ==================== CHART OF ACCOUNTS ====================

/**
 * GET /api/v1/accounts
 * Listar cuentas contables (Plan de Cuentas)
 */
app.get(`/api/${API_VERSION}/accounts`, authenticateToken, async (req: Request, res: Response) => {
  try {
    // TODO: Integrar con Azure SQL Hyperscale usando Prisma
    const accounts: Account[] = [];
    res.json(accounts);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * GET /api/v1/accounts/:id
 * Obtener cuenta por ID
 */
app.get(`/api/${API_VERSION}/accounts/:id`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    // TODO: Buscar cuenta en Azure SQL Hyperscale
    res.status(404).json({ error: 'Account not found' });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * POST /api/v1/accounts
 * Crear nueva cuenta contable
 */
app.post(`/api/${API_VERSION}/accounts`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { code, name, type, parentId } = req.body;
    
    // Validación
    if (!code || !name || !type) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // TODO: Validar que el código no exista
    // TODO: Guardar en Azure SQL Hyperscale usando Prisma
    
    const newAccount: Account = {
      id: 1,
      code,
      name,
      type,
      parentId,
      balance: 0,
      isActive: true
    };

    res.status(201).json(newAccount);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * PUT /api/v1/accounts/:id
 * Actualizar cuenta contable
 */
app.put(`/api/${API_VERSION}/accounts/:id`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { name, isActive } = req.body;

    // TODO: Actualizar en Azure SQL Hyperscale
    res.status(404).json({ error: 'Account not found' });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ==================== JOURNAL ENTRIES ====================

/**
 * GET /api/v1/journal-entries
 * Listar asientos contables
 */
app.get(`/api/${API_VERSION}/journal-entries`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { startDate, endDate, page = 1, limit = 50 } = req.query;
    
    // TODO: Obtener asientos de Azure SQL Hyperscale con paginación
    const entries: JournalEntry[] = [];
    
    res.json({
      data: entries,
      pagination: {
        page: Number(page),
        limit: Number(limit),
        total: 0
      }
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * POST /api/v1/journal-entries
 * Crear asiento contable
 */
app.post(`/api/${API_VERSION}/journal-entries`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { date, description, reference, lines } = req.body;

    // Validación básica
    if (!date || !description || !lines || lines.length < 2) {
      return res.status(400).json({ error: 'Invalid journal entry' });
    }

    // Validar que esté balanceado (débitos = créditos)
    const totalDebit = lines.reduce((sum: number, line: any) => sum + (line.debit || 0), 0);
    const totalCredit = lines.reduce((sum: number, line: any) => sum + (line.credit || 0), 0);

    if (Math.abs(totalDebit - totalCredit) > 0.01) {
      return res.status(400).json({ error: 'Journal entry is not balanced' });
    }

    // TODO: Guardar en Azure SQL Hyperscale (transacción)
    // TODO: Actualizar balances de cuentas
    // TODO: Publicar evento en Azure Service Bus

    const newEntry: JournalEntry = {
      id: 1,
      date: new Date(date),
      description,
      reference,
      lines
    };

    res.status(201).json(newEntry);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ==================== BALANCES ====================

/**
 * GET /api/v1/balances/trial-balance
 * Balance de Comprobación
 */
app.get(`/api/${API_VERSION}/balances/trial-balance`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { asOfDate } = req.query;
    
    // TODO: Calcular balance de comprobación desde Azure SQL Hyperscale
    
    res.json({
      asOfDate: asOfDate || new Date().toISOString(),
      accounts: [],
      totalDebits: 0,
      totalCredits: 0
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * GET /api/v1/balances/balance-sheet
 * Balance General (Estado de Situación Financiera)
 */
app.get(`/api/${API_VERSION}/balances/balance-sheet`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { asOfDate } = req.query;
    
    // TODO: Generar Balance General desde Azure SQL Hyperscale
    
    res.json({
      asOfDate: asOfDate || new Date().toISOString(),
      assets: [],
      liabilities: [],
      equity: [],
      totalAssets: 0,
      totalLiabilities: 0,
      totalEquity: 0
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * GET /api/v1/balances/income-statement
 * Estado de Resultados (P&L)
 */
app.get(`/api/${API_VERSION}/balances/income-statement`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { startDate, endDate } = req.query;
    
    // TODO: Generar Estado de Resultados desde Azure SQL Hyperscale
    
    res.json({
      period: { startDate, endDate },
      revenues: [],
      expenses: [],
      costs: [],
      totalRevenues: 0,
      totalExpenses: 0,
      totalCosts: 0,
      netIncome: 0
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Manejo de errores global
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`?? ${SERVICE_NAME} running on port ${PORT}`);
  console.log(`?? Region: ${REGION}`);
  console.log(`?? API Docs: http://localhost:${PORT}/api/${API_VERSION}/docs`);
});

export default app;
