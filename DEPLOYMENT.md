# Deployment Optionen für Incident Management App

## 1. SAP BTP Trial (Empfohlen) ⭐

### Vorteile:
- Speziell für CAP-Apps optimiert
- Kostenloser Trial Account
- Integrierte Fiori Launchpad
- HANA Cloud Datenbank (SQLite → HANA Migration)
- Professional Hosting

### Setup:
1. **Trial Account erstellen**: https://account.hanatrial.ondemand.com/
2. **Cloud Foundry CLI installieren**:
   ```bash
   brew install cloudfoundry/tap/cf-cli
   ```

3. **Dependencies für Cloud Deployment hinzufügen**:
   ```bash
   npm install --save @sap/hdi-deploy
   npm install --save-dev @sap/cds-dk
   ```

4. **mta.yaml erstellen** (Multi-Target Application):
   ```bash
   cds add mta
   ```

5. **Build und Deploy**:
   ```bash
   mbt build
   cf login
   cf deploy mta_archives/incident-management_1.0.0.mtar
   ```

### Kosten: **KOSTENLOS** (Trial Account mit Einschränkungen)

---

## 2. Render.com (Einfachste Option) ⚡

### Vorteile:
- Sehr einfach
- Direktes Git-Deployment
- Kostenloser Plan verfügbar
- Automatische SSL-Zertifikate

### Setup:

1. **package.json anpassen**:
   Füge ein Start-Script hinzu:
   ```json
   "scripts": {
     "start": "cds-serve",
     "build": "cds build --production"
   }
   ```

2. **Render.yaml erstellen** (für automatisches Deployment):
   ```yaml
   services:
     - type: web
       name: incident-management
       env: node
       buildCommand: npm install
       startCommand: npm start
       envVars:
         - key: NODE_ENV
           value: production
   ```

3. **Auf Render deployen**:
   - Gehe zu https://render.com
   - Verbinde dein Git Repository
   - Wähle "Web Service"
   - Deploy!

### Kosten: **KOSTENLOS** (mit Einschränkungen: schläft nach Inaktivität)

---

## 3. Railway.app 🚂

### Vorteile:
- Einfaches Deployment
- $5 kostenloses Guthaben pro Monat
- Gute Performance
- Automatische Deployments von Git

### Setup:

1. **Auf Railway deployen**:
   - Gehe zu https://railway.app
   - "New Project" → "Deploy from GitHub"
   - Wähle dein Repository
   - Railway erkennt automatisch Node.js

2. **Umgebungsvariablen setzen**:
   ```
   NODE_ENV=production
   ```

### Kosten: **KOSTENLOS** ($5/Monat Guthaben, reicht für kleine Apps)

---

## 4. Vercel (Serverless) ⚡

### Vorteile:
- Sehr schnell
- Automatische Git-Deployments
- Serverless Functions
- Kostenloser Plan

### Einschränkungen:
- Serverless → SQLite funktioniert nicht persistent
- Braucht externe Datenbank (z.B. PostgreSQL)

### Setup:

1. **Vercel CLI installieren**:
   ```bash
   npm install -g vercel
   ```

2. **vercel.json erstellen**:
   ```json
   {
     "version": 2,
     "builds": [
       {
         "src": "package.json",
         "use": "@vercel/node"
       }
     ],
     "routes": [
       {
         "src": "/(.*)",
         "dest": "/"
       }
     ]
   }
   ```

3. **Deployen**:
   ```bash
   vercel
   ```

### Kosten: **KOSTENLOS** (Hobby Plan)

---

## 5. Heroku (Klassiker) 🟪

### Vorteile:
- Bewährt und zuverlässig
- Einfaches Deployment
- Add-ons für Datenbanken

### Einschränkungen:
- Seit Nov 2022 keine kostenlose Tier mehr
- Ab $5/Monat

---

## Empfehlung für dein Projekt:

### Für Entwicklung/Demo:
**Render.com** - Einfachste Option, komplett kostenlos

### Für Production/Enterprise:
**SAP BTP Trial** - Professional, aber komplexer Setup

### Schnellste Option:
**Railway.app** - Gut balanciert zwischen Einfachheit und Features

---

## Nächste Schritte:

Welche Option möchtest du nutzen? Ich kann dir helfen:
1. SAP BTP Setup
2. Render.com Deployment
3. Railway.app Deployment
4. Vercel Deployment
