# SVYD LEDGER - API Endpoints Documentation
## Production Environment - Central US

---

## ?? Base URLs

### API Gateway (Recommended)
```
http://api.svydledger.com
```

### Individual Services (Direct Access)
```
http://identity.svydledger.com
http://language.svydledger.com
http://country.svydledger.com
http://accounting.svydledger.com
http://reports.svydledger.com
http://payments.svydledger.com
```

### Load Balancer IP (Temporary - before DNS)
```
http://172.169.53.186
```

---

## ?? Identity Service

### Base Path: `/api/v1`

#### Authentication Endpoints

**POST** `/auth/register`
- Register new user
- Body: `{ email, username, full_name, password }`
- Returns: User object

**POST** `/auth/token`
- Login and get JWT token
- Body: Form data `username` and `password`
- Returns: `{ access_token, token_type, expires_in }`

**GET** `/auth/me`
- Get current authenticated user
- Headers: `Authorization: Bearer <token>`
- Returns: User object

#### User Management

**GET** `/users`
- List all users (paginated)
- Headers: `Authorization: Bearer <token>`
- Query: `?skip=0&limit=100`

**GET** `/users/{user_id}`
- Get user by ID
- Headers: `Authorization: Bearer <token>`

#### Roles Management

**GET** `/roles`
- List available roles
- Headers: `Authorization: Bearer <token>`

**POST** `/users/{user_id}/roles/{role_id}`
- Assign role to user
- Headers: `Authorization: Bearer <token>`

#### Health Check
**GET** `/health`
- Service health status
- No auth required
- Returns: `{ status, service, version, region, timestamp }`

---

## ?? Language Service

### Base Path: `/api/v1`

#### Languages

**GET** `/languages`
- List available languages
- Query: `?active_only=true`

**GET** `/languages/{language_code}`
- Get language by code (ISO 639-1)

**POST** `/languages`
- Create new language
- Headers: `Authorization: Bearer <token>`
- Body: `{ code, name, native_name, is_active, is_default }`

#### Translations

**GET** `/translations/{language_code}`
- Get all translations for a language
- Query: `?module=accounting`

**POST** `/translations`
- Create single translation
- Headers: `Authorization: Bearer <token>`
- Body: `{ language_code, key, value, module }`

**POST** `/translations/batch`
- Create multiple translations
- Headers: `Authorization: Bearer <token>`
- Body: `{ language_code, module, translations: {key: value} }`

**PUT** `/translations/{translation_id}`
- Update translation
- Headers: `Authorization: Bearer <token>`

**DELETE** `/translations/{translation_id}`
- Delete translation
- Headers: `Authorization: Bearer <token>`

**GET** `/translations/export/{language_code}`
- Export translations as JSON
- Query: `?module=accounting`

---

## ??? Country Service

### Base Path: `/api/v1`

#### Countries

**GET** `/countries`
- List available countries
- Query: `?active_only=true`

**GET** `/countries/{country_code}`
- Get country by code (ISO 3166-1)

**POST** `/countries`
- Create new country
- Headers: `Authorization: Bearer <token>`
- Body: `{ code, name, native_name, currency, tax_system, vat_rate }`

#### Taxes

**GET** `/countries/{country_code}/taxes`
- Get all taxes for a country

**POST** `/taxes`
- Create tax type
- Headers: `Authorization: Bearer <token>`
- Body: `{ country_code, name, description, rate }`

#### Currencies

**GET** `/currencies`
- List available currencies
- Returns: `[{ code, name, symbol }]`

#### Accounting Configuration

**GET** `/countries/{country_code}/accounting-config`
- Get accounting configuration for country
- Returns: `{ accounting_standard, fiscal_year_start, requires_audit }`

---

## ?? Accounting Service

### Base Path: `/api/v1`

#### Chart of Accounts

**GET** `/accounts`
- List all accounts (Chart of Accounts)
- Headers: `Authorization: Bearer <token>`

**GET** `/accounts/{id}`
- Get account by ID
- Headers: `Authorization: Bearer <token>`

**POST** `/accounts`
- Create new account
- Headers: `Authorization: Bearer <token>`
- Body: `{ code, name, type, parentId }`

**PUT** `/accounts/{id}`
- Update account
- Headers: `Authorization: Bearer <token>`
- Body: `{ name, isActive }`

#### Journal Entries

**GET** `/journal-entries`
- List journal entries (paginated)
- Headers: `Authorization: Bearer <token>`
- Query: `?startDate=2025-01-01&endDate=2025-12-31&page=1&limit=50`

**POST** `/journal-entries`
- Create journal entry
- Headers: `Authorization: Bearer <token>`
- Body: `{ date, description, reference, lines: [{ accountId, debit, credit, description }] }`

#### Balances

**GET** `/balances/trial-balance`
- Get Trial Balance
- Headers: `Authorization: Bearer <token>`
- Query: `?asOfDate=2025-12-31`

**GET** `/balances/balance-sheet`
- Get Balance Sheet
- Headers: `Authorization: Bearer <token>`
- Query: `?asOfDate=2025-12-31`

