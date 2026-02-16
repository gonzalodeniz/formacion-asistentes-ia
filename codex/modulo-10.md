# Módulo 10 — CI/CD, Control de Versiones y Operaciones (DevOps con IA)

**Duración estimada:** 90 minutos (45 min teoría + 45 min laboratorio)
**Enfoque:** Automatización, Gobernanza y Cultura DevOps.

## 1. Objetivos de Aprendizaje

1. **Integración en el Pipeline:** Dejar de usar la IA solo en el IDE ("localhost") y empezar a usarla como un actor en el flujo de CI/CD (GitHub Actions, GitLab CI).
2. **Estandarización de Git:** Utilizar la IA para imponer convenciones estrictas (Conventional Commits) y generar descripciones de Pull Requests (PR) ricas en contexto.
3. **El Ciclo "Fix-until-Green":** Configurar agentes autónomos supervisados que intenten arreglar fallos de tests en el CI automáticamente, con límites de intentos para evitar costes infinitos.

---

## 2. Contenidos Teóricos

### 2.1. Codex en el Flujo de Trabajo (Workflow)

La IA no debe ser un "ente mágico" que toca el código sin control. Debe tratarse como un **Desarrollador Junior** automatizado.

* **Modelo de Ramas:** La IA nunca debe hacer push a `main`. Siempre debe trabajar en `feature/` o `fix/`.
* **La Regla del Árbitro (CI):** La IA propone cambios, pero el sistema de Integración Continua (CI) es la autoridad final. Si el CI está rojo, el cambio de la IA se rechaza, independientemente de lo convincente que sea su explicación.

### 2.2. Automatización con CLI y Hooks

La CLI de Codex (`codex`) es idempotente y scriptable, lo que permite integrarla en:

* **Pre-commit Hooks:** Antes de que el humano haga commit, la IA revisa si hay secretos expuestos o si los nombres de variables cumplen el estándar.
* **CI Reviewer:** Un paso en el pipeline donde **GPT-5.1-Codex-Max** lee el diff del PR y comenta sugerencias de seguridad o arquitectura antes de que un humano pierda tiempo revisándolo.

### 2.3. Patrones de Colaboración

* **"Draft PR First":** La IA abre el PR en modo borrador con un resumen de lo que hizo, los archivos que tocó y *por qué*.
* **Conventional Commits:** La IA debe ser instruida (vía `SKILL.md`) para escribir mensajes semánticos: `feat(auth): add jwt support` en lugar de `fix code`.

---

## 3. Buenas Prácticas

1. **Plantillas de PR Corporativas:** Configura la IA para que rellene tu plantilla de Markdown (`.github/PULL_REQUEST_TEMPLATE.md`). Debe marcar qué tests manuales realizó.
2. **Límites de Reintento (Circuit Breaker):** Si configuras un agente para "arreglar el build", limítalo a 3 intentos. Si falla 3 veces, asigna la tarea a un humano. Evita bucles infinitos de facturación.
3. **Scopes Protegidos:** Usa archivos `.codexignore` o configuraciones de seguridad para prohibir terminantemente que la IA toque carpetas como `.github/workflows/` o `/terraform/prod/`.

---

## 4. Errores Comunes

1. **"Blind Merge":** Automatizar que si el CI pasa, el PR se apruebe y fusione solo. **Peligro:** La IA puede borrar un test para que el pipeline pase. La revisión humana del diff sigue siendo obligatoria.
2. **Commit Spam:** Dejar que la IA haga un commit por cada cambio menor (typo, formato), ensuciando el historial. Instrúyela para hacer `squash` o commits atómicos.
3. **Reescritura de Historial:** Permitir que la IA haga `git push --force` en ramas compartidas.

---

## 5. Casos de Uso Reales

* **Generación de Changelog:** Un script que lee los diffs de los últimos 20 commits y genera un `CHANGELOG.md` resumido para humanos, agrupado por funcionalidades.
* **Migración de Dependencias:** Un bot que detecta una vulnerabilidad en `package.json`, crea una rama, actualiza la librería, corre los tests, corrige las roturas menores y abre el PR listo para revisión.

---

## 6. Laboratorio (L10) — “El PR Perfecto”

**Escenario:** Simularemos un entorno de trabajo real. Crearemos una feature, aseguraremos que pase un pipeline de calidad simulado (linter + tests) y generaremos el artefacto de entrega (PR) automáticamente.

### Paso 1: Setup del Repo y el "Pipeline"

Crearemos un script que simula ser Jenkins o GitHub Actions.

```bash
mkdir codex-lab10
cd codex-lab10
git init

# 1. Crear el script de CI simulado
cat <<EOF > ci_pipeline.sh
#!/bin/bash
echo ">>> Ejecutando Pipeline de CI..."
# Simula chequeo de estilo: Falla si hay funciones sin docstrings
if grep -q "def " calculator.py && ! grep -q '"""' calculator.py; then
    echo "[ERROR] Linter: Faltan docstrings en las funciones."
    exit 1
fi
# Simula tests: Falla si no existe el archivo de tests
if [ ! -f test_calculator.py ]; then
    echo "[ERROR] Tests: No se encontró test_calculator.py"
    exit 1
fi
# Ejecuta tests reales
python3 -m unittest test_calculator.py
EOF
chmod +x ci_pipeline.sh

# 2. Commit inicial
touch README.md
git add .
git commit -m "chore: initial commit"

```

### Paso 2: Desarrollo de la Feature con IA

Pedimos a la IA que cree una calculadora básica.

**Instrucción:**

```bash
codex do "Crea un archivo 'calculator.py' con funciones sumar y restar. Crea también 'test_calculator.py'. NO añadas docstrings todavía (quiero que falle el CI)."

```

### Paso 3: El Fallo del CI (Feedback Loop)

Ejecutamos nuestro pipeline simulado.

```bash
./ci_pipeline.sh
# Resultado esperado: [ERROR] Linter: Faltan docstrings...

```

### Paso 4: Modo "Auto-Fix"

Ahora usamos la IA para arreglar el fallo basándose en el output del CI.

**Instrucción:**

```bash
# Simulamos pasar el log de error a la IA
./ci_pipeline.sh > ci_log.txt 2>&1
codex do "El pipeline de CI ha fallado. Lee 'ci_log.txt' y arregla el código para que pase."

```

*Acción de la IA:* Leerá el error de "Faltan docstrings", editará `calculator.py` para añadirlos y quizás ajuste los tests.

**Verificación:**

```bash
./ci_pipeline.sh
# Resultado esperado: OK (Tests passed)

```

### Paso 5: Generación del PR y Commits

Una vez el código es válido, formalizamos la entrega.

**Instrucción:**

```bash
# 1. Pedirle que haga los commits semánticos
codex do "Genera los comandos git para hacer commit de los cambios usando la convención 'Conventional Commits'. No ejecutes, solo muestra."

# 2. Generar la descripción del PR
codex do "Genera una descripción para el Pull Request en formato Markdown. Incluye: Resumen, Cambios, Checklist de validación y comandos para probarlo."

```

**Resultado Esperado:**
Un texto listo para copiar y pegar en GitHub/GitLab que explica profesionalmente qué se hizo y confirma que los tests pasan.

### Paso 6: Limpieza Final

```bash
cd ..
rm -rf codex-lab10
echo "Curso finalizado. ¡Felicidades!"

```
