# MÓDULO AVANZADO — MCP con Chrome DevTools

## Codex + Chrome DevTools MCP Server

Inspección DOM · Auditoría de Accesibilidad · Depuración de Red · Performance · Automatización de Pruebas

*Plan de Formación — OpenAI Codex para Desarrolladores*
Nivel: Avanzado · Duración estimada: 2–3 horas (teoría + 3 laboratorios)
Versión 1.0 — Febrero 2026

---

## 1. Introducción

Codex puede conectarse a un navegador Chrome en tiempo real mediante MCP (Model Context Protocol), utilizando el servidor `mcp_servers.chrome_devtools`. Este servidor expone las capacidades del protocolo Chrome DevTools (CDP) como herramientas MCP, permitiendo al agente inspeccionar el DOM, analizar tráfico de red, ejecutar JavaScript en el contexto de la página, auditar accesibilidad y capturar snapshots visuales, todo sin salir del CLI.

A diferencia de herramientas de testing como Playwright o Puppeteer, la integración MCP permite a Codex interactuar con una sesión de Chrome ya abierta y persistente, con el contexto completo del desarrollador: cookies de sesión, estado de autenticación, datos reales de la aplicación. Esto lo convierte en una herramienta especialmente potente para depuración asistida de frontends en desarrollo.

Este módulo enseña a configurar la conexión MCP entre Codex y Chrome, aplicar guardrails de seguridad (perfil dedicado, depuración aislada, allowlist de tools) y ejecutar tareas reales de desarrollo frontend asistidas por Codex.

---

## 2. Objetivos de aprendizaje

| # | Objetivo | Evidencia de logro |
| --- | --- | --- |
| O1 | Explicar cómo el Chrome DevTools Protocol (CDP) se expone via MCP y cómo lo usa Codex. | Diagrama mental correcto del flujo Codex → MCP → CDP → Chrome. |
| O2 | Configurar Chrome con depuración remota y conectar el servidor MCP a Codex CLI de forma reproducible. | `codex mcp list` muestra el servidor activo y Codex puede leer el título de la página activa. |
| O3 | Usar Codex para inspeccionar DOM, ejecutar JS, auditar accesibilidad y analizar tráfico de red de una aplicación real. | 3 tareas de depuración completadas con evidencia en ficheros del proyecto. |
| O4 | Aplicar seguridad operativa: perfil de Chrome aislado, allowlist de tools MCP, nunca conectar a sesión de producción autenticada. | Configuración segura verificable en config.toml. |

---

## 3. Contenidos teóricos

### 3.1 Chrome DevTools Protocol (CDP) y MCP

El Chrome DevTools Protocol es la API que permite a herramientas externas comunicarse con Chrome: inspeccionar elementos, interceptar peticiones, ejecutar código en el contexto de la página, tomar capturas de pantalla, y medir performance. Cuando Chrome arranca con `--remote-debugging-port`, expone un WebSocket al que se puede conectar cualquier cliente CDP.

El servidor MCP `chrome_devtools` actúa como traductor: escucha las invocaciones de tools MCP por parte de Codex y las convierte en llamadas CDP al navegador.

```text
Codex CLI
    │
    │ MCP (STDIO / HTTP)
    ▼
chrome_devtools MCP Server
    │
    │ Chrome DevTools Protocol (WebSocket)
    ▼
Chrome (--remote-debugging-port=9222)
    │
    └─► Página web activa
```

**Ventajas frente a Playwright/Puppeteer:**

- Codex trabaja sobre una sesión de Chrome ya abierta, con el estado real del usuario.
- No requiere instrumentar el código de la aplicación.
- Ideal para depuración ad-hoc y generación de reportes de calidad.

**Limitaciones:**

- Requiere Chrome activo con depuración habilitada antes de iniciar Codex.
- Solo un cliente CDP puede estar conectado al mismo target (pestaña) simultáneamente. Cerrar DevTools del navegador antes de conectar Codex.
- Las herramientas de ejecución de JS tienen acceso al contexto completo de la página: aplicar mínimo privilegio.

### 3.2 MCP chrome_devtools: herramientas disponibles

El servidor MCP de Chrome DevTools expone las siguientes categorías de tools:

**Navegación y contexto:**

| Tool MCP | Descripción |
| --- | --- |
| `navigate` | Navega a una URL en la pestaña activa. |
| `get_current_url` | Devuelve la URL de la pestaña activa. |
| `get_page_title` | Devuelve el título de la página activa. |
| `screenshot` | Captura la página actual como imagen base64 (PNG). |
| `list_tabs` | Lista las pestañas abiertas y sus URLs. |
| `switch_tab` | Cambia la pestaña activa por ID. |

**Inspección del DOM:**

| Tool MCP | Descripción |
| --- | --- |
| `get_dom` | Devuelve el HTML completo o de un selector. |
| `query_selector` | Evalúa un selector CSS y devuelve atributos del elemento. |
| `get_accessibility_tree` | Devuelve el árbol de accesibilidad (ARIA roles, labels). |
| `get_computed_styles` | Devuelve estilos computados de un elemento. |

