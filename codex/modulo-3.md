# Módulo 3 — Estrategia de Modelos: La Familia GPT-5 y Codex

**Duración estimada:** 90 minutos
**Documentación de referencia:** [OpenAI Codex Models](https://developers.openai.com/codex/models/) | [GPT-5.3 Launch](https://openai.com/index/introducing-gpt-5-3-codex/)

## Objetivos de Aprendizaje

1. Dominar la **Matriz de Selección GPT-5**: Diferenciar entre velocidad (**GPT-5.3-Codex**), profundidad (**GPT-5.2-Codex**) y capacidad de retención masiva (**GPT-5.1-Codex-Max**).
2. Implementar el protocolo **`PLANS.md`** para tareas de larga duración (multi-hour tasks).
3. Optimizar el **Budget de Computación**: Cuándo usar cada nivel de `reasoning_effort` (`low` / `medium` / `high` / `xhigh`) en tareas de programación.

## Contenidos Teóricos

### 1. El Nuevo Ecosistema (Post-2025)

Ya no elegimos solo por "inteligencia", sino por **rol operativo**:

* **GPT-5.3-Codex ("The Sprinter"):**
  * *Perfil:* El modelo más reciente y avanzado. Combina el rendimiento de codificación frontier de GPT-5.2-Codex con capacidades de razonamiento y conocimiento profesional de GPT-5.2, y es un 25% más rápido.
  * *Uso:* Desarrollo diario interactivo (CLI e IDE), generación de features, debugging, code review, TDD.
  * *Novedad:* Mejor colaboración en tiempo real: actualizaciones de progreso más frecuentes y respuesta a *steering* (instrucciones mid-turn) sin perder contexto.

* **GPT-5.2-Codex ("The Specialist"):**
  * *Perfil:* Modelo anterior de referencia, optimizado para coding agéntico de larga duración con context compaction nativa.
  * *Uso:* Refactorizaciones masivas, migraciones de lenguaje, análisis de ciberseguridad, entornos Windows.
  * *Feature Clave:* Actualmente el modelo Codex más avanzado disponible en la API (`gpt-5.2-codex`).

* **GPT-5.1-Codex-Max ("The Architect"):**
  * *Perfil:* Primer modelo nativo con compaction multi-contexto. Más lento pero capaz de trabajar coherentemente durante horas sobre millones de tokens.
  * *Uso:* Refactorización de arquitectura a gran escala, migraciones de lenguaje completas, auditorías de seguridad en monolitos.
  * *Feature Clave:* Soporte nativo para tareas autónomas de más de 7 horas con compaction automática.

* **GPT-5.1-Codex-Mini ("The Economist"):**
  * *Perfil:* Versión más pequeña y económica de GPT-5.1-Codex. Extiende los límites de uso del plan ~4x.
  * *Uso:* Tareas masivas y repetitivas (CI/CD, documentación, linting semántico, renombrados), donde el output es validable por tests.

> **Nota:** No existe un modelo llamado "GPT-5-Nano". El modelo económico de la familia Codex es **GPT-5.1-Codex-Mini** (identificador: `gpt-5.1-codex-mini`).

### 2. Protocolo de Agentes: `PLANS.md`

Con la llegada de las capacidades "Agentic" en los modelos Codex, OpenAI documentó el uso del archivo **`PLANS.md`** como patrón recomendado para tareas de larga duración.

* **¿Qué es?** Un fichero en la raíz del repo que el agente Codex lee como parte de sus instrucciones (vía `AGENTS.md`) y que puede actualizar autónomamente para mantener el estado en tareas largas.
* **Estructura recomendada:** Contiene `Purpose / Big Picture`, `Progress` (con checkboxes), `Surprises & Discoveries`, `Decision Log` y `Outcomes & Retrospective`. Evita que el agente "se pierda" cuando trabaja durante horas.
* **Activación:** Se habilita referenciando `PLANS.md` desde `AGENTS.md`. El modelo no lo lee automáticamente solo por existir; necesita la instrucción en `AGENTS.md`.
* **Documentación oficial:** [Using PLANS.md for multi-hour problem solving](https://developers.openai.com/cookbook/articles/codex_exec_plans/)

### Guía de Decisión (Matriz GPT-5)

| Tipo de Tarea | Modelo Recomendado | Configuración | ¿Por qué? |
| --- | --- | --- | --- |
| **Fix rápido / Hotfix** | **GPT-5.3-Codex** | `codex --full-auto` (Interactive) | 25% más rápido. Scope acotado con validación por tests. |
| **Migración (ej. Java 8 → 21)** | **GPT-5.1-Codex-Max** | `codex cloud exec` + `PLANS.md` | Requiere compaction multi-contexto para 500+ archivos durante horas. |
| **Generación de Tests Unitarios** | **GPT-5.3-Codex** | `codex --full-auto`, effort `medium` | Tarea bien definida con output directamente verificable. |
| **Documentación de API** | **GPT-5.1-Codex-Mini** | `codex --profile quick`, effort `low` | Tarea mecánica de bajo coste. Extiende límites de uso ~4x. |
| **Debugging de Concurrencia** | **GPT-5.3-Codex** | effort `high` | Razonamiento profundo necesario pero sin duración extrema. |

### Buenas Prácticas

1. **Regla del 5.3 por defecto:** Configura tu IDE (VS Code/Cursor) para usar **GPT-5.3-Codex** con `medium` reasoning effort en el chat diario. Es el modelo más avanzado, 25% más rápido que su predecesor, y está incluido en los planes de ChatGPT.
2. **No uses Max para el "Hola Mundo":** Invocar a **GPT-5.1-Codex-Max** con `xhigh` reasoning consume muchos más tokens de razonamiento. Úsalo solo cuando la tarea requiera compaction multi-contexto (proyectos grandes, duración >1 hora).
3. **Gestión de `PLANS.md`:** Nunca edites manualmente el apartado `Progress` del archivo `PLANS.md` mientras el agente está ejecutándose; podrías provocar inconsistencias de estado. Usa mid-turn steering (pulsa `Enter` durante la ejecución) para redirigir al agente si es necesario.
4. **Usa Mini para maximizar límites:** Cambia a **GPT-5.1-Codex-Mini** con `codex -m gpt-5.1-codex-mini` para tareas simples (docstrings, renombrados, formateo). Extiende tus límites de uso ~4x.

### Errores Comunes

* **"Agent Drift":** Lanzar una tarea de refactorización de 2 horas con **GPT-5.3-Codex** en `medium` reasoning sin `PLANS.md` ni `AGENTS.md`. Sin instrucciones de persistencia, el agente puede perder el hilo tras la compaction del contexto.
* **Over-contextualization:** Ejecutar Codex desde la raíz de un monorepo completo en lugar de usar `codex --cd services/api` para acotar el scope. Para repositorios muy grandes, preferir Codex Cloud o GPT-5.1-Codex-Max con `PLANS.md`.
* **Usar xhigh para todo:** El reasoning effort `xhigh` genera cientos de miles de tokens de pensamiento. Agota rate limits rápidamente. Usar `medium` como daily driver y escalar solo cuando la tarea lo requiera.

### Casos de Uso Reales (2025-2026)

* **Empresa Fintech:** Usa **GPT-5.1-Codex-Max** con `codex exec` en pipelines nocturnos para auditar código legacy COBOL y generar informes de equivalencia en Java. Las tareas duran horas y usan `PLANS.md` para mantener el estado.
* **Startup SaaS:** Usa **GPT-5.3-Codex** integrado en la extensión IDE de VS Code para que cada desarrollador tenga asistencia interactiva instantánea, con **GPT-5.1-Codex-Mini** configurado como perfil `quick` para tareas repetitivas.

---

## Laboratorio L3: Velocidad vs. Profundidad (GPT-5.3-Codex vs GPT-5.1-Codex-Max)

**Tiempo estimado:** 25-30 minutos
**Objetivo:** Experimentar la diferencia entre una **interacción interactiva rápida** (fix con GPT-5.3-Codex) y un **flujo agéntico autónomo** (refactorización arquitectural con GPT-5.1-Codex-Max usando el protocolo `PLANS.md`).

**Requisitos previos:**

* Terminal (Bash/Zsh o PowerShell).
* Python 3 instalado.
* Codex CLI instalado (`npm i -g @openai/codex`) y autenticado.
* Acceso a GPT-5.3-Codex y GPT-5.1-Codex-Max (plan ChatGPT Plus/Pro/Business/Enterprise).

---

### Paso 1: Preparación del entorno "Legacy"

Vamos a crear un escenario de "código espagueti" que servirá de base para nuestras pruebas.

1. Abre tu terminal.
2. Crea el directorio del laboratorio, inicializa Git y entra en él:

```bash
mkdir /tmp/lab-gpt5-bench
cd /tmp/lab-gpt5-bench
git init
```

1. Crea un archivo llamado `processor.py` con código deficiente (sin funciones, variables globales, difícil de leer):

```bash
cat <<'EOF' > processor.py
data = ["  user_1:admin  ", "user_2:guest", "user_3:admin", "err:"]
out = []
for i in data:
    if ":" in i:
        parts = i.split(":")
        if parts[1].strip() == "admin":
            out.append(parts[0].strip().upper())
print(out)
EOF
```

> **Windows (PowerShell):** Crea el archivo manualmente con el contenido anterior o usa WSL2.

1. Haz un commit inicial (Codex recomienda repos versionados):

```bash
git add -A && git commit -m "chore: scaffold legacy processor"
```

---

### Paso 2: El Velocista (GPT-5.3-Codex)

En este paso usaremos **GPT-5.3-Codex**. Este modelo combina rendimiento frontier con velocidad (25% más rápido). Lo usaremos para una tarea de **corrección puntual**.

**Instrucción al alumno:**
Queremos añadir *Type Hints* y docstrings, pero sin cambiar la lógica. Necesitamos que sea rápido.

1. Ejecuta Codex en modo interactivo con GPT-5.3-Codex:

```bash
codex -m gpt-5.3-codex --full-auto
```

1. En el TUI (Terminal User Interface) que se abre, escribe el prompt:

```text
Añade type hints y docstrings a processor.py. No cambies la lógica.
```

1. Codex mostrará el plan y ejecutará los cambios. Verifica el resultado:

```bash
cat processor.py
```

1. Sal de la sesión interactiva con `Ctrl+C` o `/exit`.

**Observación esperada:**
Verás que el código ha sido modificado con type hints y docstrings añadidos. El modelo ejecutó la instrucción de forma rápida sin replantearse la arquitectura. Es ideal para tareas de scope acotado.

---

### Paso 3: El Arquitecto (GPT-5.1-Codex-Max + PLANS.md)

Ahora abordaremos un escenario complejo. Queremos transformar este script en una arquitectura orientada a objetos (OOP) robusta. Usaremos **GPT-5.1-Codex-Max** con el protocolo de planificación `PLANS.md`, referenciado desde `AGENTS.md`.

1. **Crear las instrucciones del proyecto (`AGENTS.md`):**

```bash
cat <<'EOF' > AGENTS.md
# Instrucciones del proyecto

## Convenciones
- Python 3.12 con type hints obligatorios.
- Tests con pytest.
- Docstrings en formato Google.

## ExecPlans
Cuando trabajes en refactorizaciones complejas, usa PLANS.md como
documento de planificación vivo. Actualiza el apartado Progress
con checkboxes a medida que completes cada paso.
EOF
```

1. **Crear el Plan Maestro (`PLANS.md`):**

```bash
cat <<'EOF' > PLANS.md
# Refactorizar processor.py a Arquitectura OOP limpia

## Purpose / Big Picture
Transformar el script procedural processor.py en una arquitectura
orientada a objetos con validación, separación de responsabilidades
y tests unitarios.

## Progress
- [ ] Definir clase UserProcessor con método process()
- [ ] Implementar validación de errores (try/except para entries malformadas)
- [ ] Separar lógica de negocio de la impresión (print)
- [ ] Añadir tests unitarios en test_processor.py
- [ ] Ejecutar pytest y verificar que pasan

## Decision Log
(El agente registrará aquí las decisiones de diseño)

## Outcomes & Retrospective
(Se completará al finalizar)
EOF
```

1. **Hacer commit antes de la refactorización:**

```bash
git add -A && git commit -m "chore: añadir AGENTS.md y PLANS.md"
```

1. **Invocar al agente con GPT-5.1-Codex-Max y reasoning effort alto:**

```bash
codex -m gpt-5.1-codex-max \
  --config 'model_reasoning_effort="high"' \
  --full-auto \
  "Ejecuta el plan de refactorización descrito en PLANS.md. \
   Actualiza el Progress a medida que completes cada paso. \
   Al terminar, ejecuta pytest para verificar."
```

> **Nota:** El flag `--full-auto` equivale a `--sandbox workspace-write --ask-for-approval on-request`, permitiendo que el agente escriba ficheros y ejecute comandos con aprobación mínima.

1. **Monitorización (lo que sucede "bajo el capó"):**
    * El agente leerá `AGENTS.md` y `PLANS.md` antes de empezar.
    * Verás reasoning summaries en el TUI indicando el progreso.
    * Puedes usar **mid-turn steering** (pulsa `Enter` mientras trabaja) para redirigirlo si es necesario.

2. **Verificación del Progreso:**
    Cuando el agente termine, revisa el plan actualizado:

```bash
cat PLANS.md
```

*Deberías ver que las casillas `[ ]` han cambiado a `[x]` a medida que el agente completó cada paso.*

1. **Verificación del Resultado:**
    Lista los archivos para ver qué ha creado el agente:

```bash
ls -la
```

Deberías ver ahora:

* `processor.py` — Refactorizado con clase `UserProcessor`.
* `test_processor.py` — Archivo nuevo creado por el agente.
* `PLANS.md` — Actualizado con progreso y decisiones.

1. **Ejecutar los tests:**

```bash
pip install pytest  # si no está instalado
PYTHONPATH=. pytest test_processor.py -v
```

1. **Analizar la calidad:**

```bash
cat processor.py
```

**Observación:** Observa que **GPT-5.1-Codex-Max** ha tomado decisiones de diseño (crear métodos privados, manejar excepciones) que no estaban explícitas, gracias a su mayor capacidad de razonamiento con `high` effort y al contexto proporcionado por `AGENTS.md` y `PLANS.md`.

---

### Paso 4: Comparativa de Coste y Latencia

Discute (o reflexiona) sobre los siguientes datos estimados de la ejecución:

| Métrica | Tarea Paso 2 (GPT-5.3-Codex) | Tarea Paso 3 (GPT-5.1-Codex-Max) |
| --- | --- | --- |
| **Tiempo** | ~5-15 segundos | ~30-90 segundos |
| **Reasoning tokens** | Pocos cientos (medium) | Miles a decenas de miles (high) |
| **Archivos tocados** | 1 (Edición) | 3 (Edición + Creación + PLANS.md) |
| **Modo** | Interactivo rápido | Agéntico con planificación |
| **Reasoning effort** | medium (default) | high |

**Lección:** Si hubieras usado GPT-5.1-Codex-Max con `high` reasoning para poner los type hints del Paso 2, habrías consumido significativamente más tokens de razonamiento y tiempo para el mismo resultado. La clave es **emparejar el modelo y effort con la complejidad real de la tarea**.

---

### Paso 5: Limpieza (obligatoria)

Como buenos profesionales, no dejamos código de prueba en el disco.

1. Borra el directorio completo del laboratorio:

```bash
cd /tmp
rm -rf /tmp/lab-gpt5-bench
```

1. Verifica que no queda nada:

```bash
ls /tmp/lab-gpt5-bench 2>/dev/null && echo "ERROR: aún existe" || echo "OK: limpio"
```

> **Nota:** Codex no tiene un comando `codex clean`. Los transcripts de sesiones se almacenan localmente en `~/.codex/` y se pueden consultar con `codex resume`. No es necesario borrarlos salvo que contengan información sensible, en cuyo caso se puede borrar el directorio `~/.codex/sessions/`.
