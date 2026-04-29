# Tema 6. Especificaciones ejecutables y criterios de aceptación

## Descripción

En este tema se explica cómo transformar especificaciones funcionales en
artefactos verificables. Para ello se usan criterios de aceptación, ejemplos
concretos y formatos ejecutables que permiten validar el comportamiento esperado
del sistema.

El objetivo principal es reducir la ambigüedad entre negocio, análisis,
desarrollo y QA. Una especificación útil no solo describe qué debe hacer el
sistema, sino que permite comprobar de forma objetiva si el comportamiento
implementado es correcto.

Las especificaciones ejecutables conectan la conversación funcional con la
validación técnica. Cuando están bien redactadas, pueden servir como base para
pruebas automatizadas, documentación viva y revisión compartida del producto.

## Objetivos

Al finalizar este tema, el participante será capaz de:

* Traducir especificaciones funcionales en criterios de aceptación claros.
* Redactar ejemplos verificables orientados al comportamiento.
* Relacionar especificaciones con validación manual y automatizada.
* Usar escenarios de negocio como base para pruebas ejecutables.
* Mejorar la colaboración entre negocio, QA y desarrollo.
* Revisar una funcionalidad comparando especificación, implementación y
  evidencia de validación.

## 1. El problema de las especificaciones ambiguas

Una especificación ambigua permite múltiples interpretaciones. Esto provoca
retrabajo, defectos, discusiones tardías y validaciones subjetivas.

Ejemplo de especificación ambigua:

> El usuario debe poder consultar sus pedidos recientes.

Esta frase no responde a preguntas importantes:

* ¿Qué se considera un pedido reciente?
* ¿Cuántos pedidos se muestran?
* ¿Se incluyen pedidos cancelados?
* ¿Qué ocurre si el usuario no tiene pedidos?
* ¿Cómo se ordenan los resultados?
* ¿Qué permisos necesita el usuario?

Una especificación verificable transforma esas dudas en reglas concretas.

Ejemplo de especificación más precisa:

> El sistema mostrará los pedidos realizados por el usuario autenticado durante
> los últimos 90 días, ordenados de más reciente a más antiguo. Si no existen
> pedidos en ese periodo, se mostrará un mensaje informativo.

Esta segunda versión permite diseñar pruebas y criterios de aceptación.

## 2. Qué es un criterio de aceptación

Un criterio de aceptación es una condición observable que debe cumplirse para
considerar que una historia, requisito o funcionalidad está correctamente
implementada.

Un buen criterio de aceptación debe ser:

* Claro.
* Verificable.
* Independiente de detalles internos innecesarios.
* Comprensible para perfiles funcionales y técnicos.
* Orientado al comportamiento esperado.
* Específico sobre entradas, condiciones y resultados.

Ejemplo de historia de usuario:

> Como cliente autenticado, quiero consultar mis pedidos recientes para revisar
> el estado de mis compras.

Ejemplos de criterios de aceptación:

* El sistema muestra únicamente pedidos del cliente autenticado.
* El sistema muestra pedidos creados en los últimos 90 días.
* Los pedidos se muestran ordenados por fecha descendente.
* Cada pedido muestra identificador, fecha, estado e importe total.
* Si no hay pedidos recientes, se muestra un mensaje informativo.
* Si el usuario no está autenticado, se solicita iniciar sesión.

Estos criterios permiten evaluar objetivamente la funcionalidad.

## 3. Diferencia entre requisito y criterio de aceptación

Un requisito describe una necesidad o comportamiento esperado.

Un criterio de aceptación define las condiciones que permiten aceptar o rechazar
la implementación del requisito.

Ejemplo:

| Elemento  | Ejemplo                                                                      |
| --------- | ---------------------------------------------------------------------------- |
| Requisito | El usuario podrá recuperar su contraseña.                                    |
| Criterio  | Si el correo existe, el sistema enviará un enlace válido durante 30 minutos. |
| Criterio  | Si el correo no existe, el sistema mostrará un mensaje genérico.             |
| Criterio  | El enlace expirado no permitirá cambiar la contraseña.                       |

El requisito indica qué se necesita. Los criterios indican cómo comprobarlo.

## 4. Características de un buen criterio de aceptación

### 4.1 Claridad

Debe evitar términos vagos como "rápido", "fácil", "adecuado" o "reciente"
si no se definen de forma concreta.