**Ejecución de JavaScript:**

| Tool MCP | Descripción |
| --- | --- |
| `evaluate` | Ejecuta una expresión JS en el contexto de la página y devuelve el resultado. |
| `call_function` | Llama una función JS serializable con argumentos. |

**Red y performance:**

| Tool MCP | Descripción |
| --- | --- |
| `get_network_requests` | Lista las peticiones de red capturadas (URL, método, status, duración). |
| `get_console_logs` | Devuelve los mensajes de consola (log, warn, error). |
| `get_performance_metrics` | Devuelve métricas de performance de la página (LCP, FID, CLS, etc.). |
| `clear_network_logs` | Limpia el log de peticiones de red acumulado. |

> **⚠️ Nota:** El conjunto exacto de tools disponibles puede variar según la versión del servidor MCP instalado. Verificar con `codex` + "lista las tools disponibles de chrome_devtools" en el primer uso.

### 3.3 Configurar Chrome con depuración remota

Chrome debe arrancar con el flag `--remote-debugging-port` ANTES de lanzar Codex. No es posible habilitarlo en un Chrome ya abierto sin reiniciarlo.

#### Opción A: Perfil de laboratorio aislado (recomendado)

```bash
# Linux (no wsl)/ macOS — perfil aislado en directorio temporal
google-chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-devtools-lab \
  --no-first-run \
  --no-default-browser-check \
  http://localhost:3000

# macOS con Chrome desde Applications
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-devtools-lab \
  http://localhost:3000
```

#### Opción B: Variable de entorno (wrapper script corporativo)

```bash
#!/bin/bash
# scripts/launch-chrome-lab.sh
export CHROME_DEBUG_PORT=${CHROME_DEBUG_PORT:-9222}
export CHROME_PROFILE_DIR=${CHROME_PROFILE_DIR:-/tmp/chrome-codex-lab}

google-chrome \
  --remote-debugging-port="$CHROME_DEBUG_PORT" \
  --user-data-dir="$CHROME_PROFILE_DIR" \
  --no-first-run \
  "$@"
```

#### Verificar que Chrome está escuchando

```bash
# Debe devolver JSON con lista de targets (pestañas)
curl -s http://localhost:9222/json | python3 -m json.tool | head -30
```

#### Opción C: Windows + WSL2 (Chrome en Windows, Codex en WSL) — con `portproxy` (recomendado en entornos WSL)

Si estás ejecutando **Codex dentro de WSL2** pero quieres depurar un **Google Chrome que corre en Windows**, la forma más reproducible es:

1) arrancar Chrome en Windows con *remote debugging* (9222),
2) publicar ese puerto hacia la interfaz de WSL mediante `netsh interface portproxy` (9223),
3) conectar el servidor MCP desde WSL al endpoint `http://<WSL_IP>:9223`.

> **Requisito:** el paquete `chrome-devtools-mcp` requiere **Node.js 20.19.0 LTS o superior (LTS)** en WSL.

##### Paso 1 — Ejecuta estas instrucciones en **PowerShell como Administrador** (Windows)

```powershell
# Abre el navegador en modo depuración (Chrome en Windows)
& "C:\Program Files\Google\Chrome\Application\chrome.exe" `
  --remote-debugging-port=9222 `
  --user-data-dir="$env:TEMP\chrome-debug" `
  --no-first-run `
  --no-default-browser-check

# IP de WSL (vEthernet WSL). Esta IP es la que utilizaremos en la configuración siguiente:
Get-NetIPAddress -AddressFamily IPv4 `
  | Where-Object { $_.InterfaceAlias -like "vEthernet (WSL*)" } `
  | Select-Object IPAddress

# Crea proxy (WSL_IP:9223 -> 127.0.0.1:9222 en Windows)
netsh interface portproxy add v4tov4 `
  listenaddress=172.27.64.1 `
  listenport=9223 `
  connectaddress=127.0.0.1 `
  connectport=9222

# Crea la regla en el firewall
New-NetFirewallRule -DisplayName "WSL Chrome DevTools Debug proxy" `
  -Direction Inbound `
  -LocalPort 9223 `
  -Protocol TCP `
  -Action Allow

# Comprueba el proxy
netsh interface portproxy show all
```

Salida esperada (ejemplo):

```text
Escuchar en ipv4:       Conectar a ipv4:

Dirección       Puerto      Dirección       Puerto
--------------- ----------  --------------- ----------
172.27.64.1     9223        127.0.0.1       9222
```

Para eliminar el proxy creado:

```powershell
netsh interface portproxy delete v4tov4 `
  listenaddress=172.27.64.1 `
  listenport=9223

# Verifica que se ha eliminado
netsh interface portproxy show all
```

##### Paso 2 — Comprueba conectividad desde **WSL**

