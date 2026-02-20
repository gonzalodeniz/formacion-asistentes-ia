# Módulo 11 — Seguridad, Privacidad y Control de Calidad del Código Generado

> **Duración estimada:** 90 minutos
> (45 min teoría + 45 min laboratorio)
> **Enfoque:** Seguridad operativa, gobernanza de datos
> y quality gates para código generado por IA.
> **Referencias:**
> [Security](https://developers.openai.com/codex/security/) |
> [Rules](https://developers.openai.com/codex/rules/) |
> [Config Reference](https://developers.openai.com/codex/config-reference/) |
> [Admin Setup](https://developers.openai.com/codex/enterprise/admin-setup/) |
> [SAST GitLab](https://developers.openai.com/cookbook/examples/codex/secure_quality_gitlab/)

---

## 1. Objetivos de Aprendizaje

1. **Seguridad operativa de Codex:** Entender y configurar
   sandbox, approval policy, network access, execution rules
   y `shell_environment_policy` para proteger secretos.
2. **Controles empresariales:** Conocer `requirements.toml`,
   ZDR (Zero Data Retention), `history.persistence`,
   OTel para auditoría, y RBAC.
3. **Quality gates para código generado:** Establecer un
   "Definition of Done" con tests, linters, SAST scanning,
   cobertura mínima y revisión de dependencias/licencias.

---

## 2. Contenidos Teóricos

### 2.1. Seguridad Operativa de Codex

Codex tiene dos capas de seguridad que trabajan juntas:

- **Sandbox mode:** Qué puede hacer Codex técnicamente
  (dónde puede escribir, si tiene red). Por defecto
  `read-only` en CLI, `workspace-write` en --full-auto.
  Codex Cloud corre en contenedores aislados de OpenAI.
- **Approval policy:** Cuándo Codex pide permiso antes de
  actuar. `on-request` (default): el modelo decide cuándo
  preguntar. `untrusted`: solo comandos read-only se
  ejecutan sin aprobación.
- **Network access:** Desactivado por defecto en CLI/IDE.
  Web search usa cache de OpenAI (pre-indexed) por default,
  reduciendo exposición a prompt injection.

### 2.2. Protección de Secretos

#### `shell_environment_policy` — Filtrado automático

Codex filtra automáticamente variables que contengan
`KEY`, `SECRET` o `TOKEN` (case-insensitive) antes de
pasarlas a subprocesos:

```toml
# ~/.codex/config.toml
[shell_environment_policy]
inherit = "none"              # empezar limpio
set = { PATH = "/usr/bin" }   # solo lo necesario
exclude = ["AWS_*", "AZURE_*"]
# ignore_default_excludes = false mantiene el filtro
# automático de KEY/SECRET/TOKEN (default: true)
```

#### Nunca pegar secretos en prompts

- Los prompts viajan a la API de OpenAI. Un secret pegado
  en un prompt queda registrado en el contexto.
- En Codex Cloud, los **secrets** se configuran en
  environment settings y se borran antes de la fase del
  agente (solo disponibles en setup scripts).
- En CI, usar `OPENAI_API_KEY` como secret de GitHub/GitLab,
  nunca en el prompt.

### 2.3. Execution Policy Rules

Controlar qué comandos puede ejecutar Codex fuera del
sandbox:

```text
# .codex/rules/team.rules
prefix_rule(
  pattern = ["rm", "-rf", "/"],
  decision = "forbidden",
  justification = "Operación destructiva global",
)

prefix_rule(
  pattern = ["git", "push", "--force"],
  decision = "prompt",
  justification = "Force push requiere aprobación humana",
)
```

La decisión más restrictiva gana cuando coinciden
múltiples reglas: `forbidden` > `prompt` > `allow`.

Smart approvals (activado por default) sugiere
`prefix_rule` automáticamente durante escalation requests.

### 2.4. Controles Empresariales

#### `requirements.toml` (Business/Enterprise)

Constraints que los admins imponen y los usuarios no
pueden override:

```toml
# Distribuido vía MDM o cloud-fetched
allowed_approval_policies = ["on-request", "untrusted"]
allowed_sandbox_modes = ["read-only", "workspace-write"]
allowed_web_search = ["cached"]

# Allowlist de MCP servers
[[mcp_servers]]
id = "openaiDocs"
url = "https://developers.openai.com/mcp"
```

#### Zero Data Retention (ZDR)

Codex soporta organizaciones con ZDR habilitado en
la API de OpenAI. Los datos no se retienen para
entrenamiento.

#### Retención local

```toml
# ~/.codex/config.toml
[history]
persistence = false  # no guardar transcripciones
# max_bytes = 10485760  # limitar tamaño
```

#### OTel para auditoría

Eventos como `codex.tool_decision` (approved/denied),
`codex.tool_result`, `codex.user_prompt` (redactado por
default). `log_user_prompt = false` por default.

#### RBAC

ChatGPT Business/Enterprise: controles separados para
local (app, CLI, IDE) y cloud (Codex Cloud, Code Review,
Slack integration). Admins asignan permisos por grupos.

### 2.5. Quality Gates para Código Generado

El código generado por Codex debe pasar los mismos gates
que cualquier código humano:

| Gate | Herramienta | Configuración Codex |
| --- | --- | --- |
| Unit tests | pytest, jest | AGENTS.md: "Run tests after every change" |
| Lint | flake8, ESLint | AGENTS.md: "Run lint before committing" |
| SAST | Bandit, Semgrep | `codex exec` en pipeline CI |
| Dependency audit | pip-audit, npm audit | WebSearch MCP para CVEs (M7) |
| Coverage | pytest-cov | `--cov-fail-under=80` en CI |
| License check | license_finder | Pre-commit o CI step |
| Code review | `/review` | P0/P1 antes de merge (M8) |

### 2.6. Principios de Seguridad para Código Generado

- **Validación de inputs:** Todo input de usuario debe
  validarse. Pedir a Codex: "Validate all user inputs.
  Reject invalid data before processing."
- **Authorization checks:** No confiar en que Codex añada
  authz automáticamente. Pedir explícitamente: "Add
  authorization checks. Verify the user has permission."
- **Logging sin PII:** Pedir: "Add logging for audit trail.
  NEVER log passwords, tokens, PII, or request bodies
  containing sensitive data."
- **Dependencias:** Revisar cada dependencia que Codex
  sugiera: CVEs conocidos, licencia compatible, versión
  actualizada.

---

## 3. Buenas Prácticas

1. **Checklist de seguridad para tareas Codex:**
   ¿Tocó auth/authz? ¿Añadió dependencias? ¿Maneja inputs
   y errores? ¿Logs exponen PII/secrets?
2. **`shell_environment_policy`:** Configurar `inherit = "none"`
   o `"core"` en entornos sensibles. Nunca desactivar
   el filtro de KEY/SECRET/TOKEN.
3. **Execution rules en el repo:** `.codex/rules/` con
   `forbidden` para operaciones destructivas, `prompt`
   para operaciones sensibles (force push, rebase, deploy).
4. **`requirements.toml` para equipos:** Limitar sandbox
   modes y approval policies a nivel organizacional.
5. **Quality gates automatizados:** Lint + tests + SAST +
   coverage + `/review` antes de merge. Configurar en
   AGENTS.md y en CI pipeline.

---

## 4. Errores Comunes

1. **Copiar trazas con tokens/API keys:** Stack traces
   o logs pueden contener secrets. Nunca pegarlos en
   prompts sin redactar. *Solución:* Redactar manualmente
   o usar `shell_environment_policy` para filtrar.
2. **Aceptar dependencias sin revisar:** Codex puede sugerir
   dependencias con CVEs conocidos o licencias
   incompatibles. *Solución:* Ejecutar `pip-audit` o
   `npm audit` después de cada cambio de dependencias.
3. **`danger-full-access` en CI compartido:** Riesgo de
   acceso a secrets de otros jobs. *Solución:*
   `drop-sudo` (default en GitHub Action) + `workspace-write`.
4. **Prompt injection via web search:** Web search puede
   contener instrucciones maliciosas. *Solución:* Usar
   `web_search = "cached"` (default) en vez de `"live"`.
5. **No configurar `history.persistence`:** Las
   transcripciones quedan en disco indefinidamente.
   *Solución:* `persistence = false` o `max_bytes` limitado.

---

## 5. Casos de Uso Reales

- **Hardening de endpoints:** `/review` para identificar
  inputs no validados, falta de authz, y SQL injection.
  Luego generar tests de seguridad (M9) y aplicar fixes.
- **Sanitización de logs:** Pedir a Codex que audite todos
  los `log.*` y `print()` del proyecto buscando PII o
  secrets expuestos, y reemplace con placeholders.
- **SAST + Codex en GitLab:** Pipeline que ejecuta scanner
  SAST, pasa el report a Codex para interpretación con
  `codex exec`, y genera patches de remediación validados
  con `git apply --check` (cookbook oficial).

---

## 6. Laboratorio (L11) — Auditoría de Seguridad y Hardening

**Escenario:** Crearemos un servicio pequeño con
vulnerabilidades controladas (inyección SQL, falta de
authz, logs con PII, dependencia vulnerable). Usaremos
Codex para auditar, corregir y generar tests de regresión.

### Paso 1: Setup del proyecto (5 min)

```bash
mkdir /tmp/codex-lab11 && cd /tmp/codex-lab11
git init

python3 -m venv .venv
source .venv/bin/activate
pip install pytest flake8 bandit

cat > .gitignore << 'EOF'
.venv/
__pycache__/
*.pyc
*.db
security_report.md
EOF

mkdir -p src tests
```

### Paso 2: Crear servicio con vulnerabilidades (5 min)

```bash
cat > src/user_service.py << 'PYEOF'
"""User service — con vulnerabilidades deliberadas."""
import sqlite3
import hashlib
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

DB_PATH = "users.db"

def init_db():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("""CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        email TEXT,
        role TEXT DEFAULT 'user'
    )""")
    conn.commit()
    conn.close()

def create_user(username, password, email, role="user"):
    """VULN 1: SQL injection en role (f-string)"""
    """VULN 2: Password almacenada en MD5 sin salt"""
    """VULN 3: Log con password en claro"""
    conn = sqlite3.connect(DB_PATH)
    hashed = hashlib.md5(password.encode()).hexdigest()
    logger.debug(
        f"Creating user {username} with password {password} "
        f"and email {email}"
    )
    conn.execute(
        f"INSERT INTO users (username, password, email, role) "
        f"VALUES (?, ?, ?, '{role}')",
        (username, hashed, email)
    )
    conn.commit()
    conn.close()

def get_user(username):
    """VULN 4: Sin authz — cualquiera puede consultar"""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.execute(
        "SELECT * FROM users WHERE username = ?",
        (username,)
    )
    row = cursor.fetchone()
    conn.close()
    if row:
        return {
            "id": row[0], "username": row[1],
            "password": row[2],  # VULN 5: Expone hash
            "email": row[3], "role": row[4]
        }
    return None

def delete_user(username):
    """VULN 6: Sin authz — cualquiera puede borrar"""
    """VULN 7: Sin confirmación ni soft delete"""
    conn = sqlite3.connect(DB_PATH)
    conn.execute(
        "DELETE FROM users WHERE username = ?",
        (username,)
    )
    conn.commit()
    conn.close()
    logger.info(f"User {username} deleted")

def search_users(query):
    """VULN 8: SQL injection directa"""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.execute(
        f"SELECT username, email FROM users "
        f"WHERE username LIKE '%{query}%'"
    )
    results = cursor.fetchall()
    conn.close()
    return results
PYEOF

git add -A && git commit -m "chore: servicio con vulnerabilidades"
```

### Paso 3: AGENTS.md con reglas de seguridad (3 min)

```bash
cat > AGENTS.md << 'EOF'
# Project Instructions

## Security Rules
- NEVER log passwords, tokens, PII, or sensitive data.
- All SQL queries MUST use parameterized queries (?).
- All user inputs MUST be validated before use.
- Password hashing: use hashlib.sha256 with random salt
  (os.urandom), NEVER MD5.
- Functions that modify data MUST include authorization
  checks (caller_role parameter).
- get_user MUST NOT return password hash in response.
- Use soft delete (is_active flag) instead of hard DELETE.

## Testing Rules
- All security fixes need regression tests.
- Include tests that attempt to exploit each vulnerability.
- Run pytest + bandit after changes.
EOF

git add AGENTS.md && git commit -m "docs: AGENTS.md seguridad"
```

### Paso 4: Auditoría con `/review` (10 min)

```bash
codex
```

```text
/review
```

Seleccionar **"Review uncommitted changes"** (o branch
si aplica).

**Observar:** Codex identifica vulnerabilidades como
hallazgos P0/P1 con fichero y línea.

Alternativamente, pedir auditoría explícita:

```text
Analiza @src/user_service.py buscando vulnerabilidades
de seguridad. Para cada una:
1. Describe la vulnerabilidad y su severidad (Critical,
   High, Medium, Low).
2. Indica el fichero y línea exacta.
3. Explica el vector de ataque.
4. Propón la corrección.

NO corrijas nada todavía — solo genera el informe.
Guárdalo en security_report.md.
```

### Paso 5: Generar tests de seguridad ANTES del fix (5 min)

```text
Genera tests de seguridad en tests/test_security.py
que intenten explotar CADA vulnerabilidad del informe:
1. SQL injection en create_user(role=...) y search_users()
2. Verificar que MD5 NO se usa para passwords
3. Verificar que logs NO contienen passwords ni emails
4. Verificar que get_user NO retorna password hash
5. Verificar que delete_user requiere authz

Cada test con docstring explicando qué vulnerabilidad
explota. Ejecuta pytest tests/ -v.
```

**Observar:** Los tests FALLAN — confirman que las
vulnerabilidades son reales.

### Paso 6: Aplicar fixes con Codex (10 min)

```text
Corrige TODAS las vulnerabilidades en @src/user_service.py
siguiendo las reglas de @AGENTS.md:
- SQL injection: parámetros (?) en todas las queries
- Password: sha256 con os.urandom(16) salt
- Logs: redactar passwords, emails = solo dominio
- get_user: no retornar password hash
- Authz: añadir caller_role a delete_user, verificar admin
- Soft delete: añadir is_active, no borrar realmente
- Validación: username no vacío, email formato básico

Ejecuta pytest tests/ -v para verificar que TODOS
los tests pasan. Luego ejecuta bandit src/ -r.
```

### Paso 7: Ejecutar SAST con Bandit (3 min)

```bash
bandit src/ -r -f txt
```

**Observar:** Bandit debería reportar 0 issues de
severidad High después de los fixes.

### Paso 8: Verificación final

| Verificación | Resultado esperado |
| --- | --- |
| `/review` o informe generado | Vulnerabilidades identificadas con línea |
| Tests de seguridad generados | Exploits para cada vulnerabilidad |
| Tests fallaron ANTES del fix | Confirman vulnerabilidades reales |
| Fixes aplicados | Todos los tests pasan (green) |
| SQL injection eliminada | Todas las queries con parámetros (?) |
| Password hashing seguro | SHA-256 + random salt |
| Logs sanitizados | Sin passwords ni PII |
| Authz añadido | delete_user requiere admin |
| Bandit limpio | 0 issues High/Critical |

### Paso 9: Limpieza (Protocolo Obligatorio)

```bash
deactivate
rm -rf /tmp/codex-lab11

ls /tmp/codex-lab11 2>/dev/null \
  && echo "ERROR: aún existe" \
  || echo "OK: limpio"
```
