# Plan de formación OpenAI-Codex

A continuación tienes un **plan formativo corporativo, completo y progresivo**
para que equipos de desarrollo aprovechen **Codex (OpenAI)** como
**asistente/agente de programación** en entornos reales (local, IDE, cloud y
automatizaciones). Está diseñado para impartirse en **módulos independientes**
(puedes compactarlo en 2–5 días intensivos o en 4–8 semanas).

> Referencias oficiales clave (se citan en el contenido): documentación de
**Codex** (CLI/IDE/App/Cloud, configuración, MCP, Skills, seguridad), catálogo
de **modelos** de OpenAI y guías de **reasoning**. ([OpenAI Developers][1])

---

## Módulo 1 — Fundamentos de Codex como agente de desarrollo (Intro)

### Objetivos de aprendizaje del Módulo 1

* Entender qué es Codex (agente que **lee/edita/ejecuta** código) y en qué se
diferencia de “chat de ayuda”.
* Conocer los **clientes**: CLI, extensión IDE, app de escritorio y Codex cloud.
* Adoptar un flujo de trabajo “humano en control”: revisión de diffs,
aprobaciones, y trazabilidad.

### Contenidos teóricos del Módulo 1

* Capacidades base: generación de código, comprensión de codebases, revisión y
corrección de bugs. ([OpenAI Developers][2])
* Modos de uso: **local (CLI)**, **IDE (VS Code y compatibles)**, **app**
(multi-agente) y **cloud** (ejecución en entorno remoto). ([OpenAI
Developers][1])
* Filosofía de trabajo: tareas pequeñas vs. tareas largas, checkpoints y
validación.

### Buenas prácticas del Módulo 1

* Pedir resultados verificables: “incluye comandos para ejecutar tests”,
“muestra diff”, “explica supuestos”.
* Mantener tareas acotadas: objetivo, restricciones, definición de “done”.
* Revisar siempre los cambios como si fuera un PR.

### Errores comunes del Módulo 1

* “Hazlo todo” sin criterios de aceptación.
* No fijar límites: el agente toca demasiados archivos o cambia estilos sin
permiso.
* Confiar en explicaciones sin ejecutar tests/lint.

### Casos de uso reales del Módulo 1

* Onboarding a repos grandes: mapa de módulos, puntos de entrada.
* Hotfix guiado con pruebas.
* Generación de documentación técnica del repo.

### Laboratorio práctico (L1) — Primer ciclo agente→diff→validación

* **Objetivo:** crear una funcionalidad pequeña en un repo de ejemplo y
validarla.
* **Pasos:**

  1. Crear repo temporal `codex-lab01/` con un servicio mínimo (p.ej.,
  Node/Express o Python/FastAPI).
  2. Ejecutar Codex (CLI o IDE) y pedir: endpoint + tests + README.
  3. Revisar el **diff**, pedir ajustes (naming, estructura) y ejecutar tests.
* **Resultado esperado:** PR local con endpoint funcional + tests verdes +
README.
* **Limpieza (obligatoria):**

  * Borrar repo: `rm -rf codex-lab01`
  * Si usaste claves, eliminarlas del entorno: `unset OPENAI_API_KEY` (o
  equivalente) y borrar archivos `.env`.

---

## Módulo 2 — Instalación y uso eficiente de herramientas (CLI, IDE, App, Cloud)

### Objetivos del Módulo 2

* Instalar y operar **Codex CLI** y **Codex IDE extension**.
* Entender configuración por capas (usuario vs repo).
* Saber cuándo usar app de escritorio y cuándo cloud.

### Teoría del Módulo 2

* Codex CLI: agente local en el directorio, open-source, orientado a repos
reales. ([OpenAI Developers][1])
* Extensión IDE: disponible en VS Code y editores compatibles (Cursor, Windsurf,
etc.), comparte agente y configuración con CLI. ([OpenAI Developers][3])
* Config por capas: `~/.codex/config.toml` (usuario) y `.codex/config.toml`
(repo). ([OpenAI Developers][4])
* App de Codex: enfoque multi-agente y proyectos. ([OpenAI][5])
* Codex cloud: delegación en entorno cloud con tareas en paralelo. ([OpenAI
Developers][6])

