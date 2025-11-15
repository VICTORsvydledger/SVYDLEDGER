/**
 * SVYD LEDGER - Payments Service
 * Servicio de Pagos: Integración con Stripe Billing
 * Node.js + TypeScript + Express + Stripe
 */

import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import Stripe from 'stripe';
import { config } from 'dotenv';

config();

const API_VERSION = 'v1';
const SERVICE_NAME = 'Payments Service';
const REGION = 'centralus'; // Región parametrizada Central US
const PORT = process.env.PORT || 8006;

// Inicializar Stripe
const stripeSecretKey = process.env.STRIPE_SECRET_KEY || '';
const stripe = new Stripe(stripeSecretKey, {
  apiVersion: '2023-10-16',
  typescript: true
});

const app = express();

// Middleware
app.use(helmet());
app.use(cors({
  origin: ['https://www.svydledger.com', 'https://svydledger.com'],
  credentials: true
}));

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});
app.use(limiter);

// Para webhooks de Stripe, necesitamos el body raw
app.use('/api/v1/webhooks/stripe', express.raw({ type: 'application/json' }));
app.use(express.json());

// Tipos
enum SubscriptionPlan {
  FREE = 'free',
  BASIC = 'basic',
  PROFESSIONAL = 'professional',
  ENTERPRISE = 'enterprise'
}

interface SubscriptionRequest {
  userId: number;
  plan: SubscriptionPlan;
  paymentMethodId: string;
}

// Middleware de autenticación
const authenticateToken = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  // TODO: Verificar token JWT
  next();
};

// Health Check
app.get('/health', (req: Request, res: Response) => {
  res.json({
    status: 'healthy',
    service: SERVICE_NAME,
    version: API_VERSION,
    region: REGION,
    stripeConnected: !!stripeSecretKey,
    timestamp: new Date().toISOString()
  });
});

// ==================== CUSTOMERS ====================

/**
 * POST /api/v1/customers
 * Crear customer en Stripe
 */
app.post(`/api/${API_VERSION}/customers`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { email, name, userId } = req.body;

    // Crear customer en Stripe
    const customer = await stripe.customers.create({
      email,
      name,
      metadata: {
        userId: userId.toString()
      }
    });

    // TODO: Guardar stripeCustomerId en Azure SQL Hyperscale

    res.status(201).json({
      customerId: customer.id,
      email: customer.email,
      name: customer.name
    });
  } catch (error: any) {
    console.error('Error creating customer:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * GET /api/v1/customers/:customerId
 * Obtener información del customer
 */
app.get(`/api/${API_VERSION}/customers/:customerId`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { customerId } = req.params;

    const customer = await stripe.customers.retrieve(customerId);

    res.json(customer);
  } catch (error: any) {
    res.status(404).json({ error: 'Customer not found' });
  }
});

// ==================== PAYMENT METHODS ====================

/**
 * POST /api/v1/payment-methods
 * Agregar método de pago
 */