Ejemplo débil:

> La búsqueda debe ser rápida.

Ejemplo mejorado:

> La búsqueda debe devolver resultados en menos de dos segundos para consultas
> con hasta 10 000 registros indexados.

### 4.2 Verificabilidad

Debe poder comprobarse mediante revisión, prueba manual o prueba automatizada.

Ejemplo débil:

> La pantalla debe ser intuitiva.

Ejemplo mejorado:

> La pantalla debe mostrar un botón primario con el texto "Guardar cambios" y
> un enlace secundario con el texto "Cancelar".

### 4.3 Orientación al comportamiento

Debe describir lo que el sistema hace desde el punto de vista observable.

Ejemplo débil:

> El sistema usará una clase interna para calcular descuentos.

Ejemplo mejorado:

> Cuando el cliente tenga un cupón válido del 10 %, el total del pedido se
> reducirá en un 10 % antes de aplicar los gastos de envío.

### 4.4 Cobertura de casos relevantes

Los criterios deben incluir casos positivos, negativos y de borde.

Ejemplo para un cupón de descuento:

* Cupón válido.
* Cupón caducado.
* Cupón inexistente.
* Cupón ya utilizado.
* Cupón incompatible con la cesta.
* Cesta vacía.

## 5. Formatos habituales de criterios de aceptación

### 5.1 Lista de reglas

Es el formato más simple. Resulta útil para requisitos sencillos.

Ejemplo:

* El usuario debe estar autenticado.
* El sistema debe permitir cambiar el nombre visible.
* El nombre visible debe tener entre 3 y 50 caracteres.
* Si el nombre no cumple la longitud, se mostrará un error.
* Al guardar correctamente, se mostrará un mensaje de confirmación.

### 5.2 Formato regla y ejemplos

Este formato separa la regla general de ejemplos concretos.

Ejemplo:

Regla:

> Un cupón solo puede aplicarse si está activo, no ha caducado y pertenece al
> cliente autenticado.

Ejemplos:

| Cupón        | Estado   | Propietario    | Resultado  |
| ------------ | -------- | -------------- | ---------- |
| BIENVENIDA10 | Activo   | Cliente actual | Se aplica  |
| VERANO20     | Caducado | Cliente actual | Se rechaza |
| VIP15        | Activo   | Otro cliente   | Se rechaza |

### 5.3 Formato Given, When, Then

Es un formato muy usado en BDD y especificaciones ejecutables.

Estructura:

* Given: contexto inicial.
* When: acción realizada.
* Then: resultado esperado.

Ejemplo:

```gherkin
Scenario: Aplicar un cupón válido
  Given el cliente tiene una cesta con productos por valor de 100 euros
  And el cliente dispone del cupón "BIENVENIDA10"
  When el cliente aplica el cupón
  Then el sistema muestra un descuento de 10 euros
  And el total de la cesta queda en 90 euros
```

Este formato facilita la conversación entre negocio, QA y desarrollo.

## 6. Especificaciones ejecutables

Una especificación ejecutable es una descripción del comportamiento esperado que
puede conectarse con pruebas automatizadas.

No toda especificación escrita en formato Gherkin es ejecutable. Para que lo sea,
debe existir una implementación técnica que relacione cada paso con acciones y
comprobaciones reales.

Ejemplo conceptual:

```gherkin
Feature: Consulta de pedidos recientes

  Scenario: Cliente con pedidos recientes
    Given existe un cliente autenticado
    And el cliente tiene pedidos realizados en los últimos 90 días
    When consulta sus pedidos recientes
    Then el sistema muestra esos pedidos
    And los ordena de más reciente a más antiguo
```

Este escenario puede ejecutarse si existen definiciones técnicas para pasos como:

* Crear o preparar un cliente autenticado.
* Preparar pedidos de prueba.
* Ejecutar la consulta.
* Comprobar la lista devuelta.
* Validar el orden de los resultados.

## 7. Ventajas de las especificaciones ejecutables

Las especificaciones ejecutables aportan valor porque:

* Reducen malentendidos.
* Sirven como documentación viva.
* Permiten validar requisitos de forma repetible.
* Facilitan el trabajo conjunto de negocio, QA y desarrollo.
* Ayudan a detectar regresiones.
* Conectan la definición funcional con la calidad del producto.

