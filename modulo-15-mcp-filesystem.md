# MÓDULO AVANZADO — MCP con Filesystem

## Codex + Filesystem MCP Server

Exploración · Lectura/Escritura · Búsqueda · Edición · Auditoría de Proyectos

*Plan de Formación — OpenAI Codex para Desarrolladores*
Nivel: Avanzado · Duración estimada: 2–3 horas (teoría + 3 laboratorios)
Versión 1.0 — Febrero 2026

---

## Índice

1. Introducción
2. Objetivos de aprendizaje
3. Contenidos teóricos
4. Buenas prácticas
5. Errores comunes
6. Casos de uso reales en desarrollo
7. Laboratorios prácticos
8. Resumen y conceptos clave
9. Material de entrega para adopción corporativa
10. Referencias oficiales

---

## 1. Introducción

Codex opera dentro de un sandbox controlado. Por defecto, su acceso al sistema de archivos se limita al directorio de trabajo del proyecto. Mediante el Filesystem MCP Server (`@modelcontextprotocol/server-filesystem`), Codex puede acceder de forma controlada a directorios externos al workspace: documentación compartida, repositorios de referencia, datasets, ficheros de configuración de otros servicios, o árboles de código de proyectos adyacentes.

El servidor expone 13 herramientas MCP que cubren todo el ciclo de operaciones con ficheros: lectura, escritura, búsqueda, edición quirúrgica, y gestión de directorios. Cada herramienta lleva anotaciones MCP (`readOnlyHint`, `idempotentHint`, `destructiveHint`) que permiten a Codex entender el nivel de riesgo de cada operación.

Este módulo enseña a configurar el Filesystem MCP Server con Codex, aplicar el principio de mínimo acceso (directorios permitidos explícitos), y ejecutar tareas reales de exploración, refactorización y auditoría de proyectos.

---

## 2. Objetivos de aprendizaje

| # | Objetivo | Evidencia de logro |
| --- | --- | --- |
| O1 | Explicar el Filesystem MCP Server (tools, access control, anotaciones) y su valor respecto al acceso nativo de Codex al workspace. | Diagrama correcto del flujo Codex → MCP → filesystem externo. |
| O2 | Configurar el servidor MCP de filesystem conectado a Codex CLI de forma reproducible, con directorios permitidos explícitos. | `codex mcp list` muestra el servidor activo. |
| O3 | Usar las 13 tools del servidor para explorar, leer, buscar, escribir y editar ficheros en directorios permitidos. | Operaciones verificadas en los 3 laboratorios. |
| O4 | Aplicar seguridad operativa: mínimo acceso, directorios restringidos, `disabled_tools` para forzar read-only, MCP allowlist. | Configuración segura verificable en config.toml. |

---

## 3. Contenidos teóricos

### 3.1 ¿Qué es el Filesystem MCP Server?

Es un servidor MCP oficial del proyecto Model Context Protocol, implementado en Node.js, que expone operaciones del sistema de archivos como MCP tools. El servidor **solo permite operaciones dentro de los directorios especificados como argumentos** al arrancar, proporcionando un sandbox a nivel de filesystem.

```toml
# .codex/config.toml
[mcp_servers.filesystem_lab]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem",
        "/tmp/codex-lab-fs/workspace",
        "/tmp/codex-lab-fs/docs"]
startup_timeout_sec = 15.0
```

En este ejemplo, Codex solo puede acceder a `/tmp/codex-lab-fs/workspace` y `/tmp/codex-lab-fs/docs`. Cualquier intento de acceder a `/etc`, `/home`, o cualquier otro directorio será rechazado por el servidor.

### 3.2 Cuándo usar Filesystem MCP vs acceso nativo de Codex

Codex ya puede leer y escribir ficheros en su workspace. ¿Por qué añadir un servidor MCP de filesystem?

| Escenario | Acceso nativo Codex | Filesystem MCP |
| --- | --- | --- |
| Ficheros dentro del workspace actual | ✅ Sí, directo | Innecesario |
| Documentación compartida en otro directorio | ❌ No accesible | ✅ Configurable |
| Repositorio de referencia adyacente | ❌ No accesible | ✅ Read-only posible |
| Datasets o logs en ruta externa | ❌ No accesible | ✅ Configurable |
| Auditoría multi-proyecto | ❌ Un proyecto a la vez | ✅ Múltiples directorios |
| Acceso controlado por equipo/admin | Sandbox por diseño | ✅ Allowlist + `disabled_tools` |

El valor principal es el **acceso controlado a directorios externos al workspace**, con granularidad de tools (read-only vs read/write) y trazabilidad (cada operación es una invocación MCP visible en los logs).

### 3.3 Las 13 tools del Filesystem MCP Server

#### Tools de lectura (read-only)

| Tool | Descripción | Parámetros |
| --- | --- | --- |
| `read_text_file` | Lee contenido completo de un fichero de texto (UTF-8). | `path` (string) |
| `read_media_file` | Lee un fichero binario/media y devuelve contenido base64. | `path` (string) |
| `read_multiple_files` | Lee múltiples ficheros simultáneamente. Si uno falla, los demás continúan. | `paths` (string[]) |
| `list_directory` | Lista contenido de un directorio (nombres y tipos). | `path` (string) |
| `list_directory_with_sizes` | Lista contenido con tamaños de ficheros. | `path` (string) |
| `directory_tree` | Árbol recursivo de directorio en JSON (nombre, tipo, hijos). | `path` (string) |
| `search_files` | Busca ficheros/directorios recursivamente por patrón (case-insensitive). | `path` (string), `pattern` (string) |
| `get_file_info` | Metadatos detallados: tamaño, fechas, tipo, permisos. | `path` (string) |
| `list_allowed_directories` | Lista los directorios permitidos configurados. | (ninguno) |

