# Módulo 9 — Testing y Debugging Asistido con GPT-5.3

**Duración estimada:** 90 minutos (45 min teoría + 45 min laboratorio)
**Tecnología:** GPT-5.3-Codex-Spark (Unit), GPT-5.1-Codex-Max (E2E/Security)

## 1. Objetivos de Aprendizaje

1. **Dominar la Pirámide de Testing Híbrida:** Saber asignar el modelo correcto (Spark vs. Max) a cada capa de prueba (Unit vs. E2E).
2. **Debugging Agéntico:** Pasar de "leer logs" a delegar el análisis de trazas y la minimización de errores al modelo.
3. **Generación de "Tests Hostiles":** Usar la IA no solo para verificar que el código funciona, sino para intentar romperlo (Security & Edge Cases).

---

## 2. Contenidos Teóricos

### 2.1. La Pirámide de Pruebas en la Era GPT-5

La estrategia clásica de testing se adapta según la latencia y el coste cognitivo del modelo:

* **Unit Tests (Base):**
* *Modelo:* **GPT-5.3-Codex-Spark**.
* *Por qué:* Necesitas velocidad instantánea (<1s). El modelo genera tests para funciones puras mientras escribes (TDD en tiempo real).
* *Enfoque:* Lógica pura, mocking de dependencias directas.

* **Integration Tests (Medio):**
* *Modelo:* **GPT-5.3-Codex (Standard)**.
* *Por qué:* Requiere entender cómo interactúan dos módulos (ej. API + DB). El modelo estándar equilibra contexto y velocidad.

* **GUI / E2E / Smoke (Cúspide):**
* *Modelo:* **GPT-5.1-Codex-Max**.
* *Por qué:* Son tests frágiles y largos. Requieren leer todo el árbol del DOM o flujos de usuario complejos. *Max* reduce el "flakiness" razonando sobre esperas dinámicas.

* **Security (Transversal):**
* *Modelo:* **GPT-5.1-Codex-Max**.
* *Por qué:* Requiere pensar como un atacante (SAST, validación de inputs, SQLi).

### 2.2. Prompting para Debugging: El Protocolo "C.E.R."

Para arreglar bugs complejos, usa esta estructura en tu prompt:

1. **C (Contexto):** `@archivo_roto.py` + `@test_fallando.py`.
2. **E (Error):** Pega el Stacktrace completo o usa una herramienta MCP para leer el log.
3. **R (Restricción):** "No parches el síntoma, encuentra la causa raíz (Root Cause Analysis). Explica tu hipótesis antes de generar el código."

---

## 3. Buenas Prácticas

1. **TDD Asistido (Test-Driven Development):**
    * Escribe la firma de la función.
    * Pide a *Spark*: "Genera un test que falle para esta función cubriendo casos nulos y negativos".
    * Implementa el código hasta que el test pase.

1. **Evitar "Tests Placebo":**
    * La IA tiende a crear tests que siempre pasan (`assert True`).
    * *Regla:* Exige al modelo: *"Genera el test, ejecútalo para confirmar que falla (Rojo), y luego implementa la solución (Verde)."*

1. **Anti-Flakiness en E2E:**
    * Prohíbe explícitamente el uso de `sleep()` o `wait(5000)`.
    * Instruye al modelo: *"Usa esperas explícitas basadas en eventos (ej. `await expect(locator).toBeVisible()`)."*

---

## 4. Errores Comunes

1. **El "Espejo" Lógico:** Dejar que la IA escriba el test leyendo el código existente. Si el código tiene un bug, el test validará el bug como "correcto". *Solución:* Generar tests basados en requisitos/specs, no en la implementación.
2. **Debugging Ciego:** Pedir "Arregla esto" sin pasar el error. GPT-5.3 es listo, pero no adivino.
3. **Obsesión E2E:** Usar GPT-5.1-Max para generar 50 tests de UI que tardan horas en correr. Mantén la pirámide equilibrada.

---

## 5. Casos de Uso Reales

* **Regresión en Pagos:** Un bug en producción donde el redondeo de decimales fallaba. Se usó GPT-5.3 para generar un test de reproducción con 100 variaciones de importes decimales hasta aislar el fallo.
* **Endurecimiento de API:** Usar GPT-5.1-Max para auditar un endpoint público y generar automáticamente tests que envían payloads JSON malformados y enormes para probar la resiliencia (fuzzing básico).

---

## 6. Laboratorio (L9) — "The Bulletproof Module"

**Escenario:** Crearemos un módulo de **Procesamiento de Reembolsos**. Debe ser robusto, seguro y estar bien probado.

### Paso 1: Configuración (El Módulo Base)

Crea el directorio y un archivo base vacío.

```bash
mkdir codex-lab09
cd codex-lab09
touch refund_processor.py

```

### Paso 2: Unit Testing con GPT-5.3-Spark (Velocidad)

Vamos a definir el contrato antes del código.

**Instrucción:**

> "Usa el modelo **Spark**. Genera un archivo `test_refund.py` (usando `pytest`) para una función `process_refund(amount, user_tier)`.
> Reglas:
>
> 1. `amount` debe ser positivo.
> 2. Si `user_tier` es 'VIP', el reembolso es instantáneo (return True).
> 3. Si es 'Standard', requiere aprobación manual si amount > 100.
> Genera solo los tests."
>

*Acción:* Ejecuta `pytest`. Deben fallar (o dar error de importación). Esto es correcto.

### Paso 3: Implementación Reactiva

**Instrucción:**

> "Ahora implementa la lógica en `refund_processor.py` para que los tests pasen. Hazlo lo más simple posible."

*Acción:* Ejecuta `pytest`. Deben pasar (Verde).

### Paso 4: Integración y Mocking (GPT-5.3 Standard)

Ahora añadimos una dependencia externa (una API de banco).

**Instrucción:**

> "Modifica el procesador para que llame a una función externa `bank_api.send_money()`.
> Actualiza los tests para usar `unittest.mock` o `pytest-mock` y verificar que `send_money` se llama con los argumentos correctos. No quiero que llame a la API real."

### Paso 5: Seguridad y Casos Límite (GPT-5.1-Max)

Vamos a intentar romper el código.

**Instrucción:**

> "Usa el modelo **Max**. Actúa como un QA de Seguridad.
> Analiza `refund_processor.py`. Genera 5 nuevos casos de prueba en `test_security.py` que intenten explotar vulnerabilidades:
>
> 1. Inyección de tipos (pasar strings en lugar de floats).
> 2. Desbordamiento de precisión (números muy grandes).
> 3. Valores negativos o cero.
> Si encuentras fallos, propón el fix en el código."
>
>

### Paso 6: Debugging de Regresión (El Bug Oculto)

Introduce manualmente un error sutil en `refund_processor.py`: cambia `> 100` por `>= 100`.

**Instrucción:**

> "He introducido una regresión. Ejecuta los tests. Analiza el fallo y dime exactamente qué línea cambió la lógica de negocio y cómo arreglarlo para volver al estado original."

### Limpieza Obligatoria

```bash
# Eliminar entorno de pruebas
cd ..
rm -rf codex-lab09
# Limpiar caché de pytest si existe
rm -rf .pytest_cache

```
