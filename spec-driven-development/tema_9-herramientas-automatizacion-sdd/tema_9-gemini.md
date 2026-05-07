## Tema 9. Herramientas y automatización para SDD

> Las especificaciones estáticas mueren el día que se publican. En Spec Driven Development, el ecosistema de herramientas y la automatización son el "soporte vital" que mantiene las especificaciones vivas, sincronizadas con el código y accesibles para todos los actores del proyecto.

### 1. El Ecosistema de Herramientas en SDD

La implementación exitosa del SDD requiere abandonar los procesadores de texto tradicionales (como Word) y adoptar herramientas que traten la documentación con el mismo rigor que el código fuente.

Podemos clasificar las herramientas en tres grandes categorías:

*   **Formatos y Lenguajes de Especificación:**
    *   **Gherkin:** Lenguaje legible por humanos y máquinas (Given-When-Then) usado para definir comportamientos y criterios de aceptación.
    *   **OpenAPI / AsyncAPI:** Estándares de la industria para definir contratos de APIs RESTful y sistemas orientados a eventos, respectivamente.
    *   **Markdown / AsciiDoc:** Formatos de marcado ligero ideales para escribir reglas de negocio, invariantes y arquitectura.
*   **Frameworks de Validación (Ejecución):**
    *   **Cucumber / SpecFlow / Behave:** Leen los archivos Gherkin y los conectan con el código de automatización de pruebas para verificar el comportamiento.
    *   **Pact:** Herramienta líder para pruebas de contratos impulsadas por el consumidor (Consumer-Driven Contract Testing), validando que las APIs cumplan lo prometido.
    *   **Cypress / Playwright:** Herramientas de automatización de interfaz (E2E) que pueden integrarse con especificaciones de comportamiento.
*   **Publicación de Documentación Viva (Living Documentation):**
    *   **Serenity BDD / Allure:** Generan reportes visuales detallados tras la ejecución de pruebas, mostrando qué especificaciones pasaron y cuáles fallaron.
    *   **Swagger UI / ReDoc:** Renderizan los archivos OpenAPI en portales web interactivos donde los desarrolladores pueden explorar y probar contratos de APIs.
    *   **Docusaurus / Backstage:** Portales de desarrollo (Developer Portals) que centralizan todas las especificaciones Markdown del repositorio en un sitio web navegable.

### 2. Flujos de trabajo y automatización (Docs as Code)



El enfoque "Docs as Code" significa gestionar las especificaciones a través de Git. Esto permite automatizar tareas repetitivas mediante pipelines de Integración Continua (CI):

1.  **Linting de especificaciones:** Al subir un cambio, un script revisa que el archivo OpenAPI o Markdown no tenga errores de sintaxis o formato.
2.  **Validación de contratos:** Se ejecutan tests automatizados para asegurar que los cambios en la especificación no rompan integraciones existentes.
3.  **Generación y despliegue:** Si todo es correcto, el pipeline compila las especificaciones y actualiza automáticamente el portal interno de Documentación Viva.

---

## Soluciones a los Laboratorios (Tema 9)

### Laboratorio 1: Configuración de repositorio para especificaciones versionadas

**Reto:** Diseñar la estructura de carpetas de un repositorio Git que integre el código de la aplicación, las especificaciones de comportamiento (Gherkin) y los contratos de API (OpenAPI), siguiendo las buenas prácticas de SDD.

**Solución:**
El repositorio debe reflejar la separación entre negocio, contratos técnicos y código, pero manteniéndolos en la misma línea temporal (versión).

```text
mi-proyecto-sdd/
├── .github/workflows/      # Pipelines de CI/CD (Automatización)
├── docs/                   # Documentación funcional y arquitectura
│   ├── reglas_negocio/
│   └── invariantes.md
├── specs/                  # Especificaciones ejecutables
│   ├── api/
│   │   └── contrato-pagos.yaml # Contrato OpenAPI
│   └── features/
│       ├── login.feature       # Escenarios Gherkin
│       └── checkout.feature
├── src/                    # Código fuente de la aplicación
└── tests/                  # Scripts de automatización que leen la carpeta /specs
```

### Laboratorio 2: Flujo de revisión colaborativa de especificaciones

**Reto:** Crear una plantilla de *Pull Request* (PR) en Markdown para que el equipo la utilice obligatoriamente cada vez que alguien proponga un cambio en una especificación.

**Solución (Plantilla `pull_request_template.md`):**

```markdown
## Descripción del cambio en la Especificación
[Explica brevemente qué regla de negocio, contrato o caso de uso se ha añadido/modificado]

## Tipo de cambio
- [ ] Nueva funcionalidad / Regla de negocio
- [ ] Modificación de contrato de API (Breaking Change)
- [ ] Corrección de ambigüedad funcional

## Lista de verificación de calidad (Spec Review)
- [ ] Los escenarios (Given-When-Then) cubren el "Happy Path" y los casos de error.
- [ ] No se utiliza lenguaje técnico (nombres de tablas, variables) en las historias funcionales.
- [ ] Si es un cambio de API, se ha actualizado la versión del contrato.

## Aprobaciones requeridas
Para poder fusionar (merge) esta especificación se necesita:
- [ ] Aprobación del Product Owner (Negocio).
- [ ] Aprobación de Arquitectura / Tech Lead (Factibilidad técnica).
- [ ] Aprobación de QA (Verificabilidad).
```

### Laboratorio 3: Publicación automatizada de documentación viva

**Reto:** Escribir un fragmento de configuración para un pipeline (ej. GitHub Actions) que automatice la generación y publicación de la documentación cada vez que se apruebe y fusione una especificación en la rama `main`.

**Solución:**
Este pipeline garantiza que nadie tenga que actualizar PDFs o Wikis manualmente. En cuanto la especificación entra en la rama principal, el portal web se regenera y se publica.

```yaml
name: Despliegue de Documentación Viva (SDD)

on:
  push:
    branches:
      - main
    paths:
      - 'specs/**'
      - 'docs/**'

jobs:
  publish-living-docs:
    runs-on: ubuntu-latest
    steps:
      - name: Descargar repositorio
        uses: actions/checkout@v3

      - name: Validar sintaxis OpenAPI
        uses: char0n/swagger-editor-validate@v1
        with:
          definition-file: specs/api/contrato-pagos.yaml

      - name: Generar portal estático con ReDoc (Para APIs)
        run: npx redoc-cli build specs/api/contrato-pagos.yaml -o public/api-docs.html

      - name: Generar reportes BDD (Cucumber/Serenity)
        run: ./gradlew reports

      - name: Desplegar en servidor interno (Ejemplo: GitHub Pages)
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```