#### Tools de escritura

| Tool | readOnly | idempotent | destructive | Descripción |
| --- | --- | --- | --- | --- |
| `create_directory` | false | true | false | Crea directorio (recursivo). Repetir es no-op. |
| `write_file` | false | true | true | Crea fichero nuevo o **sobreescribe** existente. |
| `edit_file` | false | false | true | Edición quirúrgica: busca y reemplaza texto dentro de un fichero. |
| `move_file` | false | false | false | Mueve o renombra. Falla si el destino ya existe. |

> **💡 Anotaciones MCP:** Cada tool lleva `readOnlyHint`, `idempotentHint` y `destructiveHint`. Codex usa estas anotaciones para entender el riesgo de cada operación y solicitar approval cuando corresponde según la `approval_policy` configurada.

### 3.4 Control de acceso: directorios permitidos

El servidor implementa un **sandbox estricto**: solo los directorios pasados como argumentos están permitidos. Todo path fuera de esos directorios es rechazado.

```bash
# Arrancar con dos directorios permitidos
npx -y @modelcontextprotocol/server-filesystem \
  /tmp/codex-lab-fs/workspace \
  /tmp/codex-lab-fs/docs

# Intento de acceder a /etc/passwd → ERROR: acceso denegado
```

El flujo de control de acceso es:

1. El servidor arranca con la lista de directorios permitidos.
2. Cada invocación de tool recibe un `path` como parámetro.
3. El servidor resuelve el path absoluto y verifica que esté dentro de un directorio permitido.
4. Si no está permitido, la operación falla con error descriptivo.

> **⚠️ Importante:** El servidor también soporta el protocolo Roots de MCP, que permite a clientes actualizar dinámicamente los directorios permitidos. En Codex CLI, se usan los argumentos de la línea de comandos (método 1).

### 3.5 Seguridad y guardrails

#### 3.5.1 Principio de mínimo acceso

Solo incluir los directorios estrictamente necesarios para la tarea. Nunca `/`, `/home`, ni directorios raíz amplios.

```toml
# ❌ MAL: demasiado amplio
args = ["-y", "@modelcontextprotocol/server-filesystem", "/home/gonzalo"]

# ✅ BIEN: solo lo necesario
args = ["-y", "@modelcontextprotocol/server-filesystem",
        "/home/gonzalo/projects/app-web/docs",
        "/home/gonzalo/projects/app-web/config"]
```

#### 3.5.2 Forzar read-only con disabled_tools

Para auditoría o exploración donde no se debe modificar nada:

```toml
[mcp_servers.filesystem_readonly]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem",
        "/opt/shared-docs", "/opt/reference-code"]
disabled_tools = ["write_file", "edit_file", "move_file", "create_directory"]
```

Esto deja solo las 9 tools de lectura activas. Codex no puede modificar nada.

#### 3.5.3 MCP allowlist en requirements.toml (Enterprise)

```toml
# requirements.toml (admin-enforced)
[[mcp_servers]]
id = "filesystem_lab"
identity = { command = "npx" }
```

#### 3.5.4 Sandbox de Codex + MCP

El Filesystem MCP Server se ejecuta como un proceso hijo local (STDIO). No necesita acceso a red para el protocolo MCP. La conexión es stdin/stdout entre Codex y el proceso npx. Mantener `approval_policy = on-request` para que Codex pida confirmación antes de operaciones de escritura.

---

## 4. Buenas prácticas

### 4.1 Exploración-first

Antes de cualquier operación de escritura, pedir a Codex que explore el directorio con `list_directory`, `directory_tree` y `get_file_info`. Esto ancla el contexto y evita suposiciones sobre la estructura.

### 4.2 Directorios mínimos y explícitos

Cada servidor MCP de filesystem debe tener la lista mínima de directorios necesarios. Si una tarea solo requiere leer documentación, no incluir el directorio de código fuente.

### 4.3 Read-only por defecto en auditoría

Para tareas de análisis, revisión o documentación de código ajeno, usar `disabled_tools` para desactivar todas las tools de escritura. Activar escritura solo cuando la tarea lo requiera explícitamente.

### 4.4 Un servidor por contexto de seguridad

No mezclar directorios con diferente nivel de confianza en el mismo servidor MCP. Si necesitas acceso read-only a documentación y read/write al workspace de lab, usar dos servidores MCP separados:

```toml
[mcp_servers.docs_readonly]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem", "/opt/docs"]
disabled_tools = ["write_file", "edit_file", "move_file", "create_directory"]

[mcp_servers.lab_workspace]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem", "/tmp/lab"]
```

### 4.5 Pin de versión

```toml
# Pinear versión exacta para reproducibilidad
args = ["-y", "@modelcontextprotocol/server-filesystem@2026.1.14", "/tmp/lab"]
```

---

## 5. Errores comunes

### 5.1 Directorios demasiado amplios

**Problema:** Pasar `/home` o `/` como directorio permitido "para que Codex pueda acceder a todo".
**Solución:** Solo directorios específicos de la tarea. Revisar con `list_allowed_directories`.