### Buenas prácticas del Módulo 2

* Definir “proyecto” con mínimo alcance (sandbox): separar monorepos por
subproyectos en la app.
* Usar configuración repo-scoped para estandarizar en el equipo (sin secretos).
* Preferir CLI para automatizar rutinas repetibles; IDE para pair-programming y
refactorización interactiva.

### Errores comunes del Módulo 2

* Mezclar config global con config del repo sin control.
* Ejecutar en directorio equivocado (alcance excesivo).
* No versionar convenciones (lint, formato) y luego culpar a la IA de
inconsistencias.

### Casos reales del Módulo 2

* Setup corporativo: baseline config + políticas.
* Homogeneizar comandos y flujos entre equipos.

### Laboratorio (L2) — “Setup corporativo mínimo”

* **Objetivo:** dejar listo un repo con configuración estándar para que Codex
trabaje de forma consistente.
* **Pasos:**

  1. Crear `codex-lab02/` con un proyecto y añadir `.codex/config.toml`.
  2. Configurar: estilo (formatter/linter), comandos recomendados (build/test),
  y restricciones.
  3. Probar en CLI e IDE que ambos respetan la misma config.
* **Resultado esperado:** mismo comportamiento del agente en CLI e IDE,
reproducible.
* **Limpieza:** `rm -rf codex-lab02` y revertir cambios en
`~/.codex/config.toml` si aplicaste valores de prueba.

---

## Módulo 3 — Selección del modelo óptimo para programación (coste, latencia, calidad)

### Objetivos del Módulo 3

* Elegir modelo según tarea: generación, refactor, debugging, tareas largas
“agentic”.
* Entender la diferencia práctica entre **modelos de razonamiento** y
no-razonamiento.

### Teoría del Módulo 3

* Catálogo de modelos y variantes “Codex” optimizadas para coding/agentic tasks.
([OpenAI][7])
* Buenas prácticas para **reasoning models** (cuándo convienen y cómo pedirles
trabajo). ([OpenAI][8])
* Novedades relevantes en modelos “Codex” (p.ej. familias optimizadas y mejoras
de velocidad/alcance). ([OpenAI][9])

### Guía de decisión del Módulo 3

* **Tareas largas y multi-paso (agentic)**: usar modelos “Codex” de mayor
capacidad (p.ej. variantes “-Codex” y/o “Max” cuando existan), especialmente si
el agente debe planificar, ejecutar y revisar. ([OpenAI][7])
* **Cambios pequeños y repetitivos**: modelos “mini/nano” cuando el output sea
bien definido y validado por tests.
* **Análisis complejo (arquitectura, debugging difícil, migración)**: modelos de
razonamiento o modelos top de la línea, con prompts orientados a verificación.

### Buenas prácticas del Módulo 3

* Emparejar modelo con *grado de verificación automática*: cuanto menos tests
tengas, más “capacidad” necesitas y más revisión humana.
* “Escalar” el modelo solo cuando se atasque: empieza barato, sube cuando el
plan falle.

### Errores comunes del Módulo 3

* Usar el modelo más caro para todo.
* No medir: latencia, coste por tarea, tasa de retrabajo.

### Casos reales del Módulo 3

* Política corporativa de modelos por tipo de trabajo (feature, hotfix,
refactor, doc).
* “Model routing” en equipos (plantillas por tarea).

### Laboratorio (L3) — Benchmark interno de 3 modelos

* **Objetivo:** comparar 3 perfiles (alto/medio/rápido) en la misma tarea.
* **Pasos:**

  1. Definir una tarea idéntica: añadir feature + tests + pequeña refactor.
  2. Ejecutarla con 3 configuraciones de modelo (según disponibilidad del
  entorno).
  3. Medir: nº de iteraciones, cambios innecesarios, tiempo hasta tests verdes.
* **Resultado esperado:** tabla interna de decisión del equipo (modelo→tipo de
tarea).
* **Limpieza:** borrar repo `codex-lab03/` y cualquier log exportado con datos
sensibles.

