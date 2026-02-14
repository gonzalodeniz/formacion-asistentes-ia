# Módulo 8 — Refactorización, Revisión y Optimización Segura

> **Duración estimada:** 90 minutos (45 min teoría + 45 min laboratorio)
> **Enfoque:** Calidad de Software, Clean Code y Rendimiento.

## 1. Objetivos de Aprendizaje

1. **Cambio de Rol:** Configurar a Codex para actuar como un "Senior Reviewer" implacable antes de hacer merge.
2. **Refactorización Defensiva:** Aplicar el patrón *Strangler Fig* asistido por IA para modernizar código legacy sin romper la funcionalidad existente.
3. **Optimización Basada en Datos:** Usar la IA para reducir la complejidad algorítmica (Big O) y consumo de memoria, exigiendo pruebas de carga antes y después.

## 2. Contenidos Teóricos

### 2.1. La IA como Auditor de Código (The AI Reviewer)

A diferencia de un linter estático (que busca errores de sintaxis), Codex entiende la *intención* del código.

* **Análisis Semántico:** Detecta nombres de variables confusos, lógica innecesariamente compleja o falta de manejo de errores de borde (edge cases).
* **Seguridad:** Identifica patrones vulnerables (Inyección SQL, XSS, secretos hardcodeados) que escapan a los tests unitarios simples.

### 2.2. Técnicas de Refactorización Asistida

* **Snapshot Testing (Test de Caracterización):** Antes de tocar código legacy sin tests, pedimos a la IA: *"Genera un test que capture el comportamiento actual de esta función, incluso si está mal. Quiero asegurar que mi refactor no cambia la salida"*.
* **Strangler Fig Pattern (Patrón Higuera Estranguladora):**

1. La IA crea una nueva función `v2` limpia junto a la `v1` antigua.
2. La IA crea un "enrutador" que manda el 10% del tráfico a la `v2`.
3. Si todo va bien, se elimina la `v1`.

### 2.3. Optimización: Complejidad Ciclomática y Big O

La IA es excelente simplificando lógica anidada (`if` dentro de `for` dentro de `if`).

* **Métrica clave:** Pedir a la IA *"Reduce la complejidad ciclomática de esta función a menos de 5"* o *"Optimiza este algoritmo de O(n^2) a O(n log n)"*.

## 3. Buenas Prácticas

1. **"Review First, Fix Later":** No pidas *"Arregla esto"* directamente. Pide primero: *"Analiza este archivo y lista los 3 problemas de diseño más graves"*. Esto te permite decidir qué arreglar y evita que la IA reescriba el archivo entero con su propio estilo.
2. **Micro-Refactors:** Nunca mezcles `feat` y `refactor` en el mismo prompt. Si vas a limpiar código, hazlo en un commit separado antes de añadir la nueva funcionalidad.
3. **Tests de Regresión:** Exige siempre que la IA genere el test que demuestra que la optimización no rompió la lógica de negocio.

## 4. Errores Comunes

1. **Optimización Prematura:** Pedirle a Codex que optimice una función que se ejecuta una vez al día. *Solución:* Enfocarse solo en los "hot paths".
2. **La Trampa del "Código Inteligente":** Aceptar one-liners (código en una línea) muy astutos que genera la IA pero que son imposibles de debugear por humanos. *Regla:* Legibilidad > Astucia.
3. **Refactorización sin Red:** Permitir que la IA cambie lógica de negocio sin tener un test de cobertura previo.

## 5. Casos de Uso Reales

* **Limpieza de Deuda Técnica:** Un equipo dedica los viernes a ejecutar Codex sobre módulos antiguos con el prompt: *"Identifica código duplicado en estas 3 clases y extrae una clase base común"*.
* **Review de Seguridad en CI:** Un paso en GitHub Actions donde Codex analiza solo los archivos cambiados en el PR y comenta si detecta riesgos de seguridad (OWASP Top 10).

---