### 5.2 No desactivar escritura en auditoría

**Problema:** Usar el servidor con todas las tools activas cuando solo se necesita leer.
**Solución:** `disabled_tools` con las 4 tools de escritura.

### 5.3 Confundir con acceso nativo de Codex

**Problema:** Configurar Filesystem MCP para el mismo directorio donde Codex ya trabaja.
**Solución:** El MCP de filesystem es para directorios **externos** al workspace. Para el workspace actual, Codex ya tiene acceso directo.

### 5.4 Timeout en primera ejecución

**Problema:** `npx -y` descarga el paquete la primera vez y el handshake falla por timeout.
**Solución:** Pre-descargar con `npx -y @modelcontextprotocol/server-filesystem --help` o subir `startup_timeout_sec` a 30.

### 5.5 Paths relativos en config.toml

**Problema:** Usar paths relativos que dependen del directorio desde donde se lance Codex.
**Solución:** Siempre paths absolutos en los argumentos del servidor MCP.

---

## 6. Casos de uso reales en desarrollo

### 6.1 Auditoría de estructura de proyecto legacy

Un proyecto legacy tiene estructura desconocida. Codex usa `directory_tree` para mapear la estructura completa, `search_files` para encontrar ficheros de configuración, y `read_text_file` para leer los que parecen relevantes. Genera un informe `docs/audit-structure.md` con hallazgos.

### 6.2 Refactorización cross-project

Un monorepo tiene múltiples servicios que comparten una librería interna. Codex accede a la librería compartida (read-only) y al servicio a refactorizar (read/write) como dos directorios separados. Usa `search_files` en la librería para entender la API y `edit_file` en el servicio para actualizar imports.

### 6.3 Documentación automática desde código

Codex lee el código fuente de un proyecto (Filesystem MCP, read-only), analiza la estructura con `directory_tree`, lee ficheros clave con `read_multiple_files`, y genera documentación Markdown en un directorio de salida (Filesystem MCP, read/write).

### 6.4 Migración de configuración entre entornos

Codex lee ficheros de configuración de un entorno (staging) y genera versiones adaptadas para otro entorno (production), comparando diferencias y generando un informe de cambios.

---

## 7. Laboratorios prácticos

> **📦 Prerequisitos comunes:** Node.js (para npx), Codex CLI instalado con soporte MCP. No se requiere Docker ni servicios externos.

---

### 7.1 Lab L-FS-1 — Exploración y auditoría de un proyecto desconocido

> **🎯 Objetivo:** Configurar Filesystem MCP Server en modo read-only, explorar un proyecto simulado con estructura compleja, y generar un informe de auditoría.

#### Paso 1: Setup del proyecto de laboratorio

```bash
mkdir -p /tmp/codex-lab-fs/{workspace,target-project}
cd /tmp/codex-lab-fs/workspace
git init
mkdir -p docs
```

#### Paso 2: Crear proyecto simulado a auditar