Una documentación viva es aquella que se mantiene actualizada porque forma parte
del proceso de validación. Si la funcionalidad cambia, las especificaciones y las
pruebas asociadas también deben cambiar.

## 8. Riesgos habituales

### 8.1 Escribir escenarios demasiado técnicos

Un escenario de aceptación no debería describir detalles internos de
implementación.

Ejemplo débil:

```gherkin
Scenario: Guardar usuario en base de datos
  Given se instancia UserRepository
  When se invoca el método save
  Then se ejecuta una sentencia insert
```

Ejemplo mejorado:

```gherkin
Scenario: Registrar un usuario nuevo
  Given una persona introduce datos válidos de registro
  When confirma el alta
  Then el sistema crea la cuenta
  And permite iniciar sesión con las credenciales registradas
```

### 8.2 Escribir escenarios demasiado genéricos

Un escenario genérico no aporta suficiente capacidad de validación.

Ejemplo débil:

```gherkin
Scenario: Descuento correcto
  Given un cliente
  When compra productos
  Then se aplica el descuento correcto
```

Ejemplo mejorado:

```gherkin
Scenario: Aplicar descuento del 10 por ciento
  Given un cliente tiene una cesta de 100 euros
  And dispone de un cupón válido del 10 por ciento
  When aplica el cupón
  Then el sistema descuenta 10 euros
  And el total final es 90 euros
```

### 8.3 Confundir criterios con tareas técnicas

Los criterios de aceptación no son una lista de tareas de desarrollo.

Ejemplo de tarea técnica:

* Crear tabla `orders`.
* Añadir índice sobre `customer_id`.
* Implementar endpoint `GET /orders`.

Ejemplo de criterio de aceptación:

* El cliente autenticado puede consultar únicamente sus propios pedidos.
* Los pedidos se muestran ordenados por fecha descendente.
* Si el cliente no tiene pedidos, se muestra un mensaje informativo.

Ambos niveles son útiles, pero tienen propósitos diferentes.

## 9. Relación entre criterios, pruebas y automatización

Los criterios de aceptación ayudan a derivar pruebas.

| Criterio de aceptación                        | Posible prueba                                   |
| --------------------------------------------- | ------------------------------------------------ |
| El usuario no autenticado no puede acceder.   | Intentar acceder sin sesión.                     |
| El cupón caducado se rechaza.                 | Aplicar un cupón con fecha vencida.              |
| Los pedidos se ordenan por fecha descendente. | Crear pedidos con varias fechas y validar orden. |
| El campo email es obligatorio.                | Enviar formulario sin email y comprobar error.   |

No todos los criterios deben automatizarse necesariamente. La decisión depende
del valor, la frecuencia de uso, el coste de automatización y el riesgo.

## 10. Niveles de validación

Una misma especificación puede validarse en distintos niveles.

### 10.1 Pruebas unitarias

Validan reglas pequeñas y aisladas.

Ejemplo:

* Cálculo de descuento.
* Validación de formato de email.
* Regla de caducidad de cupón.

### 10.2 Pruebas de integración

Validan la colaboración entre componentes.

Ejemplo:

* Servicio de pedidos con base de datos.
* Validación de cupón con repositorio de cupones.
* Publicación de evento después de confirmar una compra.

### 10.3 Pruebas de aceptación

Validan el comportamiento desde la perspectiva del usuario o negocio.

Ejemplo:

* Un cliente aplica un cupón válido durante el proceso de compra.
* Un usuario recupera su contraseña mediante un enlace temporal.
* Un administrador revisa solicitudes pendientes.

### 10.4 Pruebas end-to-end

Validan flujos completos desde la interfaz hasta los sistemas implicados.

Ejemplo:

* Registro, inicio de sesión, compra y consulta del pedido.

Estas pruebas son valiosas, pero suelen ser más lentas y frágiles. Por eso deben
usarse con criterio.

## 11. Buenas prácticas para redactar escenarios

### 11.1 Usar lenguaje de negocio

Los escenarios deben ser entendibles por personas no técnicas.

Preferible:

```gherkin
Given el cliente tiene una cesta con productos
```

Evitable:

```gherkin
Given existe una fila en la tabla shopping_cart
```

### 11.2 Ser concreto con los datos

Los ejemplos deben incluir datos representativos.

Ejemplo:

