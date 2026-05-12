---
name: conventional-commit-generator
description: Analiza cambios de código y genera mensajes de commit descriptivos siguiendo el estándar Conventional Commits con tipo, scope, descripción y body opcional.
---

# Generador de Commits Convencionales

## Resumen

Toma un diff, una descripción de cambios o una lista de archivos modificados y genera mensajes de commit profesionales siguiendo Conventional Commits.

**Palabras clave**: git, commit, conventional commits, versionado, changelog, historial

## Características

- Formato Conventional Commits (type(scope): description)
- Detección automática del tipo (feat, fix, refactor, docs, style, test, chore)
- Scope inferido del contexto
- Body opcional para cambios complejos
- Breaking changes detectados y marcados
- Múltiples commits si los cambios son independientes

## Formato de Salida

- Mensaje de commit formateado:
  - Línea 1: type(scope): descripción concisa
  - Línea 3+: body explicativo (si el cambio lo requiere)
  - Footer: BREAKING CHANGE si aplica

## Instrucciones

- Analizar los cambios proporcionados (diff, lista o descripción)
- Determinar el tipo principal: feat (nueva funcionalidad), fix (corrección), refactor (sin cambio de comportamiento), docs, style, test, chore
- Inferir el scope del área afectada (auth, api, ui, db, etc.)
- Escribir descripción en imperativo, minúscula, sin punto final, máximo 72 caracteres
- Si hay múltiples cambios no relacionados, proponer commits separados
- Añadir body solo si el "qué" no es obvio sin el "por qué"

## Restricciones

- Máximo 72 caracteres en la primera línea
- Imperativo: "add" no "added", "fix" no "fixed"
- Un commit = un cambio lógico
- No mezclar feat + fix en el mismo commit
- Si no hay suficiente contexto, preguntar antes de asumir el tipo