```bash
curl http://172.27.64.1:9223/json/version
```

Si devuelve JSON (Browser/Protocol-Version/webSocketDebuggerUrl), la conectividad CDP está lista.

##### Paso 3 — Configura el MCP en `~/.codex/config.toml` (WSL)

```toml
[mcp_servers.chrome-devtools]
command = "npx"
args = [
  "-y",
  "chrome-devtools-mcp@latest",
  "--browser-url=http://172.27.64.1:9223"
]
startup_timeout_sec = 20
enabled = true
```

> Consejo: si `codex` no encuentra `npx` o usa otra versión de Node, usa rutas absolutas (`which node`, `which npx`) o fija Node 20+ con `nvm` en WSL.

### 3.5 Selección de servidor MCP (criterios corporativos)

| Servidor MCP | Enfoque | Ejecución JS | Acceso Red | Transporte |
| --- | --- | --- | --- | --- |
| **@modelcontextprotocol/server-chrome-devtools** | **Inspección y depuración. Usado en este módulo.** | **Sí (controlable via enabled_tools)** | **Sí (read)** | **STDIO** |
| Playwright MCP | Testing automatizado, headless | Sí | Sí | STDIO |
| Puppeteer MCP | Scraping y automatización | Sí | Sí | STDIO |

> **⚠️ Supply chain MCP:** Aplicar el mismo criterio que en otros módulos: allowlist en `requirements.toml`, pin de versión, revisión del repositorio antes de adoptar.

### 3.6 Seguridad y guardrails

#### 3.6.1 Perfil de Chrome aislado

NUNCA usar el perfil de Chrome de trabajo o personal con `--remote-debugging-port`. Usar siempre un directorio `--user-data-dir` temporal y vacío. El servidor MCP podría acceder a cookies, contraseñas guardadas o tokens de sesión del perfil real.

#### 3.6.2 Allowlist de tools en requirements.toml (Enterprise)

```toml
# requirements.toml (admin-enforced, no overridable)
[[mcp_servers]]
id = "chrome_devtools"
identity = { command = "npx" }
```

#### 3.6.3 Deshabilitar ejecución de JS por defecto

```toml
[mcp_servers.chrome_devtools]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-chrome-devtools", "--port", "9222"]
disabled_tools = ["evaluate", "call_function", "navigate"]
```

#### 3.6.4 AGENTS.md con reglas de uso

```markdown
# AGENTS.md — Reglas chrome_devtools MCP
- Solo conectar a Chrome con perfil de laboratorio aislado (/tmp/chrome-codex-lab).
- No usar evaluate ni call_function sin aprobación explícita en el prompt.
- No navegar a URLs externas durante sesiones de depuración.
- Guardar capturas de pantalla y reportes en docs/devtools/ del proyecto.
- Nunca incluir cookies ni tokens en los ficheros de salida.
```

---

## 4. Buenas prácticas

### 4.1 Screenshot-first

Antes de pedir análisis de DOM o accesibilidad, pedir a Codex que capture un screenshot de la página actual. Esto ancla el contexto visual y permite detectar si Chrome está en el estado correcto antes de ejecutar análisis más complejos.

### 4.2 Inspección antes de evaluación

Preferir `get_dom` y `query_selector` sobre `evaluate` para extraer datos. Si se necesita JS, definir el propósito exacto del script antes de pedirle a Codex que lo ejecute, y revisar el código antes de aprobar.

### 4.3 Trazabilidad de inspecciones

Cada snapshot de DOM, log de red o reporte de accesibilidad debe guardarse en fichero en el proyecto, con marca de tiempo y URL auditada. Esto permite reproducir el análisis y comparar con versiones futuras.

### 4.4 Performance: baseline primero

No pedir "optimiza el frontend" sin métricas de partida. Primero: `get_performance_metrics` y `get_network_requests`. Luego pedir análisis específico de los cuellos de botella detectados.

### 4.5 Accesibilidad como parte del flujo

Integrar `get_accessibility_tree` en el flujo de revisión de nuevas vistas, no como corrección posterior. Pedirle a Codex que detecte violaciones WCAG antes del merge.

### 4.6 Pin de versión del servidor MCP

```toml
args = ["-y", "@modelcontextprotocol/server-chrome-devtools@1.2.0", "--port", "9222"]
```

---

## 5. Errores comunes

### 5.1 Chrome sin depuración activa

**Problema:** El servidor MCP falla al conectar porque Chrome se lanzó sin `--remote-debugging-port`.
**Solución:** Cerrar Chrome completamente y relanzarlo con el flag. Verificar con `curl http://localhost:9222/json`.

### 5.2 Conflicto con DevTools abierto

**Problema:** Solo un cliente CDP puede conectarse al mismo target. Si DevTools del navegador está abierto en la misma pestaña, la conexión MCP falla o se comporta de forma errática.
**Solución:** Cerrar DevTools del navegador antes de iniciar Codex con chrome_devtools MCP.

