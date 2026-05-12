---
name: unit-test-generator
description: Analiza funciones o módulos y genera tests unitarios completos cubriendo happy paths, edge cases y manejo de errores para los principales frameworks de testing.
---

# Generador de Tests Unitarios

## Resumen

Toma cualquier función o módulo y genera una suite de tests que cubre los caminos principales, los casos límite y los errores esperados. Te ahorra la parte más tediosa del desarrollo.

**Palabras clave**: tests, testing, unitarios, jest, pytest, vitest, edge cases, cobertura

## Características

- Tests para happy path (caso normal)
- Tests para edge cases (valores límite, vacíos, nulos)
- Tests para manejo de errores
- Mocks y stubs cuando sea necesario
- Adaptable al framework (Jest, Vitest, Pytest, JUnit, Mocha)

## Formato de Salida

- Archivo de tests completo y ejecutable
- Organizado por describe/it o equivalente
- Comentarios explicando qué testea cada bloque

## Instrucciones

- Analizar la función y sus inputs/outputs
- Identificar todos los caminos posibles del código
- Generar al menos: 2 tests happy path, 2 edge cases, 1 test de error
- Si la función tiene dependencias externas, mockearlas
- Usar nombres descriptivos: "should return X when Y"
- Añadir comentarios breves sobre por qué cada test importa

## Restricciones

- Los tests deben ser ejecutables sin modificación
- No testear implementación interna, solo comportamiento
- Cada test debe ser independiente (no depender del orden)
- Usar el framework que corresponda al lenguaje del código fuente