```bash
# Simular un proyecto legacy con estructura desordenada
cd /tmp/codex-lab-fs/target-project

mkdir -p src/{api,utils,models,services} \
         config/{dev,staging,prod} \
         tests/{unit,integration} \
         scripts \
         docs \
         legacy/{old-api,deprecated}

# Ficheros de configuración
cat > config/dev/app.json << 'EOF'
{
  "database": { "host": "localhost", "port": 5432, "name": "devdb" },
  "cache": { "enabled": false },
  "logging": { "level": "debug" },
  "api": { "port": 3000, "cors": "*" }
}
EOF

cat > config/staging/app.json << 'EOF'
{
  "database": { "host": "staging-db.internal", "port": 5432, "name": "stagingdb" },
  "cache": { "enabled": true, "ttl": 300 },
  "logging": { "level": "info" },
  "api": { "port": 3000, "cors": "https://staging.example.com" }
}
EOF

cat > config/prod/app.json << 'EOF'
{
  "database": { "host": "prod-db.internal", "port": 5432, "name": "proddb" },
  "cache": { "enabled": true, "ttl": 3600 },
  "logging": { "level": "warn" },
  "api": { "port": 8080, "cors": "https://app.example.com" }
}
EOF

# Código fuente simulado
cat > src/api/routes.py << 'EOF'
from flask import Flask, jsonify
from src.services.user_service import get_users, create_user
from src.services.product_service import get_products

app = Flask(__name__)

@app.route('/api/users', methods=['GET'])
def list_users():
    return jsonify(get_users())

@app.route('/api/users', methods=['POST'])
def add_user():
    return jsonify(create_user()), 201

@app.route('/api/products', methods=['GET'])
def list_products():
    return jsonify(get_products())

# TODO: endpoint de pedidos pendiente
# TODO: autenticación no implementada
EOF

cat > src/services/user_service.py << 'EOF'
from src.models.user import User
from src.utils.db import get_connection

def get_users():
    conn = get_connection()
    # WARNING: SQL sin parametrizar
    return conn.execute("SELECT * FROM users").fetchall()

def create_user():
    # TODO: validación pendiente
    pass
EOF

cat > src/services/product_service.py << 'EOF'
from src.models.product import Product
from src.utils.db import get_connection

def get_products():
    conn = get_connection()
    return conn.execute("SELECT * FROM products WHERE active = 1").fetchall()
EOF

cat > src/utils/db.py << 'EOF'
import sqlite3
# HARDCODED: connection string
DATABASE_PATH = "/var/data/app.db"

def get_connection():
    return sqlite3.connect(DATABASE_PATH)
EOF

cat > src/utils/helpers.py << 'EOF'
import hashlib

def hash_password(password):
    # INSECURE: MD5 para passwords
    return hashlib.md5(password.encode()).hexdigest()

def format_date(d):
    return d.strftime("%Y-%m-%d")
EOF

cat > src/models/user.py << 'EOF'
class User:
    def __init__(self, id, name, email, password_hash):
        self.id = id
        self.name = name
        self.email = email
        self.password_hash = password_hash
EOF

cat > src/models/product.py << 'EOF'
class Product:
    def __init__(self, id, name, price, active=True):
        self.id = id
        self.name = name
        self.price = price
        self.active = active
EOF

# Código legacy (deprecated)
cat > legacy/old-api/server.py << 'EOF'
# DEPRECATED: migrar a src/api/routes.py
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(json.dumps({"status": "old"}).encode())

HTTPServer(('', 9090), Handler).serve_forever()
EOF

cat > legacy/deprecated/config_loader.py << 'EOF'
# DEPRECATED: usar src/utils/config.py (no existe aún)
import os
def load_config():
    return {"db": os.environ.get("DB_URL", "sqlite:///default.db")}
EOF

# Tests incompletos
cat > tests/unit/test_users.py << 'EOF'
import pytest

def test_get_users():
    # TODO: implementar
    pass

def test_create_user():
    # TODO: implementar
    pass
EOF

cat > tests/integration/test_api.py << 'EOF'
import pytest

def test_list_users_endpoint():
    # TODO: implementar
    pass
EOF

# Scripts de utilidad
cat > scripts/deploy.sh << 'EOF'
#!/bin/bash
# FIXME: sin manejo de errores
echo "Deploying to $1..."
scp -r src/ deploy@$1:/app/
ssh deploy@$1 "systemctl restart app"
EOF

cat > scripts/migrate.sh << 'EOF'
#!/bin/bash
# TODO: migraciones reales
echo "Running migrations..."
sqlite3 /var/data/app.db < migrations/001.sql
EOF

# Ficheros raíz
cat > requirements.txt << 'EOF'
flask==2.3.2
gunicorn==21.2.0
sqlite3
EOF

cat > README.md << 'EOF'
# Legacy App

Flask application. See docs/ for more info.

## Quick Start
1. pip install -r requirements.txt
2. python -m src.api.routes

## Known Issues
- No auth
- SQL injection in user queries
- Hardcoded DB path
- MD5 password hashing
EOF

echo "Proyecto simulado creado en /tmp/codex-lab-fs/target-project"
```

#### Paso 3: Configurar Filesystem MCP en Codex (read-only)

```toml
# /tmp/codex-lab-fs/workspace/.codex/config.toml
[mcp_servers.filesystem_audit]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem",
        "/tmp/codex-lab-fs/target-project"]
startup_timeout_sec = 15.0
disabled_tools = ["write_file", "edit_file", "move_file", "create_directory"]
```

```bash
cd /tmp/codex-lab-fs/workspace
codex mcp list  # Verificar filesystem_audit activo
```

#### Paso 4: Explorar y auditar con Codex

```text
# Turno 1: Exploración inicial
Usa las tools MCP de filesystem_audit para:
1. list_allowed_directories — confirma directorios accesibles
2. directory_tree en /tmp/codex-lab-fs/target-project — mapa completo
3. Genera docs/audit-structure.md con el árbol y observaciones
   sobre la organización (directorios legacy, tests incompletos, etc.)

# Turno 2: Búsqueda de problemas
Busca en el proyecto:
1. search_files para encontrar ficheros .py con "TODO" o "FIXME"
2. search_files para ficheros de configuración (.json, .sh)
3. Lee los ficheros encontrados con read_multiple_files
4. Genera docs/audit-findings.md con hallazgos:
   - Vulnerabilidades de seguridad (SQL injection, MD5, hardcoded paths)
   - Código deprecated pendiente de migración
   - Tests no implementados
   - Problemas de deployment (deploy.sh sin error handling)
   Clasifica cada hallazgo como CRITICAL / HIGH / MEDIUM / LOW

# Turno 3: Informe ejecutivo
Lee el README.md del proyecto via filesystem_audit.
Genera docs/audit-executive-summary.md con:
- Estado general del proyecto
- Top 5 riesgos priorizados
- Recomendaciones concretas de acción
- Estimación de esfuerzo (T-shirt sizing: S/M/L/XL)
```

#### Verificación L-FS-1

| Verificación | Resultado esperado |
| --- | --- |
| `codex mcp list` | filesystem_audit activo, disabled_tools aplicados |
| `docs/audit-structure.md` | Árbol completo, observaciones sobre estructura |
| `docs/audit-findings.md` | Hallazgos clasificados CRITICAL/HIGH/MEDIUM/LOW |
| `docs/audit-executive-summary.md` | Resumen ejecutivo con top 5 riesgos + acciones |
| Tools de escritura bloqueadas | Codex no pudo modificar ningún fichero del proyecto auditado |

#### Limpieza L-FS-1

```bash
cd /tmp && rm -rf codex-lab-fs
# Si se añadió MCP global: editar ~/.codex/config.toml
# y borrar [mcp_servers.filesystem_audit]
```

