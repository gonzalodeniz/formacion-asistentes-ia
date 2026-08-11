# Checklist práctico — Ejemplos de la "Descripción general" de Claude Code

Basado en [code.claude.com/docs/es/overview](https://code.claude.com/docs/es/overview).

Marca cada casilla (`[ ]` → `[x]`) según vayas completando el ejemplo.
Los ejemplos están en el idioma original de la doc (inglés); funcionan igual en español si prefieres traducirlos.

> **Antes de empezar:** ten a mano un proyecto real con git donde probar. Varios ejemplos crean commits o ramas.

---

## 0. Instalación y primer arranque

- [ ] **Instalar Claude Code** con el método que corresponda a tu sistema
  ```bash
  # macOS / Linux / WSL
  curl -fsSL https://claude.ai/install.sh | bash
  ```
  <details><summary>Otros instaladores</summary>

  ```powershell
  # Windows PowerShell
  irm https://claude.ai/install.ps1 | iex
  ```
  ```batch
  :: Windows CMD
  curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
  ```
  ```bash
  brew install --cask claude-code        # Homebrew (no autoactualiza)
  winget install Anthropic.ClaudeCode    # WinGet (no autoactualiza)
  ```
  </details>

- [ ] **Arrancar en un proyecto** y completar el login del primer uso
  ```bash
  cd tu-proyecto
  claude
  ```

- [ ] **Comprobar la versión instalada**
  ```bash
  claude --version
  ```

---

## 1. Automatizar el trabajo que vas posponiendo

- [ ] **Escribir tests, ejecutarlos y arreglar los fallos** (ejemplo literal de la doc)
  ```bash
  claude "write tests for the auth module, run them, and fix any failures"
  ```
  > Adáptalo al módulo real de tu proyecto. Observa cómo planifica antes de escribir.

- [ ] **Corregir los errores de lint del proyecto**
  ```bash
  claude "fix all lint errors in this project"
  ```

- [ ] **Actualizar dependencias** y comprobar que nada se rompe
  ```bash
  claude "update the dependencies and make sure the build still passes"
  ```

---

## 2. Construir características y corregir errores

- [ ] **Pedir una característica en lenguaje natural** y ver cómo planifica y toca varios archivos
  ```bash
  claude "añade un endpoint de health check y su test"
  ```

- [ ] **Pegar un mensaje de error** y dejar que rastree la causa raíz
  ```bash
  claude "estoy viendo este error: <pega aquí el stacktrace>"
  ```

- [ ] **Describir solo el síntoma**, sin stacktrace, y comprobar que llega igualmente al origen
  ```bash
  claude "el login falla intermitentemente en producción, investiga por qué"
  ```

---

## 3. Git: commits y pull requests

- [ ] **Crear un commit con mensaje descriptivo** (ejemplo literal de la doc)
  ```bash
  claude "commit my changes with a descriptive message"
  ```

- [ ] **Crear una rama y abrir un pull request** desde Claude
  ```bash
  claude "crea una rama con estos cambios y abre un PR"
  ```

- [ ] *(Opcional)* **Automatizar revisión de código en CI** con GitHub Actions o GitLab CI/CD

---

## 4. Componer con la CLI al estilo Unix

Los tres ejemplos de la doc, tal cual:

- [ ] **Analizar la salida de logs recientes**
  ```bash
  tail -200 app.log | claude -p "Slack me if you see any anomalies"
  ```
  > Si no tienes Slack conectado, prueba con `... | claude -p "señala cualquier anomalía"`.

- [ ] **Automatizar traducciones en CI**
  ```bash
  claude -p "translate new strings into French and raise a PR for review"
  ```

- [ ] **Operación en masa sobre archivos cambiados**
  ```bash
  git diff main --name-only | claude -p "review these changed files for security issues"
  ```

- [ ] **Probar la salida estructurada** de `-p` para scripting
  ```bash
  claude -p --output-format json "resume qué hace este repo"
  ```

---

## 5. Conectar herramientas con MCP

- [ ] **Ver la configuración MCP actual**
  ```bash
  claude mcp
  ```

- [ ] **Conectar tu primer servidor MCP** de extremo a extremo (Google Drive, Jira, Slack o uno propio)

- [ ] **Usarlo desde una sesión**: pedirle a Claude que lea o escriba en esa herramienta externa

---

## 6. Personalización

- [ ] **Crear un `CLAUDE.md`** en la raíz del proyecto con estándares de código, arquitectura y librerías preferidas
  ```bash
  claude   # y dentro de la sesión:  /init
  ```

- [ ] **Verificar la memoria automática**: trabajar un rato y comprobar qué ha aprendido solo (comandos de build, insights de depuración)

- [ ] **Crear una skill** para un flujo repetible tuyo (p. ej. `/review-pr` o `/deploy-staging`)

- [ ] **Crear un hook** que se ejecute automáticamente, por ejemplo formatear tras cada edición de archivo o lint antes de un commit

---

## 7. Equipos de agentes

- [ ] **Lanzar subagentes** para que trabajen en paralelo sobre partes distintas de una tarea

- [ ] **Usar agentes en segundo plano** y observar varias sesiones desde una sola pantalla
  ```bash
  claude --bg "investiga el test que falla de forma intermitente"
  claude agents
  ```

- [ ] *(Avanzado)* **Explorar el Agent SDK** para construir un agente propio

---

## 8. Tareas recurrentes

- [ ] **Crear una Routine** (se ejecuta en infraestructura de Anthropic, aunque tu equipo esté apagado)
  ```
  /schedule
  ```
  Ideas: revisión de PRs por la mañana, análisis nocturno de fallos de CI, auditoría semanal de dependencias.

- [ ] **Probar una tarea programada de escritorio** (se ejecuta en tu máquina, con acceso a tus archivos locales)

- [ ] **Probar `/loop`** para repetir un prompt dentro de una sesión de CLI
  ```
  /loop 5m comprueba si el despliegue ha terminado
  ```

---

## 9. Trabajar desde cualquier sitio

- [ ] **Remote Control**: continuar una sesión local desde el móvil o el navegador
  ```bash
  claude --remote-control "Mi Proyecto"
  ```

- [ ] **Web**: iniciar una tarea larga en [claude.ai/code](https://claude.ai/code) y volver cuando esté lista

- [ ] **Teleport**: traer a tu terminal una tarea empezada en web o iOS
  ```bash
  claude --teleport
  ```

- [ ] **`/desktop`**: pasar una sesión de terminal a la app de escritorio para revisar los diffs visualmente

- [ ] **Dispatch**: enviar una tarea desde el móvil y abrir la sesión de escritorio que crea

- [ ] **Slack**: mencionar `@Claude` con un informe de bug y recibir un pull request

- [ ] **Channels**: enviar eventos desde Telegram, Discord, iMessage o tus webhooks a una sesión

---

## 10. Probar otras superficies

- [ ] **VS Code / Cursor**: instalar la extensión y usar diffs en línea y menciones `@`
- [ ] **JetBrains**: instalar el plugin (requiere la CLI instalada aparte)
- [ ] **App de escritorio**: instalarla y probar la revisión visual de diffs
- [ ] **Web**: usar [claude.ai/code](https://claude.ai/code) sin configuración local
- [ ] **Chrome**: depurar una app web en vivo
  ```bash
  claude --chrome
  ```

---

## 11. Próximos pasos sugeridos por la doc

- [ ] Completar la **Guía de inicio rápido** (primera tarea real de principio a fin)
- [ ] Leer **Flujos de trabajo comunes** y **Mejores prácticas**
- [ ] Leer el artículo **"Un arnés para cada tarea"** sobre flujos de trabajo dinámicos
- [ ] Revisar la página de **Configuración** y ajustar Claude Code a tu flujo
- [ ] Echar un ojo a **Solución de problemas** para tenerlo localizado cuando haga falta

---

### Progreso

```
Sección 0  Instalación            [ ]
Sección 1  Automatizar            [ ]
Sección 2  Features y bugs        [ ]
Sección 3  Git                    [ ]
Sección 4  CLI / pipes            [ ]
Sección 5  MCP                    [ ]
Sección 6  Personalización        [ ]
Sección 7  Agentes                [ ]
Sección 8  Tareas recurrentes     [ ]
Sección 9  Multi-dispositivo      [ ]
Sección 10 Superficies            [ ]
Sección 11 Lecturas              [ ]
```
