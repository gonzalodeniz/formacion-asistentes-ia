# Módulo 1: Fundamentos de Codex como Agente de Desarrollo

> **Duración estimada:** 90 minutos (60 min teoría + 30 min laboratorio)
> **Requisitos:** Terminal con acceso a internet, Git instalado, Python 3.9+.

---

## 1. Introducción y Objetivos

En este módulo, cambiamos el paradigma mental: dejamos de ver a la IA como un "chatbot" al que se le hacen preguntas, para verla como un **agente activo** ("Codex") capaz de leer tu sistema de archivos, proponer ediciones complejas y ejecutar comandos.

**Al finalizar este módulo, serás capaz de:**

1. **Diferenciar** entre "pedir consejo" (Chat) y "delegar una tarea" (Agente).
2. **Navegar** por las interfaces disponibles (CLI, IDE, Cloud).
3. **Implementar** el ciclo de seguridad "Humano en control": nada se commitea sin revisión de diffs y tests.

---

## 2. Contenidos Teóricos

### 2.1. ¿Qué es Codex en modo "Agente"?

A diferencia de un chat web (como ChatGPT estándar), un agente de desarrollo integrado (como las herramientas basadas en la tecnología Codex/GPT-4o) tiene **permisos**.

| Característica | Chat de Ayuda (Web) | Agente de Desarrollo (Codex) |
| --- | --- | --- |
| **Contexto** | Tú copias y pegas fragmentos. | **Lee** todo tu repositorio automáticamente. |
| **Salida** | Texto/Código en markdown. | **Edita** tus archivos directamente (`diffs`). |
| **Ejecución** | No ejecuta nada (salvo sandbox). | Puede **ejecutar** comandos de terminal (linter, tests). |
| **Rol** | Consultor externo. | **Junior Developer** integrado en tu equipo. |

### 2.2. Ecosistema de Herramientas (Los "Clientes")

El modelo es el cerebro, pero necesitamos un cuerpo (cliente) para interactuar con el código.

1. **IDE (VS Code / JetBrains):**
   * *Uso:* El agente vive en el editor. Ve el archivo abierto y los relacionados.
   * *Ideal para:* Refactorización, completar funciones, generar Docstrings, arreglar errores de sintaxis en tiempo real.

1. **CLI (Línea de Comandos):**
   * *Uso:* Se invoca desde la terminal. Puede pipear salidas de logs o errores.
   * *Ideal para:* Tareas de "fontanería", scripts de automatización, explicar por qué falló el build, generar `.gitignore`.

1. **App de Escritorio / Cloud (Entorno Remoto):**
   * *Uso:* El agente tiene su propio entorno (Docker/Sandbox).
   * *Ideal para:* Tareas de larga duración ("Migra este proyecto de Python 2 a 3").

### 2.3. Filosofía de Trabajo: "Confianza Cero, Verificación Total"

El agente es incansable, pero puede alucinar. La metodología correcta es:

1. **Definición (Prompt):** Clara y con restricciones.
2. **Generación (Agente):** El agente propone cambios.
3. **Revisión (Humano):** Lectura del `diff`.
4. **Validación (Máquina):** Ejecución de tests.
5. **Merge.**

---

## 3. Buenas Prácticas

### 3.1. Solicita "Evidencias", no solo código

No pidas *"Haz una función que sume"*. Pide:

> *"Crea una función que sume, incluye un test unitario para validarla y el comando para ejecutar ese test."*
> Esto fuerza al agente a autovalidar su trabajo.

### 3.2. Criterios de Aceptación (Definition of Done)

Trata al agente como a un desarrollador junior.

* **Mal:** "Mejora el código."
* **Bien:** "Refactoriza `process_data` para reducir la complejidad ciclomática. No cambies la firma de la función. Mantén los logs existentes."

### 3.3. Revisión de Diffs

Nunca aceptes un cambio masivo a ciegas. Usa la vista de diferencias de tu IDE. Busca:

* Alucinaciones (importar librerías que no existen).
* Borrado accidental de comentarios o lógica de negocio.
* Cambios de estilo innecesarios (espacios vs tabs).

---

## 4. Errores Comunes

1. **"El Agente Mágico":** Esperar que el agente entienda la arquitectura de un proyecto de 50,000 líneas sin contexto. *Solución:* Dale contexto (archivos clave, interfaces).
2. **Iteración Infinita:** Pedir correcciones sobre correcciones sin volver atrás. *Solución:* Si el agente falla 2 veces, deshaz los cambios (`git reset`) y reformula el prompt.
3. **Prompt Vago:** "Arregla esto". *Solución:* Pega el error del log y di: "Analiza este stacktrace y propón un fix para el archivo `utils.py`".

---

## 5. Casos de Uso Reales

* **Onboarding:** *"Explícame cómo fluyen los datos desde la API hasta la base de datos en este repo. Créame un diagrama en formato Mermaid."*
* **Hotfix:** *"Aquí tienes el error de producción. Crea un test que reproduzca el fallo (debe fallar ahora) y luego modifica el código para que el test pase."*
* **Documentación:** *"Genera un `README.md` basado en el `package.json` y los comentarios de las funciones principales."*

---

## 6. Laboratorio Práctico (L1) — Primer Ciclo Agente→Diff→Validación

**Escenario:** Vamos a crear un microservicio desde cero usando el agente para escribir el código, los tests y la documentación.

### Pasos del Laboratorio

#### Paso 1: Preparación del entorno

Abre tu terminal y crea un directorio vacío.

```bash
mkdir codex-lab01
cd codex-lab01
# Inicia un entorno virtual (opcional pero recomendado)
python3 -m venv venv
source venv/bin/activate  # O venv\Scripts\activate en Windows

```

#### Paso 2: El Prompt Inicial (Scaffolding)

Abre tu herramienta de Codex (puede ser la terminal si usas CLI, o abre VS Code en esta carpeta).
**Instrucción al Agente:**

> "Actúa como experto en Python. Crea un servicio REST simple usando FastAPI en un archivo `main.py`. Debe tener un endpoint `GET /health` que devuelva `{'status': 'ok'}` y un endpoint `POST /echo` que devuelva el body recibido. No instales dependencias, solo genera el código y un archivo `requirements.txt`."

*Acción:* Revisa los archivos generados. Instala las dependencias:

```bash
pip install -r requirements.txt

```

#### Paso 3: Desarrollo Guiado por Tests (TDD con IA)

**Instrucción al Agente:**

> "Ahora crea un archivo `test_main.py` usando `pytest`. Debe probar ambos endpoints. Incluye casos de éxito y un caso de error si el body del echo está vacío (asume que debe devolver 400)."

*Acción:* El agente generará los tests. Es probable que el agente *no haya implementado* la lógica del error 400 en el paso anterior.

1. Ejecuta los tests: `pytest`.
2. Si fallan (esperado), pide al agente: *"Los tests fallaron con este error [pegar error]. Ajusta `main.py` para manejar el error 400 tal como espera el test."*

#### Paso 4: Documentación y Cierre

**Instrucción al Agente:**

> "Genera un `README.md` profesional. Debe explicar cómo instalar, cómo ejecutar el servidor y cómo correr los tests. Incluye ejemplos de `curl` para probar los endpoints."

#### Paso 5: Validación Final

1. Lee el README generado.
2. Sigue sus instrucciones para levantar el servidor y probarlo.
3. Verifica que los tests sigan pasando.

### Limpieza Obligatoria

Para asegurar que no dejamos residuos ni claves expuestas:

```bash
# Detener servidor (Ctrl+C)
# Desactivar entorno virtual
deactivate

# Borrar directorio del laboratorio
cd ..
rm -rf codex-lab01

# Limpieza de credenciales (si se exportaron en la sesión)
unset OPENAI_API_KEY
# Verificar que no quedan archivos .env
ls -la

```

---

**Fin del Módulo 1.**