```gherkin
Given el producto "Teclado USB" cuesta 25 euros
And el producto "Ratón óptico" cuesta 15 euros
When el cliente añade ambos productos a la cesta
Then el total de la cesta es 40 euros
```

### 11.3 Evitar escenarios demasiado largos

Un escenario debe validar una idea principal. Si incluye demasiadas acciones,
puede ser difícil de mantener.

### 11.4 Separar reglas independientes

Cada regla relevante debería tener uno o varios ejemplos específicos.

Ejemplo:

* Regla de autenticación.
* Regla de autorización.
* Regla de ordenación.
* Regla de ausencia de datos.
* Regla de error.

### 11.5 Nombrar los escenarios con intención

El nombre del escenario debe explicar qué comportamiento valida.

Ejemplo débil:

```gherkin
Scenario: Caso 1
```

Ejemplo mejorado:

```gherkin
Scenario: Rechazar un cupón caducado
```

## 12. Ejemplo completo

### 12.1 Historia de usuario

> Como cliente autenticado, quiero aplicar un cupón de descuento a mi cesta para
> reducir el importe total de mi compra.

### 12.2 Reglas de negocio

* Solo se puede aplicar un cupón por cesta.
* El cupón debe existir.
* El cupón debe estar activo.
* El cupón no debe estar caducado.
* El cupón debe pertenecer al cliente o ser de uso general.
* El descuento se aplica antes de los gastos de envío.
* Si el cupón no es válido, el total no cambia.

### 12.3 Criterios de aceptación

* Dado un cupón válido del 10 %, al aplicarlo sobre una cesta de 100 euros,
  el descuento será de 10 euros.
* Dado un cupón caducado, al aplicarlo, el sistema mostrará un error.
* Dado un cupón inexistente, al aplicarlo, el sistema mostrará un error.
* Dado que la cesta ya tiene un cupón aplicado, al aplicar otro cupón, el
  sistema rechazará la operación.
* Dado un cupón no válido, el total de la cesta permanecerá sin cambios.

### 12.4 Escenarios verificables

```gherkin
Feature: Aplicación de cupones de descuento

  Rule: Solo se aplican cupones válidos

    Scenario: Aplicar un cupón válido del 10 por ciento
      Given el cliente tiene una cesta con importe de 100 euros
      And existe el cupón "BIENVENIDA10" con descuento del 10 por ciento
      And el cupón está activo y no caducado
      When el cliente aplica el cupón "BIENVENIDA10"
      Then el sistema muestra un descuento de 10 euros
      And el total de la cesta queda en 90 euros

    Scenario: Rechazar un cupón caducado
      Given el cliente tiene una cesta con importe de 100 euros
      And existe el cupón "VERANO20"
      And el cupón está caducado
      When el cliente aplica el cupón "VERANO20"
      Then el sistema muestra el error "El cupón no es válido"
      And el total de la cesta sigue siendo 100 euros

    Scenario: Rechazar un segundo cupón
      Given el cliente tiene una cesta con importe de 100 euros
      And la cesta ya tiene aplicado el cupón "BIENVENIDA10"
      When el cliente aplica el cupón "VIP15"
      Then el sistema muestra el error "Solo se permite un cupón por cesta"
      And se mantiene aplicado el cupón "BIENVENIDA10"
```

## 13. Conversación entre negocio, QA y desarrollo

Las especificaciones ejecutables no deben escribirse de forma aislada. Su mayor
valor aparece cuando se construyen mediante conversación.

### 13.1 Papel de negocio

Negocio define objetivos, reglas, excepciones y prioridades.

Preguntas útiles:

* ¿Qué resultado espera el usuario?
* ¿Qué casos son más importantes?
* ¿Qué excepciones existen?
* ¿Qué comportamiento sería inaceptable?

### 13.2 Papel de QA

QA ayuda a identificar casos límite, datos relevantes y riesgos.

Preguntas útiles:

* ¿Qué pasa si faltan datos?
* ¿Qué ocurre con valores mínimos y máximos?
* ¿Qué errores deben mostrarse?
* ¿Cómo comprobaremos que funciona?

### 13.3 Papel de desarrollo

Desarrollo ayuda a evaluar viabilidad, dependencias y automatización.

Preguntas útiles:

* ¿Qué datos necesitamos preparar?
* ¿Qué parte puede automatizarse?
* ¿Qué integración puede fallar?
* ¿Qué comportamiento no está definido?

