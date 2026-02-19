# Módulo 12 — Limitaciones, mitigaciones y “playbook” corporativo

<!-- markdownlint-configure-file {"MD012": false, "MD013": false, "MD024": {"siblings_only": true}} -->

## 0) Ficha del módulo (para L&D / implantación)

* **Duración recomendada:** 3h – 4h (con laboratorio).
* **Formato:** workshop + trabajo en equipo (2–5 personas) + revisión conjunta.
* **Prerequisitos:** Módulos 1–6 (mínimo), Git y CI básico, experiencia usando Codex CLI/IDE.
* **Entregable final:** **Codex Playbook** versionado: prompts + skills + configs + métricas + checklist.

---

## 1) Objetivos de aprendizaje (medibles)

Al finalizar, el equipo podrá:

1. Identificar y clasificar fallos típicos (alucinación de APIs, sobre-edición, drift de estilo, supuestos de arquitectura) y **aplicar mitigaciones concretas** por tipo de fallo.
2. Montar un **playbook corporativo** reproducible y versionable:

   * 5 plantillas de prompt
   * 3 skills (ci-guardian, refactor-safe, security-review)
   * baseline `.codex/config.toml` por perfiles
3. Definir y reportar **métricas operativas** (calidad, iteración, riesgo) que permitan mejora continua.

---

## 2) Agenda sugerida (con tiempos)

1. **(25 min)** Taxonomía de fallos + “señales tempranas”.
2. **(35 min)** Mitigaciones por capas: prompt → skills → config → tests/CI.
3. **(30 min)** Migraciones legacy: estrategia incremental + feature flags + compatibilidad.
4. **(15 min)** Métricas y panel mínimo (sin burocracia).
5. **(60–90 min)** Laboratorio L12: construcción del playbook + ejecución end-to-end.
6. **(15 min)** Retro: lecciones + acciones para adopción en la org.

---

## 3) Teoría aplicada: limitaciones típicas y mitigaciones “accionables”

### 3.1 Fallo: alucinaciones de APIs / librerías / flags

#### Síntomas

* Propone funciones inexistentes, endpoints no reales, clases que “suenan” correctas.
* Escribe código que compila “en teoría” pero falla al importar/ejecutar.

#### Mitigaciones

* **Read-first / Plan-first obligatorio**: “antes de tocar nada, localiza el API real en el repo”.
* **Tests como contrato**: “primero añade test que falle por el bug/feature inexistente y que pase al final”.
* **Verificación por herramientas**: “ejecuta import, typecheck, tests; pega el error y corrige”.
* **MCP para documentación** (cuando aplique): conectar Codex a documentación confiable y herramientas externas mediante MCP. ([OpenAI Developers][2])

#### Guardrail de prompt (copy/paste)

* “No inventes APIs. Si no encuentras algo en el repo, dilo y pide confirmación o propón alternativas.”

---

### 3.2 Fallo: cambios de estilo no solicitados (format churn)

#### Síntomas

* Diff enorme por reformat, reordenación de imports, renombrados masivos.
* “Refactor” que en realidad es cosmético.

#### Mitigaciones

* **Límites por archivos (whitelist)**: “solo `src/foo/*` y `tests/foo/*`”.
* **Regla de diff mínimo**: “no cambies formato fuera de líneas tocadas; no reformat global”.
* **Config por perfiles**: un perfil “safe-edit” (aprobaciones estrictas) para cambios pequeños. Los perfiles y su selección están soportados por `config.toml`. ([OpenAI Developers][3])

---

### 3.3 Fallo: sobre-edición (scope creep)

#### Síntomas

* Cambia arquitectura, mueve carpetas, añade dependencias “porque sí”.
* Mezcla refactor + feature + doc en el mismo paquete de cambios.

#### Mitigaciones

* **Criterios de aceptación**: “DoD” explícito (tests/lint/docs) + “no tocar X”.
* **Checkpoints**: pedir al agente que se detenga tras cada paso con diff.
* **Skill “refactor-safe”**: codifica “no behaviour change”, “un paso cada vez”, “mantén API pública”.

