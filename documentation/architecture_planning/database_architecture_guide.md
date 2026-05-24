# Database Architecture Guide

Este documento define la estrategia de modelado de datos para el Dev Blueprint Builder.

## 1. Objetivo

Separar y formalizar todo lo relacionado con la base de datos:
- Eleccion de motor (Firestore o SQL)
- Definicion de entidades y relaciones
- Reglas de acceso y validaciones
- Indices requeridos
- Convenciones de nombres

## 2. Convenciones Generales

- Entidades en plural: `users`, `courses`, `members`, `businesses`
- Campos de auditoria estandar:
  - `createdAt`
  - `updatedAt`
  - `createdBy` (si aplica)
- IDs inmutables (`id` o `documentId`)
- Evitar campos de lista sin limite de crecimiento

## 3. Firestore (Documento/coleccion)

### 3.1 Patrones recomendados

- Colecciones raiz por agregado principal
- Subcolecciones para hijos de alto volumen
- Denormalizacion controlada para lecturas frecuentes

### 3.2 Estructura base

- `users/{userId}`
- `audit_logs/{logId}`
- `notifications/{notificationId}` (si aplica)

### 3.3 Jerarquias comunes

- Negocio:
  - `businesses/{businessId}`
  - `businesses/{businessId}/branches/{branchId}`
  - `businesses/{businessId}/employees/{employeeId}`
- Cursos:
  - `courses/{courseId}`
  - `courses/{courseId}/modules/{moduleId}`
  - `courses/{courseId}/lessons/{lessonId}`
  - `enrollments/{enrollmentId}`
- Gym:
  - `gyms/{gymId}`
  - `gyms/{gymId}/members/{memberId}`
  - `gyms/{gymId}/plans/{planId}`
  - `gyms/{gymId}/workouts/{workoutId}`

### 3.4 Indices minimos sugeridos

- `users`: `createdAt DESC`
- Entidades operativas: `ownerId ASC`, `createdAt DESC`
- Mensajeria: `conversationId ASC`, `createdAt DESC`

### 3.5 Reglas de seguridad (base)

- Requerir autenticacion para lecturas/escrituras privadas
- Validar ownership o permisos por rol
- Denegar por defecto (`allow read, write: if false`)
- Validar campos requeridos en `request.resource.data`

## 4. SQL (Tabla/relacion)

### 4.1 Mapeo de entidades

- Cada entidad custom -> tabla
- Campo `id` como PK
- Si hay padre, agregar FK a la tabla padre

### 4.2 Relaciones

- One-to-many: padre -> hijos
- Many-to-many: tabla pivote (`student_courses`, `member_plans`)

### 4.3 Indices recomendados

- FK + `createdAt`
- Campos de busqueda frecuente (`email`, `status`, `slug`)

## 5. Checklist de diseño de schema

- Existe al menos una entidad principal del dominio
- Todas las entidades tienen campos minimos de auditoria
- Las relaciones estan explicitas (padre/hijo o FK)
- Hay plan de indices para queries criticas
- Hay reglas/politicas de acceso documentadas

## 6. Integracion con el Dev Planner

En la pantalla de arquitectura:
- Seccion de "Modelo de Datos Personalizado" para crear entidades
- Seccion de "Esquema de Base de Datos" para visualizar el resultado
- Botones de copiado para pegar en tareas del agente

## 7. Resultado esperado al enviar al agente

El agente debe crear:
- Modelos de datos
- Repositorios
- Mappers
- Servicio de acceso a BD
- Tests minimos
- Reglas/indices (Firestore) o migraciones base (SQL)