## 14. Definición de terminado y aceptación

Los criterios de aceptación están relacionados con la definición de terminado,
pero no son lo mismo.

La definición de terminado suele aplicar a todo el equipo o producto.

Ejemplos:

* El código está revisado.
* Las pruebas automatizadas relevantes pasan.
* La funcionalidad está desplegada en el entorno de validación.
* La documentación necesaria está actualizada.
* No existen defectos bloqueantes conocidos.

Los criterios de aceptación aplican a una historia o funcionalidad concreta.

Ejemplos:

* El cliente puede aplicar un cupón válido.
* El cupón caducado se rechaza.
* El total no cambia cuando el cupón es inválido.

Ambos elementos se complementan.

## 15. Checklist para revisar criterios de aceptación

Antes de dar por válidos los criterios, se puede usar esta lista:

* ¿Se entienden sin conocer la implementación?
* ¿Describen comportamiento observable?
* ¿Incluyen casos positivos y negativos?
* ¿Incluyen datos concretos cuando son necesarios?
* ¿Evitan términos ambiguos?
* ¿Pueden verificarse mediante prueba manual o automatizada?
* ¿Están alineados con la regla de negocio?
* ¿Son comprensibles para negocio, QA y desarrollo?
* ¿Evitan mezclar tareas técnicas con resultados funcionales?
* ¿Cubren los errores y excepciones más relevantes?

## 16. Antipatrones frecuentes

### 16.1 Criterios demasiado vagos

Ejemplo:

> La funcionalidad debe funcionar correctamente.

Problema:

No define qué significa funcionar correctamente.

### 16.2 Criterios imposibles de verificar

Ejemplo:

> El usuario debe sentirse satisfecho con el formulario.

Problema:

No es observable directamente dentro de la validación funcional.

### 16.3 Criterios centrados en implementación

Ejemplo:

> Se debe usar una clase llamada DiscountCalculator.

Problema:

Describe una decisión técnica, no un comportamiento aceptable.

### 16.4 Criterios incompletos

Ejemplo:

> El usuario puede subir un archivo.

Problema:

No indica formatos permitidos, tamaño máximo, errores ni resultado esperado.

### 16.5 Escenarios sin datos representativos

Ejemplo:

```gherkin
Scenario: Calcular total
  Given una cesta
  When se calcula el total
  Then el total es correcto
```

Problema:

No permite comprobar el resultado con precisión.

## 17. Laboratorio 1: Redacción de criterios de aceptación

### 17.1 Enunciado

Se dispone de la siguiente historia de usuario:

> Como usuario registrado, quiero cambiar mi contraseña para mantener segura mi
> cuenta.

Redactar criterios de aceptación claros y verificables.

### 17.2 Análisis

Para redactar los criterios conviene identificar:

* Quién realiza la acción.
* Qué datos introduce.
* Qué validaciones se aplican.
* Qué resultado se espera.
* Qué errores pueden aparecer.
* Qué restricciones de seguridad son necesarias.

Preguntas relevantes:

* ¿Debe introducir la contraseña actual?
* ¿Qué longitud mínima debe tener la nueva contraseña?
* ¿Debe repetirse la nueva contraseña?
* ¿Qué ocurre si la contraseña actual es incorrecta?
* ¿Qué ocurre si la nueva contraseña no cumple la política?
* ¿Qué ocurre después del cambio?

### 17.3 Solución propuesta

Criterios de aceptación:

* El usuario debe estar autenticado para cambiar su contraseña.
* El formulario debe solicitar contraseña actual, nueva contraseña y
  confirmación de nueva contraseña.
* La nueva contraseña debe tener al menos 12 caracteres.
* La nueva contraseña debe contener al menos una letra y un número.
* La nueva contraseña y su confirmación deben coincidir.
* Si la contraseña actual es incorrecta, el sistema debe rechazar el cambio.
* Si la nueva contraseña no cumple la política, el sistema debe mostrar un error.
* Si la confirmación no coincide, el sistema debe mostrar un error.
* Si el cambio se realiza correctamente, el sistema debe mostrar una
  confirmación.
* Después del cambio, el usuario debe poder iniciar sesión con la nueva
  contraseña.
* Después del cambio, la contraseña anterior no debe permitir iniciar sesión.

### 17.4 Escenarios verificables

