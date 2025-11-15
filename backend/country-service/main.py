# -*- coding: utf-8 -*-
"""
SVYD LEDGER - Country Service
Servicio de Paises: Gestion de paises y sistemas tributarios
Python + FastAPI
"""

from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Optional, List, Dict
from datetime import datetime
from enum import Enum
import os

# Configuracion
API_VERSION = "v1"
SERVICE_NAME = "Country Service"
REGION = "centralus"  # Region parametrizada Central US

app = FastAPI(
    title=f"SVYD LEDGER - {SERVICE_NAME}",
    description="Servicio de Gestion de Paises y Sistemas Tributarios",
    version=API_VERSION,
    docs_url=f"/api/{API_VERSION}/docs",
    redoc_url=f"/api/{API_VERSION}/redoc"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://www.svydledger.com", "https://svydledger.com"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Enums
class TaxSystem(str, Enum):
    PROGRESSIVE = "progressive"
    FLAT = "flat"
    DUAL = "dual"
    NONE = "none"

class Currency(str, Enum):
    USD = "USD"
    EUR = "EUR"
    GBP = "GBP"
    MXN = "MXN"
    COP = "COP"
    BRL = "BRL"
    ARS = "ARS"
    CLP = "CLP"

# Modelos
class Country(BaseModel):
    id: int
    code: str = Field(..., min_length=2, max_length=3, description="ISO 3166-1 alpha-2/3 code")
    name: str
    native_name: str
    currency: Currency
    tax_system: TaxSystem
    vat_rate: Optional[float] = Field(None, ge=0, le=100, description="VAT/IVA rate percentage")
    is_active: bool = True
    
class CountryCreate(BaseModel):
    code: str = Field(..., min_length=2, max_length=3)
    name: str
    native_name: str
    currency: Currency
    tax_system: TaxSystem
    vat_rate: Optional[float] = Field(None, ge=0, le=100)
    is_active: bool = True

class TaxType(BaseModel):
    id: int
    country_code: str
    name: str
    description: str
    rate: float = Field(..., ge=0, le=100)
    is_active: bool = True

class TaxTypeCreate(BaseModel):
    country_code: str
    name: str
    description: str
    rate: float = Field(..., ge=0, le=100)
    is_active: bool = True

class AccountingStandard(str, Enum):
    IFRS = "IFRS"  # International Financial Reporting Standards
    GAAP_US = "GAAP_US"  # US GAAP
    GAAP_LOCAL = "GAAP_LOCAL"  # Local GAAP

class CountryAccountingConfig(BaseModel):
    id: int
    country_code: str
    accounting_standard: AccountingStandard
    fiscal_year_start: int = Field(..., ge=1, le=12, description="Fiscal year start month (1-12)")
    requires_audit: bool = False
    tax_forms: List[str] = []

# Health Check
@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": SERVICE_NAME,
        "version": API_VERSION,
        "region": REGION,
        "timestamp": datetime.utcnow().isoformat()
    }

# Endpoints de Paises
@app.get(f"/api/{API_VERSION}/countries", response_model=List[Country])
async def list_countries(active_only: bool = True):
    """
    Listar paises disponibles
    TODO: Integrar con Azure SQL Hyperscale
    """
    # Paises iniciales del sistema (ejemplos)
    default_countries = [
        Country(
            id=1,
            code="US",
            name="United States",
            native_name="United States",
            currency=Currency.USD,
            tax_system=TaxSystem.PROGRESSIVE,
            vat_rate=0.0,  # No VAT, uses sales tax
            is_active=True
        ),
        Country(
            id=2,
            code="MX",
            name="Mexico",
            native_name="Mexico",
            currency=Currency.MXN,
            tax_system=TaxSystem.PROGRESSIVE,
            vat_rate=16.0,
            is_active=True
        ),
        Country(
            id=3,
            code="ES",
            name="Spain",
            native_name="Espana",
            currency=Currency.EUR,
            tax_system=TaxSystem.PROGRESSIVE,
            vat_rate=21.0,
            is_active=True
        ),
        Country(
            id=4,
            code="CO",
            name="Colombia",
            native_name="Colombia",
            currency=Currency.COP,
            tax_system=TaxSystem.PROGRESSIVE,
            vat_rate=19.0,
            is_active=True
        ),
    ]
    
    if active_only:
        return [c for c in default_countries if c.is_active]
    return default_countries

@app.get(f"/api/{API_VERSION}/countries/{{country_code}}", response_model=Country)
async def get_country(country_code: str):
    """
    Obtener pais por codigo
    TODO: Integrar con Azure SQL Hyperscale
    """
    raise HTTPException(status_code=404, detail="Country not found")

@app.post(f"/api/{API_VERSION}/countries", response_model=Country, status_code=status.HTTP_201_CREATED)
async def create_country(country: CountryCreate):
    """
    Crear nuevo pais
    TODO: Integrar con Azure SQL Hyperscale
    """
    # TODO: Validar que el codigo no exista
    # TODO: Guardar en Azure SQL Hyperscale
    return Country(
        id=1,
        code=country.code,
        name=country.name,
        native_name=country.native_name,
        currency=country.currency,
        tax_system=country.tax_system,
        vat_rate=country.vat_rate,
        is_active=country.is_active
    )

# Endpoints de Impuestos
@app.get(f"/api/{API_VERSION}/countries/{{country_code}}/taxes", response_model=List[TaxType])
async def get_country_taxes(country_code: str):
    """
    Obtener todos los impuestos de un pais
    TODO: Integrar con Azure SQL Hyperscale
    """
    # TODO: Obtener desde Azure SQL Hyperscale
    return []

@app.post(f"/api/{API_VERSION}/taxes", response_model=TaxType, status_code=status.HTTP_201_CREATED)
async def create_tax_type(tax: TaxTypeCreate):
    """
    Crear nuevo tipo de impuesto
    TODO: Integrar con Azure SQL Hyperscale
    """
    # TODO: Validar que el pais exista
    # TODO: Guardar en Azure SQL Hyperscale
    return TaxType(
        id=1,
        country_code=tax.country_code,
        name=tax.name,
        description=tax.description,
        rate=tax.rate,
        is_active=tax.is_active
    )

# Endpoints de Configuracion Contable
@app.get(f"/api/{API_VERSION}/countries/{{country_code}}/accounting-config", response_model=CountryAccountingConfig)
async def get_accounting_config(country_code: str):
    """
    Obtener configuracion contable de un pais
    TODO: Integrar con Azure SQL Hyperscale
    """
    raise HTTPException(status_code=404, detail="Accounting config not found")

@app.get(f"/api/{API_VERSION}/currencies")
async def list_currencies():
    """
    Listar monedas disponibles
    """
    return {
        "currencies": [
            {"code": "USD", "name": "US Dollar", "symbol": "$"},
            {"code": "EUR", "name": "Euro", "symbol": "€"},
            {"code": "GBP", "name": "British Pound", "symbol": "£"},
            {"code": "MXN", "name": "Mexican Peso", "symbol": "$"},
            {"code": "COP", "name": "Colombian Peso", "symbol": "$"},
            {"code": "BRL", "name": "Brazilian Real", "symbol": "R$"},
            {"code": "ARS", "name": "Argentine Peso", "symbol": "$"},
            {"code": "CLP", "name": "Chilean Peso", "symbol": "$"},
        ]
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8003)