---

### 7.2 Lab L-FS-2 — Búsqueda y refactorización multi-directorio

> **🎯 Objetivo:** Configurar dos directorios (librería compartida read-only + servicio read/write), buscar patrones en la librería y refactorizar imports en el servicio.

#### Paso 1: Setup de los proyectos

```bash
mkdir -p /tmp/codex-lab-fs/{workspace,shared-lib,my-service}
cd /tmp/codex-lab-fs/workspace
git init
mkdir -p docs
```

#### Paso 2: Crear librería compartida y servicio

```bash
# Librería compartida (será read-only)
cd /tmp/codex-lab-fs/shared-lib
mkdir -p src/{auth,validation,logging}

cat > src/auth/__init__.py << 'EOF'
from .jwt_handler import create_token, verify_token
from .permissions import check_permission, require_role
EOF

cat > src/auth/jwt_handler.py << 'EOF'
import jwt
import datetime

SECRET_KEY = "change-me-in-production"

def create_token(user_id: int, roles: list[str]) -> str:
    payload = {
        "user_id": user_id,
        "roles": roles,
        "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm="HS256")

def verify_token(token: str) -> dict:
    return jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
EOF

cat > src/auth/permissions.py << 'EOF'
from functools import wraps

def check_permission(user_roles: list[str], required_role: str) -> bool:
    return required_role in user_roles

def require_role(role: str):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            # Framework-agnostic role check
            return func(*args, **kwargs)
        return wrapper
    return decorator
EOF

cat > src/validation/__init__.py << 'EOF'
from .validators import validate_email, validate_password, validate_phone
from .sanitizers import sanitize_html, sanitize_sql_param
EOF

cat > src/validation/validators.py << 'EOF'
import re

def validate_email(email: str) -> bool:
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))

def validate_password(password: str) -> tuple[bool, str]:
    if len(password) < 8:
        return False, "Password must be at least 8 characters"
    if not re.search(r'[A-Z]', password):
        return False, "Password must contain uppercase letter"
    if not re.search(r'[0-9]', password):
        return False, "Password must contain a digit"
    return True, "OK"

def validate_phone(phone: str) -> bool:
    pattern = r'^\+?[1-9]\d{1,14}$'
    return bool(re.match(pattern, phone))
EOF

cat > src/validation/sanitizers.py << 'EOF'
import html

def sanitize_html(text: str) -> str:
    return html.escape(text)

def sanitize_sql_param(param: str) -> str:
    # Use parameterized queries instead of this
    return param.replace("'", "''")
EOF

cat > src/logging/__init__.py << 'EOF'
from .logger import get_logger, setup_logging
EOF

cat > src/logging/logger.py << 'EOF'
import logging

def setup_logging(level: str = "INFO"):
    logging.basicConfig(
        level=getattr(logging, level.upper()),
        format='%(asctime)s [%(name)s] %(levelname)s: %(message)s'
    )

def get_logger(name: str) -> logging.Logger:
    return logging.getLogger(name)
EOF

# Servicio que usa la librería (será read/write)
cd /tmp/codex-lab-fs/my-service
mkdir -p src/{routes,services} tests

cat > src/routes/users.py << 'EOF'
from flask import Flask, request, jsonify
# PROBLEMA: imports obsoletos/incorrectos de shared-lib
from shared.auth import verify_jwt, check_role  # WRONG: funciones renombradas
from shared.validate import is_valid_email       # WRONG: módulo renombrado
from shared.log import create_logger             # WRONG: API cambiada

app = Flask(__name__)
log = create_logger("users")  # WRONG: es get_logger

@app.route('/users', methods=['POST'])
def create_user():
    data = request.json
    # Usa la función antigua de validación
    if not is_valid_email(data.get('email', '')):  # WRONG: es validate_email
        return jsonify({"error": "Invalid email"}), 400
    # Sin verificación de token
    # Sin sanitización de input
    log.info(f"Creating user: {data}")
    return jsonify({"status": "created"}), 201

@app.route('/users', methods=['GET'])
def list_users():
    # WRONG: no verifica token
    return jsonify({"users": []})
EOF

cat > src/services/user_service.py << 'EOF'
# PROBLEMA: no usa shared-lib para validación
def create_user(name: str, email: str, password: str) -> dict:
    # TODO: usar validate_email y validate_password de shared-lib
    # TODO: usar sanitize_html para name
    # TODO: usar create_token después de registro
    return {"name": name, "email": email, "status": "created"}
EOF

cat > tests/test_users.py << 'EOF'
import pytest

def test_create_user_valid():
    # TODO: implementar con imports correctos
    pass

def test_create_user_invalid_email():
    # TODO: implementar
    pass
EOF

cat > requirements.txt << 'EOF'
flask==2.3.2
shared-lib @ file:../shared-lib
EOF

echo "Librería y servicio creados"
```

#### Paso 3: Configurar dos servidores MCP con diferentes permisos

```toml
# /tmp/codex-lab-fs/workspace/.codex/config.toml

# Librería compartida: solo lectura
[mcp_servers.shared_lib]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem",
        "/tmp/codex-lab-fs/shared-lib"]
startup_timeout_sec = 15.0
disabled_tools = ["write_file", "edit_file", "move_file", "create_directory"]

# Servicio a refactorizar: lectura y escritura
[mcp_servers.my_service]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem",
        "/tmp/codex-lab-fs/my-service"]
startup_timeout_sec = 15.0
```