---

## Módulo 4 — Gestión avanzada del contexto (prompts, historial, límites, estrategias)

### Objetivos del Módulo 4

* Mantener a Codex “en carril” en repos grandes.
* Diseñar prompts que produzcan **cambios mínimos, revisables y testeables**.
* Evitar degradación por contexto insuficiente o ruido.

### Teoría del Módulo 4

* Estrategias de contexto: “brief + constraints + definition of done +
commands”.
* Contexto progresivo: no volcar todo; alimentar por fases
(lectura→plan→edición→validación).
* Uso de habilidades/Skills como *contexto reutilizable* (se profundiza en el
módulo 5). ([OpenAI Developers][10])

### Buenas prácticas (plantillas) del Módulo 4

* **Plantilla Feature**: alcance, rutas/archivos permitidos, estilo, criterios,
tests a ejecutar.
* **Plantilla Bugfix**: reproducción, hipótesis, instrumentación, fix,
regresión.
* **Plantilla Refactor**: objetivos (complejidad, duplicación), “no behaviour
change”, tests.

### Errores comunes del Módulo 4

* Pedir “refactoriza todo el repo”.
* No fijar *guardrails*: “no cambies API pública”, “no rompas compatibilidad”.
* No pedir comandos de verificación.

### Casos reales del Módulo 4

* Onboarding: “explica el flujo de auth y dónde cambiarlo”.
* Aislar el cambio a un paquete/módulo en monorepo.

### Laboratorio (L4) — Prompting con guardrails y reducción de diffs

* **Objetivo:** lograr una mejora con **diff mínimo** y validación reproducible.
* **Pasos:**

  1. Tomar un componente con deuda técnica (p.ej., función larga).
  2. Prompt con: archivos permitidos, límite de líneas, mantener API, añadir
  tests.
  3. Iterar hasta pasar tests con diff acotado.
* **Resultado esperado:** refactor pequeño, seguro y testeado.
* **Limpieza:** `rm -rf codex-lab04` y borrar ramas locales.

---

## Módulo 5 — Skills: diseño de “SKILL.md” y librería de habilidades del equipo (obligatorio)

### Objetivos del Módulo 5

* Crear skills reutilizables y gobernables: estándar de equipo.
* Activación explícita/implícita y “progressive disclosure” del contexto.
* Sustituir “custom prompts” (deprecados) por skills. ([OpenAI Developers][11])

### Teoría del Módulo 5

* Qué es un **skill**: directorio con `SKILL.md` (YAML frontmatter
`name/description`) + scripts opcionales; Codex carga instrucciones completas
solo cuando aplica. ([OpenAI Developers][10])
* Ubicación: user-scoped `~/.agents/skills/…` o repo-scoped `.agents/skills/…`.
([OpenAI Developers][12])
* Diseño de `description` para evitar *over-triggering*. ([OpenAI
Developers][12])

### Buenas prácticas del Módulo 5

* Skills por disciplina: `backend-api`, `frontend-react`, `db-migrations`,
`security-review`, `ci-fix`.
* Incluir checklist de verificación en el skill (tests, lint, amenazas).
* Mantener skills versionadas y revisadas como código.

### Errores comunes del Módulo 5

* Descripciones vagas (“ayuda con todo”) → activación errática.
* Mezclar políticas de seguridad con instrucciones de estilo sin prioridades.
* Skills gigantes: mejor composables.

### Casos reales del Módulo 5

* Skill de **“fix CI hasta verde”** (con pasos y límites).
* Skill de **“migración legacy”** con estrategia incremental.

### Laboratorio (L5) — Crear 2 skills corporativas

* **Objetivo:** crear skills listas para producción.
* **Pasos:**

  1. Crear `.agents/skills/ci-guardian/SKILL.md` con: criterios CI, comandos,
  rollback.
  2. Crear `.agents/skills/refactor-safe/SKILL.md` con: “no behaviour change”,
  tests, límites.
  3. Probar invocación explícita (mencionando la skill) y verificar que reduce
  iteraciones.
