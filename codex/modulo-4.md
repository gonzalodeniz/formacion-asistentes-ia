# Módulo 4: Gestión Avanzada del Contexto y Flujos Agénticos

> **Duración estimada:** 90 minutos (45 min teoría + 45 min laboratorio)
> **Referencias:**
> [Codex Workflows](https://developers.openai.com/codex/workflows/) |
> [AGENTS.md](https://developers.openai.com/codex/guides/agents-md/)

---

## 1. Objetivos de Aprendizaje

1. **Dominar el "Steering" (Pilotaje):** Aprender a guiar a Codex usando
   referencias precisas (`@file`) y mid-turn steering en lugar de "volcar"
   todo el código.
2. **Arquitectura de Contexto Persistente:** Implementar archivos
   **`AGENTS.md`** para definir las convenciones y restricciones del agente
   a nivel de repositorio.
3. **Ingeniería de Prompts Estructurada:** Crear prompts con la estructura
   Brief + Constraints + Definition of Done + Validation Commands para
   garantizar *diffs* pequeños y atómicos.

---

## 2. Contenidos Teóricos

### 2.1. La Economía de la Atención en los modelos Codex

Aunque los modelos Codex tienen ventanas de contexto grandes (hasta 400K
tokens), más contexto no siempre es mejor. El exceso de información
irrelevante degrada la capacidad de razonamiento y produce resultados
genéricos.

**Estrategia: contexto quirúrgico con `@` references.**

En lugar de cargar todo el repositorio, referencia solo los ficheros
relevantes:

- *Mal:* `"Arregla el bug en el login."` (El modelo lee todo y adivina
  dónde está el problema).
- *Bien:* `"Arregla el error de timeout en @src/auth/controller.py usando
  la configuración de @config/timeouts.json."` (El modelo se centra en los
  ficheros indicados).

> **Nota:** En el **CLI**, escribe `@` en el composer y empieza a escribir
> el nombre del fichero. Codex abre un buscador fuzzy sobre el workspace y
> puedes pulsar Tab/Enter para insertar la ruta. En la **extensión IDE**,
> los ficheros abiertos en el editor se incluyen automáticamente como
> contexto.

### 2.2. Contexto Persistente: `AGENTS.md`

A diferencia de `PLANS.md` (que gestiona el *progreso* de una tarea
larga), **`AGENTS.md`** define las *convenciones y reglas permanentes* del
proyecto. Codex lo lee automáticamente al iniciar cada sesión como parte
de su cadena de instrucciones.

**Cómo funciona la cadena de descubrimiento:**

1. **Scope global:** Codex lee `AGENTS.md` (o `AGENTS.override.md`) desde
   `~/.codex/` (el "home" de Codex).
2. **Scope de proyecto:** Desde la raíz del repo Git hasta el directorio
   de trabajo actual (CWD), Codex busca `AGENTS.md` en cada directorio
   intermedio. Los directorios más cercanos al CWD sobreescriben los
   anteriores.
3. **Fusión:** Las instrucciones se fusionan en orden de precedencia.
   Los `AGENTS.override.md` tienen prioridad sobre `AGENTS.md` en el
   mismo directorio.

> **Requisito:** El proyecto debe estar marcado como **trusted** para que
> Codex cargue los ficheros `.codex/` y `AGENTS.md` del repositorio. En
> caso contrario, se ignoran silenciosamente.

**Estructura recomendada de un `AGENTS.md`:**

```markdown
# Convenciones del proyecto

## Estilo de código
- Python 3.12 con type hints obligatorios.
- Formatter: black (línea máxima 88 chars).
- Linter: flake8 con max-line-length 88.
- Naming: snake_case para funciones y variables.

## Comandos de validación
- Tests: `PYTHONPATH=. pytest tests/ -v`
- Lint: `flake8 src/`
- Formato: `black --check src/`

## Restricciones
- No añadir dependencias de producción sin aprobación explícita.
- No modificar ficheros en legacy/ sin permiso.
- No usar import * en ningún caso.
- Mantener cobertura de tests > 80%.
```

> **Nota:** `AGENTS.md` no es un prompt de "persona". No escribas
> instrucciones como "Eres un Senior Backend Engineer". `AGENTS.md` está
> diseñado para convenciones de proyecto, comandos de validación y
> restricciones técnicas que se aplican a todo el equipo.

### 2.3. Funcionalidades CLI Avanzadas

La CLI de Codex permite gestionar el contexto de forma precisa:

- **`@referencia` en el composer:** Vincula ficheros específicos al
  prompt. Escribe `@` y usa Tab para autocompletar rutas del workspace.
- **`/review`:** Comando slash que lanza un reviewer dedicado. Lee el diff
  actual y reporta hallazgos priorizados y accionables **sin tocar el
  working tree**. Se puede personalizar con instrucciones:
  `/review Focus on security and edge cases`.
- **Mid-turn steering:** Pulsa **Enter** mientras Codex está trabajando
  para inyectar instrucciones correctivas sin perder el contexto. Pulsa
  **Tab** para encolar un follow-up para el siguiente turno.
- **`codex --cd <path>`:** Lanza Codex con el workspace acotado a un
  subdirectorio. El sandbox `workspace-write` restringe la escritura a ese
  directorio.
- **`codex --add-dir <path>`:** Añade directorios adicionales como
  accesibles (para lectura o escritura según el sandbox).
- **`! comando`:** Ejecuta un comando shell local desde el composer
  (ej. `!git status`, `!ls src/`). Codex trata el output como contexto.

> **Nota:** No existen flags `--read-only`, `--patch` ni `--context` en
> el CLI de Codex. Para modo solo lectura, usa
> `--sandbox read-only`. Para acotar cambios, usa constraints en el
> prompt.

---

## 3. Buenas Prácticas: Plantillas de Prompting

Para evitar resultados impredecibles, estandarizamos la petición según el
tipo de tarea usando la estructura de cuatro bloques.

### A. Plantilla "Feature" (Nueva funcionalidad)

```text
## Brief
Implementa la interfaz definida en @src/interfaces/base.ts siguiendo las
reglas de negocio de @docs/spec.md.

## Constraints
- Crea un nuevo archivo en src/features/.
- No modifiques la interfaz base.
- No añadas dependencias externas.
- Máximo 80 líneas nuevas.

## Definition of Done
- La nueva clase implementa todos los métodos de la interfaz.
- Tests unitarios cubren happy path + 2 edge cases.

## Validation Commands
- npm test -- --testPathPattern=features
- npm run lint
- Muestra resultados.
```

### B. Plantilla "Refactor" (Mantenimiento)

```text
## Brief
Refactoriza la función process_data en @src/legacy_module.py para reducir
su complejidad ciclomática extrayendo subfunciones.

## Invariant
- NO BEHAVIOUR CHANGE: la funcionalidad externa debe ser idéntica.
- Todos los tests existentes deben pasar SIN MODIFICACIÓN.
- No cambiar la firma de process_data().

## Constraints
- Solo modifica src/legacy_module.py.
- Añade type hints a las funciones nuevas.
- Funciones auxiliares con máximo 15 líneas.

## Validation Commands
- PYTHONPATH=. pytest tests/ -v
- flake8 src/legacy_module.py
- git diff --stat
- Muestra resultados.
```

### C. Plantilla "Bugfix" (Corrección)

```text
## Bug Description
Error de timeout en el flujo de login. El token expira durante la
request pero no se renueva automáticamente.

## Reproduction Steps
1. Iniciar sesión con token válido.
2. Esperar a que el token expire (mock time).
3. Hacer una request autenticada.
4. Esperado: renovación automática. Actual: error 401.

## Constraints
- Solo modifica src/auth/middleware.py.
- Fix mínimo: la menor cantidad de cambios posible.
- No cambiar la API pública.

## Fix + Regression
1. Explica la causa raíz.
2. Genera un test de regresión que falle SIN el fix.
3. Implementa el fix para que el test pase.

## Validation Commands
- PYTHONPATH=. pytest tests/auth/ -v
- Muestra resultados.
```

---

## 4. Errores Comunes

1. **Context Dumping:** Abrir decenas de ficheros irrelevantes en el IDE o
   referenciar carpetas enteras con `@`. *Consecuencia:* Codex pierde foco
   entre ficheros irrelevantes y genera código genérico o toca ficheros
   que no debería.
   *Solución:* Referenciar solo los 2-3 ficheros directamente relevantes.
   Usar `codex --cd` para acotar el workspace.
2. **Falta de "Definition of Done":** No especificar qué constituye el
   éxito ni qué comandos de validación ejecutar. *Consecuencia:* Codex
   entrega código que parece correcto pero no se ejecuta ni se valida.
   *Solución:* Terminar siempre el prompt con comandos de validación
   explícitos.
3. **Ignorar el `AGENTS.md`:** Trabajar en equipo sin un archivo de
   convenciones compartido. *Consecuencia:* Cada desarrollador obtiene
   estilos de código diferentes del mismo modelo.
   *Solución:* Versionar `AGENTS.md` en el repo junto con
   `.codex/config.toml`.

---

## 5. Casos de Uso Reales

- **Aislamiento en Monorepos:** Usar `codex --cd packages/ui-library`
  para restringir el workspace del agente solo a ese directorio. Si
  necesita acceso de lectura a tipos compartidos:
  `codex --cd packages/ui-library --add-dir ../shared/types`. El sandbox
  `workspace-write` impide que escriba fuera de `ui-library/`.
- **Onboarding Interactivo:** Un nuevo desarrollador pregunta:
  *"¿Cómo funciona la autenticación?"*. Inicia Codex en sandbox
  `read-only` y usa `@src/auth/middleware.ts` y `@src/auth/session.ts`
  como contexto. Codex explica el flujo sin riesgo de modificar nada.

---

## 6. Laboratorio Práctico (L4): Prompting con Guardrails y Reducción de Diffs

**Escenario:** Tienes una función "God Object" (gigante y desordenada) en
Python. Debemos refactorizarla usando `AGENTS.md` para asegurar calidad y
referencias `@` para precisión.

**Objetivo:** Extraer lógica a funciones pequeñas sin romper la ejecución,
guiado por reglas estrictas en `AGENTS.md`.

### Paso 1: Configurar el Entorno y el "Desastre"

Crea el directorio, inicializa Git, crea un entorno virtual de Python
y genera los archivos necesarios.

```bash
mkdir /tmp/codex-lab04 && cd /tmp/codex-lab04
git init

# 1. Crear entorno virtual e instalar dependencias
python3 -m venv .venv
source .venv/bin/activate    # Windows: .venv\Scripts\activate
pip install pytest flake8

# 2. Crear .gitignore (excluir venv del repo)
cat <<'EOF' > .gitignore
.venv/
__pycache__/
*.pyc
EOF

# 3. Crear el archivo de convenciones del proyecto
cat <<'EOF' > AGENTS.md
# Convenciones del proyecto

## Estilo de código
- Usa snake_case para funciones y variables.
- Añade type hints (módulo typing si es necesario).
- Mantén las funciones con menos de 15 líneas.
- Docstrings en formato Google.

## Comandos de validación
- Tests: `pytest test_processor.py -v`
- Lint: `flake8 *.py`

## Restricciones
- No renombrar funciones públicas existentes.
- No cambiar firmas de funciones públicas.
- No añadir dependencias externas.

## Entorno
- El proyecto usa un entorno virtual en .venv/.
- Ejecutar siempre los comandos con el venv activado.
EOF

# 4. Crear el código legado (God Object)
cat <<'EOF' > legacy_processor.py
def super_process(data):
    # Esta funcion hace demasiadas cosas
    results = []
    for item in data:
        if item > 10:
            print("Processing large item")
            val = item * 2
            if val > 50:
                val = val - 5
            results.append(val)
        else:
            print("Skipping small item")
    total = sum(results)
    print(f"Total: {total}")
    return results
EOF

# 5. Verificar que el entorno funciona
python --version
pytest --version
flake8 --version

# 6. Commit inicial (Codex funciona mejor con repos Git)
git add -A && git commit -m "chore: scaffold lab04 con deuda técnica"
```

> **Nota:** Codex hereda las variables de entorno del shell
> donde se lanza. Al activar el venv **antes** de ejecutar
> `codex`, el agente usará automáticamente el Python y las
> herramientas del entorno virtual (.venv/bin/python,
> .venv/bin/pytest, etc.).

### Paso 2: Ejecución sin Contexto (El "Mal" ejemplo)

Intenta (o simula) pedir un refactor genérico sin estructura:

```text
"Mejora este código."
```

**Resultado típico sin guardrails:** El modelo podría cambiar `print` por
`logging`, cambiar la lógica de negocio, renombrar la función
`super_process` (rompiendo compatibilidad externa), o reformatear todo el
fichero sin criterio claro.

### Paso 3: Ejecución con Guardrails (El Camino Correcto)

Usaremos el CLI con prompt estructurado. Codex lee `AGENTS.md`
automáticamente porque está en la raíz del repo Git.

**Instrucción al alumno:** Asegúrate de que el entorno virtual
está activo y lanza Codex en modo interactivo:

```bash
cd /tmp/codex-lab04
source .venv/bin/activate    # Windows: .venv\Scripts\activate
codex --full-auto
```

En el TUI (Terminal User Interface) que se abre, escribe el prompt:

```text
## Brief
Refactoriza la función super_process en @legacy_processor.py:
Extrae la lógica de cálculo a una función privada _calculate_val(item).

## Invariant
- NO BEHAVIOUR CHANGE: la función super_process debe retornar
  exactamente el mismo resultado para los mismos inputs.
- NO cambies los prints ni el nombre de la función principal.

## Constraints
- Solo modifica legacy_processor.py.
- Añade type hints a todas las funciones (como pide AGENTS.md).
- Funciones auxiliares con máximo 15 líneas.

## Validation
- Crea un fichero test_processor.py con tests que verifiquen que
  super_process([5, 12, 30]) retorna el mismo resultado que antes.
- Ejecuta: pytest test_processor.py -v
- Ejecuta: flake8 legacy_processor.py
- Muestra resultados.
```

### Paso 4: Revisión y Validación (`/review`)

Una vez que Codex completa los cambios, ejecuta el comando de revisión
antes de hacer commit:

1. Escribe `/review` en el TUI de Codex.
2. Codex lanza un reviewer dedicado que lee el diff y reporta hallazgos
   priorizados **sin tocar el working tree**.
3. Verifica en el reporte:
   - ¿Creó `_calculate_val` con type hints?
   - ¿Mantuvo los prints intactos?
   - ¿La firma de `super_process` no cambió?
   - ¿Los tests pasan?
4. Si el review detecta problemas, pide a Codex que los corrija.
5. Repite `/review` hasta que no haya hallazgos.

### Paso 5: Verificación de Integridad

Verifica manualmente que la lógica no cambió (con el venv activo):

```bash
# Ejecutar el procesador con datos de prueba
python -c "
from legacy_processor import super_process
print(super_process([5, 12, 30]))
"
# Esperado: [24, 55] (12*2=24, 30*2-5=55)

# Ejecutar tests formales
pytest test_processor.py -v

# Verificar que el diff es pequeño y acotado
git diff --stat
```

Haz commit si todo está correcto:

```bash
git add -A && git commit -m "refactor: extraer _calculate_val de super_process"
```

### Paso 6: Limpieza (Protocolo Obligatorio)

```bash
# 1. Desactivar el entorno virtual
deactivate

# 2. Eliminar todo el entorno del laboratorio
rm -rf /tmp/codex-lab04

# 3. Verificar
ls /tmp/codex-lab04 2>/dev/null \
  && echo "ERROR: aún existe" \
  || echo "OK: limpio"
```
