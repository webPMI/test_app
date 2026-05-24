# Checklist de Pruebas: Layout Responsivo y Componentes Atómicos

Asegura que el diseño se adapte a cualquier resolución basándose en la arquitectura de quiebres estandarizados y que los componentes sean altamente eficientes sin afectar el *Render Tree*.

## 1. Breakpoints y ResponsiveLayoutBuilder
- [ ] **Móvil (< 600px):** El `ResponsiveLayoutBuilder` inyecta correctamente el layout compacto sin *overflows* en pantallas estrechas (ej. 320x568).
- [ ] **Tablet (600px - 899px):** El layout cambia fluidamente al diseño intermedio, reacomodando paneles.
- [ ] **Desktop (>= 900px):** El layout expande su contenido aprovechando el ancho sin estirar excesivamente los elementos.
- [ ] **Rotación:** El diseño se ajusta correctamente al alternar el dispositivo entre *Portrait* y *Landscape* sin corromper el estado de la UI.
- [ ] Ningún componente utiliza condicionales con anchos numéricos directos (`if (width > 500)`); se validó el uso exclusivo de la clase central de *breakpoints*.

## 2. Componentes Atómicos (Escalabilidad Visual)
- [ ] **Átomos:** Botones e inputs mantienen su tamaño mínimo de accesibilidad táctil (mínimo 48x48 dp) en cualquier resolución y dispositivo.
- [ ] **Moléculas (Formularios/Tarjetas):** Limitan su ancho máximo en pantallas ultra-anchas mediante contenedores (`ConstrainedBox` o `Center`) para mantener la legibilidad.
- [ ] **Grillas Dinámicas:** Los listados (`GridView`) recalculan la cantidad de columnas (*crossAxisCount*) de forma reactiva al redimensionar la ventana (ej. 1 columna en móvil a 4 columnas en desktop).
- [ ] **Reflow de Contenido:** Elementos estructurales combinados pasan de apilarse verticalmente (`Column`) en móvil, a organizarse lado a lado (`Row`) en espacios amplios cuando es necesario.

## 3. Eficiencia y Rendimiento de Componentes (Performance)
- [ ] **Aislamiento de Rebuilds:** Los componentes hijos con estados locales complejos (ej. *hover* o parpadeo) no reconstruyen al componente padre ni a toda la pantalla (aislados con `ValueListenableBuilder` o `BlocBuilder` puntuales).
- [ ] **RepaintBoundary:** Elementos con animaciones complejas (spinners, loaders) o listas pesadas están aislados para no obligar al repintado de toda la interfaz estática que los rodea.
- [ ] **Renderizado Perezoso (Lazy Loading):** Las colecciones de datos masivas utilizan obligatoriamente constructores `.builder` (ej. `ListView.builder`) en lugar de renderizar toda la lista en memoria.
- [ ] **Inmutabilidad Estricta:** Todo widget que no necesite redibujarse utiliza su constructor como `const` para optimizar el trabajo del motor de Flutter en redimensionamientos.