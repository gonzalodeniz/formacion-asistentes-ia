# Módulo 6: Configuración Profesional y Seguridad Operativa

> **Duración estimada:** 90 minutos
> (45 min teoría + 45 min laboratorio)
> **Enfoque:** DevSecOps y Gobernanza de IA.
> **Referencias:**
> [Security](https://developers.openai.com/codex/security/) |
> [Config basics](https://developers.openai.com/codex/config-basic/) |
> [Config advanced](https://developers.openai.com/codex/config-advanced/) |
> [Execution policy](https://developers.openai.com/codex/exec-policy/)

---

## 1. Objetivos de Aprendizaje

1. **Implementar "Least Privilege":** Configurar al agente
   para que solo tenga acceso a lo estrictamente necesario
   (lectura vs. escritura, red vs. offline).
2. **Gestionar Riesgos Operativos:** Usar execution policy
   rules para bloquear comandos destructivos y controlar qué
   puede ejecutar el agente fuera del sandbox.
3. **Dominar los Perfiles de Ejecución:** Diferenciar entre
   configuraciones por tipo de tarea (dev, review, CI).

---

## 2. Contenidos Teóricos

### 2.1. El Modelo de Seguridad de Codex (Sandbox)

Codex protege el sistema mediante dos capas que trabajan
juntas:

- **Sandbox mode:** Qué puede hacer Codex técnicamente
  (dónde puede escribir, si tiene acceso a red). Enforced
  por el sistema operativo (Bubblewrap en Linux, sandbox
  nativo en macOS), no mediante heurísticas de texto.
- **Approval policy:** Cuándo debe detenerse y pedir permiso
  antes de actuar.

Por defecto, Codex ejecuta en modo **read-only** con red
**desactivada**. Esto es seguro por diseño.

**Modos de sandbox:**

| Modo | Descripción | Red |
| --- | --- | --- |
| `read-only` (defecto) | Solo lectura. No escribe ni modifica estado. | Off |
| `workspace-write` | Escritura limitada al workspace. `.git/` y `.codex/` permanecen solo lectura. | Configurable |
| `danger-full-access` | Sin sandbox. Acceso total. Extremadamente arriesgado. | On |

> **Nota:** `--full-auto` es un alias conveniente de
> `--sandbox workspace-write --ask-for-approval on-request`.

### 2.2. Configuración de seguridad en `config.toml`

La configuración real de seguridad usa **claves raíz** (no
secciones `[permissions]` ni `[danger_zone]`, que no existen):

```toml
# .codex/config.toml (proyecto) o ~/.codex/config.toml (global)

# Cuándo pedir aprobación:
# "untrusted" | "on-failure" | "on-request" | "never"
approval_policy = "untrusted"

# Qué puede hacer técnicamente:
# "read-only" | "workspace-write" | "danger-full-access"
sandbox_mode = "workspace-write"

# Web search: "disabled" | "cached" | "live"
web_search = "disabled"

[sandbox_workspace_write]
network_access = false          # red desactivada por defecto
exclude_slash_tmp = false       # /tmp escribible
writable_roots = []             # raíces adicionales
```

### 2.3. Políticas de Aprobación (Human-in-the-loop)

Codex tiene **cuatro niveles** de aprobación:

| Política | Comportamiento | Riesgo |
| --- | --- | --- |
| `untrusted` | Solo comandos read-only conocidos auto-ejecutan. Todo lo demás pide permiso. | Mínimo |
| `on-failure` | Auto-ejecuta en sandbox. Pide permiso solo si falla y necesita escalar. | Bajo |
| `on-request` | El modelo decide cuándo pedir permiso (defecto con --full-auto). | Medio |
| `never` | Nunca pide permiso. Ejecuta todo automáticamente. | Alto |

### 2.4. Execution Policy Rules (Control de Comandos)

Para controlar qué comandos específicos puede ejecutar Codex
fuera del sandbox, usa **ficheros `.rules`** en `.codex/rules/`
(proyecto) o `~/.codex/rules/` (usuario):

```python
# .codex/rules/project.rules

# Bloquear permanentemente rm -rf /
prefix_rule(
  pattern = ["rm", "-rf", "/"],
  decision = "forbidden",
  justification = "Eliminación recursiva de raíz prohibida.",
  match = ["rm -rf /"],
)

# Pedir aprobación para pip install
prefix_rule(
  pattern = ["pip", "install"],
  decision = "prompt",
  justification = "Instalar paquetes requiere aprobación.",
  match = ["pip install requests"],
)

# Bloquear curl (proyecto sin red)
prefix_rule(
  pattern = ["curl"],
  decision = "forbidden",
  justification = "Red deshabilitada en este proyecto.",
  match = ["curl https://example.com"],
)
```

Decisiones (de menor a mayor prioridad):
`allow` < `prompt` < `forbidden`. Si múltiples reglas
coinciden, gana la más restrictiva.

Verificar reglas antes de usarlas:

```bash
codex execpolicy check --pretty \
  --rules .codex/rules/project.rules \
  -- curl https://example.com
# Output: decision = "forbidden"
```

> **Protección anti-smuggling:** Codex evalúa cada comando
> por separado. Aunque permitas `git add`, no auto-permitirá
> `git add . && rm -rf /` porque `rm -rf /` se evalúa
> independientemente.

### 2.5. Monitorización y Auditoría

Codex emite eventos OpenTelemetry para auditoría:

- `codex.tool_decision` — comando aprobado/denegado.
- `codex.tool_result` — duración, éxito/fallo, snippet.
- `codex.user_prompt` — longitud (contenido redactado).

```toml
[otel]
environment = "prod"
exporter = "otlp-http"
log_user_prompt = false  # redactar prompts

[otel.exporter_otlp_http]
endpoint = "https://collector.empresa.com/v1/traces"
```

Las transcripciones de sesión se guardan automáticamente en
`~/.codex/sessions/` para análisis post-mortem.

---

## 3. Buenas Prácticas

### 3.1. Perfiles por Entorno

No uses la misma configuración para todo. Define perfiles
en config.toml:

```toml
[profiles.safe-readonly]
sandbox_mode = "read-only"
approval_policy = "untrusted"
# Exploración, onboarding, auditoría

[profiles.dev-edit]
sandbox_mode = "workspace-write"
approval_policy = "on-request"
# Desarrollo activo (equivalente a --full-auto)

[profiles.ci-audit]
sandbox_mode = "read-only"
approval_policy = "untrusted"
web_search = "disabled"
# Solo lectura, sin red ni web search
```

Usar: `codex --profile safe-readonly`.
Perfil por defecto: `profile = "dev-edit"` en raíz de
config.toml.

### 3.2. "Trusted Projects"

Codex solo carga ficheros `.codex/` del repositorio
(config.toml, skills, rules) si el proyecto está marcado
como **trusted**. Esto previene que repos maliciosos
inyecten configuraciones peligrosas.

```toml
# ~/.codex/config.toml
[[project_trust]]
path = "/home/user/work/my-company"
trust = "trusted"
```

Proyectos fuera de rutas confiables se tratan como
untrusted: Codex ignora su `.codex/` local.

### 3.3. Auditoría de Acciones

- Habilitar OTel para registrar todas las acciones.
- Revisar `codex.tool_decision` periódicamente.
- Transcripciones en `~/.codex/sessions/`.
- En enterprise: `requirements.toml` con constraints que los
  usuarios no pueden sobreescribir.

---

## 4. Errores Comunes

1. **`danger-full-access` en local:** Elimina TODAS las
   protecciones del sandbox. Un prompt malicioso podría
   modificar ficheros del sistema o acceder a credenciales.
   *Solución:* Reservar exclusivamente para contenedores CI
   aislados. En local, máximo `workspace-write`.
2. **`approval_policy = "never"` en local:** Codex ejecuta
   todo sin confirmación, incluidos comandos destructivos.
   *Solución:* Solo en CI automatizado. En local, mínimo
   `on-request`.
3. **Ejecutar Codex desde `$HOME`:** En `workspace-write`,
   esto da acceso de escritura a todo tu directorio home.
   *Solución:* Ejecutar siempre desde la raíz del repo.
4. **No configurar trusted projects:** Codex podría cargar
   `.codex/config.toml` de un repo malicioso con políticas
   permisivas. *Solución:* Marcar repos explícitamente en
   `[[project_trust]]`.
5. **Activar red sin auditoría:** `network_access = true` sin
   OTel. *Solución:* Si necesitas red, habilitar OTel y
   revisar eventos.

---

## 5. Casos de Uso Reales

- **Entornos Regulados (Banca/Salud):**
  `approval_policy = "untrusted"`,
  `sandbox_mode = "workspace-write"`,
  `web_search = "disabled"`, `network_access = false`.
  Rules que bloquean `curl`/`wget` (forbidden) y requieren
  aprobación para `pip install` (prompt). OTel habilitado
  para auditoría completa.
- **SRE / DevOps:** Perfil `ops-read-only` con
  `sandbox_mode = "read-only"`. Codex puede leer logs y
  configs de Kubernetes para diagnosticar, pero execution
  policy rules bloquean `kubectl delete` y `terraform apply`
  como `forbidden`.

---

## 6. Laboratorio Práctico (L6) — La "Jaula" (Sandbox y Políticas)

**Escenario:** Configuraremos un entorno de alta seguridad:
sin red, con ejecución restringida por rules, y verificaremos
que Codex respeta los límites.

### Paso 1: Preparación del Entorno

```bash
mkdir /tmp/codex-lab06 && cd /tmp/codex-lab06
git init

# Entorno virtual
python3 -m venv .venv
source .venv/bin/activate
pip install pytest flake8

cat > .gitignore << 'EOF'
.venv/
__pycache__/
*.pyc
EOF

# Código base
mkdir -p src tests

cat > src/app.py << 'PYEOF'
import os

def get_config():
    return {"debug": os.getenv("DEBUG", "false")}

def process(data):
    return [x * 2 for x in data if x > 0]
PYEOF

cat > tests/test_app.py << 'PYEOF'
from src.app import get_config, process

def test_config():
    assert "debug" in get_config()

def test_process():
    assert process([1, -2, 3]) == [2, 6]
PYEOF

PYTHONPATH=. pytest tests/ -v
git add -A && git commit -m "chore: scaffold lab06"
```

### Paso 2: Configuración Restrictiva

```bash
mkdir -p .codex

cat > .codex/config.toml << 'EOF'
# Política estricta: sandbox + approvals + sin red
approval_policy = "untrusted"
sandbox_mode = "workspace-write"
web_search = "disabled"

[sandbox_workspace_write]
network_access = false
EOF

git add .codex/ && git commit -m "config: política restrictiva"
```

### Paso 3: Execution Policy Rules

```bash
mkdir -p .codex/rules

cat > .codex/rules/security.rules << 'EOF'
# Bloquear herramientas de red
prefix_rule(
  pattern = ["curl"],
  decision = "forbidden",
  justification = "Red prohibida. No se permiten requests.",
  match = ["curl https://google.com"],
)

prefix_rule(
  pattern = ["wget"],
  decision = "forbidden",
  justification = "Red prohibida.",
  match = ["wget https://example.com"],
)

# Pedir aprobación para pip install
prefix_rule(
  pattern = ["pip", "install"],
  decision = "prompt",
  justification = "Instalar paquetes requiere aprobación.",
  match = ["pip install requests"],
)

# Permitir pytest sin aprobación
prefix_rule(
  pattern = ["pytest"],
  decision = "allow",
  match = ["pytest tests/ -v"],
)
EOF

git add .codex/rules/
git commit -m "rules: política de ejecución"
```

**Verificar las reglas (sin lanzar Codex):**

```bash
# curl debe estar bloqueado
codex execpolicy check --pretty \
  --rules .codex/rules/security.rules \
  -- curl https://google.com
# Esperado: decision = "forbidden"

# pip install debe pedir aprobación
codex execpolicy check --pretty \
  --rules .codex/rules/security.rules \
  -- pip install requests
# Esperado: decision = "prompt"

# pytest debe estar permitido
codex execpolicy check --pretty \
  --rules .codex/rules/security.rules \
  -- pytest tests/ -v
# Esperado: decision = "allow"
```

### Paso 4: Intento de Violación de Red

Lanzar Codex y pedir una tarea que requiere internet:

```bash
source .venv/bin/activate
codex
```

Prompt en el TUI:

```text
Crea un script que descargue la home de google.com
usando curl y guárdala en un archivo.
```

**Observación esperada:**

1. Codex genera el código (script con curl).
2. Al intentar ejecutar curl, la execution policy rule lo
   bloquea con `forbidden` — Codex no puede ejecutarlo.
3. Aunque curl no estuviera bloqueado por regla, la red
   está desactivada (`network_access = false`), así que
   la conexión fallaría igualmente.

### Paso 5: Aprobación Explícita (pip install)

Prompt en el TUI:

```text
Añade la dependencia 'requests' al proyecto
e impórtala en src/app.py.
```

**Observación esperada:**

1. Codex propone ejecutar `pip install requests`.
2. La approval policy `untrusted` + la regla `prompt`
   fuerzan a Codex a pedir permiso.
3. El usuario puede aprobar (`y`) o denegar (`n`).
4. Si se deniega, Codex informa que no puede completar
   la tarea.

### Paso 6: Acción Permitida (pytest)

Prompt en el TUI:

```text
Añade un test para process() con una lista vacía
y ejecuta los tests.
```

**Observación esperada:**
Codex modifica el fichero de tests y ejecuta `pytest`
sin pedir aprobación (la regla `allow` lo permite).

### Paso 7: Limpieza (Protocolo Obligatorio)

```bash
deactivate
rm -rf /tmp/codex-lab06

ls /tmp/codex-lab06 2>/dev/null \
  && echo "ERROR: aún existe" \
  || echo "OK: limpio"
```

> No es necesario revisar config global: toda la
> configuración del laboratorio estaba en
> `/tmp/codex-lab06/.codex/` (proyecto, no global).
