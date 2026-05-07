# Sistema de Reserva de Puestos — Especificaciones SDD

Repositorio de especificaciones del sistema de reserva
de puestos de trabajo de TechNova, gestionadas con Spec
Driven Development (SDD).

## Estructura del repositorio

```text
sdd-reserva-puestos/
  SPEC-0-vision-alcance.md    Visión y alcance
  INDICE.md                   Índice de todas las specs
  GLOSARIO.md                 Términos del dominio
  specs/
    funcional/                Especificaciones funcionales
    dominio/                  Reglas de negocio
    contratos/                Contratos de API
    seguridad/                Seguridad y autenticación
    rendimiento/              Requisitos de rendimiento
    aceptacion/features/      Escenarios ejecutables
  baselines/                  Baselines por release
  cambios/                    Solicitudes de cambio
```

## Cómo empezar

1. Lee SPEC-0 para entender el proyecto.
2. Consulta GLOSARIO.md para los términos del dominio.
3. Navega por INDICE.md para encontrar cada spec.

## Flujo de trabajo

Crear spec: rama `spec/[ID]-descripcion` y PR con
revisores asignados.

Modificar spec: solicitud de cambio en `cambios/`,
análisis de impacto, rama y PR.

## Convención de commits

```text
spec(ID): descripción [CR-NNN]
test(ID): descripción
docs: descripción
```

## Validación

```text
markdownlint specs/**/*.md
```