```bash
cd /tmp/codex-lab-fs/workspace
codex mcp list  # Verificar ambos servidores activos
```

#### Paso 4: Investigar la librería y refactorizar el servicio

```text
# Turno 1: Mapear la API de shared-lib (read-only)
Usa las tools MCP de shared_lib para:
1. directory_tree de /tmp/codex-lab-fs/shared-lib/src
2. read_multiple_files de todos los __init__.py para mapear exports
3. Genera docs/shared-lib-api.md con la API pública:
   - Módulo auth: funciones, parámetros, retornos
   - Módulo validation: funciones, parámetros, retornos
   - Módulo logging: funciones, parámetros, retornos

# Turno 2: Diagnosticar imports rotos en my-service
Lee @docs/shared-lib-api.md y luego usa my_service para:
1. read_text_file de src/routes/users.py y src/services/user_service.py
2. Identifica todos los imports incorrectos comparando con la API real
3. Genera docs/import-fix-plan.md con:
   - Cada import incorrecto → import correcto
   - Funciones usadas incorrectamente → función real
   - Funcionalidades faltantes (sanitización, auth)

# Turno 3: Aplicar fix de imports
Usando las tools de my_service (read/write):
1. edit_file en src/routes/users.py:
   - Corrige todos los imports según shared-lib real
   - Añade verificación de token en endpoints
   - Añade sanitización de input
2. edit_file en src/services/user_service.py:
   - Añade imports correctos de validation y auth
   - Implementa validaciones
3. Verifica con read_text_file que los ficheros
   corregidos son correctos
```

#### Verificación L-FS-2

| Verificación | Resultado esperado |
| --- | --- |
| `codex mcp list` | shared_lib (read-only) + my_service (read/write) activos |
| `docs/shared-lib-api.md` | API mapeada: auth, validation, logging con funciones y parámetros |
| `docs/import-fix-plan.md` | Tabla import-incorrecto → import-correcto para cada fichero |
| `src/routes/users.py` (my-service) | Imports corregidos, auth + sanitización añadidos |
| `src/services/user_service.py` (my-service) | Validaciones implementadas con shared-lib |
| shared-lib intacta | No se modificó ningún fichero de la librería compartida |

#### Limpieza L-FS-2

```bash
cd /tmp && rm -rf codex-lab-fs
# Si MCP global: limpiar ~/.codex/config.toml
```

---

### 7.3 Lab L-FS-3 — Generación de documentación técnica desde código

> **🎯 Objetivo:** Leer un proyecto existente via Filesystem MCP (read-only), analizar su estructura y código, y generar documentación técnica completa en un directorio de salida separado (read/write).

#### Paso 1: Setup

```bash
mkdir -p /tmp/codex-lab-fs/{workspace,source-project,output-docs}
cd /tmp/codex-lab-fs/workspace
git init
```

#### Paso 2: Crear proyecto fuente a documentar

