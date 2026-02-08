# Módulo 2: Instalación y Uso Eficiente de Herramientas (CLI, IDE, App, Cloud)

> **Duración estimada:** 90 minutos (60 min teoría + 30 min laboratorio)
> **Requisitos:** VS Code instalado, Node.js (para el ejemplo del lab), acceso a terminal.

---

## 1. Introducción y Objetivos

Una vez comprendido el concepto de "Agente", es vital dominar las interfaces a través de las cuales interactuamos con él. No es lo mismo refactorizar una función (IDE) que generar documentación para 50 microservicios (CLI/Cloud).

**Al finalizar este módulo, serás capaz de:**

1. **Orquestar** el entorno de trabajo: instalar y verificar la CLI y la extensión de IDE.
2. **Configurar** el comportamiento del agente mediante el sistema de capas (`Global` vs `Workspace`).
3. **Discernir** qué herramienta usar: ¿Cuándo abrir la App de escritorio y cuándo delegar a la Cloud?

---

## 2. Contenidos Teóricos

### 2.1. El Ecosistema de Herramientas

OpenAI y sus partners ofrecen diferentes "puntos de entrada" al modelo. Elegir el correcto ahorra tiempo y dinero.

#### A. Codex CLI (La herramienta "Headless")

* **Definición:** Agente de línea de comandos que opera sobre el directorio actual.
* **Filosofía:** "Tubería de Unix". Puede recibir input de otros comandos (`cat logs.txt | codex fix`) y su salida puede redirigirse a archivos.
* **Uso principal:** Automatización, scripts de mantenimiento, tareas repetitivas en múltiples archivos sin abrir editor visual.

#### B. Codex IDE Extension (El Copiloto)

* **Definición:** Plugin integrado en VS Code, Cursor, o JetBrains.
* **Filosofía:** "Pair Programming". Comparte el contexto de lo que estás viendo (archivo abierto, pestañas vecinas, terminal integrada).
* **Uso principal:** Edición quirúrgica, autocompletado inteligente, explicación de código *in-situ*.

#### C. App de Escritorio vs. Codex Cloud

* **App (Local/Híbrido):** Gestiona proyectos complejos, múltiples repositorios a la vez y mantiene un historial persistente de "sesiones de trabajo". Ideal para arquitectura.
* **Cloud (Delegación):** Ejecución remota para tareas pesadas que requieren paralelismo o acceso a recursos que tu máquina no tiene.

### 2.2. Configuración por Capas (Configuration Cascading)

El comportamiento del agente no debe ser aleatorio. Se controla mediante archivos de configuración TOML/JSON con un orden de precedencia estricto:

1. **Capa Proyecto (`./.codex/config.toml`):**
    * *Prioridad:* **ALTA**.
    * *Contenido:* Reglas de linter del equipo, versiones de lenguaje (ej. "Usar Java 17"), rutas ignoradas específicas. **Se debe commitear en Git.**

1. **Capa Usuario (`~/.codex/config.toml`):**
    * *Prioridad:* **MEDIA**.
    * *Contenido:* Preferencias personales (idioma del chat, atajos de teclado, tema oscuro/claro). **No se comparte.**

1. **Capa Default:** Configuración de fábrica del modelo.

---

## 3. Buenas Prácticas

### 3.1. "Infrastructure as Code" para la IA

Trata la configuración de la IA (`.codex/config.toml`) como parte de tu código fuente.

* **Estandarización:** Si el equipo usa *snake_case* en Python, configúralo en el archivo del repo. Así, la IA sugerirá código que cumpla las normas del equipo, independientemente de quién pregunte.
* **Sin Secretos:** **NUNCA** guardes API Keys o tokens en el `config.toml` del repositorio. Usa variables de entorno (`.env`) que estén en `.gitignore`.

### 3.2. Selección de Herramienta por Contexto

* **Usa CLI para:** "Genera un archivo `.gitignore` para un proyecto Node", "Explica qué hace este script de bash", "Refactoriza todos los archivos en `/src/utils`".
* **Usa IDE para:** "Cambia este bucle `for` por un `map`", "Añade manejo de errores en esta función específica", "¿Qué devuelve esta variable?".