* **Resultado esperado:** 2 skills funcionales, con `description` precisa.
* **Limpieza:** borrar el repo `codex-lab05/` (o si se trabaja sobre repo real,
eliminar solo las carpetas de skill creadas para el laboratorio).

---

## Módulo 6 — Configuración profesional: policies, approvals, sandbox, red, perfiles (obligatorio)

### Objetivos del Módulo 6

* Controlar permisos y riesgos operativos del agente.
* Aplicar configuración por proyecto y perfiles (dev vs prod-like).
* Entender defaults de seguridad (p.ej. red deshabilitada por defecto
localmente).

### Teoría del Módulo 6

* Seguridad en Codex: sandbox del SO, control de aprobaciones, red desactivada
por defecto. ([OpenAI Developers][13])
* Configuración (básica y avanzada) y referencia completa de `config.toml`.
([OpenAI Developers][4])

### Buenas prácticas del Módulo 6

* Aprobar explícitamente acciones con impacto: instalación paquetes, cambios
masivos, comandos destructivos.
* Perfiles de config: `safe-readonly`, `dev-edit`, `ci-fixer`.
* “Trusted projects”: solo permitir capacidades avanzadas en repos confiables.

### Errores comunes del Módulo 6

* Activar red/herramientas externas sin auditoría.
* Permitir comandos arbitrarios sin política de aprobación.
* No registrar qué hizo el agente (difícil post-mortem).

### Casos reales del Módulo 6

* Equipos regulados: política de red, secretos, y alcance de filesystem.
* Entornos con datos sensibles: separación de repos y acceso mínimo.

### Laboratorio (L6) — Política de aprobaciones y sandbox

* **Objetivo:** configurar un proyecto con límites estrictos y comprobar que se
respetan.
* **Pasos:**

  1. Crear `codex-lab06/` y establecer `.codex/config.toml` con políticas
  “safe”.
  2. Pedir a Codex una tarea que requiera acciones sensibles (p.ej., instalar
  dependencia).
  3. Verificar que el agente solicita aprobación según lo esperado.
* **Resultado esperado:** comportamiento “seguro por defecto”.
* **Limpieza:** `rm -rf codex-lab06` y revertir cambios de config global.

---

## Módulo 7 — Integraciones: MCP (Model Context Protocol) y herramientas externas

### Objetivos del Módulo 7

* Conectar Codex a herramientas (tickets, observabilidad, repos, etc.) vía MCP.
* Diseñar “herramientas” con contratos claros para que el agente sea fiable.

### Teoría del Módulo 7

* MCP en Codex: configuración en `config.toml`, compartida entre CLI e IDE;
gestión con comandos `codex mcp`. ([OpenAI Developers][14])
* Principios de diseño de herramientas:

  * idempotencia
  * respuestas estructuradas
  * límites de alcance y permisos

### Buenas prácticas del Módulo 7

* MCP servers por entorno (dev/stage) y por rol (lectura vs escritura).
* Sanitizar entradas/salidas (no filtrar secretos).
* Observabilidad: logging, trazas, correlación por tarea.

### Errores comunes del Módulo 7

* Herramientas con efectos colaterales no controlados.
* Contratos ambiguos → decisiones erróneas del agente.

### Casos reales del Módulo 7

* Integrar: gestor de incidencias, consultas a DB, Sentry, pipelines CI (si la
org lo permite).

### Laboratorio (L7) — Conectar un MCP server “mock”

* **Objetivo:** que Codex llame una herramienta externa controlada.
* **Pasos:**

  1. Levantar un servidor MCP de ejemplo (mock) que devuelva datos estáticos
  (p.ej., lista de tickets).
  2. Añadir configuración MCP al `config.toml` del lab.
  3. Pedir a Codex: “elige el ticket más prioritario y propone fix + tests”.
* **Resultado esperado:** Codex usa la herramienta, incorpora datos y produce
cambios verificables.
* **Limpieza:** detener el servidor MCP, borrar `codex-lab07/` y eliminar
entradas MCP del config del laboratorio.

---

## Módulo 8 — Refactorización, revisión de código y optimización con IA

### Objetivos del Módulo 8

