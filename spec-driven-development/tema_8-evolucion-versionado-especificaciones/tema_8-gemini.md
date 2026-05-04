# Tema 8. Evolución y versionado de especificaciones

> El software no es estático y el negocio tampoco. El mayor desafío del Spec Driven Development no es escribir la primera especificación, sino mantenerla como la fuente de verdad inmutable a medida que el sistema evoluciona a lo largo del tiempo.

## 1. El paradigma de "Docs as Code" (Documentación como Código)

Para que la evolución de las especificaciones sea controlable, debemos abandonar los procesadores de texto tradicionales o las wikis aisladas y adoptar el paradigma "Docs as Code". Esto implica que las especificaciones (escritas en Markdown, Gherkin u OpenAPI) se almacenan en el mismo repositorio de control de versiones (ejemplo: Git) que el código fuente y las pruebas.

Beneficios de este enfoque:

* **Historial inmutable:** Permite saber exactamente quién, cuándo y por qué cambió una regla de negocio.
* **Ramas y flujos de trabajo:** Facilita trabajar en una nueva funcionalidad (en una rama separada) diseñando primero la especificación sin afectar la documentación de la versión actual en producción.
* **Revisiones por pares (Pull Requests / Merge Requests):** Un cambio funcional requiere la aprobación explícita de los distintos perfiles (*stakeholders*, QA, Arquitectura) antes de fusionarse al entorno principal.

## 2. Gestión del Cambio y Análisis de Impacto

Cuando el negocio solicita un cambio, no se debe modificar el código inmediatamente. El flujo correcto y disciplinado en SDD es:

1. **Modificar la Especificación:** Se actualizan las reglas, invariantes o criterios de aceptación en una rama nueva.
2. **Análisis de Impacto:** Al revisar los cambios en la especificación, el equipo evalúa sistemáticamente qué contratos (APIs), esquemas de base de datos o interfaces visuales se verán afectados.
3. **Actualización de Pruebas:** Se adaptan los tests automatizados a la nueva especificación (lo cual hará que fallen inicialmente).
4. **Actualización del Código:** Se modifica la implementación de desarrollo para que vuelva a cumplir el contrato y las pruebas se ejecuten con éxito.

## 3. Sincronización entre versiones de API y Especificaciones

Un problema común durante la evolución del software es el impacto en terceros. Si cambiamos un contrato de una API (por ejemplo, eliminando un campo que antes era obligatorio), romperemos las aplicaciones cliente que dependan de ella. Las especificaciones vivas deben soportar **versionado semántico** (ej. v1.0.0, v2.0.0) para reflejar de forma clara los cambios que rompen la compatibilidad (*breaking changes*) y mantener las versiones antiguas operativas y documentadas hasta su periodo oficial de obsolescencia.

---

## Soluciones a los Laboratorios (Tema 8)

### Laboratorio 1: Simulación de cambio de requisito con análisis de impacto

**Reto:** El sistema de facturación calcula actualmente un IVA fijo del 21% para todas las compras. Negocio solicita un cambio funcional: *"Debido a la nueva expansión comercial, el IVA debe calcularse dinámicamente según el país de residencia del comprador"*. Realiza el análisis de impacto sobre los artefactos de desarrollo existentes.

**Solución (Matriz de Impacto):**
El equipo evalúa el cambio en el documento de especificación e identifica la cascada de modificaciones técnicas necesarias:

* **Impacto en Precondiciones (UI/UX):** El formulario de registro o proceso de pago debe incluir un nuevo campo obligatorio: "País de residencia".
* **Impacto en Modelos de Datos:** La tabla de usuarios o transacciones debe almacenar el código del país (`country_code`). Es necesario definir un script de migración para asignar un país por defecto a todos los usuarios históricos existentes.
* **Impacto en Contratos (API):** El endpoint de cálculo de carrito (`/api/checkout/calculate`) debe requerir el nuevo parámetro de país. La regla matemática (Invariante) cambia de `precio * 1.21` a `precio * (1 + getTax(country))`.
* **Impacto en Pruebas de Aceptación:** Las automatizaciones de pruebas anteriores fallarán. Es mandatorio redactar nuevos escenarios (Gherkin) validando tasas impositivas para al menos tres países diferentes y añadiendo un caso de error de negocio (por ejemplo, un intento de compra desde un país no soportado).

### Laboratorio 2: Versionado de especificaciones en flujo colaborativo

**Reto:** Simular cómo dos equipos distintos (Equipo de Catálogo y Equipo de Pagos) añaden modificaciones simultáneas a la especificación central del objeto "Producto" sin sobrescribir el trabajo del otro.

**Solución (Flujo versionado para SDD):**

1. **Punto de partida:** Ambos equipos sincronizan sus entornos desde la rama `main`, donde el documento `especificacion-producto.md` se encuentra en su versión estable aprobada.
2. **Trabajo aislado:**
   * El *Equipo de Catálogo* crea la rama `feature/nuevas-categorias` y modifica el documento para incluir propiedades taxonómicas complejas (tallas, colores, familias).
   * El *Equipo de Pagos* crea la rama paralela `feature/soporte-cripto` y modifica la especificación del mismo documento añadiendo los contratos para aceptar tokens de criptomonedas.
3. **Revisión colaborativa:** Al finalizar sus definiciones, cada equipo abre una solicitud de integración (Pull Request). Representantes de Negocio y QA auditan que las especificaciones cumplen los estándares de completitud y no generan ambigüedad.
4. **Integración:** Tras la aprobación, se fusionan ambas ramas. El documento `especificacion-producto.md` en la rama `main` pasa a reflejar el esfuerzo consolidado de ambos equipos de manera estructurada y rastreable en el historial del repositorio.

### Laboratorio 3: Resolución de conflictos entre versiones de especificación

**Reto:** Durante la fusión del Laboratorio 2, surge un conflicto en el control de versiones. El Equipo de Catálogo definió en la especificación que el precio base del producto es un número entero (`integer`) que representa céntimos. Por otro lado, el Equipo de Pagos definió que el precio debe ser un decimal (`float`) para soportar fracciones diminutas requeridas en transacciones de criptomonedas. ¿Cómo se resuelve este escenario bajo el modelo SDD?

**Solución (Resolución funcional por encima de la técnica):**
Bajo la metodología SDD, un conflicto de este tipo no es un simple problema técnico de Git que un programador deba resolver forzando el código, sino una colisión directa en las reglas de dominio.

1. **Detección y Bloqueo:** El sistema de integración detecta el conflicto y detiene inmediatamente el proceso de desarrollo.
2. **Escalado Operativo:** Se convoca una sesión de revisión cruzada (dinámica "Tres Amigos") reuniendo a responsables de Negocio, Desarrollo y QA de ambos equipos.
3. **Determinación de la Fuente de Verdad:** Durante el debate, los técnicos exponen que el uso de coma flotante (`float`) acarrea riesgos críticos por errores de redondeo en las auditorías financieras. Negocio asume el riesgo y establece una nueva regla de dominio global: *"Todo el sistema transaccional utilizará números enteros representando la unidad mínima indivisible de la moneda subyacente (céntimos para divisas fiat, o satoshis para cripto)"*.
4. **Resolución:** Se unifica la especificación modificando manualmente el documento en conflicto para reflejar exclusivamente el formato `integer`. Se aprueba el cambio y, a partir de ese instante, ambos equipos construyen su código y sus pruebas respetando esta única directriz aprobada.