### 3.3. Scope (Alcance) Definido

Evita ejecutar la CLI o abrir el IDE en la raíz de tu disco duro. Define "Proyectos" o "Workspaces" acotados. Si tienes un monorepo, abre la instancia del agente en la carpeta del microservicio específico para no diluir el contexto.

---

## 4. Errores Comunes

1. **Conflicto de Configuración:** Tener una regla en el usuario ("Usa Tabs") y otra en el repo ("Usa Espacios"). *Resultado:* El agente se confunde o prioriza el repo, frustrando al usuario que no entiende por qué ignora su preferencia.
2. **Directorio Incorrecto:** Ejecutar `codex explain` en una carpeta vacía y esperar que entienda el proyecto que está dos carpetas más arriba.
3. **"Magic Fix":** Esperar que la CLI arregle un bug de compilación sin pasarle los logs de error. La CLI no "ve" la terminal a menos que se lo pases explícitamente.

---

## 5. Casos de Uso Reales

* **Onboarding Corporativo:** Una empresa crea un repositorio plantilla (skeleton) que ya incluye la carpeta `.codex/` con las reglas de negocio, estilo y seguridad preconfiguradas. El nuevo empleado clona, y su IA ya "sabe" cómo trabajar allí.
* **Homogeneización de Logs:** Usar la CLI para recorrer todo el proyecto y asegurar que todos los `print()` o `console.log()` sigan un formato JSON estructurado definido en la configuración.

---

## 6. Laboratorio Práctico (L2) — “Setup Corporativo Mínimo”

**Escenario:** Simularemos un entorno profesional donde queremos que la IA respete reglas estrictas de estilo definidas en el repositorio, ignorando las preferencias personales del desarrollador.

### Pasos del Laboratorio

#### Paso 1: Crear estructura y configuración global simulada

Primero, vamos a simular una preferencia de usuario (global) que querremos sobrescribir.
*(Nota: En este lab usaremos archivos locales para simular `~/.codex/` si no tienes acceso a home)*.

1. Crea el directorio del laboratorio:

```bash
mkdir codex-lab02
cd codex-lab02
mkdir .codex

```

#### Paso 2: Definir la configuración del Proyecto (Repo Scope)

Crea el archivo `.codex/config.toml` dentro de `codex-lab02`. Este archivo simula las reglas del equipo.

```toml
# .codex/config.toml
[style]
language = "javascript"
indentation = "spaces"
quote_style = "single" # Regla estricta del equipo: comillas simples
framework = "express"

[agent]
role = "backend_developer"
allowed_commands = ["npm test", "node app.js"]

```

#### Paso 3: Ejecución y Verificación (CLI)

Vamos a pedirle al agente que genere código y verificar si obedece el archivo de configuración del repo.

* **Comando (simulado):** Ejecuta tu herramienta de IA (CLI o Chat de IDE) en este directorio.
* **Prompt:** *"Genera un servidor básico 'Hello World' en un archivo `app.js`."*
* **Verificación:**

1. Abre el `app.js` generado.
2. ¿Usa **comillas simples** (`'Hello World'`) como pide el config? (Correcto).
3. ¿Usa **Express** como framework? (Correcto, aunque no se lo pedimos explícitamente en el prompt, está en el config).

#### Paso 4: Prueba de Conflicto (IDE)

1. Abre VS Code (o tu editor) en la carpeta `codex-lab02`.
2. Pide al chat del IDE: *"Añade un endpoint de status".*
3. Verifica que el código generado mantenga la coherencia (comillas simples). Esto confirma que el IDE está leyendo la configuración local `.codex/config.toml`.

### Resultado Esperado

El agente debe comportarse como un miembro del equipo que conoce las reglas: usa Express y comillas simples automáticamente, sin necesidad de repetirlo en cada prompt.

### Limpieza Obligatoria

```bash
# Salir del directorio
cd ..

# Eliminar el laboratorio
rm -rf codex-lab02

# Si modificaste tu config global real (~/.codex/config.toml), reviértela ahora.
# (En este lab usamos configuración local para evitar tocar el home real).
echo "Limpieza completada."

```