---

### 3.4 Fallo: supuestos de arquitectura (inventar capas/patrones)

#### Síntomas

* “Asume” hexagonal, microservicios, CQRS, etc. sin evidencia.
* Propone rediseños por gusto.

#### Mitigaciones

* **Inventario de realidad**: “resume arquitectura observada (carpetas, dependencias, entrypoints) con citas a rutas/archivos”.
* **Decisiones explícitas**: “si hay dos patrones posibles, proponlos y no implementes hasta confirmación”.
* **Feature flags** y compatibilidad en migraciones (ver 3.5).

---

### 3.5 Migraciones legacy: patrón incremental + compatibilidad + feature flags

#### Objetivo

migrar sin “big bang”.

#### Estrategia estándar (playbook)

1. **Baseline**: tests existentes + métricas (tiempo CI, cobertura mínima).
2. **Strangler / adapter**: capa nueva al lado, con adaptadores.
3. **Compatibilidad**: mantener interfaz pública; deprecaciones con periodo.
4. **Feature flags**: activar por entorno/cliente; rollback fácil.
5. **Migración por módulos**: PRs pequeños, CI verde siempre.

#### Guardrails para Codex

* “Cada PR migra 1 módulo, añade tests y no cambia comportamiento salvo el módulo objetivo.”

---

## 4) Buenas prácticas: plantillas corporativas (listas para pegar)

> Formato recomendado: un directorio `playbook/prompts/` con ficheros `.md` que el equipo copia/pega.

### 4.1 Plantilla “feature request”

#### Campos obligatorios

* Objetivo (1 frase)
* Alcance (carpetas/archivos permitidos)
* Restricciones (no dependencias / no cambios de API / no reformat)
* DoD (tests + lint/typecheck + doc)
* Entrega (diff + comandos ejecutados + riesgos)

#### Texto

* “Antes de editar: localiza el punto de entrada y enumera archivos a tocar. Si son >5, para y pregunta.”

---

### 4.2 Plantilla “bug report + repro”

* Repro steps (comandos exactos)
* Expected vs Actual
* Logs / stacktrace
* Entorno (OS, versión, flags)
* DoD:

  1. test que falle
  2. fix mínimo
  3. test pasa + no regresiones

---

### 4.3 Plantilla “refactor safe”

* Objetivo: reducir complejidad/duplicación
* Regla: **no behaviour change**
* Límite: máximo N archivos por iteración
* DoD: tests existentes + nuevos tests si falta cobertura

---

### 4.4 Plantilla “review”

* Revisar como PR:

  * riesgos, edge cases, seguridad básica, rendimiento
  * tests faltantes
  * sugerencias con prioridad (P0/P1/P2)
* Regla: **no aplicar cambios** salvo que se pida explícitamente

---

### 4.5 Plantilla “migration step”

* Módulo objetivo (solo 1)
* Feature flag (nombre, default, rollout)
* Compatibilidad (interfaces y formatos)
* Plan rollback
* DoD: tests + smoke + docs de operación

---

## 5) Skills corporativas: estructura, activación y gobernanza

### 5.1 Qué debe incluir una skill “de verdad”

Una skill es un directorio con `SKILL.md` y opcionalmente scripts/referencias; `SKILL.md` **debe** incluir `name` y `description` en frontmatter, y Codex carga instrucciones completas solo cuando decide usarla (“progressive disclosure”). ([OpenAI Developers][1])

#### Estructura recomendada

* `Trigger conditions` (cuándo aplica)
* `Workflow` (pasos)
* `Guardrails` (límites: archivos, dependencias, comportamiento)
* `Verification` (comandos de test/lint)
* `Definition of Done`

### 5.2 Gobernanza mínima

* Las skills viven en repo (`.agents/skills/...`) o a nivel usuario, pero **las corporativas** deben ir en repo y **versionadas**.
* Cada skill tiene:

  * owner (equipo)
  * versión
  * changelog
  * tests de “comportamiento esperado” (al menos checklist)

---

