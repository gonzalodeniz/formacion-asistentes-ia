# Módulo 3: Selección del modelo óptimo para programación (Coste, Latencia, Calidad)

> **Duración estimada:** 90 minutos (45 min teoría + 45 min laboratorio y debate)
> **Requisitos:** Acceso a la API de OpenAI (o interfaz de chat) con permisos para seleccionar diferentes modelos (GPT-4o, GPT-4o-mini, o1-preview/mini).

---

## 1. Introducción y Objetivos

En el ecosistema actual de OpenAI, "Codex" ya no es un solo modelo, sino una capacidad integrada en varias familias de modelos. No se mata moscas a cañonazos: usar el modelo más "inteligente" para tareas triviales es lento y costoso; usar un modelo "rápido" para arquitectura compleja genera deuda técnica.

**Al finalizar este módulo, serás capaz de:**

1. **Mapear** tus tareas de desarrollo (refactor, docs, arquitectura) al modelo adecuado.
2. **Entender** la compensación entre *Latencia* (tiempo de espera) y *Razonamiento* (profundidad de análisis).
3. **Implementar** una estrategia de "Model Routing" manual en tu flujo de trabajo.

---

## 2. Contenidos Teóricos

### 2.1. El Catálogo Actual: La Matriz de Decisión

A fecha de hoy, debemos distinguir tres categorías principales para desarrollo de software:

| Familia de Modelos | Alias Común | Características Clave | Caso de Uso Ideal |
| --- | --- | --- | --- |
| **Omni (High Intelligence)** | `gpt-4o` | **Equilibrio Áureo.** Rápido, multimodal (ve diagramas), ventana de contexto grande. Es el estándar para la mayoría de tareas de código. | Chat diario, refactorización estándar, escritura de tests unitarios, explicación de código. |
| **Reasoning (Deep Thought)** | `o1` / `o1-mini` | **"Piensa antes de escribir".** Utiliza *Chain of Thought* oculta. Alta latencia (puede tardar 10-30s en empezar). | Algoritmos complejos, debugging de condiciones de carrera, optimización matemática, arquitectura de sistemas. |
| **Efficiency (Low Cost)** | `gpt-4o-mini` | **Velocidad Extrema.** Muy barato y rápido. Menor capacidad de razonamiento complejo. | Scripts simples, documentación (docstrings), formateo de datos, commits, CI/CD bots. |

### 2.2. Modelos de Razonamiento (`o1`): ¿Qué cambia?

Los modelos de la serie `o1` no simplemente predicen el siguiente token. Antes de responder, generan una cadena de pensamiento interna.

* **Cuándo usarlos:** Cuando el problema requiere planificación previa o tiene "trampas" lógicas.
* **Cómo pedírselo:** A diferencia de GPT-4, a `o1` **NO** se le debe dar un prompt con "paso a paso" (chain of thought prompting), porque ya lo hace nativamente. Se directo y dale todas las restricciones de golpe.

### 2.3. Novedades y Tendencias

* **Context Caching:** Para repositorios grandes, los modelos ahora pueden "cachear" el contexto. Si envías el mismo codebase repetidamente (ej. en un chat largo), el coste y la latencia bajan drásticamente.
* **Distillation:** OpenAI utiliza modelos grandes para entrenar a los pequeños (`4o-mini`). Esto hace que el modelo pequeño sea sorprendentemente bueno en código si la tarea está bien definida.

---

## 3. Guía de Decisión (Framework de Selección)

Utiliza este árbol de decisión mental antes de enviar tu prompt:

1. **¿Requiere creatividad arquitectónica o resolver un bug que lleva 2 días abierto?**
    * ✅ SÍ -> **Usa `o1-preview**`. (Asume el coste de tiempo y dinero).
    * ❌ NO -> Pasa al siguiente.

1. **¿Es una tarea de desarrollo estándar (crear una función, un test, explicar un fichero)?**
    * ✅ SÍ -> **Usa `gpt-4o**`. (Respuesta rápida, calidad alta).
    * ❌ NO -> Pasa al siguiente.

1. **¿Es una tarea mecánica, repetitiva o masiva (ej. añadir tipos a 50 archivos, traducir JSON)?**
    * ✅ SÍ -> **Usa `gpt-4o-mini**`. (Ahorra presupuesto, respuesta instantánea).

---

## 4. Buenas Prácticas

### 4.1. "Escalado de Modelos" (Model Escalation)

