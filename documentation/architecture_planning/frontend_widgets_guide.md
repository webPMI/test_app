# Frontend and Widgets Architecture Guide

Este documento concentra las decisiones de frontend y widgets para el Dev Blueprint Builder y la app final.

## 1. Objetivo

Definir de forma separada todo lo visual y de UX:
- Estructura de pantallas
- Composicion de widgets
- Reutilizacion de componentes
- Estado visual y feedback
- Integracion con el modelo de datos

## 2. Capas UI recomendadas

- `presentation/pages`: paginas principales
- `presentation/sections`: bloques grandes de una pagina
- `presentation/widgets`: componentes de uso puntual
- `core/widgets`: componentes compartidos globales

## 3. Secciones clave del Dev Planner

- Hero de contexto
- Configuracion de proyecto y dominio
- Configuracion tecnica
- Modelo de datos personalizado
- Esquema generado
- Tarea para agente
- Estado de ejecucion del agente

## 4. Reglas de widgets

- Cada widget debe tener una sola responsabilidad
- Evitar widgets gigantes; extraer secciones reutilizables
- Inputs con validacion y mensajes de error claros
- Componentes de accion con estados: normal, loading, disabled

## 5. UX para personalizacion masiva

- Permitir agregar/quitar entidades rapidamente
- Soportar jerarquias (padre/hijo)
- Mostrar previsualizacion de impacto en esquema
- Avisar cuando hay cambios no enviados al agente

## 6. Accesibilidad y legibilidad

- Contraste correcto para textos y botones
- Targets tactiles comodos
- Jerarquia tipografica estable
- Etiquetas claras en cada campo

## 7. Integracion con estado de trabajo del agente

La UI debe mostrar:
- Estado actual: no enviado, en trabajo, completado
- Ultimo envio
- Ultima finalizacion
- Alertas de cambios pendientes de reenviar

## 8. Checklist frontend/widgets

- Todas las acciones criticas tienen feedback visual
- Los formularios tienen defaults y validacion
- El esquema generado se puede copiar
- La tarea para agente se puede copiar
- El estado de agente es visible y entendible

## 9. Evolucion sugerida

Fase 1:
- Separar widgets por archivos (`sections/`)

Fase 2:
- Agregar formularios dinamicos por tipo de entidad

Fase 3:
- Generacion directa de archivos de feature desde UI

Fase 4:
- Historial de tareas enviadas y resultado por iteracion
