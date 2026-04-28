Aquí tienes el desarrollo detallado del **Tema 5: Contratos, interfaces y reglas de dominio**, diseñado para profundizar en la precisión técnica que exige el Spec Driven Development (SDD).

---

# Tema 5. Contratos, interfaces y reglas de dominio

El Spec Driven Development alcanza su máxima madurez técnica en este punto. Ya no solo describimos qué hace el usuario (Casos de Uso), sino que definimos matemáticamente y técnicamente cómo interactúan las piezas del sistema.

## 1. El concepto de Diseño por Contrato (DbC)

En SDD, tratamos cada interacción entre componentes (ya sea una API REST, una función interna o un microservicio) como un contrato legal. Si el invocador cumple con las **Precondiciones**, el sistema garantiza las **Postcondiciones**.

### Componentes del contrato

* **Precondiciones:** Obligaciones del cliente (invocador). Si no se cumplen, el sistema no garantiza nada y suele fallar inmediatamente (Fail-Fast).
* **Postcondiciones:** Obligaciones del proveedor (el sistema). Si las precondiciones se cumplieron, el sistema debe entregar este resultado exacto.
* **Invariantes:** Verdades absolutas que no cambian. Se aplican a los objetos de dominio durante toda su vida.



## 2. Especificación de Interfaces y APIs

Una interfaz bien especificada en SDD debe ser "autodescriptiva". No basta con decir que un campo es un `string`; hay que especificar su semántica, longitud, formato y si es obligatorio.

### Elementos de una especificación de API robusta

1.  **Esquema de Entrada (Request):** Tipos de datos, rangos y obligatoriedad.
2.  **Esquema de Salida (Response):** Estructura del éxito (200 OK) y estructura del error.
3.  **Semántica de errores:** Mapeo de códigos de estado HTTP a reglas de negocio fallidas.

## 3. Reglas de Dominio e Invariantes

Las reglas de dominio son la lógica pura del negocio, independiente de la tecnología. El SDD busca que estas reglas estén explicitadas en la especificación para que el código sea simplemente un reflejo fiel de ellas.

**Ejemplo de Invariante en un Sistema Bancario:**
* `Balance de cuenta >= Límite de crédito asignado`. Esta regla debe cumplirse antes y después de cualquier transacción.

---

## Laboratorios: Soluciones

### Laboratorio 1: Definición de contratos para una API REST

**Reto:** Especificar el contrato para un endpoint de "Creación de Pedido" (`POST /orders`).

**Solución (Especificación de Contrato):**

| Campo | Tipo | Requerido | Regla / Validación |
| :--- | :--- | :--- | :--- |
| `customer_id` | UUID | Sí | Debe existir en la base de datos de clientes. |
| `items` | Array | Sí | Mínimo 1 elemento, máximo 50. |
| `items[].sku` | String | Sí | Formato alfanumérico. |
| `items[].qty` | Integer | Sí | Valor > 0. |
| `coupon_code` | String | No | Si se envía, debe estar activo. |

**Precondiciones:**
* El usuario debe tener un token JWT válido.
* Todos los productos (`sku`) deben tener stock disponible.

**Postcondiciones:**
* Se crea un registro en la tabla `orders` con estado `PENDING`.
* Se reserva el stock de los productos.
* Se devuelve el `order_id` y el `total_price` calculado.

### Laboratorio 2: Especificación de reglas de negocio con invariantes

**Reto:** Definir las invariantes para un sistema de "Gestión de Bibliotecas".

**Solución (Lista de Invariantes):**

1.  **INV-01 (Límite de préstamos):** Un usuario nunca puede tener más de 5 libros prestados simultáneamente.
2.  **INV-02 (Estado del libro):** Un libro marcado como `RESERVED` no puede ser prestado a un usuario distinto al que hizo la reserva.
3.  **INV-03 (Penalizaciones):** Si un usuario tiene una deuda > 10€ por retrasos, su capacidad de préstamo queda bloqueada automáticamente.

### Laboratorio 3: Validación de contratos entre consumidor y proveedor

**Reto:** Simular un cambio en el contrato de una API y detectar el impacto.

**Escenario:** El equipo de Backend decide cambiar el campo `zip_code` (entero) por `postal_code` (string) para soportar códigos internacionales.

**Solución (Análisis de Impacto SDD):**
1.  **Detección:** Al estar el contrato especificado como Fuente de Verdad, cualquier cambio genera una alerta de ruptura de compatibilidad (Breaking Change).
2.  **Acción:**
    * **Proveedor:** Debe mantener `zip_code` como *deprecated* y añadir `postal_code` durante una versión de transición.
    * **Consumidor:** Debe actualizar sus modelos de datos para tratar el código como string antes de la fecha de cierre de la versión antigua.
    * **Validación:** Se ejecutan tests de contrato (Pact o similar) basados en la especificación para asegurar que el Frontend no se rompa al recibir el nuevo formato.

