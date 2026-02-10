# Módulo 4: Gestión Avanzada del Contexto y Flujos Agénticos

> **Duración estimada:** 90 minutos (45 min teoría + 45 min laboratorio)
> **Referencias:** [Codex Workflows](https://developers.openai.com/codex/workflows/) | [AGENTS.md Guide](https://developers.openai.com/codex/guides/agents-md/)

---

## 1. Objetivos de Aprendizaje

1. **Dominar el "Steering" (Pilotaje):** Aprender a guiar al modelo **GPT-5** usando referencias precisas (`@file`, `@symbol`) en lugar de "volcar" todo el código.
2. **Arquitectura de Contexto Persistente:** Implementar archivos **`AGENTS.md`** para definir el comportamiento y las restricciones del agente a nivel de repositorio.
3. **Ingeniería de Prompts Estructurada:** Crear prompts que minimicen la "deriva" (hallucinations) y garanticen *diffs* pequeños y atómicos.

---

## 2. Contenidos Teóricos

### 2.1. La Economía de la Atención en GPT-5

Aunque los modelos actuales tienen ventanas de contexto enormes (1M+ tokens), más contexto no siempre es mejor. El exceso de información provoca **"Context Pollution"** (ruido), lo que degrada la capacidad de razonamiento.

* **Estrategia "Needle in a Haystack":** No le des el pajar entero. Usa referencias explícitas.
* *Mal:* "Arregla el bug en el login." (El modelo lee todo y adivina).
* *Bien:* "Arregla el error de timeout en `@auth_controller.py` usando la configuración de `@timeout_config.json`."

### 2.2. Contexto Persistente: `AGENTS.md`

A diferencia de `PLANS.md` (que gestiona el *progreso* de una tarea), **`AGENTS.md`** define la *identidad y reglas* inmutables del proyecto. El modelo lo lee automáticamente al iniciar.

**Estructura típica de un `AGENTS.md`:**

```markdown
# Agent Persona
Eres un Senior Backend Engineer experto en Django.

# Guardrails (Límites)
- NUNCA commitees credenciales.
- PREFIERE composición sobre herencia.
- SIEMPRE usa type hints en Python.
- LÍMITE: No toques archivos en /legacy/* sin permiso explícito.

```

### 2.3. Funcionalidades CLI Avanzadas (`@` y `/review`)

La CLI moderna de Codex permite inyectar contexto quirúrgico:

* **`@referencia`**: Vincula archivos, carpetas o incluso símbolos de función específicos al prompt.
* **`/review`**: Un comando especial que pide al modelo que critique su propio diff *antes* de aplicarlo al disco, reduciendo errores lógicos.
* **Steering Mode:** Uso de flags como `--read-only` para que el agente analice sin riesgo de modificar, o `--patch` para forzar cambios pequeños.

---

## 3. Buenas Prácticas: Plantillas de Prompting

Para evitar resultados impredecibles, estandarizamos la petición según el tipo de tarea.

### A. Plantilla "Feature" (Nueva funcionalidad)

> **Contexto:** `@spec_doc.md`, `@interface_base.ts`
> **Prompt:** "Implementa la interfaz definida en `@interface_base.ts` siguiendo las reglas de negocio de `@spec_doc.md`.
> **Restricciones:**
>
> 1. Crea un nuevo archivo en `src/features/`.
> 2. No modifiques la interfaz base.
> 3. Incluye tests unitarios."
>

### B. Plantilla "Refactor" (Mantenimiento)

> **Contexto:** `@legacy_module.py`
> **Prompt:** "Refactoriza la función `process_data` en `@legacy_module.py` para reducir su complejidad ciclomática.
> **Guardrail Crítico:** NO cambies el comportamiento observable (comportamiento de caja negra).
> **Validación:** Ejecuta `pytest legacy_module.py` antes y después para confirmar que no hay regresión."

### C. Plantilla "Bugfix" (Corrección)

> **Contexto:** `@error.log`, `@failing_component.tsx`
> **Prompt:** "Analiza el stacktrace en `@error.log`. Identifica la línea culpable en `@failing_component.tsx`.
>
> 1. Explica la causa raíz.
> 2. Genera un test que reproduzca el fallo (debe fallar).
> 3. Aplica el fix para que el test pase."
>
>

---

## 4. Errores Comunes

1. **Context Dumping:** Copiar y pegar 50 archivos en el chat del IDE. *Consecuencia:* El modelo se "diluye", olvida las instrucciones iniciales y genera código genérico.
2. **Falta de "Definition of Done":** No especificar qué constituye el éxito (ej. "que pasen los tests"). *Consecuencia:* El modelo entrega código que compila pero no funciona lógicamente.
3. **Ignorar el `AGENTS.md`:** Trabajar en un equipo sin un archivo de reglas compartido. *Consecuencia:* Cada desarrollador obtiene estilos de código diferentes del mismo modelo.

---

## 5. Casos de Uso Reales

* **Aislamiento en Monorepos:** En un repo gigante de Google/Meta, usar la flag `--cd packages/ui-library` para restringir la visión del agente solo a ese directorio, evitando que importe dependencias del backend por error.
* **Onboarding Interactivo:** Un nuevo desarrollador pregunta: *"¿Cómo funciona la autenticación?"*. El agente usa `@auth_flow.mermaid` y `@login_controller.java` para explicarlo, ignorando el resto del sistema.

---

## 6. Laboratorio Práctico (L4): Prompting con Guardrails y Reducción de Diffs

**Escenario:** Tienes una función "God Object" (gigante y desordenada) en Python. Debemos refactorizarla usando `AGENTS.md` para asegurar calidad y referencias (`@`) para precisión.

**Objetivo:** Extraer lógica a funciones pequeñas sin romper la ejecución, guiado por reglas estrictas.

### Paso 1: Configurar el Entorno y el "Desastre"

Crea el directorio y los archivos necesarios.

```bash
mkdir codex-lab04
cd codex-lab04

# 1. Crear el archivo de reglas del Agente
cat <<EOF > AGENTS.md
# Code Style
- Usa Snake Case para funciones.
- Añade Type Hints (typing module).
- Mantén las funciones con menos de 15 líneas.
EOF

# 2. Crear el código legado (God Object)
cat <<EOF > legacy_processor.py
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

```

### Paso 2: Ejecución sin Contexto (El "Mal" ejemplo)

Intenta (o simula) pedir un refactor genérico.

* *Prompt simulado:* "Mejora este código."
* *Resultado típico:* El modelo podría cambiar `print` por `logging`, cambiar la lógica de negocio o renombrar la función `super_process`, rompiendo la compatibilidad externa.

### Paso 3: Ejecución con "Steering" (El Camino Correcto)

Usaremos la CLI con referencias explícitas y guardrails.

**Instrucción al alumno:** Escribe el siguiente comando que usa el archivo de reglas (`AGENTS.md`) y apunta específicamente al archivo legado.

```bash
codex edit @legacy_processor.py \
  --context @AGENTS.md \
  --instruction "Refactoriza 'super_process': Extrae la lógica de cálculo a una función privada '_calculate_val'. NO cambies los prints ni el nombre de la función principal."

```

### Paso 4: Revisión y Validación (`/review`)

Supongamos que el modelo genera un diff. En la CLI moderna, activamos el modo revisión antes de aplicar.

**Instrucción:**

1. El sistema mostrará el diff propuesto.
2. Verifica: ¿Creó `_calculate_val`? ¿Tiene type hints (como pide `AGENTS.md`)? ¿Mantuvo los prints?
3. Si es correcto, acepta el cambio.

### Paso 5: Verificación de Integridad

Para asegurar que no rompimos nada, creamos un script de prueba rápida (usando también la IA).

```bash
codex do "Crea un script 'verify.py' que importe legacy_processor y pruebe super_process con [5, 12, 30]. Imprime el resultado."
python3 verify.py

```

*Debe funcionar igual que la lógica original.*

### Paso 6: Limpieza (Protocolo Obligatorio)

```bash
# Eliminar todo el entorno del laboratorio
cd ..
rm -rf codex-lab04

```
