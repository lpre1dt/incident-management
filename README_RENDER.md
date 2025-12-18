# 🚀 Deployment auf Render.com

## Schritt-für-Schritt Anleitung

### 1️⃣ Git Repository erstellen

Wenn du noch kein Git Repository hast:

```bash
git init
git add .
git commit -m "Initial commit - Incident Management App"
```

Erstelle ein Repository auf GitHub:
1. Gehe zu https://github.com/new
2. Erstelle ein neues Repository (z.B. `incident-management`)
3. Pushe dein Projekt:

```bash
git remote add origin https://github.com/DEIN-USERNAME/incident-management.git
git branch -M main
git push -u origin main
```

---

### 2️⃣ Auf Render deployen

1. **Gehe zu Render.com**
   - Öffne https://render.com
   - Klicke auf "Get Started for Free"
   - Melde dich mit GitHub an

2. **Neuen Web Service erstellen**
   - Klicke auf "New +" → "Web Service"
   - Verbinde dein GitHub Repository
   - Wähle `incident-management` aus

3. **Konfiguration**
   - **Name**: `incident-management` (oder dein gewünschter Name)
   - **Region**: Frankfurt (Europa) oder deine bevorzugte Region
   - **Branch**: `main`
   - **Runtime**: `Node`
   - **Build Command**: `npm install && cds deploy --to sqlite:db.sqlite`
   - **Start Command**: `cds-serve`
   - **Instance Type**: `Free`

4. **Umgebungsvariablen** (Optional)
   Klicke auf "Advanced" und füge hinzu:
   ```
   NODE_ENV=production
   ```

5. **Deploy!**
   - Klicke auf "Create Web Service"
   - Render wird deine App automatisch bauen und deployen
   - Das dauert ca. 3-5 Minuten

---

### 3️⃣ App öffnen

Nach erfolgreichem Deployment:
- Deine App ist verfügbar unter: `https://incident-management-XXXX.onrender.com`
- Die Fiori Apps:
  - **Incidents**: `https://incident-management-XXXX.onrender.com/incidents/webapp/index.html`
  - **Customers**: `https://incident-management-XXXX.onrender.com/customers/webapp/index.html`
- **OData Service**: `https://incident-management-XXXX.onrender.com/odata/v4/processor`

---

## ⚠️ Wichtige Hinweise

### SQLite Datenpersistenz
Die kostenlose Render-Instanz hat **ephemeral storage** - das bedeutet:
- Die SQLite-Datenbank wird bei jedem Deploy neu erstellt
- Daten gehen verloren, wenn die App neu startet (nach Inaktivität)

**Lösungen:**
1. **Für Demos**: OK, Testdaten werden automatisch geladen
2. **Für Production**: Verwende PostgreSQL (siehe unten)

### Auto-Sleep
- Free Tier Apps schlafen nach 15 Min. Inaktivität ein
- Erster Request dauert dann 30-60 Sekunden (Cold Start)
- Danach läuft alles normal

---

## 🔄 Updates deployen

Wenn du Änderungen machst:

```bash
git add .
git commit -m "Deine Änderung"
git push
```

Render erkennt automatisch den Push und deployed die neue Version!

---

## 🗄️ PostgreSQL statt SQLite (Optional)

Für persistente Daten:

1. **Füge PostgreSQL Support hinzu**:
   ```bash
   npm install pg
   ```

2. **Update `package.json`**:
   ```json
   "cds": {
     "requires": {
       "db": {
         "[production]": {
           "kind": "postgres"
         }
       }
     }
   }
   ```

3. **Auf Render**:
   - Erstelle eine PostgreSQL Datenbank (New → PostgreSQL)
   - Verbinde sie mit deinem Web Service
   - Render setzt automatisch `DATABASE_URL`

---

## 🎉 Fertig!

Deine Incident Management App läuft jetzt live im Internet!

**Teile deine App**: Schicke einfach den Link!

### Troubleshooting

**Logs anschauen**:
- Gehe zu deinem Service auf Render
- Klicke auf "Logs"
- Dort siehst du alle Ausgaben

**App funktioniert nicht**:
- Prüfe die Logs
- Stelle sicher, dass `cds deploy` im Build Command ist
- Node Version sollte >= 18 sein