## 6) Configuración corporativa: perfiles, sandbox y approvals

### 6.1 Perfiles por rol (ejemplo de catálogo)

Codex permite perfiles en `config.toml` y seleccionar perfil por defecto o por CLI. ([OpenAI Developers][3])

* **profile: safe-readonly**

  * lectura, revisión, planificación (casi sin ejecución)
* **profile: dev-edit**

  * ediciones permitidas en workspace con approvals “untrusted”
* **profile: ci-fixer**

  * más automatización, pero con límites y verificación fuerte
* **profile: deep-review**

  * modelo más capaz, reasoning alto, pero sin tocar dependencias

### 6.2 Seguridad por defecto (punto de policy)

En Codex app/CLI/IDE, el modo sandbox `workspace-write` mantiene la **red deshabilitada por defecto** salvo que se habilite explícitamente en configuración. ([OpenAI Developers][4])

#### Policy corporativa mínima

* Red OFF por defecto.
* Habilitación solo para proyectos “trusted”.
* Aprobaciones obligatorias para:

  * instalar dependencias
  * tocar CI
  * migraciones
  * cambios en auth/crypto

---

## 7) Métricas recomendadas (prácticas y accionables)

### 7.1 Métricas “mínimas viables” (por tarea / PR)

1. **Tests verdes al primer intento (%)**
2. **Iteraciones por tarea** (cuántas rondas prompt→diff→fix)
3. **Tamaño del diff** (líneas tocadas, nº de archivos)
4. **Retrabajo por regresión** (PRs de revert/fix en 7–14 días)

### 7.2 Interpretación (qué significa “mal”)

* Iteraciones altas + diffs grandes → falta guardrails / skills / DoD.
* Retrabajo alto → tests insuficientes o prompts ambiguos.
* Tests verdes bajos → escoger mal el perfil/modelo o validar tarde.

### 7.3 Ritual semanal de mejora (15 min)

* Revisar 5 PRs recientes con Codex:

  * ¿Qué prompt funcionó?
  * ¿Qué skill faltó?
  * ¿Qué guardrail evitaba el problema?
* Actualizar playbook (PR pequeño).

---

## Laboratorio (L12) — Construcción del “Codex Playbook” del equipo

### Objetivo

Entregar un paquete reutilizable y versionable:

* 5 plantillas de prompt
* 3 skills (ci-guardian, refactor-safe, security-review)
* baseline `.codex/config.toml` por perfil
* mini-dashboard de métricas (aunque sea en Markdown)

### Duración

60–90 min (recomendado en equipos de 2–5).

---

## Paso 1 — Crear estructura `codex-lab12/` y `playbook/` (10 min)

1. Crear repo temporal:

   ```bash
   mkdir codex-lab12 && cd codex-lab12
   git init
   mkdir -p playbook/prompts playbook/metrics .agents/skills .codex
   ```

2. Añadir `playbook/README.md` con objetivo y reglas del juego:

   * “Todo cambio con Codex debe usar una plantilla”
   * “Toda tarea debe tener DoD y comandos”

**Resultado esperado:** estructura base lista.

---

## Paso 2 — Crear las 5 plantillas de prompt (15–20 min)

Crea estos archivos (contenido mínimo + campos):

* `playbook/prompts/feature.md`
* `playbook/prompts/bug-repro.md`
* `playbook/prompts/refactor-safe.md`
* `playbook/prompts/review.md`
* `playbook/prompts/migration-step.md`

**Regla:** cada plantilla debe incluir:

* Alcance (paths)
* Restricciones
* DoD
* Verificación (comandos)
* Entrega (diff + supuestos)

**Resultado esperado:** 5 ficheros listos para copiar/pegar.

---

## Paso 3 — Crear 3 skills corporativas (20–30 min)

> Cada skill: carpeta + `SKILL.md` con `name` y `description` en frontmatter; instrucciones en Markdown. ([OpenAI Developers][1])

Estructura:

* `.agents/skills/ci-guardian/SKILL.md`
* `.agents/skills/refactor-safe/SKILL.md`
* `.agents/skills/security-review/SKILL.md`