```gherkin
Feature: Cambio de contraseña

  Rule: Solo un usuario autenticado puede cambiar su contraseña

    Scenario: Cambiar la contraseña correctamente
      Given existe un usuario autenticado con contraseña "Anterior12345"
      When introduce la contraseña actual "Anterior12345"
      And introduce la nueva contraseña "Nueva12345678"
      And confirma la nueva contraseña "Nueva12345678"
      Then el sistema cambia la contraseña
      And muestra el mensaje "Contraseña actualizada correctamente"

    Scenario: Rechazar el cambio con contraseña actual incorrecta
      Given existe un usuario autenticado con contraseña "Anterior12345"
      When introduce la contraseña actual "Incorrecta123"
      And introduce la nueva contraseña "Nueva12345678"
      And confirma la nueva contraseña "Nueva12345678"
      Then el sistema rechaza el cambio
      And muestra el error "La contraseña actual no es correcta"

    Scenario: Rechazar el cambio si la confirmación no coincide
      Given existe un usuario autenticado con contraseña "Anterior12345"
      When introduce la contraseña actual "Anterior12345"
      And introduce la nueva contraseña "Nueva12345678"
      And confirma la nueva contraseña "Otra12345678"
      Then el sistema rechaza el cambio
      And muestra el error "La confirmación no coincide"

    Scenario: Rechazar una contraseña que no cumple la política
      Given existe un usuario autenticado con contraseña "Anterior12345"
      When introduce la contraseña actual "Anterior12345"
      And introduce la nueva contraseña "corta1"
      And confirma la nueva contraseña "corta1"
      Then el sistema rechaza el cambio
      And muestra el error "La contraseña no cumple la política de seguridad"
```

### 17.5 Comentario sobre la solución

La solución incluye casos positivos, negativos y reglas de seguridad. Además,
los escenarios usan datos concretos, por lo que pueden convertirse en pruebas
manuales o automatizadas.

## 18. Laboratorio 2: Conversión de ejemplos de negocio

### 18.1 Enunciado

Se reciben los siguientes ejemplos de negocio sobre gastos de envío:

> Los pedidos de 50 euros o más tienen envío gratuito.
> Los pedidos inferiores a 50 euros tienen un coste de envío de 4,99 euros.
> Los clientes premium siempre tienen envío gratuito.
> No se puede calcular el envío de una cesta vacía.

Convertir estos ejemplos en escenarios verificables.

### 18.2 Análisis

Primero se identifican las reglas:

* Regla 1: pedido estándar de al menos 50 euros tiene envío gratuito.
* Regla 2: pedido estándar inferior a 50 euros tiene envío de 4,99 euros.
* Regla 3: cliente premium tiene envío gratuito.
* Regla 4: cesta vacía no permite calcular envío.

Después se seleccionan datos concretos:

| Tipo de cliente |     Importe | Resultado           |
| --------------- | ----------: | ------------------- |
| Estándar        | 50,00 euros | Envío gratuito      |
| Estándar        | 49,99 euros | Envío de 4,99 euros |
| Premium         | 10,00 euros | Envío gratuito      |
| Estándar        |  0,00 euros | Error               |

### 18.3 Solución propuesta

```gherkin
Feature: Cálculo de gastos de envío

  Rule: El coste de envío depende del importe y del tipo de cliente

    Scenario: Envío gratuito para pedido estándar de 50 euros
      Given existe un cliente estándar
      And tiene una cesta con importe de 50 euros
      When el sistema calcula los gastos de envío
      Then el coste de envío es 0 euros
      And el sistema indica "Envío gratuito"

    Scenario: Envío con coste para pedido estándar inferior a 50 euros
      Given existe un cliente estándar
      And tiene una cesta con importe de 49,99 euros
      When el sistema calcula los gastos de envío
      Then el coste de envío es 4,99 euros

    Scenario: Envío gratuito para cliente premium
      Given existe un cliente premium
      And tiene una cesta con importe de 10 euros
      When el sistema calcula los gastos de envío
      Then el coste de envío es 0 euros
      And el sistema indica "Envío gratuito"

    Scenario: Rechazar el cálculo de envío para una cesta vacía
      Given existe un cliente estándar
      And tiene una cesta vacía
      When el sistema calcula los gastos de envío
      Then el sistema rechaza el cálculo
      And muestra el error "No se puede calcular el envío de una cesta vacía"
```

