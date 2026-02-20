## Módulo 10 — CI/CD, control de versiones y operación en equipos

### Propósito del módulo

Aprender a integrar Codex (especialmente vía CLI y app) en flujos reales de trabajo en equipo: Git, PRs, revisiones y CI/CD, manteniendo **seguridad**, **trazabilidad** y **control humano**. El objetivo no es “automatizar por automatizar”, sino **reducir trabajo repetible** y **subir la calidad** sin perder gobernanza.

---

## Objetivos de aprendizaje

Al finalizar el módulo, el/la participante será capaz de:

1. **Integrar Codex** en flujos Git + CI/CD de forma **segura** y **repetible**.
2. **Estandarizar** prácticas de control de versiones: ramas, commits, PRs, plantillas y revisiones.
3. Diseñar automatizaciones con el patrón **“Codex propone, humano aprueba”**.
4. Implementar un modo operativo **“fix CI”** (iteración hasta verde) con límites y guardrails.
5. Reducir riesgos habituales: reescritura de historial, merges sin revisión, cambios en carpetas sensibles, secretos expuestos.

---

## Teoría

### 1) Codex CLI como pieza operable en automatización

Codex CLI puede ejecutarse de forma consistente para tareas repetibles: generar cambios, proponer diffs, actualizar tests, y preparar texto de PR bajo reglas de equipo. En CI/CD, su papel típico no es “mergear”, sino **asistir** y **producir artefactos revisables** (diff, tests, documentación, checklist).
Referencia: [OpenAI Developers][15]

**Enfoque recomendado**

* **Local/Dev**: Codex prepara cambios y el humano revisa.
* **CI**: valida (lint/test/build/security). CI es el árbitro.
* **PR**: vehículo de trazabilidad (qué/por qué/cómo probar).

---

### 2) Configuración Git en la app (y guardrails de equipo)

En la app (multi-agente), suelen existir configuraciones orientadas a:

* **Branch naming** (convenciones de ramas).
* Restricciones sobre **force push**.
* Prompts / plantillas para **commits** y **PRs**.
* Límites para reintentos y alcance de cambios.

La idea es que la herramienta trabaje **dentro de la política** del equipo.
Referencia: [OpenAI Developers][16]

---

### 3) Patrones operativos clave

#### a) “Codex propone, humano aprueba”

* Codex produce: cambios + explicación + cómo probar + riesgos.
* El humano: revisa diff, ejecuta pruebas, valida impacto, aprueba/ajusta.

#### b) PRs pequeños

* Menos superficie → mejor revisión → menos conflictos → merges más seguros.
* Regla práctica: **un PR = un propósito** (bugfix, refactor acotado, feature slice).

#### c) CI como árbitro (“no merge sin verde”)

* El CI tiene la última palabra: si no está verde, no se integra.
* La mejora: convertir “verde” en requisito y diseñar el trabajo para llegar ahí rápido.

---

## Buenas prácticas

### 1) Plantilla corporativa para commits y PRs

#### Plantilla de commit (ejemplo)

Formato recomendado (adaptable a Conventional Commits si aplica):

* `tipo(área): resumen`
* Cuerpo: **qué**, **por qué**, **impacto**, **cómo probar**
* Referencias: ticket, incidente, RFC, etc.

Ejemplo:

* `fix(api): corrige validación de payload vacío`
* Cuerpo:

  * Qué: evita NPE en el handler X
  * Por qué: aparecía en requests sin campo Y
  * Cómo probar: `pytest -k test_payload_vacio`

#### Plantilla de PR (ejemplo)

**Título**: `[Área] Acción breve (resultado)`
**Descripción**:

* **Qué cambia**
* **Por qué**
* **Cómo probar**
* **Riesgos/impacto**
* **Checklist**

Checklist sugerido:

* [ ] Tests añadidos/actualizados
* [ ] Lint/format OK
* [ ] CI verde
* [ ] Documentación / CHANGELOG (si aplica)
* [ ] No toca carpetas sensibles (o justificación)
* [ ] Plan de rollback

---

### 2) Hooks y protecciones (“Codex no toca”)

**Pre-commit / pre-push** (recomendado):

* Lint/format
* Tests rápidos (smoke)
* Escaneo de secretos (si está disponible)
* Validaciones de convenciones (nombres de ramas, mensajes, etc.)

**Carpetas sensibles (ejemplo de política)**

