/**
 * Account Types for SVYD LEDGER
 * Azure SQL Hyperscale doesn't support native ENUMs in Prisma
 * So we use TypeScript enums for type safety
 */

export enum AccountType {
  ASSET = 'ASSET',
  LIABILITY = 'LIABILITY',
  EQUITY = 'EQUITY',
  REVENUE = 'REVENUE',
  EXPENSE = 'EXPENSE',
  COST = 'COST'
}

/**
 * Validate if a string is a valid AccountType
 */
export function isValidAccountType(type: string): type is AccountType {
  return Object.values(AccountType).includes(type as AccountType);
}

/**
 * Get all account types as array
 */
export function getAllAccountTypes(): AccountType[] {
  return Object.values(AccountType);
}

/**
 * Get account type display name
 */
export function getAccountTypeLabel(type: AccountType): string {
  const labels: Record<AccountType, string> = {
    [AccountType.ASSET]: 'Activo',
    [AccountType.LIABILITY]: 'Pasivo',
    [AccountType.EQUITY]: 'Patrimonio',
    [AccountType.REVENUE]: 'Ingreso',
    [AccountType.EXPENSE]: 'Gasto',
    [AccountType.COST]: 'Costo'
  };
  
  return labels[type];
}