### 18.4 Variante con tabla de ejemplos

Cuando varios casos comparten la misma estructura, se puede usar un esquema de
escenario:

```gherkin
Feature: Cálculo de gastos de envío

  Scenario Outline: Calcular envío según cliente e importe
    Given existe un cliente de tipo "<tipo_cliente>"
    And tiene una cesta con importe de <importe> euros
    When el sistema calcula los gastos de envío
    Then el coste de envío es <coste_envio> euros

    Examples:
      | tipo_cliente | importe | coste_envio |
      | estándar     | 50,00   | 0,00        |
      | estándar     | 49,99   | 4,99        |
      | premium      | 10,00   | 0,00        |
      | premium      | 0,01    | 0,00        |
```

El caso de cesta vacía se mantiene separado porque representa un error y no un
cálculo válido.

### 18.5 Comentario sobre la solución

La conversión transforma frases de negocio en ejemplos comprobables. Los datos
elegidos incluyen un caso de frontera importante: 50 euros. También se valida el
comportamiento especial de clientes premium y el error para cesta vacía.

## 19. Laboratorio 3: Revisión de aceptación de una funcionalidad

### 19.1 Enunciado

Se dispone de la siguiente especificación:

> Como administrador, quiero aprobar solicitudes de alta de proveedores para que
> puedan empezar a operar en la plataforma.

Reglas de negocio:

* Solo un administrador puede aprobar solicitudes.
* La solicitud debe estar en estado pendiente.
* Al aprobarla, el proveedor pasa a estado activo.
* Se debe registrar la fecha de aprobación.
* Se debe registrar el administrador que aprobó la solicitud.
* No se puede aprobar una solicitud rechazada.
* No se puede aprobar una solicitud ya aprobada.

Revisar la aceptación de la funcionalidad y proponer criterios, escenarios y
evidencias de validación.

### 19.2 Criterios de aceptación

* Un administrador puede aprobar una solicitud pendiente.
* Al aprobar una solicitud pendiente, su estado cambia a aprobada.
* Al aprobar una solicitud pendiente, el proveedor asociado pasa a estado activo.
* Al aprobar una solicitud, el sistema registra la fecha y hora de aprobación.
* Al aprobar una solicitud, el sistema registra el administrador responsable.
* Un usuario sin rol de administrador no puede aprobar solicitudes.
* Una solicitud rechazada no puede aprobarse.
* Una solicitud ya aprobada no puede aprobarse de nuevo.
* Si la aprobación falla, el estado de la solicitud no debe cambiar.
* Si la aprobación falla, el proveedor no debe activarse.

### 19.3 Escenarios verificables

```gherkin
Feature: Aprobación de solicitudes de proveedores

  Rule: Solo los administradores pueden aprobar solicitudes pendientes

    Scenario: Aprobar una solicitud pendiente
      Given existe un administrador "admin1"
      And existe una solicitud de proveedor en estado "pendiente"
      And el proveedor asociado está en estado "pendiente"
      When el administrador aprueba la solicitud
      Then la solicitud queda en estado "aprobada"
      And el proveedor queda en estado "activo"
      And se registra la fecha y hora de aprobación
      And se registra que "admin1" aprobó la solicitud

    Scenario: Rechazar aprobación por usuario sin rol de administrador
      Given existe un usuario sin rol de administrador
      And existe una solicitud de proveedor en estado "pendiente"
      When el usuario intenta aprobar la solicitud
      Then el sistema rechaza la operación
      And muestra el error "No tiene permisos para aprobar solicitudes"
      And la solicitud sigue en estado "pendiente"

    Scenario: Rechazar aprobación de una solicitud rechazada
      Given existe un administrador "admin1"
      And existe una solicitud de proveedor en estado "rechazada"
      When el administrador aprueba la solicitud
      Then el sistema rechaza la operación
      And muestra el error "Solo se pueden aprobar solicitudes pendientes"
      And la solicitud sigue en estado "rechazada"

    Scenario: Rechazar aprobación de una solicitud ya aprobada
      Given existe un administrador "admin1"
      And existe una solicitud de proveedor en estado "aprobada"
      When el administrador aprueba la solicitud
      Then el sistema rechaza la operación
      And muestra el error "La solicitud ya está aprobada"
      And la solicitud sigue en estado "aprobada"
```

### 19.4 Evidencias de validación

