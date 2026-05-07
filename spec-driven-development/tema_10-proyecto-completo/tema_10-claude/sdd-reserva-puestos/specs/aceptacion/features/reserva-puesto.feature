# language: es
Feature: Reserva de puesto de trabajo

  Como empleado de TechNova
  quiero reservar un puesto de trabajo
  para asegurar que tendré sitio al llegar a la oficina.

  # --- Camino feliz ---

  @FUNC-002 @AC-002-01
  Scenario: Reserva exitosa de puesto libre
    Given un empleado autenticado "Ana García"
    And el puesto "MAD-C-TUR-05" está libre
      el "2025-05-12" en franja "AM"
    And Ana no tiene reserva para "2025-05-12" "AM"
    When Ana reserva el puesto "MAD-C-TUR-05"
      para "2025-05-12" franja "AM"
    Then se crea una reserva con estado "confirmada"
    And el puesto "MAD-C-TUR-05" aparece como
      "reservado" para "2025-05-12" "AM"
    And Ana recibe un email de confirmación

  # --- Conflictos ---

  @FUNC-002 @AC-002-02
  Scenario: Reserva rechazada por solapamiento
    Given un empleado "Ana García" con reserva activa
      para "2025-05-12" "AM" en puesto "MAD-C-TUR-05"
    When Ana intenta reservar puesto "MAD-C-TUR-07"
      para "2025-05-12" "AM"
    Then la reserva es rechazada
    And se muestra "Ya tienes una reserva para esa
      fecha y franja"

  @FUNC-002 @AC-002-03
  Scenario: Reserva rechazada por concurrencia
    Given el puesto "MAD-C-TUR-05" está libre
      el "2025-05-12" "AM"
    And "Ana García" y "Luis Pérez" intentan reservar
      el mismo puesto simultáneamente
    When ambos confirman la reserva
    Then solo uno obtiene la reserva con éxito
    And el otro recibe "Este puesto acaba de ser
      reservado por otro empleado"

  # --- Franjas ---

  @DN-001 @AC-002-04
  Scenario: Día completo no disponible si AM ocupada
    Given el puesto "MAD-C-TUR-05" tiene reserva "AM"
      para "2025-05-12"
    When un empleado intenta reservar "FD" para
      "2025-05-12"
    Then la reserva es rechazada
    And se muestra "No puedes reservar día completo:
      la franja de mañana ya está ocupada"

  @DN-001 @AC-002-05
  Scenario: PM disponible aunque AM esté ocupada
    Given el puesto "MAD-C-TUR-05" tiene reserva "AM"
      para "2025-05-12"
    When un empleado reserva "PM" para "2025-05-12"
    Then la reserva se crea con éxito

  # --- Antelación ---

  @DN-002 @AC-002-06
  Scenario: Reserva dentro del rango de 14 días
    Given hoy es "2025-05-07"
    When un empleado reserva para "2025-05-21"
    Then la reserva se crea con éxito

  @DN-002 @AC-002-07
  Scenario: Reserva fuera del rango de 14 días
    Given hoy es "2025-05-07"
    When un empleado reserva para "2025-05-22"
    Then la reserva es rechazada
    And se muestra "Solo puedes reservar entre hoy
      y los próximos 14 días"

  # --- Bloqueo ---

  @FUNC-005 @AC-002-08
  Scenario: Puesto bloqueado no es reservable
    Given el puesto "MAD-C-TUR-05" está bloqueado
      por mantenimiento
    When un empleado intenta reservar ese puesto
    Then la reserva es rechazada
    And se muestra "Este puesto está bloqueado
      por mantenimiento"
