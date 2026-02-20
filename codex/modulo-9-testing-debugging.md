# Módulo 9 — Testing y Debugging Asistido: Estrategia de Capas

**Duración estimada:** 90 minutos (45 min teoría + 45 min laboratorio)
**Enfoque:** Calidad, Seguridad y Robustez (QA & DevSecOps).

## 1. Objetivos de Aprendizaje

1. **Orquestación de Modelos en QA:** Saber cuándo usar *Spark* (generación masiva de unit tests) vs *GPT-5.3* (análisis de causas raíz y seguridad).
2. **Test-Driven AI:** Invertir el flujo; usar la IA para generar los tests *antes* que el código o para "cercar" un bug antes de corregirlo.
3. **Debugging Forense:** Pasar de "prueba y error" a un enfoque científico: Reproducción -> Aislamiento -> Corrección -> Regresión.

---

### 2. Contenidos Teóricos

#### 2.1. La Pirámide de Pruebas Aumentada

La IA transforma cómo abordamos cada capa de la pirámide. No se trata solo de cobertura, sino de semántica.

* **Unit Tests (Base):**
* *Objetivo:* Lógica pura y contratos.
* *Modelo:* **GPT-5.3-Codex-Spark**. Su velocidad permite generar 50 casos de prueba en segundos.
* *Estrategia:* Generación de tablas de decisión (inputs vs expected outputs) y *Property-Based Testing* (generar miles de entradas aleatorias para encontrar fallos).

* **Integration Tests (Centro):**
* *Objetivo:* Interacción entre módulos (DB, API, Colas).
* *Modelo:* **GPT-5.3-Codex**. Requiere entender el contexto de varios archivos.
* *Estrategia:* Uso de *Testcontainers* o Mocks inteligentes generados por la IA.

* **Smoke & E2E (Cúspide):**
* *Objetivo:* Rutas críticas ("¿Enciende el sistema?").
* *Modelo:* **GPT-5.3-Codex**.
* *Estrategia:* Scripts de Playwright/Cypress resilientes. La IA es excelente generando selectores basados en atributos estables (`data-testid`) en lugar de XPaths frágiles.

* **Seguridad (Transversal):**
* *Objetivo:* SAST (Static Application Security Testing) y validación de inputs.
* *Modelo:* **GPT-5.1-Codex-Max**. Análisis profundo de flujo de datos para detectar inyecciones o fugas de información.

### 2.2. Prompting para Debugging (El Método C.E.R.)

Para un debugging efectivo, el prompt debe seguir una estructura estricta:

1. **C (Contexto):** El código relevante (minimizado).
2. **E (Error):** El stacktrace *exacto* y logs previos.
3. **R (Restricciones):** "No cambies la librería X", "Explica la causa raíz antes de proponer el fix".

---

### 3. Buenas Prácticas

* **Tests de Reproducción:** Nunca arregles un bug sin antes pedirle a la IA: *"Genera un test unitario que falle reproduciendo este bug exacto"*. Solo cuando tengas el test en rojo (failing), aplicas el fix.
* **Explicación de "El Porqué":** Exige al modelo que explique *por qué* fallará el test antes de escribirlo. Esto reduce los "tests placebo" (tests que siempre pasan).
* **Minimizar Flakiness:** En tests E2E, instruye explícitamente al modelo para usar esperas dinámicas (`await expect(...)`) y evitar `sleep(5)`, que es la causa #1 de inestabilidad.

---

### 4. Errores Comunes

* **Tests Placebo:** Aceptar tests generados que hacen `assert True` o mockean tanto la realidad que pierden valor.
* **Debugging "A Ciegas":** Pedirle a la IA "arregla esto" sin pasarle el stacktrace completo. La IA alucinará una solución plausible pero incorrecta.
* **Mirroring:** Generar tests que copian la implementación línea por línea. Si cambias la implementación, el test se rompe aunque la lógica sea correcta. El test debe probar el *contrato*, no la implementación.

---

### 5. Casos de Uso Reales

* **Hotfix en Producción:** Un error 500 intermitente. Se descargan los logs, se pasan a GPT-5.3 para que correlacione el timestamp con el código y genere una hipótesis de *Race Condition*.
* **Legacy Refactor:** Antes de tocar un módulo de cobros antiguo, se usa *Spark* para generar una batería de "Snapshot Tests" que aseguren que el comportamiento no cambia tras la limpieza.