No empieces siempre con el modelo más potente.

1. Intenta la tarea con un modelo rápido (`4o` o `mini`).
2. Si falla o la lógica es incorrecta, **escala** al modelo de razonamiento (`o1`).
3. *Tip:* A menudo, puedes pedirle a `o1` que diseñe el plan/pseudocódigo y luego usar `4o` para escribir la implementación real (más rápido).

### 4.2. Grado de Verificación Automática

* **Si tienes una suite de tests robusta:** Puedes permitirte usar modelos más pequeños/rápidos (`mini`), ya que los tests atraparán los errores.
* **Si NO tienes tests (Legacy/Spaghetti):** Necesitas la "red de seguridad" cognitiva de un modelo mayor (`4o` o `o1`) para evitar romper cosas.

---

## 5. Errores Comunes

1. **La "Fatiga del Prompt o1":** Usar `o1` para preguntas simples como "¿Cómo se hace un loop en Python?". *Consecuencia:* Esperas 15 segundos innecesariamente.
2. **Subestimar al modelo "Mini":** Pensar que el modelo pequeño es "tonto". Para tareas de transformación (ej. "Convierte este XML a JSON") es más eficiente y menos propenso a "adornar" la respuesta que los modelos grandes.
3. **Ignorar la Ventana de Contexto:** Intentar meter todo el repositorio en un modelo que no lo soporta o donde será muy caro, en lugar de seleccionar solo los archivos relevantes.

---

## 6. Casos Reales

* **Caso A: El Refactorizador Masivo.**
* *Tarea:* Cambiar la sintaxis de `var` a `const/let` en 200 archivos JS.
* *Elección:* `gpt-4o-mini` vía script CLI. Es una tarea sintáctica, no lógica. Coste mínimo.

* **Caso B: El Algoritmo de Rutas.**
* *Tarea:* Optimizar una función logística que calcula rutas de reparto.
* *Elección:* `o1-preview`. Requiere matemáticas y lógica profunda.

* **Caso C: El Compañero de Día a Día.**
* *Tarea:* Crear componentes React y sus tests.
* *Elección:* `gpt-4o`. Buen balance velocidad/código.

---

## 7. Laboratorio Práctico (L3) — Benchmark Interno

**Objetivo:** Vivir en primera persona la diferencia de velocidad y "calidad de pensamiento" entre modelos.

### Preparación

1. Crea una carpeta `codex-lab03`.
2. Crea un archivo `benchmark.py` vacío.

### El Desafío (La Tarea)

La tarea es implementar una función que valide si una cadena de paréntesis, corchetes y llaves está bien cerrada y anidada (ej: `{[()]}` es válido, `{[}]` no).

### Pasos del Laboratorio

#### Ronda 1: El Modelo Eficiente (`gpt-4o-mini`)

1. **Prompt:** "Escribe una función en Python `is_balanced(s)` que valide paréntesis, corchetes y llaves. Solo código."
2. **Medición:** Observa la velocidad. ¿Es instantáneo? Copia el código a `benchmark.py`.
3. **Prueba:** Ejecuta manualmente un caso difícil: `is_balanced("{[}]")`. *Nota:* A veces los modelos pequeños fallan en casos borde lógicos si no se les explica bien.

#### Ronda 2: El Modelo Estándar (`gpt-4o`)

1. **Prompt:** Mismo prompt.
2. **Comparación:** ¿Mejoró el estilo? ¿Añadió type hints (`def is_balanced(s: str) -> bool`)? ¿Explicó el código?

#### Ronda 3: El Modelo de Razonamiento (`o1-preview` / `o1-mini`)

1. **Prompt:** Mismo prompt.
2. **Observación:** Mira el indicador de "Thinking...". ¿Cuánto tarda?
3. **Resultado:** Probablemente generará una solución más robusta, quizás usando una pila (stack) explícita y comentando la complejidad algorítmica (O(n)).

### Análisis de Resultados (Tabla de Debate)

Completa esta tabla mentalmente con los resultados del equipo:

| Modelo | Tiempo de Respuesta | Calidad del Código | ¿Pasó los Edge Cases? |
| --- | --- | --- | --- |
| Mini | < 1s | Básica | ? |
| 4o | 2-3s | Profesional | Sí |
| o1 | 10s+ | Robusta/Académica | Sí |

### Limpieza Obligatoria

```bash
rm -rf codex-lab03
# Borrar cualquier historial de chat sensible si se usó datos reales.

