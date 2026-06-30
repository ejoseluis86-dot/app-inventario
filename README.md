# Sistema de Gestión de Inventario

Esta es una solución integral para la gestión de insumos y pedidos para pymes de producción artesanal, compuesta por una aplicación móvil en *Flutter* y una API REST en *Django*.

## Arquitectura del Proyecto
El sistema está dividido en dos repositorios independientes que trabajan en conjunto:

* **[Frontend (App Móvil)](https://github.com/ejoseluis86-dot/app-inventario):** Interfaz para administradores y empleados desarrollada en Flutter.
* **[Backend (API)](https://github.com/ejoseluis86-dot/api-app-inventario):** API RESTful desarrollada en Django/DRF para la lógica de negocio y base de datos.

---

##  Configuración e Instalación

### 1. Backend (API)
Primero, configura el motor de la aplicación:
1. Clona el repositorio: git clone https://github.com/ejoseluis86-dot/api-app-inventario
2. Crea y activa tu entorno virtual: python -m venv venv
3. Instala dependencias: pip install -r requirements.txt
4. Ejecuta las migraciones: python manage.py migrate
5. Inicia el servidor: python manage.py runserver

### 2. Frontend (Flutter App)
Una vez el backend esté corriendo, configura la aplicación:
1. Clona el repositorio: git clone https://github.com/ejoseluis86-dot/app-inventario
2. Instala las dependencias: flutter pub get
3. *Conexión:* Asegúrate de que la baseUrl en services/api_service.dart apunte a la IP de tu servidor local (ej: http://192.168.1.XX:8000).
4. Ejecuta la app: flutter run

---

## ✨ Características Destacadas
- *Gestión de Roles:* Interfaz diferenciada para Administradores y Empleados (uso de UserProvider).
- *Control de Stock Dinámico:* Descuento automático de insumos al iniciar pedidos, y descuento de insumos adicionales al finalizar pedidos.
- *Resumen Rápido:* Botonera inteligente para acceso rápido a Insumos con alerta crítica de stock y Pedidos Activos.
- *Interfaz Fluida:* Listados con soporte de RefreshIndicator y refresco automático al retornar de pantallas de detalle.
- *Toggle Rápido:* Capacidad de activar/desactivar productos e insumos directamente desde el listado (solo para ADMIN).

---

## Tecnologías Utilizadas
* *App:* Flutter, Provider, Material Design, Http.
* *API:* Django, Django REST Framework, PostgreSQL/SQLite.

---
Desarrollado para la optimización de procesos de inventario.