* `infra/`, `terraform/`, `.github/workflows/`, `security/`, `secrets/`, `prod/`
* Regla: Codex puede **leer** pero no **editar** sin una aprobación explícita (o sin un label especial / CODEOWNERS).

---

### 3) Modo “fix CI” con límites

Objetivo: iterar rápidamente hasta CI verde, sin entrar en bucles.

**Reglas de operación**

* Máximo N intentos (por ejemplo 3).
* Cada intento debe:

  1. Identificar fallo (log/stacktrace).
  2. Proponer corrección mínima.
  3. Actualizar tests si corresponde.
  4. Re-ejecutar pipeline local o equivalente.
* Si falla al tercer intento: escalar a humano (investigación manual / pairing).

---

## Errores comunes (y cómo evitarlos)

1. **Dejar que el agente reescriba historial (force push / rebase) sin política**

   * Mitigación: ramas protegidas, PR required, bloquear force push, exigir revisión.

2. **Automatizar merges sin revisión**

   * Mitigación: required reviewers + CODEOWNERS + “no merge sin verde” + restricciones de permisos.

3. **PRs gigantes**

   * Mitigación: dividir por slices, feature flags, migración incremental, PRs por módulo.

4. **Cambios en CI/workflows sin control**

   * Mitigación: carpeta sensible + revisión obligatoria por owners de plataforma.

5. **Fuga de secretos (tokens en logs o commits)**

   * Mitigación: secret scanning + políticas de no-volcado + variables de entorno + rotación.

---

## Casos reales

### Migración gradual (patrón recomendado)

**Situación**: modernización de un repo o migración de librerías.
**Estrategia**:

* PRs por módulos/capas (por ejemplo `core/`, `api/`, `ui/`).
* En cada PR:

  * cambios mínimos,
  * tests y/o adaptación de tests,
  * CI como gate,
  * rollback claro (revert del PR o feature flag).
* Resultado: avance continuo con riesgo acotado.

---

# Laboratorio (L10) — “PR listo para producción”

## Objetivo

Producir un PR con:

* checklist estándar,
* pruebas,
* CI verde,
* descripción reproducible,
* y políticas de equipo respetadas.

## Preparación

Crea un repo de laboratorio: `codex-lab10/` con:

* Código mínimo (ej. Node/Python/Go/Java) + 1-2 tests.
* Un pipeline simple (GitHub Actions o simulación local).
* Hook de pre-commit (opcional pero recomendado).

**Ejemplo de pipeline mínimo (conceptual)**

* `lint`
* `test`
* `build` (si aplica)

## Pasos

### 1) Crear repo y pipeline

* Inicializa repo y añade el workflow.
* Añade una rama base protegida (si simulas en remoto).

### 2) Pedir a Codex un cambio completo “production-ready”

Solicítale explícitamente:

* cambio funcional pequeño,
* tests,
* ajustes de CI si hicieran falta,
* y texto de PR con plantilla + checklist.

**Prompt sugerido (adaptable)**

* “Implementa X de forma mínima. Añade/actualiza tests. Asegura que lint+tests pasen. Actualiza CI si es necesario. Devuélveme: diff, comandos para probar, y texto de PR siguiendo esta plantilla: (pegar plantilla). No modifiques carpetas sensibles.”

### 3) Ejecutar pipeline y corregir hasta verde

* Ejecuta localmente lo equivalente al CI (o lanza CI remoto).
* Si falla: modo “fix CI” con límite de intentos.
* Documenta en el PR qué falló y qué se hizo.

### 4) Revisar como si fuese producción

Checklist de revisión final:

* ¿El PR es pequeño y claro?
* ¿Los tests cubren el cambio?
* ¿Hay instrucciones reproducibles?
* ¿No se han tocado carpetas sensibles sin necesidad?
* ¿CI está verde?

## Resultado esperado

Un PR reproducible con:

* CI verde,
* tests,
* descripción estándar,
* checklist completa,
* y trazabilidad del “cómo probar”.

## Limpieza

* Borrar el repo `codex-lab10/`.
* Si se usaron tokens/credenciales: **revocarlos** y verificar que no quedaron en commits/logs.

---

## Entregables del módulo

* Plantilla de PR y commit acordada por el equipo.
* Política “carpetas sensibles / Codex no toca”.
* Guía operativa “fix CI” con límites.
* Laboratorio L10 completado con PR “production-ready”.

---

### Referencias

* [OpenAI Developers][15]
* [OpenAI Developers][16]