* Usar Codex como “reviewer” (bugs, edge cases, estilo, rendimiento).
* Refactor incremental y seguro.
* Optimización con límites medibles (latencia, memoria, complejidad).

### Teoría del Módulo 8

* Codex para revisión y análisis de riesgos en cambios. ([OpenAI Developers][2])
* Técnicas:

  * refactor por “strangler pattern”
  * snapshots de tests
  * small PRs + “safe steps”

### Buenas prácticas del Módulo 8

* Pedir “review en formato PR”: riesgos, escenarios, tests faltantes.
* Obligar a proponer tests antes de tocar lógica crítica.
* Usar perfiles: “review-only” vs “edit”.

### Errores comunes del Módulo 8

* Refactor sin tests → regresiones.
* Optimización prematura sin baseline.

### Casos reales del Módulo 8

* Reducir duplicación en un módulo legacy.
* Revisiones de PR para seguridad básica y robustez.

### Laboratorio (L8) — “Codex como revisor de PR”

* **Objetivo:** generar una revisión accionable y aplicar correcciones.
* **Pasos:**

  1. Crear una rama con un cambio deliberadamente imperfecto.
  2. Pedir a Codex revisión: bugs, edge cases, estilo, seguridad básica.
  3. Aplicar solo las correcciones justificadas y medir mejoras (tests + lint).
* **Resultado esperado:** checklist de revisión + PR mejorado.
* **Limpieza:** borrar repo `codex-lab08/` y ramas locales.

---

## Módulo 9 — Testing y debugging asistidos: unit, integración, smoke, seguridad, GUI (obligatorio por alcance)

### Objetivos del Módulo 9

* Generar suites de tests útiles (no “tests placebo”).
* Debugging basado en reproducción: logs, trazas, minimización.
* Estrategias específicas por tipo de test.

### Teoría del Módulo 9

* Pirámide de pruebas y estrategia:

  * **Unit**: lógica pura, contratos.
  * **Integración**: DB/colas/IO (con contenedores o dobles).
  * **Smoke**: rutas críticas post-deploy.
  * **Seguridad**: checks SAST básicos, validación de inputs, authz.
  * **GUI/E2E**: flujos clave, selectores estables.
* Prompting para debugging: “pasos de reproducción + expected vs actual +
entorno”.

### Buenas prácticas del Módulo 9

* Exigir a Codex que:

  * añada casos límite
  * explique por qué el test fallaría antes del fix
  * ejecute comandos de test (o los proponga)
* Minimizar flakiness (E2E): waits correctos, datos deterministas.

### Errores comunes del Módulo 9

* Tests que replican la implementación (no el contrato).
* E2E excesivos para todo.

### Casos reales del Módulo 9

* Bug intermitente en producción: reducir a repro local + test de regresión.
* Endurecer validación de inputs y permisos.

### Laboratorio (L9) — Batería de pruebas completa para un módulo crítico

* **Objetivo:** crear unit+integración+smoke y un set básico de seguridad.
* **Pasos:**

  1. Seleccionar un módulo (auth, pagos simulado, etc.).
  2. Pedir a Codex: tests unitarios con casos límite + integración con recurso
  real/mocked + smoke script.
  3. Incluir checks de seguridad básicos (validación, authz, sanitización).
* **Resultado esperado:** pipeline local con pruebas por capas y regresión del
bug.
* **Limpieza:** borrar repo `codex-lab09/`, contenedores/volúmenes si se usaron
(p.ej. `docker rm -f …`, `docker volume rm …`).

---

## Módulo 10 — CI/CD, control de versiones y operación en equipos

### Objetivos del Módulo 10

* Integrar Codex en flujos CI/CD y Git de forma segura.
* Estandarizar commits, PRs, ramas, plantillas y revisiones.
* Automatizar tareas repetibles sin perder control humano.

### Teoría del Módulo 10

* Codex CLI como herramienta operable y repetible en flujos de automatización.
([OpenAI Developers][15])
* En la app: настройки Git (branch naming, force push, prompts para
commits/PRs). ([OpenAI Developers][16])
* Patrones:

  * “Codex propone, humano aprueba”
  * PRs pequeños
  * CI como árbitro: “no merge sin verde”