### 5.3 Usar perfil de Chrome personal

**Problema:** Lanzar Chrome con `--remote-debugging-port` sin `--user-data-dir`, exponiendo el perfil real con cookies y contraseñas guardadas.
**Solución:** Siempre usar `--user-data-dir=/tmp/chrome-codex-lab` o equivalente temporal y vacío.

### 5.4 Pedir evaluate sin revisión

**Problema:** Aprobar ejecución de `evaluate` sin revisar el código JS generado por Codex.
**Solución:** Leer el script completo antes de aprobar. Si el lab no requiere ejecución de JS, mantener `disabled_tools = ["evaluate", "call_function"]`.

### 5.5 Confundir MCP con Playwright

**Problema:** Esperar que el servidor MCP controle el navegador de forma headless para CI.
**Solución:** El servidor chrome_devtools MCP es para depuración interactiva asistida. Para pipelines CI/CD automatizados, usar Playwright o Puppeteer directamente (posiblemente con su propio servidor MCP específico de testing).

### 5.6 Timeout de arranque corto

**Problema:** `startup_timeout_sec` por defecto (10s) insuficiente si `npx` descarga el paquete.
**Solución:** Subir a 20-30s o pre-descargar el paquete antes: `npx -y @modelcontextprotocol/server-chrome-devtools --version`.

---

## 6. Casos de uso reales en desarrollo

### 6.1 Auditoría de accesibilidad de nueva vista

El equipo lanza una nueva página de formulario. Antes del merge, Codex accede via chrome_devtools MCP, obtiene el árbol de accesibilidad, identifica inputs sin `aria-label`, imágenes sin `alt`, y controles de formulario sin asociación correcta a su `<label>`. Genera `docs/devtools/a11y-report.md` con lista de violaciones WCAG 2.1 AA y los selectores CSS exactos a corregir.

### 6.2 Depuración de error silencioso de red

Una sección del dashboard no carga datos. El desarrollador no ve error visible. Codex usa `get_console_logs` y `get_network_requests` para detectar una petición a `/api/metrics` que devuelve 403. Identifica que el token CSRF no se envía en el header correcto. Genera el fix en el cliente HTTP.

### 6.3 Análisis de regresión de performance

Después de un refactor, el tiempo de carga del panel principal ha empeorado. Codex obtiene `get_performance_metrics` (LCP, CLS, FCP) antes y después del cambio, compara con la línea base guardada en `docs/devtools/perf-baseline.json`, e identifica que un bundle JS aumentó 180KB por una importación no lazy.

### 6.4 Extracción de datos estructurados del DOM

Un script de migración necesita extraer datos de una tabla HTML de la aplicación legacy antes de migrar a la nueva API. Codex usa `get_dom` con selector específico para extraer la tabla, la convierte a JSON y genera el fichero de datos estructurados para la migración.

---

## 7. Laboratorios prácticos

> **📦 Prerequisitos comunes:** Google Chrome instalado (versión 120+). Node.js + npx disponibles. Codex CLI instalado con soporte MCP. Una aplicación web local en ejecución (los labs incluyen setup de una app de ejemplo).

---

### 7.1 Lab L-CD-1 — Conectar Codex a Chrome y auditar accesibilidad

> **🎯 Objetivo:** Arrancar Chrome con depuración remota, conectar el servidor MCP chrome_devtools a Codex, capturar el estado visual de una página y generar un reporte completo de accesibilidad con WCAG violations.

#### Paso 1 (L-CD-1): Setup del proyecto

```bash
mkdir /tmp/codex-lab-chrome && cd /tmp/codex-lab-chrome
git init
mkdir -p src docs/devtools .codex
```

#### Paso 2: Crear aplicación de ejemplo con problemas de accesibilidad

```html
<!-- src/index.html -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Dashboard de Ventas</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
    .card { background: white; padding: 20px; border-radius: 8px; margin: 10px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    .btn { background: #007bff; color: white; border: none; padding: 10px 20px; cursor: pointer; }
    .error { color: red; }
    img.logo { width: 100px; }
    /* Bug de accesibilidad: contraste bajo */
    .low-contrast { color: #aaa; background: #bbb; padding: 5px; }
  </style>
</head>
<body>
  <h1>Dashboard</h1>

  <!-- Bug 1: imagen sin alt -->
  <img class="logo" src="https://via.placeholder.com/100x50">

  <!-- Bug 2: input sin label -->
  <div class="card">
    <h2>Buscar cliente</h2>
    <input type="text" placeholder="Nombre del cliente" id="search">
    <button class="btn" onclick="buscar()">Buscar</button>
  </div>

  <!-- Bug 3: botón sin texto accesible -->
  <div class="card">
    <h2>Acciones</h2>
    <button class="btn" onclick="exportar()">
      <span aria-hidden="true">📊</span>
    </button>
    <button class="btn">Eliminar</button>
  </div>

  <!-- Bug 4: contraste bajo -->
  <div class="card low-contrast">
    Texto con contraste insuficiente para usuarios con baja visión
  </div>

  <!-- Bug 5: tabla sin headers -->
  <div class="card">
    <h2>Últimas ventas</h2>
    <table border="1" style="width:100%">
      <tr>
        <td>Ana García</td><td>Laptop Pro</td><td>1299.99€</td><td>2026-02-01</td>
      </tr>
      <tr>
        <td>Carlos López</td><td>Monitor 27"</td><td>449.99€</td><td>2026-02-03</td>
      </tr>
    </table>
  </div>

  <script>
    function buscar() { console.log('Buscando...'); }
    function exportar() { console.log('Exportando...'); }
  </script>
</body>
</html>
```

