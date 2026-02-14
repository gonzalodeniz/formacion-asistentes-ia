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

codex mcp show openaiDocs
# Muestra configuración completa del servidor
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