```bash
cd /tmp/codex-lab-fs/source-project
mkdir -p src/{handlers,middleware,models,config} tests

cat > src/config/settings.py << 'EOF'
import os

class Settings:
    """Application configuration loaded from environment variables."""
    DB_HOST: str = os.getenv("DB_HOST", "localhost")
    DB_PORT: int = int(os.getenv("DB_PORT", "5432"))
    DB_NAME: str = os.getenv("DB_NAME", "appdb")
    DB_USER: str = os.getenv("DB_USER", "app")
    DB_PASSWORD: str = os.getenv("DB_PASSWORD", "")
    REDIS_URL: str = os.getenv("REDIS_URL", "redis://localhost:6379/0")
    JWT_SECRET: str = os.getenv("JWT_SECRET", "change-in-production")
    JWT_EXPIRY_HOURS: int = int(os.getenv("JWT_EXPIRY_HOURS", "24"))
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")
    CORS_ORIGINS: str = os.getenv("CORS_ORIGINS", "*")
    MAX_PAGE_SIZE: int = int(os.getenv("MAX_PAGE_SIZE", "100"))

settings = Settings()
EOF

cat > src/models/user.py << 'EOF'
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional

@dataclass
class User:
    """Represents a user in the system.

    Attributes:
        id: Unique identifier
        email: User email (unique, used for login)
        name: Display name
        role: Authorization role (admin, editor, viewer)
        created_at: Account creation timestamp
        last_login: Last successful login timestamp
    """
    id: int
    email: str
    name: str
    role: str = "viewer"
    created_at: datetime = field(default_factory=datetime.utcnow)
    last_login: Optional[datetime] = None

    def is_admin(self) -> bool:
        return self.role == "admin"

    def can_edit(self) -> bool:
        return self.role in ("admin", "editor")
EOF

cat > src/models/product.py << 'EOF'
from dataclasses import dataclass
from decimal import Decimal

@dataclass
class Product:
    """Catalog product.

    Attributes:
        id: Unique identifier
        name: Product display name
        price: Price in EUR (Decimal for precision)
        category: Product category
        stock: Available inventory count
        active: Whether product is listed
    """
    id: int
    name: str
    price: Decimal
    category: str
    stock: int = 0
    active: bool = True

    def is_available(self) -> bool:
        return self.active and self.stock > 0
EOF

cat > src/handlers/user_handler.py << 'EOF'
from flask import request, jsonify, Blueprint
from src.models.user import User
from src.middleware.auth import require_auth, require_role

user_bp = Blueprint('users', __name__, url_prefix='/api/v1/users')

@user_bp.route('/', methods=['GET'])
@require_auth
def list_users():
    """List all users with pagination.

    Query params:
        page (int): Page number (default 1)
        size (int): Page size (default 20, max 100)
        role (str): Filter by role (optional)

    Returns:
        200: { "users": [...], "total": int, "page": int }
        401: Unauthorized
    """
    page = request.args.get('page', 1, type=int)
    size = min(request.args.get('size', 20, type=int), 100)
    role = request.args.get('role')
    # Implementation...
    return jsonify({"users": [], "total": 0, "page": page})

@user_bp.route('/<int:user_id>', methods=['GET'])
@require_auth
def get_user(user_id: int):
    """Get user by ID.

    Returns:
        200: User object
        404: Not found
        401: Unauthorized
    """
    return jsonify({"user": None})

@user_bp.route('/', methods=['POST'])
@require_auth
@require_role('admin')
def create_user():
    """Create a new user.

    Body (JSON):
        email (str): Required, must be unique
        name (str): Required
        role (str): Optional, default "viewer"

    Returns:
        201: Created user
        400: Validation error
        401: Unauthorized
        403: Forbidden (not admin)
        409: Email already exists
    """
    return jsonify({"user": None}), 201
EOF

cat > src/handlers/product_handler.py << 'EOF'
from flask import request, jsonify, Blueprint
from src.models.product import Product
from src.middleware.auth import require_auth

product_bp = Blueprint('products', __name__, url_prefix='/api/v1/products')

@product_bp.route('/', methods=['GET'])
def list_products():
    """List products with filtering and pagination. No auth required.

    Query params:
        page (int): Page number (default 1)
        size (int): Page size (default 20, max 100)
        category (str): Filter by category (optional)
        active_only (bool): Only active products (default true)

    Returns:
        200: { "products": [...], "total": int, "page": int }
    """
    return jsonify({"products": [], "total": 0})

@product_bp.route('/<int:product_id>', methods=['PUT'])
@require_auth
def update_product(product_id: int):
    """Update product details. Requires auth.

    Body (JSON):
        name (str): Optional
        price (Decimal): Optional
        category (str): Optional
        stock (int): Optional
        active (bool): Optional

    Returns:
        200: Updated product
        404: Not found
        401: Unauthorized
    """
    return jsonify({"product": None})
EOF

cat > src/middleware/auth.py << 'EOF'
from functools import wraps
from flask import request, jsonify
import jwt
from src.config.settings import settings

def require_auth(func):
    """Decorator: validates JWT token in Authorization header."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        token = request.headers.get('Authorization', '').replace('Bearer ', '')
        if not token:
            return jsonify({"error": "Token required"}), 401
        try:
            payload = jwt.decode(token, settings.JWT_SECRET, algorithms=["HS256"])
            request.user = payload
        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Token expired"}), 401
        except jwt.InvalidTokenError:
            return jsonify({"error": "Invalid token"}), 401
        return func(*args, **kwargs)
    return wrapper

def require_role(role: str):
    """Decorator: checks user role after auth."""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            user_role = getattr(request, 'user', {}).get('role', '')
            if user_role != role:
                return jsonify({"error": "Insufficient permissions"}), 403
            return func(*args, **kwargs)
        return wrapper
    return decorator
EOF

cat > tests/test_user_handler.py << 'EOF'
import pytest

class TestListUsers:
    def test_returns_paginated_results(self):
        """GET /api/v1/users/ returns paginated user list"""
        pass

    def test_requires_auth(self):
        """GET /api/v1/users/ without token returns 401"""
        pass

    def test_filters_by_role(self):
        """GET /api/v1/users/?role=admin returns only admins"""
        pass

class TestCreateUser:
    def test_admin_can_create(self):
        """POST /api/v1/users/ as admin creates user"""
        pass

    def test_non_admin_forbidden(self):
        """POST /api/v1/users/ as viewer returns 403"""
        pass
EOF

echo "Proyecto fuente creado"
```

#### Paso 3: Configurar dos servidores MCP

```toml
# /tmp/codex-lab-fs/workspace/.codex/config.toml

# Proyecto fuente: solo lectura
[mcp_servers.source_code]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem",
        "/tmp/codex-lab-fs/source-project"]
startup_timeout_sec = 15.0
disabled_tools = ["write_file", "edit_file", "move_file", "create_directory"]

# Directorio de salida: escritura
[mcp_servers.output_docs]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem",
        "/tmp/codex-lab-fs/output-docs"]
startup_timeout_sec = 15.0
```

```bash
cd /tmp/codex-lab-fs/workspace
codex mcp list  # Verificar ambos servidores activos
```

#### Paso 4: Generar documentación técnica