#### Paso 3: Servir la aplicación localmente

```bash
# Con Python (sin dependencias adicionales)
cd src && python3 -m http.server 3000 &
# Verificar
curl -s http://localhost:3000/ | head -5
```

#### Paso 4: Lanzar Chrome con depuración remota

```bash
# Lanzar con perfil aislado (NO usar el perfil personal)
google-chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-codex-lab \
  --no-first-run \
  http://localhost:3000/ &

sleep 3

# Verificar que Chrome expone el endpoint CDP
curl -s http://localhost:9222/json/version | python3 -m json.tool
```

#### Paso 5: Configurar servidor MCP en Codex

```toml
# .codex/config.toml
[mcp_servers.chrome_devtools]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-chrome-devtools", "--port", "9222"]
startup_timeout_sec = 25.0
disabled_tools = ["evaluate", "call_function", "navigate"]
```

```bash
# Verificar configuración
codex mcp list
```

#### Paso 6: Auditar accesibilidad con Codex

```bash
codex
```

```text
# Turno 1: Verificar conexión y estado visual
Usando chrome_devtools MCP:
1. Obtén la URL y título de la pestaña activa
2. Toma un screenshot de la página actual
3. Confirma que estás viendo el Dashboard de Ventas

# Turno 2: Inspección del DOM
Obtén el DOM completo de la página usando get_dom.
Identifica todos los elementos interactivos:
inputs, botones, imágenes, tablas, formularios.

# Turno 3: Árbol de accesibilidad
Obtén el árbol de accesibilidad completo con get_accessibility_tree.
Identifica violaciones WCAG 2.1 nivel AA:
- Imágenes sin alt text
- Inputs sin label asociado
- Botones sin nombre accesible
- Tablas sin headers (<th> o scope)
- Cualquier otro problema que detectes

# Turno 4: Generar reporte
Genera docs/devtools/a11y-report.md con:
1. Resumen ejecutivo (N violaciones encontradas)
2. Tabla de violaciones: elemento | criterio WCAG | descripción | fix propuesto
3. HTML corregido para cada elemento con problema
4. Lista de verificación post-fix

Guarda también docs/devtools/a11y-fixes.html con el HTML
completo corregido de src/index.html.
```

#### Verificación L-CD-1

| Verificación | Resultado esperado |
| --- | --- |
| `codex mcp list` | chrome_devtools activo |
| Screenshot capturado | Imagen del Dashboard visible |
| `docs/devtools/a11y-report.md` | Mínimo 5 violaciones detectadas con criterio WCAG |
| Violaciones identificadas | img sin alt, input sin label, botón sin texto, tabla sin th, contraste bajo |
| `docs/devtools/a11y-fixes.html` | HTML corregido con todos los elementos accesibles |

#### Limpieza L-CD-1 (obligatoria)

```bash
# Detener servidor Python
pkill -f "python3 -m http.server 3000"
# Cerrar Chrome de laboratorio
pkill -f "chrome-codex-lab"
# Limpiar proyecto y perfil temporal
cd /tmp && rm -rf codex-lab-chrome chrome-codex-lab
```

---

### 7.2 Lab L-CD-2 — Depuración de red: del error 4xx al fix documentado

> **🎯 Objetivo:** Usar Codex con chrome_devtools MCP para inspeccionar peticiones de red fallidas, analizar logs de consola, identificar la causa raíz de un error silencioso y documentar el fix.

#### Paso 1 (L-CD-2): Setup del proyecto

```bash
mkdir /tmp/codex-lab-chrome-net && cd /tmp/codex-lab-chrome-net
git init
mkdir -p src docs/devtools .codex
```

#### Paso 2: Crear aplicación con errores de red simulados

