## Tema 4. Modelado del comportamiento y casos de uso

> En Spec Driven Development, un caso de uso no es un diagrama abstracto, sino un contrato de comportamiento explícito. Describe de forma precisa y estructurada cómo interactúa un actor con el sistema para lograr un objetivo verificable.

### 1. El valor de modelar el comportamiento

El desarrollo guiado por especificaciones exige que el comportamiento del sistema se defina rigurosamente antes de tirar la primera línea de código. Esto se logra modelando mediante casos de uso y escenarios. El objetivo principal es descubrir la complejidad oculta y los límites funcionales antes de que se conviertan en deuda técnica.

Al modelar el comportamiento, dividimos la interacción del sistema en tres grandes bloques funcionales:

* **Flujo Principal (Happy Path):** El escenario óptimo donde todo funciona como se espera, los datos de entrada son correctos, no hay cortes de servicio y el usuario alcanza su objetivo sin fricciones.
* **Flujos Alternativos:** Caminos válidos pero menos comunes para alcanzar el mismo objetivo. El usuario llega al éxito, pero dando un "rodeo" (por ejemplo, iniciar sesión con una cuenta de Google en lugar de usar el registro clásico con email y contraseña).
* **Flujos Excepcionales (Casos de Error):** Caminos donde el objetivo no se puede alcanzar debido a errores del usuario, caídas del sistema o reglas de negocio restrictivas. El sistema debe reaccionar de forma controlada, segura y previamente especificada.

### 2. Estructura de un Caso de Uso en SDD

Para que un caso de uso sea útil para el equipo de desarrollo y el de automatización de pruebas, debe abandonar la narrativa literaria vaga y adoptar una estructura técnica predecible:

1. **Identificador y Nombre:** Un código único y un título claro basado en la acción.
2. **Actor Principal:** Quién (humano) o qué (sistema/cron) inicia la acción.
3. **Precondiciones:** El estado exacto y obligatorio que debe tener el sistema antes de iniciar.
4. **Postcondiciones:** El estado del sistema tras finalizar con éxito.
5. **Pasos del Flujo Principal:** Secuencia cronológica y numerada de interacciones.
6. **Extensiones:** Bifurcaciones indexadas que referencian los pasos del flujo principal para manejar alternativas y excepciones.

---

### 3. Soluciones a los Laboratorios (Tema 4)

A continuación, se presentan las soluciones prácticas aplicando los conceptos de modelado de comportamiento. Se utilizará como ejemplo la funcionalidad de **"Autenticación en dos pasos (2FA)"**.

#### Laboratorio 1: Redacción de casos de uso para una funcionalidad real

**Dinámica:** Redactar el flujo principal (Happy Path) para la verificación 2FA, asegurando precisión técnica.

**Solución (El Flujo Principal):**

* **ID:** `CU-AUTH-02`
* **Nombre:** Iniciar sesión con Autenticación de Doble Factor.
* **Actor:** Usuario registrado.
* **Precondiciones:** El usuario ha introducido sus credenciales básicas (email y contraseña) correctamente en el paso anterior. Tiene el sistema 2FA activado en su perfil.
* **Postcondiciones:** Se genera un token de sesión (JWT) válido y el usuario accede a su panel privado.

**Pasos (Flujo Principal):**
1. El sistema solicita al usuario un código de verificación de 6 dígitos e inicia un temporizador de validez temporal (5 minutos).
2. El sistema envía un SMS con el código al número de teléfono cifrado asociado al usuario.
3. El usuario introduce el código de 6 dígitos numéricos en el formulario.
4. El usuario acciona el botón de confirmación.
5. El sistema verifica contra la base de datos que el código coincide y está dentro del tiempo de validez.
6. El sistema autentica al usuario, genera la sesión y lo redirige a `/dashboard`.

#### Laboratorio 2: Modelado de escenarios alternativos y excepciones

**Dinámica:** Tomando el caso de uso del Laboratorio 1, modelar explícitamente qué ocurre si el usuario se desvía del camino ideal o comete errores.

**Solución (Extensiones de Comportamiento):**

Las extensiones se vinculan de manera alfanumérica a los pasos específicos del flujo principal donde ocurre la desviación.

* **Alternativa 1 (Vinculada al paso 2 - Uso de App Autenticadora):**
  * 2a. El usuario tiene configurada una App Autenticadora (ej. Google Authenticator) como método preferido en lugar de SMS.
  * 2a1. El sistema omite el envío del SMS y despliega la pantalla solicitando el código dinámico de la aplicación. El flujo retorna al paso 3.
* **Excepción 1 (Vinculada al paso 5 - Código incorrecto):**
  * 5a. El sistema detecta que el código introducido no es válido.
  * 5a1. El sistema muestra el mensaje de error: *"Código incorrecto. Te quedan [X] intentos"*.
  * 5a2. El sistema incrementa el contador de intentos fallidos en la caché temporal. El flujo retorna al paso 3.
* **Excepción 2 (Vinculada al paso 5 - Bloqueo por seguridad):**
  * 5b. El usuario introduce un código incorrecto por tercera vez consecutiva (Invariante de negocio: Máximo 3 intentos).
  * 5b1. El sistema bloquea el intento de inicio de sesión por 15 minutos.
  * 5b2. El sistema envía un email automatizado de alerta de seguridad al correo del usuario.
  * 5b3. El sistema muestra el mensaje: *"Cuenta bloqueada temporalmente por seguridad. Revisa tu correo electrónico"*. El caso de uso finaliza en estado de error.

#### Laboratorio 3: Revisión cruzada de casos de uso entre equipos

**Dinámica:** Simular una revisión por pares (Spec Review) donde un perfil de Calidad (QA) evalúa la especificación elaborada en los laboratorios 1 y 2, identificando un hueco funcional crítico.

**Solución (Hallazgos y resolución):**

El equipo revisor detecta que la especificación actual es incompleta porque falta definir el comportamiento de los límites temporales. Generan el siguiente reporte de revisión para Negocio y Desarrollo:

* **Observación de QA:** *"En el paso 1 indicáis que el temporizador del código es de 5 minutos. Sin embargo, en la sección de excepciones no se ha modelado qué debe hacer el sistema cuando el usuario intenta introducir el código, por ejemplo, en el minuto 6. ¿Se asume como código incorrecto? ¿Se bloquea la cuenta? Falta comportamiento determinista."*
* **Resolución del Equipo de Producto:** Se acepta el feedback y se actualiza el modelo añadiendo una nueva excepción obligatoria antes de iniciar la programación.

**Nueva Excepción añadida al modelo:**
* **Excepción 3 (Vinculada al paso 5 - Código caducado):**
  * 5c. El sistema verifica que la diferencia de tiempo entre la generación del código y el envío del formulario es superior a 300 segundos (5 minutos).
  * 5c1. El sistema invalida y destruye el código actual.
  * 5c2. El sistema muestra un modal de aviso: *"El código de seguridad ha caducado. Por favor, solicita uno nuevo"*.
  * 5c3. El sistema resetea el formulario y habilita un botón secundario de "Reenviar código". El flujo retorna al paso 1.