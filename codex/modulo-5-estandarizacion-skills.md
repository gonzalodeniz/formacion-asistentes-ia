# Módulo 5: Estandarización del Equipo con Skills (`SKILL.md`)

> **Duración estimada:** 90 minutos
> (45 min teoría + 45 min laboratorio)
> **Referencias:**
> [Skills Overview](https://developers.openai.com/codex/skills/) |
> [Create Skills](https://developers.openai.com/codex/skills/create-skill/) |
> [Agent Skills Spec](https://agentskills.io)

---

## 1. Introducción y Objetivos

En versiones anteriores, los desarrolladores dependían de
"custom prompts" (ficheros `.md` en `~/.codex/`) invocados
manualmente vía `/prompts:nombre`. OpenAI ha **deprecado** este
enfoque en favor de las **Skills**. Una skill convierte un
prompt estático en una herramienta gobernable, versionable y de
activación inteligente.

**Al finalizar este módulo, serás capaz de:**

1. **Diseñar y empaquetar** instrucciones complejas usando el
   estándar `SKILL.md` con YAML frontmatter válido.
2. **Gestionar el "Progressive Disclosure":** Codex solo inyecta
   `name` y `description` en el contexto; las instrucciones
   completas se cargan únicamente cuando la skill se invoca.
3. **Sustituir prácticas obsoletas** por una librería
   corporativa de skills compartida y versionada con Git.

---

## 2. Contenidos Teóricos: La Anatomía de una Skill

### 2.1. ¿Qué es una Skill?

Una skill no es solo texto; es un directorio que encapsula un
comportamiento. Su núcleo es el archivo `SKILL.md`, que se
divide en dos partes:

1. **YAML Frontmatter:** Dos campos obligatorios — `name`
   (máx. 100 chars, 1 línea) y `description` (máx. 500 chars,
   1 línea). Codex los lee para indexar la skill sin cargar el
   cuerpo completo.
2. **Cuerpo Markdown:** Las instrucciones reales, checklists de
   verificación y constraints. Permanece en disco y solo se
   inyecta al invocar la skill.

**Estructura de directorio de una skill:**

```text
mi-skill/
  SKILL.md            # Obligatorio: metadatos + instrucciones
  scripts/            # Opcional: código ejecutable
  references/         # Opcional: documentación de apoyo
  assets/             # Opcional: templates, recursos
  agents/
    openai.yaml       # Opcional: interfaz UI y deps MCP
```

**Ejemplo mínimo de SKILL.md:**

```markdown
---
name: ci-guardian
description: >-
  Fix CI pipeline failures by analyzing build logs
  and applying a minimal fix.
  Do not use for feature development or code review.
---

## When to use this
Use when CI is red and the user wants to fix it.

## Workflow
1. Read the CI log.
2. Identify the failing step.
3. Apply minimal fix.

## Validation
1. Run the CI command that failed.
2. Run full test suite.
3. Show git diff --stat.
```

### 2.2. Niveles de Ubicación (Scopes)

Codex carga skills desde múltiples ubicaciones según quién
debe acceder a ellas:

- **Repo-scoped (`.codex/skills/NOMBRE/`):** La opción más
  potente. Se versionan en Git. Todo desarrollador que clone
  el repositorio hereda automáticamente las skills del equipo.
  El proyecto debe estar marcado como **trusted** para que
  Codex las cargue.
- **User-scoped (`~/.codex/skills/NOMBRE/`):** Skills
  personales que aplican en todos tus repos. No se comparten
  con el equipo.
- **User-scoped alternativo (`~/.agents/skills/NOMBRE/`):**
  Mismo efecto que la anterior (compatibilidad).
- **Admin/System:** Definida por MDM para máquinas gestionadas
  en entornos enterprise.

> **Nota:** La ubicación de repo es `.codex/skills/`, no
> `.agents/skills/`. La ubicación `.agents/skills/` es
> equivalente a `~/.codex/skills/` para skills personales.

### 2.3. Activación y "Progressive Disclosure"

Codex solo inyecta el **nombre, description y ruta** de cada
skill en el contexto de ejecución. Las instrucciones completas
(el cuerpo del SKILL.md) permanecen en disco y se inyectan
**únicamente** cuando la skill es invocada. Esto mantiene el
contexto ligero incluso con decenas de skills instaladas.

Dos modos de activación:

- **Explícita:** El usuario escribe `$nombre` en el composer
  (ej. `$ci-guardian`). Codex carga las instrucciones y las
  aplica.
- **Implícita (Automática):** Codex lee la `description` de
  cada skill disponible. Si el prompt del usuario hace match
  con la descripción, Codex selecciona y carga la skill
  automáticamente. La calidad de la `description` determina
  la precisión de este matching.

> **Tip:** Verifica tu description con 4 prompts de prueba:
> 2 que deben activar la skill y 2 que no deben. Para
> validación sistemática usa evals con
> `codex exec --json`.

### 2.4. Skills built-in y ecosistema

Codex incluye skills integradas:

- **$skill-creator** — Crea nuevas skills interactivamente.
- **$skill-installer** — Instala skills del catálogo público:
  `$skill-installer install NOMBRE`.
- **$create-plan** (experimental) — Requiere instalación:
  `$skill-installer install create-plan`.
- **$plan** — Plan de implementación con milestones.

Catálogo público: `github.com/openai/skills`.

---

## 3. Buenas Prácticas de Diseño

1. **Diseño del `description`:** Es el campo más crítico.
   Si pones `"Ayuda a programar"`, Codex la activará siempre
   (*over-triggering*). Usa descripciones precisas con verbo
   de acción, contexto de activación y negaciones:
   `"Fix CI pipeline failures by analyzing build logs. Do not
   use for feature development or code review."`.
2. **Composabilidad:** No crees un SKILL.md gigante llamado
   `backend-dev`. Crea `$db-migration`, `$api-endpoint` y
   `$security-review`. Una skill = un trabajo.
3. **Checklists integrados:** Incluye una sección
   `## Validation` con comandos que Codex debe ejecutar antes
   de dar la tarea por terminada.
4. **Preferir instrucciones sobre scripts:** Usa scripts solo
   cuando necesites comportamiento determinista o herramientas
   externas.
5. **Versionar como código:** Skills de equipo en
   `.codex/skills/` con code review obligatorio.

---

## 4. Errores Comunes

1. **Usar custom prompts antiguos:** Intentar meter
   instrucciones en ficheros `.md` sueltos en `~/.codex/` en
   lugar de migrarlos a skills en `.codex/skills/`. Los custom
   prompts están deprecados: no se comparten con el equipo ni
   se activan automáticamente.
2. **Mezclar políticas:** Poner reglas de formato de código
   (que deberían ir en `AGENTS.md` o en la configuración del
   linter) dentro de una skill específica. Las convenciones
   permanentes van en `AGENTS.md`; las skills son para flujos
   de trabajo invocables.
3. **Falta de "Definition of Done":** Una skill sin sección
   `## Validation` con comandos explícitos hará que Codex
   termine prematuramente o entre en bucle.
4. **`description` vaga o multi-línea:** Si `name` o
   `description` ocupan más de una línea o exceden el límite
   (100/500 chars), Codex ignora la skill con error de
   validación al arrancar.
5. **Fichero no se llama SKILL.md:** Codex requiere la
   mayúscula exacta `SKILL.md`. Cualquier otra variante se
   ignora.

---

## 5. Casos de Uso Reales en Producción

- **Skill "CI-Fixer" ($ci-guardian):** Cuando el pipeline
  falla, el desarrollador escribe `$ci-guardian` o simplemente
  "el CI está rojo". La skill instruye a Codex a leer los
  logs, aislar el fallo, aplicar un fix mínimo (máx. 3
  ficheros, máx. 30 líneas) y ejecutar los tests para
  verificar. Si el fix es demasiado grande, se detiene y pide
  instrucciones.
- **Skill "Migración Incremental":** Un equipo migrando de
  Vue 2 a Vue 3 usa una skill que traduce la Options API a
  Composition API componente por componente, asegurando que no
  se mezclen sintaxis. Constraint clave: un componente por
  invocación (atómico).

---

## 6. Laboratorio Práctico (L5): Creación de una Librería de Skills

**Escenario:** Vamos a establecer la librería base
(repo-scoped) para un equipo de desarrollo. Crearemos tres
skills corporativas estándar.

**Objetivo:** 3 skills funcionales con YAML frontmatter válido,
descriptions precisas y secciones de validación.

### Paso 1: Preparación del Entorno

```bash
mkdir /tmp/codex-lab05 && cd /tmp/codex-lab05
git init

# Entorno virtual
python3 -m venv .venv
source .venv/bin/activate    # Windows: .venv\Scripts\activate
pip install pytest flake8

cat > .gitignore << 'EOF'
.venv/
__pycache__/
*.pyc
EOF

# Crear estructura de skills (repo-scoped)
mkdir -p .codex/skills/new-feature
mkdir -p .codex/skills/ci-guardian
mkdir -p .codex/skills/refactor-safe

# Crear código base para probar las skills
mkdir -p src tests

cat > src/processor.py << 'PYEOF'
def process_items(items):
    results = []
    for item in items:
        if item > 10:
            val = item * 2
            if val > 50:
                val = val - 5
            results.append(val)
    return results
PYEOF

cat > tests/test_processor.py << 'PYEOF'
from src.processor import process_items

def test_basic():
    assert process_items([5, 12, 30]) == [24, 55]

def test_empty():
    assert process_items([]) == []
PYEOF

PYTHONPATH=. pytest tests/ -v
git add -A && git commit -m "chore: scaffold lab05"
```

### Paso 2: Skill 1 — Nueva Funcionalidad ($new-feature)

Establece los criterios obligatorios antes de dar por buena
una nueva feature.

```bash
cat > .codex/skills/new-feature/SKILL.md << 'EOF'
---
name: new-feature
description: >-
  Scaffold a new feature with TDD workflow.
  Use when creating a new component, endpoint, or module
  from scratch. Do not use for bugfixes or refactoring.
---

## When to use this
Use when the user wants to create a new component,
endpoint, or module from scratch.

## Workflow (strict order)
1. **Plan:** Write a brief summary of the code structure.
2. **TDD:** Write test skeletons FIRST (before implementation).
3. **Implement:** Write the feature code.
4. **Document:** Add docstrings to all public functions.

## Constraints
- Test coverage for new code must be 100%.
- Do not modify existing code unless explicitly requested.
- No new dependencies without approval.

## Validation
1. Run tests: `PYTHONPATH=. pytest tests/ -v`
2. Run linter: `flake8 src/`
3. Show `git diff --stat`.
EOF

git add .codex/skills/new-feature/
git commit -m "skill: new-feature"
```

### Paso 3: Skill 2 — Guardián del CI ($ci-guardian)

Orientada a diagnosticar y corregir fallos de pipeline con
límites estrictos.

```bash
cat > .codex/skills/ci-guardian/SKILL.md << 'EOF'
---
name: ci-guardian
description: >-
  Fix CI pipeline failures by analyzing logs, identifying
  root cause, and applying a minimal fix.
  Do not use for feature development or code review.
---

## When to use this
Use when CI is red and the user wants to diagnose and fix
the failure. The user will provide CI logs or error output.

## Workflow
1. Read the CI log or error output.
2. Identify the failing step (lint, test, build).
3. Trace root cause to specific file and line.
4. Apply minimal fix (smallest possible change).
5. Run the failing command to verify.

## Constraints
- Modify ONLY the files that cause the failure.
- Maximum 3 files modified.
- No new dependencies.
- NEVER modify CI workflow files (.github/workflows/ or
  equivalents) to silence errors (e.g., adding `|| true`).
  The goal is to fix the code, not the pipeline config.
- If the fix requires more than 30 lines, STOP and explain.

## Validation
1. Run the exact CI command that failed.
2. Run full test suite: `PYTHONPATH=. pytest tests/ -v`
3. Run linter: `flake8 src/`
4. Show `git diff --stat` to confirm minimal scope.
EOF

git add .codex/skills/ci-guardian/
git commit -m "skill: ci-guardian"
```

### Paso 4: Skill 3 — Refactorización Segura ($refactor-safe)

Skill crucial para modernizar código sin introducir bugs.

```bash
cat > .codex/skills/refactor-safe/SKILL.md << 'EOF'
---
name: refactor-safe
description: >-
  Refactor code safely with no behaviour change. Runs
  tests before and after to guarantee equivalence.
  Do not use for adding features or fixing bugs.
---

## When to use this
Use when the user wants to improve code quality, reduce
complexity, or extract functions WITHOUT changing external
behavior.

## Invariant
NO BEHAVIOUR CHANGE. The external black-box behavior must
be identical. All existing tests must pass WITHOUT
modification.

## Workflow
1. Run all tests FIRST to establish green baseline.
2. Read target code and identify refactoring opportunities.
3. If refactor is large, propose micro-steps.
4. Implement the refactoring.
5. Add type hints to new functions.
6. Run all tests again to verify no behaviour change.

## Constraints
- Only modify files explicitly mentioned by the user.
- Do not change public function signatures or return types.
- No new dependencies.
- Maximum 50 lines of new code.

## Validation
1. Tests before: `PYTHONPATH=. pytest tests/ -v` (MUST pass)
2. Apply refactoring.
3. Tests after: `PYTHONPATH=. pytest tests/ -v` (MUST pass)
4. Linter: `flake8 src/`
5. Scope: `git diff --stat`
6. Confirm: all original tests pass WITHOUT modification.
EOF

git add .codex/skills/refactor-safe/
git commit -m "skill: refactor-safe"
```

### Paso 5: Prueba de Invocación Explícita

Asegúrate de que el venv está activo y lanza Codex:

```bash
cd /tmp/codex-lab05
source .venv/bin/activate
codex --full-auto
```

**TEST 1:** Escribe en el TUI (invocación explícita de
$refactor-safe):

```text
$refactor-safe

Refactoriza @src/processor.py:
- Extrae la lógica del cálculo a una función auxiliar.
- Añade type hints.
```

**Observación esperada:** Codex ejecuta tests ANTES del
refactor (green baseline), aplica los cambios, ejecuta tests
DESPUÉS y muestra `git diff --stat` — todo como indica la
skill.

**TEST 2:** Escribe en el TUI (invocación de $ci-guardian):

```text
$ci-guardian

Añadí este test que falla:
def test_negative():
    assert process_items([-5, -1]) == []

El CI está rojo porque process_items no filtra negativos
correctamente. Arréglalo.
```

**Observación esperada:** Codex aplica un fix mínimo en
`src/processor.py` sin tocar otros ficheros ni modificar
tests existentes.

### Paso 6: Limpieza (Protocolo Obligatorio)

```bash
# Desactivar entorno virtual
deactivate

# Borrar estructura de laboratorio
rm -rf /tmp/codex-lab05

# Verificar
ls /tmp/codex-lab05 2>/dev/null \
  && echo "ERROR: aún existe" \
  || echo "OK: limpio"
```