```html
<!-- src/app.html -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>App de Métricas</title>
  <style>
    body { font-family: monospace; margin: 20px; }
    .panel { border: 1px solid #ccc; padding: 15px; margin: 10px 0; }
    .status { font-weight: bold; }
    .ok { color: green; } .error { color: red; } .loading { color: orange; }
  </style>
</head>
<body>
  <h1>Panel de Métricas</h1>

  <div class="panel">
    <h2>Usuarios activos <span id="users-status" class="status loading">cargando...</span></h2>
    <div id="users-data">—</div>
  </div>

  <div class="panel">
    <h2>Ventas hoy <span id="sales-status" class="status loading">cargando...</span></h2>
    <div id="sales-data">—</div>
  </div>

  <div class="panel">
    <h2>Alertas <span id="alerts-status" class="status loading">cargando...</span></h2>
    <div id="alerts-data">—</div>
  </div>

  <script>
    // Simular peticiones con diferentes tipos de error
    async function fetchMetric(endpoint, statusEl, dataEl) {
      try {
        const res = await fetch(endpoint, {
          headers: { 'Authorization': 'Bearer fake-token-123' }
        });
        if (!res.ok) {
          statusEl.className = 'status error';
          statusEl.textContent = `Error ${res.status}`;
          console.error(`[METRICS] ${endpoint} failed: ${res.status} ${res.statusText}`);
          return;
        }
        const data = await res.json();
        statusEl.className = 'status ok';
        statusEl.textContent = 'OK';
        dataEl.textContent = JSON.stringify(data);
      } catch (e) {
        statusEl.className = 'status error';
        statusEl.textContent = 'Error de red';
        console.error(`[METRICS] Network error for ${endpoint}:`, e.message);
      }
    }

    // Endpoint correcto (Mock: usa JSONPlaceholder como ejemplo)
    fetchMetric('https://jsonplaceholder.typicode.com/users/1', 
      document.getElementById('users-status'),
      document.getElementById('users-data'));

    // Endpoint con 404 (ruta inexistente)
    fetchMetric('https://jsonplaceholder.typicode.com/metrics/daily-sales', 
      document.getElementById('sales-status'),
      document.getElementById('sales-data'));

    // Endpoint con error de CORS (dominio que no existe)
    fetchMetric('https://api.internal-corp.invalid/v1/alerts', 
      document.getElementById('alerts-status'),
      document.getElementById('alerts-data'));
  </script>
</body>
</html>
```

#### Paso 3 (L-CD-2): Servir y abrir en Chrome

```bash
cd src && python3 -m http.server 3001 &
sleep 1

google-chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-codex-lab-net \
  --no-first-run \
  http://localhost:3001/app.html &

sleep 4
# Dar tiempo a que se ejecuten las peticiones de red
```

#### Paso 4 (L-CD-2): Configurar MCP

```toml
# .codex/config.toml
[mcp_servers.chrome_devtools]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-chrome-devtools", "--port", "9222"]
startup_timeout_sec = 25.0
# Para este lab necesitamos ver red y consola, sin ejecución de JS
disabled_tools = ["evaluate", "call_function"]
```

#### Paso 5: Investigar errores con Codex

```bash
codex
```

```text
# Turno 1: Estado visual inicial
Usando chrome_devtools MCP:
1. Captura screenshot de la página actual
2. Obtén la URL y título de la pestaña

# Turno 2: Análisis de logs de consola
Obtén todos los mensajes de consola con get_console_logs.
Filtra los mensajes de tipo 'error' y 'warning'.
Lista cada error con su mensaje completo y si hay URL/línea asociada.

# Turno 3: Análisis de peticiones de red
Obtén el log de peticiones de red con get_network_requests.
Para cada petición:
- URL, método HTTP, código de estado, duración
- Clasifica como: OK, Error cliente (4xx), Error servidor (5xx), Error de red

# Turno 4: Diagnóstico y documentación
Genera docs/devtools/network-debug-report.md con:
1. Resumen: N peticiones totales, N con éxito, N con error
2. Tabla de peticiones con status, tipo de error y causa probable
3. Para cada error: causa raíz diagnosticada + fix recomendado
4. Priorización de fixes por impacto al usuario

Incluye capturas textuales de los mensajes de error de consola
que evidencian cada problema.
```

#### Verificación L-CD-2

| Verificación | Resultado esperado |
| --- | --- |
| `get_console_logs` | Mínimo 2 errores detectados (404 y CORS/network) |
| `get_network_requests` | 3 peticiones identificadas con su status |
| `docs/devtools/network-debug-report.md` | Diagnóstico de 404 (ruta inexistente) y error de red (dominio inválido) |
| Fixes propuestos | URL correcta para 404, eliminación/mock del endpoint inválido |

#### Limpieza L-CD-2 (obligatoria)

```bash
pkill -f "python3 -m http.server 3001"
pkill -f "chrome-codex-lab-net"
cd /tmp && rm -rf codex-lab-chrome-net chrome-codex-lab-net
```

---

### 7.3 Lab L-CD-3 — Extracción de DOM y análisis de performance

> **🎯 Objetivo:** Usar Codex con chrome_devtools MCP para extraer datos estructurados del DOM (tabla HTML → JSON), obtener métricas de performance de la página, identificar recursos pesados y generar un plan de optimización.

#### Paso 1 (L-CD-3): Setup del proyecto

```bash
mkdir /tmp/codex-lab-chrome-perf && cd /tmp/codex-lab-chrome-perf
git init
mkdir -p src docs/devtools data .codex
```