---

### 6. Laboratorio (L9) — Batería de Pruebas "Defense-in-Depth"

**Escenario:** Trabajaremos sobre un módulo de **Procesamiento de Pagos** simplificado pero crítico. Contiene errores de lógica financiera y vulnerabilidades de seguridad.

**Objetivo:** Crear una suite de tests completa, detectar bugs y corregirlos de forma segura.

#### Paso 1: Setup del Módulo Vulnerable

Crea el directorio y el archivo del módulo.

```bash
mkdir codex-lab09
cd codex-lab09

# payment_gateway.py (Contiene bugs intencionales)
cat <<EOF > payment_gateway.py
import sqlite3

class PaymentProcessor:
    def __init__(self, db_path=":memory:"):
        self.conn = sqlite3.connect(db_path)
        self.conn.execute("CREATE TABLE IF NOT EXISTS wallets (user_id TEXT, balance REAL)")

    def add_user(self, user_id, balance):
        # VULNERABILIDAD: Inyección SQL potencial si no se usa correctamente
        # BUG LÓGICO: Permite saldo negativo inicial
        self.conn.execute(f"INSERT INTO wallets VALUES ('{user_id}', {balance})")
        self.conn.commit()

    def process_payment(self, user_id, amount):
        cursor = self.conn.execute(f"SELECT balance FROM wallets WHERE user_id='{user_id}'")
        row = cursor.fetchone()
        if row:
            current_balance = row[0]
            # BUG LÓGICO: No verifica si hay saldo suficiente
            new_balance = current_balance - amount
            self.conn.execute(f"UPDATE wallets SET balance={new_balance} WHERE user_id='{user_id}'")
            self.conn.commit()
            return True
        return False
EOF

```

#### Paso 2: Unit Testing Masivo con Spark

Usaremos el modelo rápido para generar cobertura base.

* **Prompt (CLI/IDE):**

> "Usa el modelo **Spark**. Genera un archivo `test_payment.py` con `unittest`. Crea 5 casos de prueba para `PaymentProcessor`: usuario nuevo, pago válido, usuario inexistente, pago con decimales, pago de 0."

* **Acción:** Ejecuta los tests.

```bash
python3 -m unittest test_payment.py

```

#### Paso 3: Análisis de Seguridad y Casos Límite (GPT-5.3)

Ahora usamos el modelo inteligente para encontrar lo que *Spark* pasó por alto.

* **Prompt:**

> "Analiza `payment_gateway.py` buscando vulnerabilidades de seguridad y errores de lógica financiera.
>
> 1. Crea un nuevo test `test_security.py` que intente una Inyección SQL en `user_id`.
> 2. Crea un test que intente gastar más dinero del que tiene el usuario (Overdraft).
> 3. Explica por qué el código actual es peligroso."
>
>

* **Acción:** Ejecuta los tests de seguridad. Deberían fallar (o pasar demostrando la vulnerabilidad, ej: borrando la tabla).

```bash
python3 -m unittest test_security.py

```

#### Paso 4: Debugging y Refactor (Ciclo Red-Green)

Tenemos la evidencia (tests fallando). Ahora arreglamos.

* **Prompt:**

> "Tengo tests de seguridad fallando por SQL Injection y lógica de saldo negativo.
> Refactoriza `payment_gateway.py` para:
>
> 1. Usar 'Parameterized Queries' (?) de SQLite para evitar inyecciones.
> 2. Validar que `balance >= amount` antes de restar.
> 3. Validar que no se creen usuarios con saldo negativo."
>
>

* **Acción:** Reemplaza el contenido de `payment_gateway.py` con la solución y vuelve a correr *todos* los tests.

```bash
python3 -m unittest discover

```

*Resultado esperado:* Todos los tests (unitarios y de seguridad) deben estar en verde.

#### Paso 5: Smoke Test (Script Post-Deploy)

Simulamos un test rápido para verificar que el sistema "arranca".

* **Prompt:**

> "Genera un script `smoke.py` que use la clase refactorizada. Debe realizar un ciclo completo: Crear usuario -> Pagar -> Verificar saldo. Si el saldo final es incorrecto, lanza una excepción."

#### Paso 6: Limpieza

```bash
cd ..
rm -rf codex-lab09
# Eliminar caché de pytest/python si existe
rm -rf __pycache__

```