### Buenas prácticas del Módulo 10

* Generación de mensajes de commit/PR con plantilla corporativa (qué, por qué,
cómo probar).
* Hooks: lint/test pre-commit; “Codex no toca” carpetas sensibles.
* Modo “fix CI”: iterar hasta verde (con límites de intentos).

### Errores comunes del Módulo 10

* Dejar que el agente reescriba historial sin política.
* Automatizar merges sin revisión.

### Casos reales del Módulo 10

* Migración gradual: PRs por módulos, con verificación y rollback.

### Laboratorio (L10) — “PR listo para producción”

* **Objetivo:** producir un PR con checklist, pruebas y descripción estándar.
* **Pasos:**

  1. Crear repo con pipeline simple (GitHub Actions o similar local simulado).
  2. Pedir a Codex: cambio + tests + actualización CI + texto de PR con
  checklist.
  3. Ejecutar pipeline y corregir hasta verde.
* **Resultado esperado:** PR reproducible con CI verde y documentación.
* **Limpieza:** borrar repo `codex-lab10/` y revocar tokens si se usaron.

---

## Módulo 11 — Seguridad, privacidad y control de calidad del código generado (obligatorio)

### Objetivos del Módulo 11

* Aplicar prácticas de seguridad: secretos, dependencias, prompt injection,
supply chain.
* Entender retención y controles de datos a nivel organización.
* Establecer un “Definition of Done” de calidad para código generado.

### Teoría del Módulo 11

* Seguridad operativa de Codex: sandbox, red por defecto deshabilitada y
políticas de aprobación. ([OpenAI Developers][13])
* Controles empresariales de datos (retención configurable / zero data retention
en API para organizaciones que califican). ([OpenAI][17])
* Principios:

  * **Nunca** pegar secretos en prompts.
  * Revisión de licencias/dependencias.
  * SAST/linters, validación de entradas, authz, logging sin PII.

### Buenas prácticas del Módulo 11

* Checklist de seguridad para tareas Codex:

  * ¿tocó auth/authz?
  * ¿añadió dependencias?
  * ¿maneja inputs y errores?
  * ¿logs exponen PII/secrets?
* “Quality gates”: tests, linters, scanning dependencias, cobertura mínima.

### Errores comunes del Módulo 11

* Copiar trazas con tokens/API keys.
* Aceptar dependencias sugeridas sin revisar CVEs/licencias.

### Casos reales del Módulo 11

* Hardening de endpoints.
* Sanitización de logs y protección de PII.

### Laboratorio (L11) — Auditoría de seguridad y hardening

* **Objetivo:** detectar y corregir vulnerabilidades típicas en un servicio
pequeño.
* **Pasos:**

  1. Introducir vulnerabilidades controladas (inyección, falta de authz, logs
  con PII).
  2. Pedir a Codex revisión de seguridad + parche + tests de regresión.
  3. Validar con linters/scanners (según stack).
* **Resultado esperado:** informe breve + fixes + tests.
* **Limpieza:** borrar repo `codex-lab11/` y eliminar cualquier reporte que
contenga datos sensibles del entorno.

---

## Módulo 12 — Limitaciones, mitigaciones y “playbook” corporativo

### Objetivos del Módulo 12

* Reconocer fallos típicos del modelo/agente y diseñar mitigaciones.
* Estandarizar un playbook: prompts, skills, configs, métricas.
* Preparar a los equipos para trabajar con codebases legacy y migraciones.

### Teoría del Módulo 12

* Limitaciones habituales:

  * alucinaciones de APIs
  * cambios de estilo no solicitados
  * sobre-edición
  * suposiciones de arquitectura
* Mitigaciones:

  * “read-first / plan-first”
  * límites por archivos
  * skills especializadas
  * tests como contrato
* Migraciones legacy: patrón incremental, compatibilidad, feature flags.

### Buenas prácticas del Módulo 12

* Plantillas corporativas:

  * “feature request”
  * “bug report + repro”
  * “refactor safe”
  * “migration step”