#### Paso 2: Crear página con tabla de datos y recursos costosos

```html
<!-- src/dashboard.html -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Dashboard de Inventario</title>
  <!-- Simulación de recursos pesados -->
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
  <style>
    body { padding: 20px; }
    .kpi { font-size: 2rem; font-weight: bold; color: #007bff; }
  </style>
</head>
<body>
  <div class="container">
    <h1>Inventario de Productos</h1>

    <div class="row mb-4">
      <div class="col-md-3">
        <div class="card text-center p-3">
          <div class="kpi" id="total-productos">12</div>
          <div>Productos totales</div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-center p-3">
          <div class="kpi" id="stock-bajo">3</div>
          <div>Stock bajo (&lt;10)</div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-center p-3">
          <div class="kpi" id="valor-total">24.750€</div>
          <div>Valor total stock</div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-center p-3">
          <div class="kpi" id="categorias">4</div>
          <div>Categorías</div>
        </div>
      </div>
    </div>

    <h2>Catálogo completo</h2>
    <table class="table table-striped table-hover" id="inventory-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Producto</th>
          <th>Categoría</th>
          <th>Precio</th>
          <th>Stock</th>
          <th>Estado</th>
        </tr>
      </thead>
      <tbody>
        <tr><td>P001</td><td>Laptop Pro 15"</td><td>Informática</td><td>1.299,99€</td><td>45</td><td>OK</td></tr>
        <tr><td>P002</td><td>Teclado Mecánico RGB</td><td>Periféricos</td><td>89,99€</td><td>8</td><td>Bajo</td></tr>
        <tr><td>P003</td><td>Monitor UltraWide 34"</td><td>Monitores</td><td>649,99€</td><td>22</td><td>OK</td></tr>
        <tr><td>P004</td><td>Ratón Inalámbrico Pro</td><td>Periféricos</td><td>59,99€</td><td>5</td><td>Bajo</td></tr>
        <tr><td>P005</td><td>Auriculares Noise-Cancel</td><td>Audio</td><td>299,99€</td><td>30</td><td>OK</td></tr>
        <tr><td>P006</td><td>SSD NVMe 2TB</td><td>Almacenamiento</td><td>179,99€</td><td>60</td><td>OK</td></tr>
        <tr><td>P007</td><td>Webcam 4K</td><td>Periféricos</td><td>129,99€</td><td>7</td><td>Bajo</td></tr>
        <tr><td>P008</td><td>Hub USB-C 10 puertos</td><td>Periféricos</td><td>79,99€</td><td>40</td><td>OK</td></tr>
        <tr><td>P009</td><td>Tablet Gráfica A4</td><td>Diseño</td><td>349,99€</td><td>15</td><td>OK</td></tr>
        <tr><td>P010</td><td>Altavoces Studio 2.1</td><td>Audio</td><td>199,99€</td><td>18</td><td>OK</td></tr>
        <tr><td>P011</td><td>Soporte Ergonómico Monitor</td><td>Ergonomía</td><td>49,99€</td><td>35</td><td>OK</td></tr>
        <tr><td>P012</td><td>Cable Thunderbolt 4 2m</td><td>Conectividad</td><td>39,99€</td><td>70</td><td>OK</td></tr>
      </tbody>
    </table>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

#### Paso 3: Servir y abrir en Chrome

```bash
cd src && python3 -m http.server 3002 &
sleep 1

google-chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-codex-lab-perf \
  --no-first-run \
  http://localhost:3002/dashboard.html &

sleep 5
```

#### Paso 4 (L-CD-3): Configurar MCP

```toml
# .codex/config.toml
[mcp_servers.chrome_devtools]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-chrome-devtools", "--port", "9222"]
startup_timeout_sec = 25.0
# Para este lab: solo inspección, sin ejecución de JS
disabled_tools = ["evaluate", "call_function", "navigate"]
```

#### Paso 5: Extraer datos y analizar performance con Codex

```bash
codex
```

```text
# Turno 1: Verificación y captura visual
Usando chrome_devtools MCP:
1. Toma un screenshot de la página
2. Obtén el título y URL activos

# Turno 2: Extracción de tabla a JSON
Obtén el DOM de la tabla con id="inventory-table" usando get_dom con selector.
Parsea el contenido de la tabla (thead + tbody) y genera:
data/inventory.json con array de objetos:
[
  { "id": "P001", "producto": "...", "categoria": "...", 
    "precio": 1299.99, "stock": 45, "estado": "OK" },
  ...
]
Normaliza los precios a números (quitar €, puntos de miles, reemplazar , por .).
Aplica el mismo parsing a todos los 12 productos de la tabla.

# Turno 3: Análisis estadístico del inventario
Con los datos extraídos en data/inventory.json, calcula:
1. Precio medio del catálogo
2. Productos con stock bajo (< 10 unidades): lista con nombre y stock actual
3. Valor total del stock (precio × stock para cada producto, suma total)
4. Distribución por categoría (N productos por categoría)
Guarda el análisis en docs/devtools/inventory-analysis.md