**GET** `/balances/income-statement`
- Get Income Statement (P&L)
- Headers: `Authorization: Bearer <token>`
- Query: `?startDate=2025-01-01&endDate=2025-12-31`

---

## ?? Reports Service

### Base Path: `/api/v1`

#### Report Generation

**POST** `/reports/generate`
- Generate report
- Headers: `Authorization: Bearer <token>`
- Body: `{ type, format, startDate, endDate, asOfDate, parameters }`
- Types: `balance_sheet`, `income_statement`, `cash_flow`, `trial_balance`
- Formats: `pdf`, `excel`, `csv`, `json`

**GET** `/reports/{reportId}/status`
- Check report generation status
- Headers: `Authorization: Bearer <token>`
- Returns: `{ reportId, status, progress, downloadUrl }`

**GET** `/reports/{reportId}/download`
- Download generated report
- Headers: `Authorization: Bearer <token>`
- Returns: File (PDF, Excel, CSV)

#### Financial Statements

**GET** `/reports/balance-sheet`
- Get Balance Sheet (JSON)
- Headers: `Authorization: Bearer <token>`
- Query: `?asOfDate=2025-12-31&format=json`

**GET** `/reports/income-statement`
- Get Income Statement (JSON)
- Headers: `Authorization: Bearer <token>`
- Query: `?startDate=2025-01-01&endDate=2025-12-31&format=json`

**GET** `/reports/cash-flow`
- Get Cash Flow Statement (JSON)
- Headers: `Authorization: Bearer <token>`
- Query: `?startDate=2025-01-01&endDate=2025-12-31&format=json`

**GET** `/reports/tax-forms`
- Get Tax Forms
- Headers: `Authorization: Bearer <token>`
- Query: `?countryCode=US&taxYear=2025&formType=1040`

---

## ?? Payments Service

### Base Path: `/api/v1`

#### Subscriptions

**GET** `/subscriptions`
- List subscriptions
- Headers: `Authorization: Bearer <token>`

**POST** `/subscriptions`
- Create subscription
- Headers: `Authorization: Bearer <token>`
- Body: `{ planId, paymentMethodId }`

**GET** `/subscriptions/{subscriptionId}`
- Get subscription details
- Headers: `Authorization: Bearer <token>`

**PUT** `/subscriptions/{subscriptionId}`
- Update subscription
- Headers: `Authorization: Bearer <token>`

**DELETE** `/subscriptions/{subscriptionId}`
- Cancel subscription
- Headers: `Authorization: Bearer <token>`

#### Invoices

**GET** `/invoices`
- List invoices
- Headers: `Authorization: Bearer <token>`
- Query: `?status=paid&limit=50`

**GET** `/invoices/{invoiceId}`
- Get invoice details
- Headers: `Authorization: Bearer <token>`

#### Webhooks (Stripe)

**POST** `/webhooks/stripe`
- Stripe webhook endpoint
- Headers: `Stripe-Signature`
- Body: Stripe event payload
- No auth (validated via Stripe signature)

---

## ?? Authentication

All endpoints (except `/health` and `/auth/*`) require JWT authentication.

### How to Authenticate

1. **Login** to get access token:
```bash
POST /api/v1/auth/token
Content-Type: application/x-www-form-urlencoded

username=user@example.com&password=mypassword
```

2. **Include token** in subsequent requests:
```bash
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## ?? Common Response Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 204 | No Content (successful delete) |
| 400 | Bad Request (validation error) |
| 401 | Unauthorized (missing/invalid token) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not Found |
| 429 | Too Many Requests (rate limit) |
| 500 | Internal Server Error |

---

## ?? Testing Endpoints

### Using cURL

```bash
# Health Check
curl http://172.169.53.186/health -H "Host: identity.svydledger.com"

# Login
curl -X POST http://api.svydledger.com/api/v1/auth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=user@example.com&password=mypassword"

# Get Countries
curl http://api.svydledger.com/api/v1/countries \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Using PowerShell

```powershell
# Health Check
Invoke-WebRequest -Uri "http://172.169.53.186/health" -Headers @{"Host"="identity.svydledger.com"}

# Login
$body = @{username="user@example.com"; password="mypassword"}
Invoke-RestMethod -Uri "http://api.svydledger.com/api/v1/auth/token" -Method POST -Body $body

# Get Countries (with token)
$headers = @{Authorization="Bearer YOUR_TOKEN"}
Invoke-RestMethod -Uri "http://api.svydledger.com/api/v1/countries" -Headers $headers
```

---

## ?? CORS Configuration

All services are configured to accept requests from:
- `https://www.svydledger.com`
- `https://svydledger.com`

Allowed methods: GET, POST, PUT, DELETE, PATCH, OPTIONS

---

## ?? Rate Limiting

Default rate limits per service:
- Identity Service: 100 requests / 15 minutes
- Accounting Service: 100 requests / 15 minutes
- Reports Service: 50 requests / 15 minutes (heavier operations)
- Other Services: 100 requests / 15 minutes

Rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1234567890
```

---

## ?? Support

For API support, contact: svydllc@outlook.com

**Documentation Version**: 1.0.0  
**Last Updated**: 2025-11-16  
**Region**: Central US
