# SVYD LEDGER - DNS Configuration Guide
## Setting up Custom Domains for Your API

---

## ?? Overview

After deploying SVYD LEDGER to Azure Kubernetes Service (AKS), you need to configure DNS records to map your custom domains to the Ingress Controller's external IP address.

**Ingress External IP**: `172.169.53.186`

---

## ?? Required DNS Records

### Option 1: A Records (Recommended for Simplicity)

Add the following **A records** in your DNS provider's control panel:

```
Record Type    Hostname                      Value
-----------    --------                      -----
A              api.svydledger.com           172.169.53.186
A              identity.svydledger.com      172.169.53.186
A              language.svydledger.com      172.169.53.186
A              country.svydledger.com       172.169.53.186
A              accounting.svydledger.com    172.169.53.186
A              reports.svydledger.com       172.169.53.186
A              payments.svydledger.com      172.169.53.186
```

### Option 2: Wildcard + Specific Records

```
Record Type    Hostname                      Value
-----------    --------                      -----
A              api.svydledger.com           172.169.53.186
A              *.svydledger.com             172.169.53.186
```

This option is simpler but less secure (wildcard DNS can be exploited).

---

## ?? DNS Provider Setup Instructions

### Cloudflare

1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. Select your domain `svydledger.com`
3. Go to **DNS** ? **Records**
4. Click **Add record**
5. For each subdomain:
   - **Type**: `A`
   - **Name**: `api` (or `identity`, `language`, etc.)
   - **IPv4 address**: `172.169.53.186`
   - **TTL**: `Auto` (or 3600)
   - **Proxy status**: ?? DNS only (disable proxy initially)
6. Click **Save**

### GoDaddy

1. Log in to [GoDaddy DNS Management](https://dcc.godaddy.com/domains)
2. Find your domain `svydledger.com` and click **Manage DNS**
3. In the **Records** section, click **Add**
4. For each subdomain:
   - **Type**: `A`
   - **Name**: `api` (or subdomain name)
   - **Value**: `172.169.53.186`
   - **TTL**: `600` seconds (10 minutes)
5. Click **Save**

### Namecheap

1. Log in to [Namecheap Dashboard](https://ap.www.namecheap.com/)
2. Go to **Domain List** ? Click **Manage** next to `svydledger.com`
3. Go to **Advanced DNS** tab
4. Click **Add New Record**
5. For each subdomain:
   - **Type**: `A Record`
   - **Host**: `api` (or subdomain name)
   - **Value**: `172.169.53.186`
   - **TTL**: `Automatic`
6. Click **?** (checkmark) to save

### Azure DNS

If you're using Azure DNS for your domain:

```powershell
# Create DNS Zone (if not already created)
az network dns zone create -g svydledger-data -n svydledger.com

# Add A Records
$ip = "172.169.53.186"
az network dns record-set a add-record -g svydledger-data -z svydledger.com -n api -a $ip
az network dns record-set a add-record -g svydledger-data -z svydledger.com -n identity -a $ip
az network dns record-set a add-record -g svydledger-data -z svydledger.com -n language -a $ip
az network dns record-set a add-record -g svydledger-data -z svydledger.com -n country -a $ip
az network dns record-set a add-record -g svydledger-data -z svydledger.com -n accounting -a $ip
az network dns record-set a add-record -g svydledger-data -z svydledger.com -n reports -a $ip
az network dns record-set a add-record -g svydledger-data -z svydledger.com -n payments -a $ip

# Verify
az network dns record-set a list -g svydledger-data -z svydledger.com -o table
```

---

## ?? Testing DNS Propagation

After adding DNS records, wait 5-15 minutes for propagation, then test:

### Using nslookup (Windows/macOS/Linux)

```bash
nslookup api.svydledger.com
```

Expected output:
```
Server:  your-dns-server
Address:  8.8.8.8

Non-authoritative answer:
Name:    api.svydledger.com
Address:  172.169.53.186
```

### Using dig (Linux/macOS)

```bash
dig api.svydledger.com +short
```

Expected output:
```
172.169.53.186
```

### Using Online Tools

- [DNS Checker](https://dnschecker.org/)
- [What's My DNS](https://www.whatsmydns.net/)
- [DNS Propagation Checker](https://www.whatsmydns.net/)

Enter `api.svydledger.com` and check if `172.169.53.186` appears globally.

---

## ?? Next Steps: SSL/TLS Certificates

Once DNS is configured, you should add HTTPS support:

### Option 1: Let's Encrypt with cert-manager (Recommended)

1. **Install cert-manager**:
```powershell
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
```

2. **Create ClusterIssuer**:
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: svydllc@outlook.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

3. **Update Ingress with TLS**:
```yaml
spec:
  tls:
  - hosts:
    - api.svydledger.com
    - identity.svydledger.com
    # ... other hosts
    secretName: svydledger-tls
  rules:
  # ... existing rules
```

### Option 2: Azure Application Gateway

Use Azure Application Gateway with integrated SSL termination.

### Option 3: Cloudflare Proxy

Enable Cloudflare proxy (orange cloud) for automatic SSL.

---

## ?? DNS Record Summary

| Subdomain | Type | Value | Purpose |
|-----------|------|-------|---------|
| api.svydledger.com | A | 172.169.53.186 | API Gateway (aggregated endpoints) |
| identity.svydledger.com | A | 172.169.53.186 | Identity/Auth Service |
| language.svydledger.com | A | 172.169.53.186 | Language & Translations |
| country.svydledger.com | A | 172.169.53.186 | Country & Tax Configuration |
| accounting.svydledger.com | A | 172.169.53.186 | Accounting & Ledger |
| reports.svydledger.com | A | 172.169.53.186 | Financial Reports |
| payments.svydledger.com | A | 172.169.53.186 | Payments & Subscriptions |

---

## ?? Important Notes

1. **TTL (Time To Live)**: Lower TTL (e.g., 300-600 seconds) allows faster changes but increases DNS queries. Higher TTL (e.g., 3600-86400 seconds) is better for production.

2. **DNS Propagation**: Can take anywhere from 5 minutes to 48 hours globally. Most providers propagate within 15-30 minutes.

3. **IP Address Changes**: If your AKS cluster is recreated or the Ingress Controller is reinstalled, the external IP may change. You'll need to update all DNS records.

4. **Monitoring**: Set up monitoring alerts for DNS resolution failures:
```powershell
# Test all subdomains
$subdomains = @('api', 'identity', 'language', 'country', 'accounting', 'reports', 'payments')
foreach ($sub in $subdomains) {
    $result = nslookup "$sub.svydledger.com" 2>&1
    if ($result -match '172.169.53.186') {
        Write-Host "$sub.svydledger.com : OK" -ForegroundColor Green
    } else {
        Write-Host "$sub.svydledger.com : FAILED" -ForegroundColor Red
    }
}
```

---

## ?? Updating DNS Records

If the Ingress IP changes:

1. Get new IP:
```powershell
kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

2. Update all DNS A records with the new IP

3. Wait for propagation

4. Verify:
```powershell
curl http://NEW_IP/health -H "Host: api.svydledger.com"
```

---

## ?? Support

If you encounter DNS issues:
- Check DNS propagation globally: https://dnschecker.org/
- Verify Kubernetes Ingress: `kubectl get ingress -n production`
- Test direct IP access: `curl http://172.169.53.186/health -H "Host: api.svydledger.com"`

**Contact**: svydllc@outlook.com  
**Documentation Version**: 1.0.0  
**Last Updated**: 2025-11-16
