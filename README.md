# cronometro

## Descripción
**Cronometro** es una aplicación móvil desarrollada en Flutter que permite medir el tiempo, registrar vueltas y enviar notificaciones. El proyecto sigue la arquitectura **MVVM** para mantener una estructura organizada y escalable.

## Funcionalidades
- Iniciar, pausar y reiniciar el cronómetro.
- Registrar vueltas.
- Enviar notificaciones locales al pausar o finalizar el cronómetro, además de notificación con el transcurso del tiempo.
- Interfaz amigable y accesible para personas con deficiencias visuales.
- Soporte para Android.

## Paquetes utilizados
- [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications) – para enviar notificaciones locales.
- [dart:async] → Proporciona herramientas para trabajar con asíncronía, como Future, Stream y Timer. Se usa en cronómetros, llamadas a APIs, o cualquier operación que se ejecute en segundo plano.

## Estructura del proyecto
- `models/` – Contiene los modelos de datos (por ejemplo, VueltasModel).
- `viewmodels/` – Maneja la lógica de negocio y comunicación con servicios.
- `views/` – Contiene las pantallas de la aplicación.
- `services/` – Contiene servicios auxiliares como notificaciones.

## Cómo usar el código fuente
Video Demostrativo: https://drive.google.com/file/d/1t2_YuTItB-94CTtRTQ1nyweFFGIMwiiz/view?usp=sharing
1. Clonar el repositorio:
   ```bash
   git clone https://github.com/tu-usuario/cronometro.git
![GIF](https://github.com/user-attachments/assets/a141a604-ec6b-469f-a0e1-3df035cd4ad9)