```text
# Turno 1: Análisis de estructura
Usa source_code (read-only) para:
1. directory_tree completo del proyecto
2. read_multiple_files de todos los __init__.py, settings.py,
   y el middleware auth.py
3. Genera vía output_docs (write_file) el fichero
   /tmp/codex-lab-fs/output-docs/architecture.md con:
   - Diagrama de capas (handlers → middleware → models → config)
   - Dependencias entre módulos
   - Tecnologías identificadas (Flask, JWT, etc.)

# Turno 2: Documentación de API
Lee todos los handlers (user_handler.py, product_handler.py)
via source_code con read_multiple_files.
Genera vía output_docs (write_file):
/tmp/codex-lab-fs/output-docs/api-reference.md con:
- Cada endpoint: método, ruta, parámetros, body, respuestas
- Requisitos de autenticación por endpoint
- Códigos de error documentados
Formato tabla Markdown por endpoint.

# Turno 3: Documentación de modelos y configuración
Lee models/ y config/ via source_code.
Genera vía output_docs (write_file):
1. /tmp/codex-lab-fs/output-docs/data-models.md
   - Cada modelo: campos, tipos, valores por defecto, métodos
2. /tmp/codex-lab-fs/output-docs/configuration.md
   - Cada variable de entorno: nombre, tipo, default, descripción
   - Tabla de configuración por entorno (dev/staging/prod si aplica)
3. /tmp/codex-lab-fs/output-docs/README.md
   - Índice con links a los 4 documentos generados
   - Quick start
   - Requisitos
```

#### Verificación L-FS-3

| Verificación | Resultado esperado |
| --- | --- |
| `codex mcp list` | source_code (read-only) + output_docs (read/write) activos |
| `output-docs/architecture.md` | Diagrama de capas, dependencias, tecnologías |
| `output-docs/api-reference.md` | Todos los endpoints con params, body, respuestas, auth |
| `output-docs/data-models.md` | Modelos User y Product con campos, tipos, métodos |
| `output-docs/configuration.md` | Variables de entorno con tipos y defaults |
| `output-docs/README.md` | Índice con links + quick start |
| Proyecto fuente intacto | No se modificó ningún fichero de source-project |

#### Limpieza final (obligatoria — todos los labs)

> **⚠️ Limpieza completa:** Ejecutar después de cada laboratorio o al finalizar los tres.

```bash
cd /tmp && rm -rf codex-lab-fs
# Si se añadió MCP global: editar ~/.codex/config.toml
# y borrar las entradas [mcp_servers.filesystem_*]

ls /tmp/codex-lab-fs 2>/dev/null \
  && echo 'ERROR: aún existe' \
  || echo 'OK: limpio'
```

---

## 8. Resumen y conceptos clave

| Concepto | Detalle |
| --- | --- |
| Filesystem MCP Server | `@modelcontextprotocol/server-filesystem`: acceso controlado al filesystem via MCP. |
| Directorios permitidos | Se pasan como argumentos al arrancar. Todo path fuera es rechazado. |
| 9 tools read-only | `read_text_file`, `read_media_file`, `read_multiple_files`, `list_directory`, `list_directory_with_sizes`, `directory_tree`, `search_files`, `get_file_info`, `list_allowed_directories`. |
| 4 tools de escritura | `create_directory`, `write_file`, `edit_file`, `move_file`. |
| Tool annotations MCP | `readOnlyHint`, `idempotentHint`, `destructiveHint` — Codex entiende el riesgo. |
| `disabled_tools` | Forzar read-only desactivando las 4 tools de escritura. |
| Múltiples servidores MCP | Separar contextos de seguridad: read-only para referencia, read/write para trabajo. |
| Mínimo acceso | Solo los directorios estrictamente necesarios para la tarea. |
| Paths absolutos | Siempre rutas absolutas en config.toml, nunca relativas. |
| STDIO transport | Proceso local, stdin/stdout, no requiere red para protocolo MCP. |
| `startup_timeout_sec` | Subir a 15–30 si `npx` necesita descargar el paquete. |
| Pin de versión | `@package@version` para reproducibilidad y supply chain safety. |
| `requirements.toml` | Allowlist enterprise para controlar qué servidores MCP están permitidos. |

> **🎓 Módulo completado:** Con el Filesystem MCP Server, Codex accede de forma controlada a directorios externos al workspace: auditoría de proyectos, refactorización cross-project, y generación de documentación, todo con seguridad por defecto y granularidad de permisos.

---

## 9. Material de entrega para adopción corporativa

- Checklist de seguridad Filesystem MCP: directorios mínimos explícitos, `disabled_tools` para auditoría, allowlist en `requirements.toml`, paths absolutos, pin de versiones.
- Plantilla "Auditoría de proyecto": exploración-first con `directory_tree` + `search_files`, hallazgos clasificados, informe ejecutivo.
- Patrón multi-servidor: read-only para referencia + read/write para trabajo, separados por contexto de seguridad.
- Config base: `.codex/config.toml` con filesystem_lab configurado, `disabled_tools` restrictivos por defecto.
- AGENTS.md con reglas de filesystem externo: "Siempre explorar antes de modificar", "Verificar `list_allowed_directories` antes de operar", "No usar Filesystem MCP para el workspace actual".

---

## 10. Referencias oficiales

- Filesystem MCP Server (GitHub): <https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem>
- Filesystem MCP Server (npm): <https://www.npmjs.com/package/@modelcontextprotocol/server-filesystem>
- MCP en Codex: <https://developers.openai.com/codex/mcp/>
- Config Reference (mcp_servers): <https://developers.openai.com/codex/config-reference/>
- Security (MCP allowlist): <https://developers.openai.com/codex/security/>
- CLI Reference (codex mcp): <https://developers.openai.com/codex/cli/reference/>
- MCP Tool Annotations: <https://modelcontextprotocol.io/specification/2025-03-26/server/tools#toolannotations>
- Codex Prompting Guide: <https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide/>
