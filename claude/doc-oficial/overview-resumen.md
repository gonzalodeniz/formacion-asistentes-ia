# Claude Code — Resumen de la "Descripción general"

Resumen de [code.claude.com/docs/es/overview](https://code.claude.com/docs/es/overview).

---

## Qué es

Claude Code es una **herramienta de codificación agencial**: lee tu base de código, edita archivos, ejecuta comandos e integra con tus herramientas de desarrollo. No es un autocompletado — entiende el proyecto completo y trabaja a través de múltiples archivos y herramientas para completar una tarea.

Sirve para construir características, corregir errores y automatizar tareas de desarrollo.

---

## Dónde se ejecuta (superficies)

Todas las superficies se conectan al **mismo motor**, así que tu `CLAUDE.md`, tu configuración y tus servidores MCP funcionan igual en todas.

| Superficie | Para qué |
| --- | --- |
| **Terminal (CLI)** | La experiencia completa. Editar, ejecutar comandos, gestionar el proyecto entero. |
| **VS Code / Cursor** | Diffs en línea, menciones `@`, revisión de planes, historial de conversación en el editor. |
| **JetBrains** | IntelliJ, PyCharm, WebStorm… con diff interactivo y contexto de la selección. Requiere la CLI instalada aparte. |
| **App de escritorio** | Revisión visual de diffs, varias sesiones en paralelo, tareas programadas, sesiones en la nube. Requiere suscripción de pago. |
| **Web** (`claude.ai/code`) | Sin configuración local. Tareas largas, repos que no tienes en local, paralelismo. También en la app iOS. |

La CLI de Terminal y VS Code admiten además **proveedores de terceros** (Bedrock, Vertex, etc.).

### Instalación en terminal

```bash
# macOS / Linux / WSL (recomendado)
curl -fsSL https://claude.ai/install.sh | bash

# Windows PowerShell
irm https://claude.ai/install.ps1 | iex

# Homebrew (no autoactualiza)
brew install --cask claude-code

# WinGet (no autoactualiza)
winget install Anthropic.ClaudeCode
```

También hay paquetes `apt`, `dnf` y `apk`. La instalación nativa **se autoactualiza en segundo plano**; Homebrew y WinGet no (hay que hacer `brew upgrade` / `winget upgrade`).

En Windows nativo conviene tener **Git for Windows** para que Claude pueda usar la herramienta Bash; sin él usa PowerShell.

---

## Lo que puedes hacer

### 1. Automatizar el trabajo que vas posponiendo
Tests para código sin probar, errores de lint, conflictos de merge, actualizar dependencias, notas de lanzamiento.

```bash
claude "write tests for the auth module, run them, and fix any failures"
```

### 2. Construir características y corregir errores
Describe lo que quieres en lenguaje natural: Claude planifica, escribe el código en varios archivos y verifica que funcione. Para bugs, pega el error o describe el síntoma y él rastrea la causa raíz.

### 3. Commits y pull requests
Trabaja directamente con git: prepara cambios, escribe mensajes de commit, crea ramas y abre PRs.

```bash
claude "commit my changes with a descriptive message"
```

En CI se automatiza con **GitHub Actions** o **GitLab CI/CD**.

### 4. Conectar tus herramientas con MCP
**MCP** (Model Context Protocol) es un estándar abierto para conectar herramientas de IA a fuentes de datos externas: leer diseños en Google Drive, actualizar tickets de Jira, extraer datos de Slack o usar tu propia herramienta.

### 5. Personalizar
- **`CLAUDE.md`** en la raíz del proyecto: se lee al inicio de cada sesión. Estándares de código, decisiones de arquitectura, librerías preferidas, checklists de revisión.
- **Memoria automática**: Claude guarda por su cuenta aprendizajes (comandos de build, insights de depuración) sin que escribas nada.
- **Skills**: empaquetan flujos repetibles compartibles con el equipo (`/review-pr`, `/deploy-staging`).
- **Hooks**: comandos de shell antes o después de acciones de Claude (formatear tras cada edición, lint antes de un commit).

### 6. Equipos de agentes
- **Subagents**: varios Claude trabajando en partes distintas de una tarea; un agente líder coordina, reparte y fusiona.
- **Agentes en segundo plano** (agent view): varias sesiones completas en paralelo, observables desde una pantalla.
- **Agent SDK**: construir tus propios agentes con control total de orquestación, herramientas y permisos.

### 7. Componer al estilo Unix
Claude Code es *pipeable*:

```bash
# Analizar logs recientes
tail -200 app.log | claude -p "Slack me if you see any anomalies"

# Traducciones automáticas en CI
claude -p "translate new strings into French and raise a PR for review"

# Operaciones en masa sobre archivos
git diff main --name-only | claude -p "review these changed files for security issues"
```

### 8. Programar tareas recurrentes
- **Routines**: se ejecutan en infraestructura de Anthropic, siguen funcionando con tu ordenador apagado. Se pueden disparar por API o eventos de GitHub. Se crean desde web, escritorio o con `/schedule`.
- **Tareas programadas de escritorio**: en tu máquina, con acceso a tus archivos y herramientas locales.
- **`/loop`**: repite un prompt dentro de una sesión de CLI, para sondeo rápido.

### 9. Trabajar desde cualquier sitio
Las sesiones no están atadas a una superficie:
- **Remote Control**: seguir desde el móvil o cualquier navegador.
- **Dispatch**: mandar una tarea desde el móvil y abrir la sesión de escritorio que crea.
- **`claude --teleport`**: traer a la terminal una tarea iniciada en web o iOS (requiere suscripción claude.ai).
- **`/desktop`**: pasar una sesión de terminal a la app de escritorio para revisar diffs visualmente.
- **Slack**: mencionar `@Claude` con un informe de bug y recibir un PR.

---

## Tabla "Quiero… → Mejor opción"

| Quiero... | Mejor opción |
| --- | --- |
| Continuar una sesión local desde el móvil u otro dispositivo | Remote Control |
| Enviar eventos de Telegram, Discord, iMessage o mis webhooks a una sesión | Channels |
| Empezar en local y continuar en móvil | Web o app Claude iOS |
| Ejecutar Claude en un horario recurrente | Routines o Tareas programadas de escritorio |
| Automatizar revisiones de PR y triaje de issues | GitHub Actions o GitLab CI/CD |
| Revisión de código automática en cada PR | GitHub Code Review |
| Convertir bugs de Slack en pull requests | Slack |
| Depurar apps web en vivo | Chrome |
| Construir agentes a medida | Agent SDK |

---

## Próximos pasos que recomienda la doc

- **Guía de inicio rápido** — primera tarea real, de explorar el código a confirmar una corrección.
- **Memoria / CLAUDE.md** — instrucciones persistentes.
- **Flujos de trabajo comunes** y **mejores prácticas**.
- **Flujos de trabajo dinámicos** — cómo el propio equipo de Claude Code orquesta subagentes a escala.
- **Configuración** y **Solución de problemas**.

---

## Ideas clave para retener

1. Un solo motor, muchas superficies: la configuración viaja contigo.
2. El lenguaje natural es la interfaz; el proyecto entero es el contexto.
3. `-p` (modo impresión) convierte a Claude en un comando Unix más: canalizable, scriptable, integrable en CI.
4. La personalización se apila: `CLAUDE.md` → skills → hooks → subagentes → SDK.
5. El trabajo puede ser asíncrono: fondo, programado, en la nube o continuado desde el móvil.
