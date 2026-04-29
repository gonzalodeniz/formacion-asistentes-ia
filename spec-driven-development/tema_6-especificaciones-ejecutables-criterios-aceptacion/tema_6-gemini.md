# Tema 6. Especificaciones ejecutables y criterios de aceptación

> En el desarrollo tradicional, el código se prueba leyendo un documento y haciendo clics manuales. En Spec Driven Development (SDD), el documento *es* la prueba. Las especificaciones ejecutables son el puente definitivo entre la intención del negocio y la validación mecánica.

## 1. El salto a la verificabilidad

Una especificación estática (como las vistas en los temas anteriores) define las reglas, pero necesita un mecanismo para comprobar que el software construido las respeta. Aquí entran en juego los **Criterios de Aceptación**. Son las condiciones precisas que debe cumplir un producto para ser aceptado por el usuario, el cliente o el sistema.

En SDD, los criterios de aceptación no son notas al margen; son el núcleo del contrato que indica cuándo una funcionalidad está oficialmente terminada (*Definition of Done*). Si una especificación no se puede validar de forma medible, se considera incompleta.

## 2. Redacción de Criterios de Aceptación orientados al comportamiento

Para que un criterio sea útil, debe evitar el lenguaje técnico interno (nombres de tablas de base de datos o variables de código) y centrarse en el **comportamiento** del sistema desde la perspectiva del actor o usuario.

Existen dos enfoques principales para redactarlos:

* **Orientados a Reglas:** Una lista de verificación estricta. (Ejemplo: *"El límite de caracteres del título es 50. Los caracteres especiales no están permitidos"*).
* **Orientados a Escenarios (Behavior Driven):** Se estructuran mediante ejemplos concretos que ilustran el uso real del sistema bajo diferentes condiciones.

## 3. Especificaciones Ejecutables: El formato Gherkin

Para automatizar la validación, la industria ha adoptado lenguajes específicos de dominio (DSL) como *Gherkin*, que utilizan la estructura **Dado-Cuando-Entonces** (*Given-When-Then*). Esto permite que el texto en lenguaje natural sea leído e interpretado directamente por herramientas de automatización de pruebas (como Cucumber, SpecFlow o Cypress).

* **Dado (Contexto / Precondición):** Define el estado inicial del sistema antes de que el usuario actúe.
* **Cuando (Acción):** Define el evento o comportamiento que desencadena el actor.
* **Entonces (Resultado / Postcondición):** Define el cambio de estado o la salida exacta esperada.

## 4. Colaboración y "Documentación Viva"

Al escribir especificaciones en un formato que las máquinas pueden ejecutar, logramos que las pruebas automatizadas y la documentación sean exactamente el mismo artefacto. Esto se conoce como **Documentación Viva** (*Living Documentation*).

Si el comportamiento del código cambia pero la especificación no, la automatización falla. Si la especificación cambia y el código no, la automatización falla. Esto garantiza la trazabilidad absoluta y asegura que Negocio, Desarrollo y Calidad (QA) trabajen bajo una única fuente de verdad.

---

## Soluciones a los Laboratorios (Tema 6)

### Laboratorio 1: Redacción de criterios de aceptación para historias funcionales

**Reto:** Redactar los criterios de aceptación precisos para la siguiente historia funcional: *"Como usuario no registrado, quiero poder suscribirme al boletín de noticias introduciendo mi email para recibir ofertas"*.

**Solución:**

Para evitar ambigüedades, los criterios deben cubrir tanto el "camino feliz" como las restricciones lógicas y de interfaz:

* **Criterio 1 (Formato de validación):** El sistema solo aceptará cadenas de texto que cumplan con el formato estándar de correo electrónico (usuario@dominio.ext). En caso contrario, el botón de envío permanecerá deshabilitado.
* **Criterio 2 (Prevención de duplicados):** Si el email introducido ya existe en la base de datos de suscriptores con estado activo, el sistema no creará un registro nuevo y mostrará en pantalla el mensaje de advertencia: *"Este correo ya está suscrito a nuestro boletín"*.
* **Criterio 3 (Confirmación visual y de estado):** Tras una suscripción exitosa, el formulario de entrada se ocultará y se mostrará un mensaje de éxito. El usuario se guardará en base de datos con el estado inicial `pending_verification`.
* **Criterio 4 (Integración de salida):** Tras el registro exitoso, el sistema disparará un evento de forma asíncrona para enviar el correo automático de doble *opt-in* (confirmación de suscripción).

### Laboratorio 2: Conversión de ejemplos de negocio en escenarios verificables

**Reto:** Transformar la siguiente regla de negocio en escenarios ejecutables usando el formato *Given-When-Then*.
*Regla funcional:* "Los clientes VIP tienen envío gratuito en pedidos superiores a 20€. Los clientes normales pagan 5€ de envío sin importar el importe."

**Solución:**

* **Escenario 1: Cliente VIP supera el umbral de envío gratuito.**
  * **Dado** que un usuario con rol "VIP" ha iniciado sesión.
  * **Y** tiene productos en su carrito por un valor total de "25.00€".
  * **Cuando** accede a la pantalla de confirmación de pago.
  * **Entonces** el coste de envío calculado debe ser "0.00€".
  * **Y** el total a pagar debe ser "25.00€".

* **Escenario 2: Cliente Normal paga el envío fijo siempre.**
  * **Dado** que un usuario con rol "Estándar" ha iniciado sesión.
  * **Y** tiene productos en su carrito por un valor total de "100.00€".
  * **Cuando** accede a la pantalla de confirmación de pago.
  * **Entonces** el coste de envío calculado debe ser "5.00€".
  * **Y** el total a pagar debe ser "105.00€".

### Laboratorio 3: Revisión de aceptación de una funcionalidad con base en especificación

**Reto:** Simular la revisión de QA de un formulario de cambio de contraseña. La especificación redactada por negocio dicta: *"La nueva contraseña debe tener al menos 8 caracteres y no puede ser igual a la anterior"*. El desarrollador entrega la funcionalidad y QA debe diseñar las pruebas de aceptación para encontrar posibles fallos u omisiones en el contrato.

**Solución:**

QA verifica la funcionalidad ejecutando escenarios basados estrictamente en la especificación, pero explorando los límites para revelar huecos funcionales:

1. **Prueba de Camino Feliz:** Se introduce una contraseña nueva válida de 10 caracteres alfanuméricos.
   * *Resultado esperado:* Éxito. *(Cumple la especificación).*
2. **Prueba de Límite Inferior:** Se introduce una contraseña de 7 caracteres.
   * *Resultado esperado:* Error de validación en pantalla. *(Cumple la especificación).*
3. **Prueba de Invariante de Negocio:** Se introduce la misma contraseña que la actual.
   * *Resultado esperado:* Error "La contraseña no puede coincidir con la actual". *(Cumple la especificación).*
4. **Prueba de Búsqueda de Huecos (Edge Case):** Se introducen 8 espacios en blanco consecutivos.
   * *Resultado real del sistema:* El sistema acepta el cambio y sobrescribe la contraseña. El desarrollador validó la longitud (`length >= 8`), pero la especificación omitió definir qué tipos de caracteres eran válidos.

**Acción correctiva basada en SDD:**
La prueba de aceptación de QA falla. En SDD, el equipo de desarrollo **no parchea el código inmediatamente**. Primero, se **actualiza la especificación** añadiendo un nuevo criterio obligatorio: *"La contraseña no puede contener espacios en blanco al inicio o al final, y debe contener caracteres alfanuméricos"*. Una vez actualizado el documento vivo, se ajusta el código para que respete el nuevo contrato.
