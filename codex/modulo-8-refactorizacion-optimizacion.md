# Módulo 8 — Refactorización, Revisión y Optimización Segura

> **Duración estimada:** 90 minutos
> (45 min teoría + 45 min laboratorio)
> **Enfoque:** Calidad de Software, Clean Code y Rendimiento.
> **Referencias:**
> [/review](https://developers.openai.com/codex/cli/slash-commands/) |
> [Workflows](https://developers.openai.com/codex/workflows/) |
> [Code Review](https://developers.openai.com/codex/cloud/code-review/) |
> [GitHub Action](https://developers.openai.com/codex/github-action/)

## 1. Objetivos de Aprendizaje

1. **Cambio de Rol:** Usar `/review` de Codex CLI para
   obtener revisiones priorizadas antes de hacer merge.
2. **Refactorización Defensiva:** Aplicar el patrón
   *Strangler Fig* asistido por IA para modernizar código
   legacy sin romper la funcionalidad existente.
3. **Optimización Basada en Datos:** Usar la IA para reducir
   complejidad algorítmica exigiendo baselines medibles
   antes y después.

## 2. Contenidos Teóricos

### 2.1. `/review` — El Revisor Integrado de Codex

A diferencia de un linter estático (que busca errores de
sintaxis), Codex entiende la *intención* del código.

Codex CLI incluye el comando `/review` que lanza un agente
reviewer dedicado. Este agente lee el diff seleccionado y
reporta hallazgos priorizados y accionables **sin tocar el
working tree**.

**Modos de revisión disponibles:**

| Modo | Descripción |
| --- | --- |
| Review against a base branch | Selecciona rama local; Codex calcula merge base y revisa diff |
| Review uncommitted changes | Revisa staged, unstaged y untracked |
| Review a commit | Lista commits recientes y revisa el SHA seleccionado |
| Custom review instructions | Prompt personalizado (ej. "Focus on security") |

```text
# En el TUI, escribir:
/review

# Codex muestra los modos disponibles y pide seleccionar.
# El resultado aparece como turno independiente en la
# transcripción.
# Usar /diff después para inspeccionar cambios exactos.
```

El modelo usado por `/review` es el de la sesión actual,
salvo que se configure `review_model` en config.toml:

```toml
# ~/.codex/config.toml
review_model = "gpt-5.3-codex"
```

**Qué detecta el reviewer:**

- **Análisis Semántico:** Nombres confusos, lógica
  innecesariamente compleja, falta de manejo de edge cases.
- **Seguridad:** Inyección SQL, XSS, secretos hardcodeados,
  path traversal. Patrones que escapan a tests unitarios.
- **Rendimiento:** Complejidad algorítmica excesiva,
  bucles ineficientes, memory leaks.

### 2.2. Code Review en GitHub

Codex puede revisar PRs directamente en GitHub:

- **Automático:** Habilitar Codex Code Review en el repo.
  Codex revisa automáticamente al abrir una PR.
- **Manual:** `@codex review` en un comentario de PR.
  Opcionalmente: `@codex review for security vulnerabilities`.

Codex busca ficheros `AGENTS.md` y sigue las secciones de
"Review guidelines". En GitHub, solo reporta issues **P0**
(bloqueantes) y **P1** (importantes). Para issues menores,
configurar en AGENTS.md: `Treat documentation typos as P1.`

### 2.3. Perfiles para Review vs. Edit

Separar los roles usando perfiles del Módulo 6:

```toml
[profiles.review-only]
sandbox_mode = "read-only"
approval_policy = "untrusted"
model_reasoning_effort = "high"
# Codex NO puede modificar ficheros

[profiles.dev-edit]
sandbox_mode = "workspace-write"
approval_policy = "on-request"
# Codex puede editar tras aprobación
```

```bash
# Revisar sin riesgo de modificar:
codex --profile review-only

# Editar tras la revisión:
codex --profile dev-edit
```

### 2.4. Técnicas de Refactorización Asistida

- **Snapshot Testing (Test de Caracterización):** Antes de
  tocar código legacy sin tests, pedir a Codex: "Genera un
  test que capture el comportamiento actual de esta función,
  incluso si está mal. Quiero asegurar que mi refactor no
  cambia la salida."
- **Strangler Fig Pattern:**
  1. Codex crea una nueva función `v2` limpia junto a `v1`.
  2. Se implementa un routing gradual entre ambas versiones.
  3. Si todo va bien, se elimina `v1`.
- **Invariante: NO BEHAVIOUR CHANGE.** Los tests existentes
  deben pasar sin modificación después de cada paso de
  refactorización.

### 2.5. Optimización: Baselines y Big O

Antes de optimizar, siempre medir:

1. **Establecer baseline:** Medir la métrica actual
   (latencia, memoria, complejidad ciclomática).
2. **Pedir la optimización** con el baseline como
   referencia explícita en el prompt.
3. **Medir después:** Comparar con el baseline.
4. **Aceptar solo si mejora** y los tests siguen pasando.

La IA es excelente simplificando lógica anidada (reducir
complejidad ciclomática) y proponiendo algoritmos más
eficientes (ej. O(n²) → O(n log n) o O(n)).

## 3. Buenas Prácticas

1. **"Review First, Fix Later":** No pedir "arregla esto"
   directamente. Usar `/review` primero. Esto permite
   decidir qué arreglar y evita que Codex reescriba el
   archivo entero con su propio estilo.
2. **Micro-Refactors:** Nunca mezclar `feat` y `refactor`
   en el mismo prompt. Limpiar código en un commit separado
   antes de añadir funcionalidad.
3. **Tests de Regresión:** Exigir siempre que Codex ejecute
   tests existentes antes y después del refactor.
4. **Perfil read-only para reviews:** Usar `review-only`
   para que Codex analice sin riesgo de modificar código.
5. **Incremental, no big-bang:** Cada refactor como commit
   atómico. Usar `/review` después de cada paso.
6. **AGENTS.md con Review Guidelines:** Definir qué debe
   revisar Codex para que las revisiones sean consistentes.

## 4. Errores Comunes

1. **Optimización Prematura:** Optimizar una función que se
   ejecuta una vez al día. *Solución:* Enfocarse solo en
   "hot paths". Incluir baseline medible en el prompt.
2. **La Trampa del "Código Inteligente":** Aceptar one-liners
   muy astutos pero imposibles de debugear por humanos.
   *Regla:* Legibilidad > Astucia.
3. **Refactorización sin Red:** Cambiar lógica de negocio
   sin un test de cobertura previo (green baseline).
   *Solución:* Tests de caracterización antes de tocar nada.
4. **Big-bang refactor:** Reescribir un módulo completo en
   un solo commit. *Solución:* Strangler pattern, safe steps.
5. **Review con perfil edit:** Usar `--full-auto` durante
   review. Codex podría modificar código sin supervisión.
   *Solución:* Perfil `review-only` (read-only).

## 5. Casos de Uso Reales

- **Limpieza de Deuda Técnica:** Un equipo dedica los viernes
  a ejecutar `/review` sobre módulos antiguos. Tras
  identificar problemas, usan prompts específicos para
  extraer clases base comunes de código duplicado.
- **Review de Seguridad en CI:** GitHub Action con
  `openai/codex-action@v1` que analiza los ficheros
  cambiados en cada PR. Codex comenta si detecta riesgos
  de seguridad (OWASP Top 10). Prioridades P0/P1.

---

## 6. Laboratorio (L8) — "El Revisor Implacable"

**Escenario:** Tienes un script de procesamiento de datos
"sucio": funciona, pero es lento, inseguro y difícil de
leer. Usaremos `/review` de Codex para auditarlo, blindarlo
con tests y refactorizarlo paso a paso.

### Paso 1: Crear proyecto base

```bash
mkdir /tmp/codex-lab08 && cd /tmp/codex-lab08
git init

python3 -m venv .venv
source .venv/bin/activate
pip install pytest flake8

cat > .gitignore << 'EOF'
.venv/
__pycache__/
*.pyc
EOF

mkdir -p src tests
```

### Paso 2: Crear el "Código Sucio"

Un script que procesa un CSV simulado. Tiene
vulnerabilidades (abre archivos sin validar rutas), es
lento (bucles ineficientes) y tiene un bug de typo.

```bash
cat > src/processor.py << 'PYEOF'
import os

def procesar(archivo):
    # Peligro: Path Traversal - abre cualquier ruta sin validar
    f = open(archivo, 'r')
    lineas = f.readlines()
    datos = []
    for l in lineas:
        partes = l.split(',')
        # Ineficiente: búsqueda lineal O(n) dentro de O(n) = O(n²)
        if len(partes) > 2:
            encontrado = False
            for d in datos:
                if d['id'] == partes[0]:
                    encontrado = True
            if found == False:  # BUG: 'found' no definido (typo)
                datos.append({'id': partes[0], 'val': partes[1]})
    return datos
PYEOF

git add -A && git commit -m "chore: código sucio inicial"
```

### Paso 3: La Auditoría — `/review`

No vamos a arreglarlo todavía. Usaremos `/review` para
obtener hallazgos priorizados.

```bash
codex --profile review-only
# (o: codex → /permissions → Read Only)
```

Escribir en el TUI:

```text
/review
```

Seleccionar **"Review uncommitted changes"** (o "Review
against a base branch" si hay commits previos).

**Resultado Esperado:** Codex identifica:

- **P0 (Bug):** Variable `found` no definida; debería ser
  `encontrado`. El código falla al ejecutarse.
- **P0 (Seguridad):** Path Traversal en `open(archivo)` sin
  validación de ruta. Fichero no se cierra (no usa `with`).
- **P1 (Rendimiento):** Complejidad O(n²) al buscar
  duplicados iterando la lista `datos` cada vez. Debería
  usar un `set` o `dict` para O(n).
- **P1 (Calidad):** Nombres de variables poco descriptivos
  (`l`, `f`, `partes`). Sin docstrings. Sin type hints.

### Paso 4: Crear la rama de feature y el fix mínimo

```bash
git checkout -b fix/processor-review

codex --full-auto
```

Prompt en el TUI:

```text
Corrige SOLO el bug de la variable 'found' en
@src/processor.py (debe ser 'encontrado').
No hagas ningún otro cambio todavía.
Genera @tests/test_processor.py con pytest que cubra:
1. Caso básico con CSV válido (3 columnas, 3 filas).
2. Caso con IDs duplicados (deben filtrarse).
3. Caso con archivo vacío.
Crea un fichero CSV de test temporal en cada test.
Ejecuta pytest.
```

**Observar:** Codex corrige solo el typo y genera tests.
Los tests deben pasar (green baseline).

```bash
PYTHONPATH=. pytest tests/ -v
git add -A && git commit -m "fix: typo found→encontrado + tests"
```

### Paso 5: Refactorización completa

Ahora que tenemos tests (la red de seguridad):

```text
Refactoriza @src/processor.py aplicando las mejoras del
Code Review:
1. Usa 'with open' para cerrar el fichero correctamente.
2. Valida que la ruta sea segura (no path traversal):
   resolver con os.path.realpath y verificar que está
   dentro de un directorio permitido.
3. Optimiza la búsqueda de duplicados de O(n²) a O(n)
   usando un set para los IDs vistos.
4. Mejora nombres de variables y añade type hints.
5. Añade docstring.

NO cambies el comportamiento: los tests existentes
deben pasar sin modificación.
Ejecuta pytest y flake8 al terminar.
```

**Observar:** Codex refactoriza manteniendo los tests verdes.

```bash
PYTHONPATH=. pytest tests/ -v
flake8 src/ tests/
git add -A && git commit -m "refactor: seguridad + O(n) + clean code"
```

### Paso 6: Re-review para confirmar

```bash
codex
```

```text
/review
```

Seleccionar **"Review against a base branch"** → main.

**Observar:** Los hallazgos P0/P1 anteriores (path traversal,
O(n²), bug de typo) deben haber desaparecido. Pueden quedar
sugerencias menores de estilo.

### Paso 7: Verificar resultado

```bash
PYTHONPATH=. pytest tests/ -v
flake8 src/ tests/
git diff main --stat
```

| Verificación | Resultado esperado |
| --- | --- |
| `/review` encontró bugs | P0: typo, P0: path traversal |
| `/review` encontró rendimiento | P1: O(n²) |
| Bug corregido | `encontrado` en lugar de `found` |
| Path traversal corregido | Validación de ruta con `realpath` |
| O(n²) → O(n) | `set` para IDs vistos |
| Tests originales pasan | Green baseline mantenido |
| Nuevos tests cubren edge cases | Duplicados, vacío, básico |
| Lint limpio | `flake8` sin errores |
| Re-review sin P0/P1 | Hallazgos graves eliminados |

### Paso 8: Limpieza (Protocolo Obligatorio)

```bash
deactivate
rm -rf /tmp/codex-lab08

ls /tmp/codex-lab08 2>/dev/null \
  && echo "ERROR: aún existe" \
  || echo "OK: limpio"
```