## 6. Laboratorio (L8) — “El Revisor Implacable”

**Escenario:** Tienes un script de procesamiento de datos "sucio": funciona, pero es lento, inseguro y difícil de leer. Usaremos Codex para auditarlo, blindarlo con tests y refactorizarlo.

### Paso 1: Crear el "Código Sucio"

Vamos a crear un script que procesa un CSV simulado. Tiene vulnerabilidades (abre archivos sin validar rutas), es lento (bucles ineficientes) y feo.

1. Crear directorio:

```bash
mkdir codex-lab08
cd codex-lab08

```

1. Crear `bad_processor.py`:

```python
import os

def procesar(archivo):
    # Peligro: Path Traversal
    f = open(archivo, 'r')
    lineas = f.readlines()
    datos = []
    for l in lineas:
        partes = l.split(',')
        # Ineficiente: Bucle anidado innecesario
        if len(partes) > 2:
            encontrado = False
            for d in datos:
                if d['id'] == partes[0]:
                    encontrado = True
            if found == False: # Bug: variable 'found' no definida (typo)
                datos.append({'id': partes[0], 'val': partes[1]})
    return datos

```

### Paso 2: La Auditoría (Code Review)

No vamos a arreglarlo todavía. Vamos a pedirle a la IA que destruya nuestra autoestima (profesionalmente).

**Instrucción:**

```bash
codex do --context bad_processor.py "Actúa como un Tech Lead de seguridad y rendimiento. Haz una Code Review de este archivo. No generes código nuevo aún, solo lista los problemas críticos (Bugs, Seguridad, Rendimiento) en formato Markdown."

```

**Resultado Esperado:**
La IA debería identificar:

1. **Seguridad:** Vulnerabilidad de Path Traversal (`open(archivo)` sin validar). Falta cerrar el archivo (no usa `with`).
2. **Bug Lógico:** La variable `found` vs `encontrado`. El código fallará al ejecutarse.
3. **Rendimiento:** Complejidad O(n^2) al buscar duplicados iterando la lista `datos` cada vez. Debería usar un `set` o `dict`.

### Paso 3: Generación de Tests de Seguridad (Safety Net)

Antes de refactorizar, necesitamos un test que falle o que capture el comportamiento. Dado que el código tiene un bug que impide que corra (`found`), pediremos arreglar el bug mínimo y crear tests.

**Instrucción:**

```bash
codex do "Corrige SOLO el error de sintaxis de la variable 'found' para que el código corra. Luego, genera un archivo 'test_processor.py' con unittest que cubra un caso básico de CSV."

```

*Ejecuta los tests para confirmar que pasan (verde).*

### Paso 4: Refactorización y Optimización

Ahora que tenemos tests (la red de seguridad), pedimos el refactor completo aplicando las mejoras de la revisión.

**Instrucción:**

```bash
codex edit bad_processor.py \
    --instruction "Refactoriza el código aplicando las mejoras del Code Review: 1) Usa 'with open', 2) Valida que el path sea seguro, 3) Optimiza la búsqueda de duplicados a O(n) usando un Set/Dict. Asegura que pase los tests existentes."

```

### Paso 5: Validación Final

1. Lee el nuevo código: ¿Es más limpio?
2. Ejecuta los tests: `python3 -m unittest test_processor.py`.

**Resultado Ideal:**

```python
# Ejemplo de lo que debería generar la IA
import os

def procesar(archivo):
    if not os.path.exists(archivo):
        raise ValueError("Archivo no válido")
    
    seen_ids = set()
    datos = []
    
    with open(archivo, 'r') as f:
        for line in f:
            parts = line.strip().split(',')
            if len(parts) > 2:
                uid = parts[0]
                if uid not in seen_ids:
                    seen_ids.add(uid)
                    datos.append({'id': uid, 'val': parts[1]})
    return datos

```

### Paso 6: Limpieza

```bash
cd ..
rm -rf codex-lab08
echo "Laboratorio 8 finalizado."

```