app.post(`/api/${API_VERSION}/payment-methods`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { customerId, paymentMethodId } = req.body;

    // Attach payment method to customer
    await stripe.paymentMethods.attach(paymentMethodId, {
      customer: customerId
    });

    // Set as default payment method
    await stripe.customers.update(customerId, {
      invoice_settings: {
        default_payment_method: paymentMethodId
      }
    });

    res.json({ message: 'Payment method added successfully' });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * GET /api/v1/customers/:customerId/payment-methods
 * Listar métodos de pago del customer
 */
app.get(`/api/${API_VERSION}/customers/:customerId/payment-methods`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { customerId } = req.params;

    const paymentMethods = await stripe.paymentMethods.list({
      customer: customerId,
      type: 'card'
    });

    res.json(paymentMethods.data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== SUBSCRIPTIONS ====================

/**
 * POST /api/v1/subscriptions
 * Crear suscripción
 */
app.post(`/api/${API_VERSION}/subscriptions`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { customerId, priceId } = req.body;

    // Crear suscripción en Stripe
    const subscription = await stripe.subscriptions.create({
      customer: customerId,
      items: [{ price: priceId }],
      payment_behavior: 'default_incomplete',
      payment_settings: { save_default_payment_method: 'on_subscription' },
      expand: ['latest_invoice.payment_intent']
    });

    // TODO: Guardar suscripción en Azure SQL Hyperscale
    // TODO: Publicar evento en Azure Service Bus

    res.status(201).json({
      subscriptionId: subscription.id,
      clientSecret: (subscription.latest_invoice as any)?.payment_intent?.client_secret,
      status: subscription.status
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * GET /api/v1/subscriptions/:subscriptionId
 * Obtener suscripción
 */
app.get(`/api/${API_VERSION}/subscriptions/:subscriptionId`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { subscriptionId } = req.params;

    const subscription = await stripe.subscriptions.retrieve(subscriptionId);

    res.json(subscription);
  } catch (error: any) {
    res.status(404).json({ error: 'Subscription not found' });
  }
});

/**
 * PUT /api/v1/subscriptions/:subscriptionId
 * Actualizar suscripción (cambiar plan)
 */
app.put(`/api/${API_VERSION}/subscriptions/:subscriptionId`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { subscriptionId } = req.params;
    const { priceId } = req.body;

    const subscription = await stripe.subscriptions.retrieve(subscriptionId);

    const updatedSubscription = await stripe.subscriptions.update(subscriptionId, {
      items: [{
        id: subscription.items.data[0].id,
        price: priceId
      }],
      proration_behavior: 'create_prorations'
    });

    // TODO: Actualizar en Azure SQL Hyperscale
    // TODO: Publicar evento

    res.json(updatedSubscription);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * DELETE /api/v1/subscriptions/:subscriptionId
 * Cancelar suscripción
 */
app.delete(`/api/${API_VERSION}/subscriptions/:subscriptionId`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { subscriptionId } = req.params;
    const { immediately = false } = req.query;

    const subscription = immediately
      ? await stripe.subscriptions.cancel(subscriptionId)
      : await stripe.subscriptions.update(subscriptionId, {
          cancel_at_period_end: true
        });

    // TODO: Actualizar en Azure SQL Hyperscale
    // TODO: Publicar evento

    res.json(subscription);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== INVOICES ====================

/**
 * GET /api/v1/customers/:customerId/invoices
 * Listar facturas del customer
 */
app.get(`/api/${API_VERSION}/customers/:customerId/invoices`, authenticateToken, async (req: Request, res: Response) => {
  try {
    const { customerId } = req.params;

    const invoices = await stripe.invoices.list({
      customer: customerId,
      limit: 100
    });

    res.json(invoices.data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== PRICES/PRODUCTS ====================

/**
 * GET /api/v1/prices
 * Listar planes disponibles
 */
app.get(`/api/${API_VERSION}/prices`, async (req: Request, res: Response) => {
  try {
    const prices = await stripe.prices.list({
      active: true,
      expand: ['data.product']
    });

    res.json(prices.data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== WEBHOOKS ====================

/**
 * POST /api/v1/webhooks/stripe
 * Webhook de Stripe
 */
app.post(`/api/${API_VERSION}/webhooks/stripe`, async (req: Request, res: Response) => {
  const sig = req.headers['stripe-signature'] as string;
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET || '';

  let event: Stripe.Event;

  try {
    event = stripe.webhooks.constructEvent(req.body, sig, webhookSecret);
  } catch (err: any) {
    console.error('Webhook signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Manejar el evento
  switch (event.type) {
    case 'customer.subscription.created':
    case 'customer.subscription.updated':
    case 'customer.subscription.deleted':
      // TODO: Actualizar estado en Azure SQL Hyperscale
      // TODO: Publicar evento en Azure Service Bus
      console.log(`Subscription ${event.type}:`, event.data.object);
      break;

    case 'invoice.paid':
      // TODO: Marcar factura como pagada
      console.log('Invoice paid:', event.data.object);
      break;

    case 'invoice.payment_failed':
      // TODO: Notificar al usuario
      console.log('Payment failed:', event.data.object);
      break;

    default:
      console.log(`Unhandled event type: ${event.type}`);
  }

  res.json({ received: true });
});

// Manejo de errores
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`?? ${SERVICE_NAME} running on port ${PORT}`);
  console.log(`?? Region: ${REGION}`);
  console.log(`?? Stripe: ${stripeSecretKey ? 'Connected' : 'Not configured'}`);
});

export default app;