### Contenido mínimo recomendado por skill

1. **ci-guardian**

   * Workflow: leer fallo CI → reproducir local → fix mínimo → rerun
   * Guardrails: no subir dependencias sin permiso, no tocar >N archivos
   * Verification: comandos de CI local

2. **refactor-safe**

   * Workflow: snapshot tests → refactor pequeño → rerun
   * Guardrails: no behaviour change, API intacta
   * Verification: tests + coverage mínima (si aplica)

3. **security-review**

   * Checklist: inputs, authz, secretos, logs, dependencias
   * Output: findings P0/P1/P2 + sugerencias de tests
   * Guardrails: no introducir datos sensibles

**Resultado esperado:** 3 skills que se activan con descripciones precisas.

---

## Paso 4 — Baseline `.codex/config.toml` por perfiles (15–20 min)

1. Crear `.codex/config.toml` (repo-scoped) con perfiles:

   * `safe-readonly`
   * `dev-edit`
   * `ci-fixer`
2. Asegurar:

   * approvals/política según perfil
   * sandbox adecuado
3. Documentar en `playbook/README.md` cuándo usar cada perfil.

> Codex soporta perfiles en `config.toml` y selección/por defecto. ([OpenAI Developers][3])
> Mantén red OFF salvo necesidad explícita (seguridad). ([OpenAI Developers][4])

**Resultado esperado:** config reproducible y explicada.

---

## Paso 5 — Ejecutar una tarea end-to-end con el playbook (20–30 min)

1. Elige una tarea pequeña (ejemplos):

   * “Añadir endpoint /health con test”
   * “Arreglar bug de validación en una función”
2. **Obligatorio**: usar una plantilla del playbook + invocar una skill (p.ej. `refactor-safe` o `ci-guardian`).
3. Ejecutar verificación (tests/lint).
4. Rellenar métricas en `playbook/metrics/run-001.md`:

   * iteraciones
   * tamaño diff
   * tests verdes a la primera (sí/no)
   * retrabajo (N/A)

**Resultado esperado:** demostración real de que el playbook reduce caos y aumenta repetibilidad.

---

## Criterios de evaluación (rúbrica)

* **(30%)** Plantillas completas (DoD + verificación + guardrails)
* **(30%)** Skills activables (descripción precisa + workflow + verificación)
* **(25%)** Config por perfiles coherente con seguridad/operación
* **(15%)** Ejecución end-to-end + registro de métricas

---

## Limpieza (obligatoria)

### Si es laboratorio aislado

```bash
cd ..
rm -rf codex-lab12
unset OPENAI_API_KEY
rm -f .env .env.local .envrc
```

### Si se integra en repo real

* Eliminar **solo** artefactos de laboratorio (runs temporales, ramas experimentales).
* Mantener `playbook/`, `.agents/skills/`, `.codex/config.toml` **versionados** tras revisión.

---

## Apéndice: “Checklist de adopción” (para rollout corporativo)

* [ ] 1 playbook por org/equipo, versionado en repo plantilla
* [ ] 3–5 perfiles de config y reglas de uso documentadas
* [ ] 5 plantillas obligatorias (feature/bug/refactor/review/migration)
* [ ] 3 skills base + proceso para añadir nuevas
* [ ] Métricas mínimas recogidas semanalmente (15 min)
* [ ] Política de seguridad: red OFF por defecto; approvals para acciones sensibles ([OpenAI Developers][4])

---

Si quieres, te lo dejo además en formato **“kit descargable”** (estructura de carpetas + ficheros ya rellenos) para que tu equipo lo copie en su repo plantilla.

[1]: https://developers.openai.com/codex/skills/?utm_source=chatgpt.com "Agent Skills"
[2]: https://developers.openai.com/codex/mcp/?utm_source=chatgpt.com "Model Context Protocol"
[3]: https://developers.openai.com/codex/config-advanced/?utm_source=chatgpt.com "Advanced Configuration"
[4]: https://developers.openai.com/codex/security/?utm_source=chatgpt.com "Security"