# Turno 4: Análisis de performance de la página
Obtén get_performance_metrics y get_network_requests.
Genera docs/devtools/performance-report.md con:
1. Métricas de carga (FCP, LCP, TTFB si están disponibles)
2. Lista de recursos externos cargados: URL, tipo, tamaño estimado
3. Identificación de recursos candidatos a lazy loading o CDN local
4. Plan de optimización con 3 acciones concretas priorizadas
```

#### Verificación L-CD-3

| Verificación | Resultado esperado |
| --- | --- |
| Screenshot capturado | Dashboard con tabla de 12 productos visible |
| `data/inventory.json` | Array de 12 objetos con precios como números |
| Precio medio | ~302€ (aproximado, verificar con datos exactos) |
| Productos stock bajo | P002 (8), P004 (5), P007 (7) |
| `docs/devtools/inventory-analysis.md` | Análisis completo con distribución por categoría |
| `docs/devtools/performance-report.md` | Recursos Bootstrap identificados, plan de optimización |

#### Limpieza L-CD-3 (obligatoria)

```bash
pkill -f "python3 -m http.server 3002"
pkill -f "chrome-codex-lab-perf"
cd /tmp && rm -rf codex-lab-chrome-perf chrome-codex-lab-perf
```

---

## 8. Resumen y conceptos clave

| Concepto | Detalle |
| --- | --- |
| CDP (Chrome DevTools Protocol) | API WebSocket de Chrome para inspección, depuración y automatización. |
| `--remote-debugging-port` | Flag de arranque de Chrome que habilita el endpoint CDP. Requiere reiniciar Chrome. |
| `--user-data-dir` | Directorio de perfil de Chrome. SIEMPRE usar uno temporal y aislado para laboratorio. |
| `curl http://localhost:9222/json` | Verificar que Chrome expone el endpoint CDP correctamente. |
| `chrome_devtools` MCP Server | Traduce tools MCP a llamadas CDP. Se conecta via STDIO (npx). |
| `disabled_tools` | Clave para desactivar `evaluate` y `call_function` por defecto (ejecución JS). |
| `get_accessibility_tree` | Tool para auditoría WCAG: roles ARIA, labels, estructura semántica. |
| `get_network_requests` | Inspección de tráfico de red: URLs, status codes, duración. |
| `get_console_logs` | Captura de errores y warnings de consola del navegador. |
| `get_performance_metrics` | Métricas Web Vitals: LCP, FCP, CLS, TTFB. |
| `get_dom` + selector | Extracción estructurada de HTML de elementos específicos. |
| Screenshot-first | Verificar contexto visual antes de análisis complejos. |
| Trazabilidad | Guardar cada inspección en fichero con URL y timestamp. |
| Supply chain MCP | Allowlist en `requirements.toml`, pin de versión, revisión del repositorio. |

> **🎓 Módulo completado:** Con MCP + Chrome DevTools, Codex pasa de analizar código estático a trabajar sobre la aplicación viva: accesibilidad real, errores de red reales, performance medida, y datos del DOM extraídos con precisión quirúrgica.

---

## 9. Material de entrega para adopción corporativa

- Checklist de seguridad MCP Chrome DevTools: perfil de Chrome aislado, `disabled_tools` con `evaluate` y `call_function`, allowlist en `requirements.toml`, pin de versiones, nunca conectar a sesión autenticada de producción.
- Script `launch-chrome-lab.sh`: wrapper para arrancar Chrome con perfil temporal y depuración habilitada, parametrizable via variables de entorno.
- AGENTS.md con reglas de uso: perfil aislado obligatorio, no navegar a URLs externas, guardar inspecciones en `docs/devtools/`, no incluir cookies ni tokens en outputs.
- Plantilla "devtools task": screenshot-first, inspección antes de evaluación, trazabilidad obligatoria.
- Config base: `.codex/config.toml` con `chrome_devtools` configurado, `evaluate` y `call_function` desactivados, `startup_timeout_sec = 25`.

---

## 10. Referencias oficiales

- MCP en Codex: <https://developers.openai.com/codex/mcp/>
- Config Reference (mcp_servers): <https://developers.openai.com/codex/config-reference/>
- Security (MCP allowlist): <https://developers.openai.com/codex/security/>
- Chrome DevTools Protocol: <https://chromedevtools.github.io/devtools-protocol/>
- Chrome Remote Debugging: <https://developer.chrome.com/docs/devtools/remote-debugging/>
- WCAG 2.1 Quick Reference: <https://www.w3.org/WAI/WCAG21/quickref/>
- Web Vitals: <https://web.dev/vitals/>
- MCP Server Chrome DevTools (npm): <https://www.npmjs.com/package/@modelcontextprotocol/server-chrome-devtools>
- Codex Prompting Guide: <https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide/>