* Métricas recomendadas:

  * tasa de tests verdes al primer intento
  * nº de iteraciones por tarea
  * tamaño promedio de diff
  * retrabajo por regresión

### Errores comunes del Módulo 12

* No capturar aprendizaje del equipo (cada uno “promptea a su manera”).
* No versionar skills/configs.

### Casos reales del Módulo 12

* Migración de framework (frontend/backend) por módulos.
* Modernización de scripts de sistemas y pipelines.

### Laboratorio (L12) — Construcción del “Codex Playbook” del equipo

* **Objetivo:** entregar un paquete reutilizable: skills + prompts + políticas +
métricas.
* **Pasos:**

  1. Crear `playbook/` con:

     * 5 plantillas de prompt (feature/bug/refactor/review/migration)
     * 3 skills (ci-guardian, refactor-safe, security-review)
     * baseline `.codex/config.toml` por perfil
  2. Ejecutar una tarea end-to-end con el playbook y ajustar.
* **Resultado esperado:** playbook listo para adopción por todo el equipo.
* **Limpieza:** si es laboratorio aislado, `rm -rf codex-lab12/`. Si se integra
en repo real, eliminar solo artefactos de laboratorio y dejar el playbook
versionado tras revisión.

---

## Material de soporte para impartición (recomendado)

* **Guía rápida de clientes Codex** (CLI/IDE/App/Cloud) y cuándo usar cada uno.
([OpenAI Developers][1])
* **Guía de configuración** (capas, referencia y ejemplo completo de
`config.toml`). ([OpenAI Developers][4])
* **Guía de Skills** (estructura, activación y redacción de `description`).
([OpenAI Developers][10])
* **Guía de seguridad Codex** (sandbox, red, approvals) + política interna de
datos. ([OpenAI Developers][13])
* **Guía de selección de modelos** (tabla interna del equipo) apoyada en
catálogo oficial y reasoning best practices. ([OpenAI][7])

---

Si quieres, puedo convertir esto en un **temario calendarizado** (p.ej. 3 días
intensivos o 6 semanas), con **duración por módulo, rúbricas de evaluación, y
checklist de adopción** para que lo uses tal cual en un plan de formación
corporativo.

[1]: https://developers.openai.com/codex/cli/?utm_source=chatgpt.com "Codex CLI"
[2]: https://developers.openai.com/codex/?utm_source=chatgpt.com "Codex"
[3]: https://developers.openai.com/codex/ide/?utm_source=chatgpt.com "Codex IDE extension"
[4]: https://developers.openai.com/codex/config-basic/?utm_source=chatgpt.com "Config basics"
[5]: https://openai.com/index/introducing-the-codex-app/?utm_source=chatgpt.com "Introducing the Codex app"
[6]: https://developers.openai.com/codex/cloud/?utm_source=chatgpt.com "Codex web"
[7]: https://platform.openai.com/docs/models?utm_source=chatgpt.com "Models | OpenAI API"
[8]: https://platform.openai.com/docs/guides/reasoning-best-practices?utm_source=chatgpt.com "Reasoning best practices | OpenAI API"
[9]: https://openai.com/index/introducing-gpt-5-3-codex/?utm_source=chatgpt.com "Introducing GPT-5.3-Codex"
[10]: https://developers.openai.com/codex/skills/?utm_source=chatgpt.com "Agent Skills"
[11]: https://developers.openai.com/codex/custom-prompts/?utm_source=chatgpt.com "Custom Prompts"
[12]: https://developers.openai.com/codex/skills/create-skill/?utm_source=chatgpt.com "Create skills"
[13]: https://developers.openai.com/codex/security/?utm_source=chatgpt.com "Security"
[14]: https://developers.openai.com/codex/mcp/?utm_source=chatgpt.com "Model Context Protocol"
[15]: https://developers.openai.com/blog/openai-for-developers-2025/?utm_source=chatgpt.com "OpenAI for Developers in 2025"
[16]: https://developers.openai.com/codex/app/settings/?utm_source=chatgpt.com "Codex app settings"
[17]: https://openai.com/business-data/?utm_source=chatgpt.com "Business data privacy, security, and compliance"
