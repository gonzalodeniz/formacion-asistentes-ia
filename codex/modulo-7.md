# Módulo 7 — Integraciones: MCP (Model Context Protocol) y Herramientas Externas

> **Duración estimada:** 90 minutos
> (45 min teoría + 45 min laboratorio)
> **Referencias:**
> [MCP Overview](https://developers.openai.com/codex/mcp/) |
> [CLI Reference](https://developers.openai.com/codex/cli/reference/) |
> [OpenAI Docs MCP](https://developers.openai.com/resources/docs-mcp/)

## 1. Objetivos de Aprendizaje

1. **Romper el aislamiento:** Conectar Codex con el mundo
   exterior (GitHub, documentación, APIs) de forma segura
   mediante el estándar **MCP**.
2. **Orquestación de Herramientas:** Configurar servidores
   MCP para que Codex descubra y use herramientas externas
   automáticamente.
3. **Seguridad en Integraciones:** Aplicar principio de
   mínimo privilegio con `enabled_tools`/`disabled_tools`
   y gestionar secretos vía variables de entorno.

## 2. Contenidos Teóricos

### 2.1. ¿Qué es MCP (Model Context Protocol)?

Hasta ahora, Codex solo "veía" tus archivos locales. **MCP**
es un estándar abierto que permite a la IA conectarse a
fuentes de datos externas (servidores MCP). OpenAI lo describe
como un "USB-C para IA": un protocolo unificado para conectar
herramientas.

**Arquitectura:**

- **Host:** La aplicación donde corre la IA (Codex CLI / IDE).
- **Client:** El componente dentro del host que gestiona la
  conexión MCP.
- **Server:** El conector que habla con la herramienta real
  (ej. `@modelcontextprotocol/server-github`,
  `@upstash/context7-mcp`).

**Tipos de transporte:**

| Tipo | Descripción | Ejemplo |
| --- | --- | --- |
| STDIO | Subproceso local lanzado por Codex | `npx -y @upstash/context7-mcp` |
| Streamable HTTP | Servidor remoto por URL | `https://developers.openai.com/mcp` |

Codex lanza los servidores STDIO automáticamente al iniciar
sesión y expone sus herramientas junto a las built-in.

### 2.2. Gestión mediante CLI (`codex mcp`)

Codex incluye un subcomando dedicado para gestionar
servidores MCP:

```bash
# Registrar un servidor STDIO
codex mcp add context7 -- npx -y @upstash/context7-mcp

# Registrar un servidor STDIO con variables de entorno
codex mcp add github \
  --env GITHUB_PAT_TOKEN=ghp_xxxx \
  -- npx -y @modelcontextprotocol/server-github

# Registrar un servidor HTTP (remoto)
codex mcp add openaiDocs \
  --url https://developers.openai.com/mcp

# Listar servidores configurados
codex mcp list
codex mcp list --json

# Ver configuración de un servidor
codex mcp show context7
codex mcp show context7 --json

# Eliminar un servidor
codex mcp remove context7

# Iniciar OAuth para servidores HTTP que lo soporten
codex mcp auth <nombre>
```

> **Nota:** La configuración MCP se almacena en
> `~/.codex/config.toml` y es **compartida entre CLI e IDE**.
> Configura una vez, usa en ambos clientes.

### 2.3. Configuración en `config.toml`

Cada servidor MCP se configura con una tabla
`[mcp_servers.<nombre>]` en config.toml:

```toml
# ~/.codex/config.toml o .codex/config.toml (trusted)

# Servidor STDIO (subproceso local)
[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]

# Servidor STDIO con variables de entorno
[mcp_servers.github]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-github"]
[mcp_servers.github.env]
GITHUB_PAT_TOKEN = "ghp_xxxx"

# Servidor HTTP (remoto)
[mcp_servers.openaiDocs]
url = "https://developers.openai.com/mcp"

# Servidor HTTP con autenticación bearer
[mcp_servers.figma]
url = "https://mcp.figma.com/mcp"
bearer_token_env_var = "FIGMA_OAUTH_TOKEN"
```

**Opciones avanzadas de configuración:**

| Opción | Default | Descripción |
| --- | --- | --- |
| `command` | (req STDIO) | Comando que lanza el servidor |
| `args` | `[]` | Argumentos del comando |
| `url` | (req HTTP) | URL del servidor remoto |
| `env` | `{}` | Variables de entorno para STDIO |
| `bearer_token_env_var` | — | Env var con bearer token |
| `http_headers` | `{}` | Headers estáticos HTTP |
| `startup_timeout_sec` | 10 | Timeout de arranque |
| `tool_timeout_sec` | 60 | Timeout por herramienta |
| `enabled` | true | `false` para deshabilitar sin borrar |
| `enabled_tools` | all | Whitelist de tools expuestas |
| `disabled_tools` | `[]` | Blacklist (tras whitelist) |

**Verificar servidores activos en el TUI:**

```text
/mcp
# Muestra servidores activos y herramientas disponibles
```

### 2.4. Diseño de Herramientas (Tools)

Para que Codex use bien una herramienta, esta debe cumplir:

- **Idempotencia:** Las herramientas de lectura deben ser
  seguras de llamar múltiples veces sin side effects. Las de
  escritura deben declarar sus efectos explícitamente para
  que Codex pueda solicitar aprobación.
- **Contratos claros:** El nombre y la descripción de cada
  tool en el servidor MCP es lo que el modelo lee para
  decidir cuándo y cómo usarla. Nombres como `do_stuff` o
  descripciones vagas provocan invocaciones incorrectas.
  Preferir `list_open_tickets`, `create_github_issue`.
- **Respuestas estructuradas:** Devolver JSON, no texto libre.
  Incluir campos de error claros. Limitar tamaño de respuesta
  (no volcar tablas de miles de filas).
- **Mínimo privilegio:** Exponer solo las tools necesarias
  usando `enabled_tools`/`disabled_tools` en config.toml.

## 3. Buenas Prácticas

1. **Segregación de entornos:**
   - Local/dev: servidores MCP de lectura (docs, GitHub
     read-only, db-viewer).
   - CI/staging: herramientas de escritura con approval
     policy estricta.
   - Producción: ningún MCP o solo lectura estrictamente
     necesaria.
2. **Sanitización de secretos:** Nunca pasar tokens como
   argumentos de línea de comandos. Usar la inyección de
   variables de entorno (`env` en config.toml o
   `bearer_token_env_var` para HTTP).
3. **Observabilidad:** OTel registra cada invocación MCP
   (`codex.tool_result`). Las transcripciones en
   `~/.codex/sessions/` incluyen tool calls completas.
   Usar `/mcp` en el TUI para verificar antes de cada sesión.
4. **Instrucciones en AGENTS.md:** Para que Codex use MCP
   automáticamente, añadir instrucciones explícitas:

```markdown
Always use the OpenAI developer documentation MCP server
if you need to work with the OpenAI API or Codex
without me having to explicitly ask.
```

## 4. Errores Comunes

1. **La "Navaja Suiza" Gigante:** Conectar 20 servidores MCP
   a la vez. Las definiciones de herramientas ocupan tokens
   de contexto. *Solución:* Activar solo lo necesario.
   Usar `enabled = false` para deshabilitar temporalmente.
2. **Contratos ambiguos:** Tool `do_stuff` sin descripción
   clara. *Solución:* Nombres descriptivos + descripción
   con parámetros, retorno y side effects documentados.
3. **Side effects ocultos:** Una herramienta de "lectura" que
   modifica datos internamente. *Solución:* Separar tools
   de lectura y escritura. Las de escritura deben declarar
   side effects para que Codex pida aprobación.
4. **Error de sintaxis TOML:** Un error en config.toml rompe
   tanto CLI como IDE (configuración compartida). *Solución:*
   Validar TOML antes de guardar. Verificar con
   `codex mcp list` después de cada cambio.
5. **Timeout insuficiente:** Servidores pesados fallan al
   arrancar con el default de 10s. *Solución:* Ajustar
   `startup_timeout_sec` (ej. 30).
6. **Secretos en respuestas:** Tokens filtrados en output de
   herramientas MCP (se inyectan en el contexto del modelo).
   *Solución:* Sanitizar respuestas del servidor.

## 5. Casos de Uso Reales

- **Documentación actualizada:** OpenAI Docs MCP
  (`url = "https://developers.openai.com/mcp"`) + instrucción
  en AGENTS.md. Codex consulta documentación oficial
  automáticamente en lugar de depender de conocimiento
  potencialmente desactualizado.
- **GitHub integrado:** GitHub MCP
  (`url = "https://api.githubcopilot.com/mcp/"`) con bearer
  token. Codex lee PRs abiertas, crea issues, revisa código.
- **Onboarding de Base de Datos:** Servidor MCP de Postgres
  con tools read-only (`list_tables`, `describe_table`,
  `run_query`). Las tools destructivas (`drop_table`,
  `truncate`) en `disabled_tools`.

---

## 6. Laboratorio (L7) — Conectar el MCP Server de OpenAI Docs

**Escenario:** En lugar de crear un mock MCP frágil,
conectaremos un servidor MCP real, gratuito y sin
autenticación: **OpenAI Docs MCP**. Verificaremos que Codex
lo usa para responder preguntas sobre la API de OpenAI con
información actualizada.

> **¿Por qué no un mock?** Un servidor MCP stdio real
> requiere implementar correctamente el protocolo completo
> (initialize, initialized, tools/list, tools/call con
> JSON-RPC 2.0 incluyendo capabilities negotiation). Un
> script simplificado fallaría en el handshake. Usar un
> servidor real es más robusto y enseña el flujo auténtico.

### Paso 1: Crear proyecto

```bash
mkdir /tmp/codex-lab07 && cd /tmp/codex-lab07
git init

cat > .gitignore << 'EOF'
__pycache__/
*.pyc
EOF

mkdir -p src

cat > src/app.py << 'PYEOF'
"""Ejemplo de aplicación que usará la API de OpenAI."""

def call_openai_api(prompt: str) -> str:
    """TODO: Implementar llamada a la API de OpenAI."""
    raise NotImplementedError("Pendiente de implementar")
PYEOF

git add -A && git commit -m "chore: scaffold lab07"
```

### Paso 2: Configurar MCP con codex mcp add

```bash
# Añadir OpenAI Docs MCP (HTTP, gratuito, sin auth)
codex mcp add openaiDocs \
  --url https://developers.openai.com/mcp

# Verificar que se añadió correctamente
codex mcp list
# Esperado: openaiDocs listado con URL

```

### Paso 3: Añadir instrucciones en AGENTS.md

Para que Codex use el MCP server automáticamente:

```bash
cat > AGENTS.md << 'EOF'
# Project Instructions

Always use the OpenAI developer documentation MCP server
if you need to work with the OpenAI API, Codex, or Apps SDK
without me having to explicitly ask.

When implementing OpenAI API calls, always consult the
documentation first to use the correct and current
parameter names.
EOF

git add AGENTS.md && git commit -m "docs: AGENTS.md con MCP"
```

### Paso 4: Verificar MCP en el TUI

```bash
cd /tmp/codex-lab07
codex --full-auto
```

TEST 1: Verificar servidores activos

```text
/mcp
```

Observar que `openaiDocs` aparece listado con sus
herramientas disponibles.

TEST 2: Preguntar sobre la API de OpenAI

```text
¿Cuáles son los campos requeridos del Responses API
de OpenAI? Consulta la documentación.
```

Observar que Codex invoca las herramientas del MCP server
(debería aparecer algo como `[Tool Use]` o similar en la
salida) y responde con información de la documentación
oficial actualizada, no solo de su conocimiento interno.

TEST 3: Pedir código basado en documentación actual

```text
Implementa src/app.py: usa la API Responses de OpenAI
en Python. Consulta la documentación para usar los
parámetros correctos y actualizados.
```

Observar que Codex consulta el MCP, obtiene el schema
actual de la API y genera código coherente con la
documentación vigente.

### Paso 5: Configuración alternativa vía config.toml

Para aprender el método manual (equivalente a Paso 2):

```bash
mkdir -p .codex

cat > .codex/config.toml << 'EOF'
# MCP de proyecto (requiere trusted project)
[mcp_servers.openaiDocs]
url = "https://developers.openai.com/mcp"
EOF

git add .codex/ && git commit -m "config: MCP en config.toml"
```

> **Nota:** Si el MCP ya está en `~/.codex/config.toml`
> (añadido por `codex mcp add`), no necesitas duplicarlo
> en el proyecto. La config de proyecto es útil cuando
> quieres que todo el equipo comparta el mismo MCP
> (versionado en Git).

### Paso 6: Limpieza (Protocolo Obligatorio)

```bash
# 1. Eliminar MCP de config global
codex mcp remove openaiDocs

# 2. Borrar proyecto
rm -rf /tmp/codex-lab07

# 3. Verificar
ls /tmp/codex-lab07 2>/dev/null \
  && echo "ERROR: aún existe" \
  || echo "OK: limpio"
```

## Laboratorio 7B — Doble MCP: Context7 (STDIO) + OpenAI Docs (HTTP)

> **Duración estimada:** 45 minutos
> **Prerrequisitos:** Codex CLI instalado y autenticado,
> Node.js 18+ (para npx), Git instalado.
> **Referencia:**
> [MCP](https://developers.openai.com/codex/mcp/) |
> [Context7](https://github.com/upstash/context7) |
> [Docs MCP](https://developers.openai.com/resources/docs-mcp/)

---

## Objetivo

Configurar **dos servidores MCP de tipos diferentes** (STDIO
y HTTP), restringir herramientas con `enabled_tools` /
`disabled_tools`, escribir instrucciones en AGENTS.md y
verificar que Codex usa ambos correctamente para generar
código con documentación actualizada.

| Servidor | Transporte | Auth | Propósito |
| --- | --- | --- | --- |
| Context7 | STDIO (local) | No | Docs de librerías (FastAPI, React, etc.) |
| OpenAI Docs | HTTP (remoto) | No | Docs de la API de OpenAI |

---

## Paso 1: Crear proyecto base (3 min)

```bash
mkdir /tmp/codex-lab07b && cd /tmp/codex-lab07b
git init

# Entorno virtual Python
python3 -m venv .venv
source .venv/bin/activate
pip install pytest flake8

cat > .gitignore << 'EOF'
.venv/
__pycache__/
*.pyc
node_modules/
EOF

# Código base: API que usa FastAPI + OpenAI
mkdir -p src tests

cat > src/main.py << 'PYEOF'
"""
API REST que usa FastAPI y la API de OpenAI.
TODO: Los endpoints están vacíos, Codex los implementará
consultando la documentación actualizada via MCP.
"""

def create_app():
    """TODO: Crear app FastAPI con endpoint /chat."""
    raise NotImplementedError

def call_openai(prompt: str) -> str:
    """TODO: Llamar a la API Responses de OpenAI."""
    raise NotImplementedError
PYEOF

cat > tests/test_main.py << 'PYEOF'
"""Tests básicos para verificar que la implementación existe."""

def test_create_app_exists():
    from src.main import create_app
    assert callable(create_app)

def test_call_openai_exists():
    from src.main import call_openai
    assert callable(call_openai)
PYEOF

PYTHONPATH=. pytest tests/ -v
git add -A && git commit -m "chore: scaffold lab07b"
```

---

## Paso 2: Añadir servidores MCP vía CLI (5 min)

Configurar ambos servidores con `codex mcp add`:

```bash
# 1. Context7 — STDIO (subproceso local, npx lo descarga)
codex mcp add context7 -- npx -y @upstash/context7-mcp

# 2. OpenAI Docs — HTTP (servidor remoto)
codex mcp add openaiDocs \
  --url https://developers.openai.com/mcp

# Verificar que ambos están configurados
codex mcp list
# Esperado:
#   context7     (stdio)  npx -y @upstash/context7-mcp
#   openaiDocs   (http)   https://developers.openai.com/mcp

# Ver detalle de cada uno
codex mcp show context7
codex mcp show openaiDocs
```

> **¿Qué acaba de pasar?** `codex mcp add` ha escrito
> entradas en `~/.codex/config.toml`. Puedes verificarlo:
>
> ```bash
> cat ~/.codex/config.toml | grep -A3 "mcp_servers"
> ```

---

## Paso 3: Configurar MCP a nivel de proyecto (5 min)

En vez de depender de la config global, vamos a definir
los servidores MCP **en el proyecto** (versionable con Git)
y aplicar restricciones de herramientas:

```bash
mkdir -p .codex

cat > .codex/config.toml << 'EOF'
# Sandbox y aprobaciones para el lab
approval_policy = "on-request"
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = false

# MCP Server 1: Context7 (STDIO)
# Documentación actualizada de librerías open-source
[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]
startup_timeout_sec = 30

# MCP Server 2: OpenAI Docs (HTTP)
# Documentación oficial de la API de OpenAI
[mcp_servers.openaiDocs]
url = "https://developers.openai.com/mcp"
EOF

git add .codex/ && git commit -m "config: doble MCP + sandbox"
```

**Conceptos aplicados:**

- `startup_timeout_sec = 30` para Context7 (npx puede tardar
  en descargar el paquete la primera vez).
- Ambos servidores definidos a nivel de proyecto: todo el
  equipo los hereda al clonar el repo (si el proyecto está
  trusted).
- `network_access = false` en el sandbox: Codex no puede
  hacer requests de red *desde comandos shell*, pero los
  servidores MCP HTTP sí funcionan (son conexiones del
  cliente MCP, no del sandbox).

---

## Paso 4: Escribir AGENTS.md con instrucciones MCP (3 min)

Para que Codex use los servidores MCP automáticamente:

```bash
cat > AGENTS.md << 'EOF'
# Project Instructions

## MCP Servers Available
- **context7**: Use this MCP server to look up current
  documentation for ANY open-source library (FastAPI,
  React, Django, etc.) before writing code that uses
  that library. Always prefer MCP docs over internal
  knowledge for API signatures and parameters.
- **openaiDocs**: Use this MCP server for ANY question
  about the OpenAI API, Codex, or Apps SDK. Always
  consult this before writing OpenAI API calls.

## Rules
- When implementing code that uses an external library,
  ALWAYS consult the appropriate MCP server first.
- Use the latest API patterns from the documentation.
- Include error handling in all implementations.
EOF

git add AGENTS.md && git commit -m "docs: AGENTS.md con MCP"
```

---

## Paso 5: Probar en el TUI (15 min)

```bash
cd /tmp/codex-lab07b
source .venv/bin/activate
codex --full-auto
```

### TEST 1: Verificar servidores activos

Escribir en el TUI:

```text
/mcp
```

**Esperado:** Ambos servidores (`context7` y `openaiDocs`)
aparecen listados con sus herramientas disponibles.

### TEST 2: Usar Context7 (STDIO) para FastAPI

Escribir en el TUI:

```text
Implementa create_app() en @src/main.py:
- Crea una app FastAPI con un endpoint POST /chat
  que reciba {"prompt": "texto"} y devuelva
  {"response": "texto"}.
- Consulta la documentación de FastAPI para usar la
  sintaxis correcta y actualizada.
```

**Observar:**

1. Codex invoca herramientas de `context7` para buscar
   documentación de FastAPI.
2. El código generado usa la sintaxis actual de FastAPI
   (no versiones obsoletas).
3. Codex debería crear el endpoint con Pydantic models
   según la documentación.

### TEST 3: Usar OpenAI Docs (HTTP) para la API de OpenAI

Escribir en el TUI:

```text
Implementa call_openai() en @src/main.py:
- Usa la API Responses de OpenAI.
- Consulta la documentación para usar los parámetros
  correctos y actualizados.
- Incluye error handling.
```

**Observar:**

1. Codex invoca herramientas de `openaiDocs` para
   consultar la documentación de la API Responses.
2. El código usa los parámetros actuales (no endpoints
   deprecated).

### TEST 4: Verificar que ambos MCP se usaron

Escribir en el TUI:

```text
Conecta create_app() con call_openai(): el endpoint
POST /chat debe llamar a call_openai() con el prompt
recibido y devolver la respuesta. Añade un test en
tests/test_main.py que verifique que el endpoint
existe y responde (puedes mockear call_openai).
```

**Observar:** Codex integra ambas implementaciones y
ejecuta los tests como validación.

---

## Paso 6: Experimentar con enabled_tools (5 min)

Para demostrar la restricción de herramientas, modifica
la config del proyecto:

```bash
cat >> .codex/config.toml << 'EOF'

# Ejemplo: deshabilitar una herramienta específica
# (descomenta para probar)
# [mcp_servers.context7]
# disabled_tools = ["searchDocumentation"]

# Ejemplo: deshabilitar un servidor sin borrarlo
# [mcp_servers.context7]
# enabled = false
EOF

git add .codex/ && git commit -m "config: ejemplo restricciones"
```

**Ejercicio para el alumno:** Descomentar `enabled = false`
para context7, reiniciar Codex, y verificar con `/mcp` que
solo aparece `openaiDocs`. Esto demuestra cómo activar/
desactivar servidores MCP sin borrar la configuración.

> **Nota:** Para conocer los nombres exactos de las tools
> de un servidor, usar `/mcp` en el TUI o
> `codex mcp show context7 --json`.

---

## Paso 7: Deshabilitar vía CLI (alternativa)

También se puede deshabilitar un servidor sin editar TOML:

```bash
# Deshabilitar context7 temporalmente para esta sesión
codex --config mcp_servers.context7.enabled=false

# O para una sesión específica:
codex --config mcp_servers.context7.enabled=false \
      --full-auto
```

---

## Resultado esperado

| Verificación | Resultado |
| --- | --- |
| `/mcp` muestra 2 servidores | context7 (STDIO) + openaiDocs (HTTP) |
| Context7 consultado para FastAPI | Código usa sintaxis actual |
| OpenAI Docs consultado para API | Parámetros actualizados |
| `enabled = false` oculta servidor | `/mcp` solo muestra el otro |
| Tests pasan | `PYTHONPATH=. pytest tests/ -v` |

---

## Paso 8: Limpieza (Protocolo Obligatorio)

```bash
# 1. Desactivar venv
deactivate

# 2. Eliminar MCP servers de config global
#    (solo si los añadiste con codex mcp add en Paso 2)
codex mcp remove context7
codex mcp remove openaiDocs

# 3. Borrar proyecto
rm -rf /tmp/codex-lab07b

# 4. Verificar
ls /tmp/codex-lab07b 2>/dev/null \
  && echo "ERROR: aún existe" \
  || echo "OK: limpio"

# 5. Verificar que config global quedó limpia
codex mcp list
# Esperado: sin context7 ni openaiDocs
```

> **Nota sobre la limpieza:** El Paso 2 añadió servidores
> a `~/.codex/config.toml` (global). El Paso 3 los
> redefinió en `.codex/config.toml` (proyecto). Al borrar
> el proyecto se elimina la config de proyecto, pero la
> global persiste. Por eso el `codex mcp remove` es
> necesario.
