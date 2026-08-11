# Claude Code CLI — Resumen práctico

Resumen de lo más importante y más usado de la [referencia de CLI](https://code.claude.com/docs/es/cli-reference).

---

## 1. Los 8 comandos del día a día

| Comando | Qué hace |
| --- | --- |
| `claude` | Abre una sesión interactiva en el directorio actual. |
| `claude "consulta"` | Sesión interactiva con una indicación inicial. |
| `claude -p "consulta"` | Modo impresión: responde y sale (para scripts, CI, pipes). |
| `cat fichero \| claude -p "consulta"` | Procesa contenido canalizado por stdin. |
| `claude -c` | Continúa la conversación más reciente de este directorio. |
| `claude -r "<sesión>" "consulta"` | Reanuda una sesión por ID o por nombre. |
| `claude update` | Actualiza a la última versión. |
| `claude doctor` | Diagnóstico de instalación y configuración (solo lectura). |

**Regla mental:** interactivo = `claude`; automatizable = `claude -p`. Casi todas las banderas de scripting solo funcionan con `-p`.

---

## 2. Las banderas que se usan siempre

| Bandera | Para qué |
| --- | --- |
| `-p`, `--print` | Respuesta sin modo interactivo. Base de todo el scripting. |
| `-c`, `--continue` | Cargar la última conversación del directorio. |
| `-r`, `--resume` | Reanudar sesión por ID/nombre, o abrir el selector interactivo. |
| `--model` | `sonnet`, `opus`, `haiku`, `fable` o el ID completo (`claude-opus-5`). |
| `--effort` | `low`, `medium`, `high`, `xhigh`, `max`, `ultracode`. No persiste. |
| `--add-dir` | Añadir directorios de trabajo extra que Claude puede leer/editar. |
| `--output-format` | `text` (def.), `json`, `stream-json`. |
| `--verbose`, `-v` | Detalle adicional del agente en modo impresión. |
| `--permission-mode` | Modo de permisos inicial (ver §4). |
| `--allowedTools` / `--disallowedTools` | Qué se ejecuta sin preguntar / qué se deniega. |
| `--append-system-prompt` | Añadir instrucciones al prompt de sistema. |
| `--mcp-config` | Cargar servidores MCP desde JSON. |
| `--version` | Versión instalada. |

### Combinaciones típicas

```bash
# Pregunta puntual sobre el repo
claude -p "explica la arquitectura de src/"

# Revisión en CI con salida estructurada
claude -p --output-format json --max-turns 5 "busca bugs en el diff"

# Continuar la última sesión sin abrir la TUI
claude -c -p "ahora corrige los errores de tipos"

# Herramientas de solo lectura, sin prompts
claude -p --allowedTools "Read" "Bash(git log *)" "Bash(git diff *)" "resume los cambios"

# Sesión con directorios adicionales y modelo concreto
claude --add-dir ../apps ../lib --model opus
```

---

## 3. Scripting y automatización (modo `-p`)

| Bandera | Uso |
| --- | --- |
| `--output-format json` | Salida completa en un objeto JSON. |
| `--output-format stream-json` | Streaming de eventos; requiere `--verbose`. |
| `--input-format stream-json` | Entrada por streaming (conversación programática). |
| `--json-schema '<schema>'` | Fuerza salida JSON validada contra un JSON Schema. |
| `--max-turns N` | Límite de turnos del agente; error al alcanzarlo. |
| `--max-budget-usd N` | Tope de gasto en dólares antes de parar. |
| `--include-partial-messages` | Eventos parciales de streaming. |
| `--replay-user-messages` | Re-emite los mensajes de usuario para acuse de recibo. |
| `--system-prompt` / `--system-prompt-file` | **Reemplaza** el prompt de sistema. |
| `--append-system-prompt` / `--append-system-prompt-file` | **Añade** al prompt de sistema. |
| `--bare` | Arranque rápido: sin hooks, skills, plugins, MCP ni CLAUDE.md. |
| `--no-session-persistence` | No guarda la sesión en disco. |
| `--exclude-dynamic-system-prompt-sections` | Mejora el cache hit entre máquinas/usuarios. |
| `claude setup-token` | Token OAuth de larga duración para CI (requiere suscripción). |

```bash
claude -p --output-format stream-json --verbose "refactoriza el módulo auth"
claude -p --json-schema '{"type":"object","properties":{"bugs":{"type":"array"}}}' "audita el código"
```

---

## 4. Permisos (lo que más se toca)

`--permission-mode` acepta:

- `default` (alias `manual`) — pregunta antes de actuar.
- `acceptEdits` — acepta ediciones de fichero automáticamente.
- `plan` — solo planifica, no ejecuta cambios.
- `auto` — clasificador automático de permisos.
- `dontAsk` — no solicita confirmaciones.
- `bypassPermissions` — omite todo (equivale a `--dangerously-skip-permissions`).

Sintaxis de reglas: nombre simple (`"Edit"`, `"*"`, `"mcp__*"`) o con alcance (`Bash(git log *)`).

- `--allowedTools`: se ejecutan sin preguntar.
- `--tools`: **restringe** qué herramientas existen (por defecto `*`).
- `--disallowedTools`: deniega; el nombre simple elimina la herramienta del contexto, la regla con alcance solo bloquea las llamadas coincidentes.
- `--allow-dangerously-skip-permissions`: añade `bypassPermissions` al ciclo `Shift+Tab` sin arrancar en él.

```bash
claude --permission-mode plan                     # explorar sin riesgo
claude --permission-mode acceptEdits              # iteración rápida
claude --tools "Read" "Bash" -p "analiza los logs" # sandbox de herramientas
```

---

## 5. Sesiones en segundo plano

| Comando / bandera | Uso |
| --- | --- |
| `claude --bg "tarea"` | Lanza un agente de fondo y devuelve el ID. No combina con `-p`. |
| `claude --bg --exec 'pytest -x'` | Ejecuta un comando de shell como trabajo de fondo. |
| `claude agents` | Vista de agentes; `--json` para scripting. |
| `claude attach <id>` | Adjuntar la sesión de fondo a esta terminal. |
| `claude logs <id>` | Ver salida reciente. |
| `claude stop <id>` / `claude rm <id>` | Detener / quitar de la lista. |
| `claude respawn <id>` | Reiniciar conservando la conversación (`--all` para todas). |
| `claude daemon status` / `daemon stop --any` | Estado y parada del supervisor. |

---

## 6. Sesiones: nombrar, reanudar, limpiar

```bash
claude -n "refactor-auth"          # nombre visible en /resume y en el título
claude --resume refactor-auth      # reanudar por nombre
claude --resume abc123 --fork-session   # reanudar creando un ID nuevo
claude --from-pr 123               # reanudar la sesión vinculada a un PR
claude --session-id <uuid>         # fijar el ID de sesión
claude project purge ~/repo --dry-run   # borrar estado local del proyecto
```

---

## 7. Extensiones: MCP, plugins, IDE

```bash
claude mcp                          # configurar servidores MCP
claude mcp login <nombre>           # flujo OAuth (--no-browser sobre SSH)
claude mcp logout <nombre>
claude --mcp-config ./mcp.json
claude --strict-mcp-config          # falla si la config MCP es inválida

claude plugin install code-review@claude-plugins-official
claude --plugin-dir ./mi-plugin     # cargar solo para esta sesión
claude --plugin-url https://.../plugin.zip

claude --ide                        # conectar al IDE al iniciar
claude --chrome / --no-chrome       # integración con Chrome
```

---

## 8. Autenticación

```bash
claude auth login              # --email, --sso, --console
claude auth status             # JSON; --text legible. Exit 0 = logueado
claude auth logout
claude setup-token             # token de larga duración para CI
```

---

## 9. Depuración y sesiones "limpias"

| Bandera | Uso |
| --- | --- |
| `--debug "api,mcp"` | Modo depuración con filtro de categorías (`!statsig` para excluir). |
| `--debug-file <ruta>` | Volcar logs a un fichero. |
| `--safe-mode` | Desactiva **todas** las personalizaciones (CLAUDE.md, skills, plugins, hooks, MCP, temas…) manteniendo auth, modelo, herramientas y permisos. Ideal para aislar qué customización rompe algo. |
| `--bare` | Similar pero orientado a velocidad de arranque en scripts. |
| `claude doctor` | Diagnóstico sin abrir sesión. |

Diferencia clave: `--safe-mode` = *depurar configuración rota*; `--bare` = *arrancar rápido en automatizaciones*.

---

## 10. Detalles útiles que suelen pillar

- `claude --help` **no lista todas las banderas**; que no aparezca no significa que no exista.
- Si escribes mal un subcomando (`claude udpate`), sugiere la corrección y sale.
- `--add-dir` da acceso a ficheros, pero **no** descubre la configuración `.claude/` de esos directorios. Para persistirlos usa `permissions.additionalDirectories` en settings.
- Las banderas de sesión (`--model`, `--effort`) anulan la configuración pero **no persisten**.
- `--fallback-model sonnet,haiku` evita fallos cuando el modelo principal está saturado.
- Varias banderas exigen versión mínima concreta de Claude Code (v2.1.18x–v2.1.20x); comprueba con `claude --version`.