Para aceptar la funcionalidad se pueden recoger estas evidencias:

| Evidencia                     | Descripción                                   |
| ----------------------------- | --------------------------------------------- |
| Prueba de aceptación positiva | Aprobación correcta de solicitud pendiente.   |
| Prueba de autorización        | Usuario no administrador no puede aprobar.    |
| Prueba de estado inválido     | Solicitud rechazada no puede aprobarse.       |
| Prueba de idempotencia        | Solicitud ya aprobada no cambia de nuevo.     |
| Registro de auditoría         | Se guarda fecha, hora y administrador.        |
| Validación de proveedor       | El proveedor queda activo tras la aprobación. |

### 19.5 Matriz de trazabilidad

| Regla de negocio                     | Criterio                                    | Escenario                                |
| ------------------------------------ | ------------------------------------------- | ---------------------------------------- |
| Solo un administrador puede aprobar. | Usuario no administrador es rechazado.      | Rechazar aprobación por usuario sin rol. |
| La solicitud debe estar pendiente.   | Solo se aprueban solicitudes pendientes.    | Aprobar pendiente y rechazar rechazada.  |
| El proveedor pasa a activo.          | Proveedor asociado queda activo.            | Aprobar una solicitud pendiente.         |
| Se registra fecha de aprobación.     | Fecha y hora quedan registradas.            | Aprobar una solicitud pendiente.         |
| Se registra administrador.           | Administrador responsable queda registrado. | Aprobar una solicitud pendiente.         |
| No se aprueba una rechazada.         | Solicitud rechazada se rechaza.             | Rechazar solicitud rechazada.            |
| No se aprueba una aprobada.          | Solicitud aprobada no cambia.               | Rechazar solicitud ya aprobada.          |

### 19.6 Decisión de aceptación

La funcionalidad puede aceptarse si:

* Todos los escenarios definidos pasan correctamente.
* Las evidencias de auditoría se pueden consultar.
* Los errores mostrados son comprensibles.
* Los estados no cambian cuando la operación es inválida.
* No se detectan defectos bloqueantes en el flujo principal.

Si cualquiera de los escenarios críticos falla, la funcionalidad no debería
aceptarse hasta corregir el comportamiento.

## 20. Ejemplo de plantilla reutilizable

La siguiente plantilla puede usarse para redactar especificaciones verificables.

````markdown
# Historia

Como [rol],
quiero [capacidad],
para [beneficio].

## Reglas de negocio

- [Regla 1]
- [Regla 2]
- [Regla 3]

## Criterios de aceptación

- [Criterio verificable 1]
- [Criterio verificable 2]
- [Criterio verificable 3]

## Escenarios

```gherkin
Feature: [Nombre de la funcionalidad]

  Scenario: [Nombre del escenario]
    Given [contexto]
    When [acción]
    Then [resultado esperado]
````

## Evidencias de validación

| Evidencia  | Resultado esperado |
| ---------- | ------------------ |
| [Prueba 1] | [Resultado]        |
| [Prueba 2] | [Resultado]        |

```

## 21. Recomendaciones finales

Para trabajar con especificaciones ejecutables de forma efectiva:

- Empezar con conversación antes de escribir escenarios.
- Usar ejemplos reales o representativos.
- Priorizar reglas de negocio importantes.
- Evitar automatizar escenarios de poco valor.
- Mantener los escenarios simples y legibles.
- Revisar los escenarios cuando cambie la funcionalidad.
- Usar el mismo lenguaje que negocio emplea en el dominio.
- Separar criterios funcionales de tareas técnicas.
- Conectar cada criterio con una evidencia de validación.
- Tratar la especificación como documentación viva.

## 22. Resumen

Los criterios de aceptación permiten transformar requisitos en condiciones
verificables. Las especificaciones ejecutables llevan esta idea un paso más allá,
ya que conectan ejemplos de negocio con validaciones que pueden automatizarse.

Un buen criterio de aceptación debe ser claro, observable y comprobable. Un buen
escenario debe describir un comportamiento concreto con datos suficientes para
evaluar el resultado.

Cuando negocio, QA y desarrollo colaboran en la definición de criterios y
ejemplos, se reducen ambigüedades y se mejora la calidad del producto. La
especificación deja de ser un documento estático y se convierte en una herramienta
activa de diseño, comunicación y validación.
```
