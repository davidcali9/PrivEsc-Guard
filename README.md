<p align="center">
  <img src="assets/privesguard.png" width="400">
</p>

# PrivEsc-Guard


<a href="https://www.buymeacoffee.com/davidcanasz" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy Me a Coffee">
</a>


PrivEsc-Guard es una herramienta de **auditoría de seguridad y hardening en Linux** enfocada en la detección de **vectores comunes de escalada local de privilegios**.

## 🎯 Objetivo

El objetivo de este proyecto es ayudar a administradores de sistemas y profesionales de la ciberseguridad a:

- Identificar configuraciones inseguras que pueden derivar en escalada de privilegios
- Comprender el riesgo asociado a cada hallazgo
- Aplicar medidas de mitigación claras y accionables
- Mejorar el nivel general de hardening en sistemas Linux

## 🔎 Qué analiza actualmente

PrivEsc-Guard incluye los siguientes módulos:

- Búsqueda de binarios SUID / SGID
- Revisión de configuraciones sudo
- Permisos críticos inseguros
- Tareas programadas (cron)
- Linux Capabilities
- Exposición de Docker
- Usuarios con UID 0 adicionales
- Riesgos de PATH Hijacking

Cada módulo contribuye a un sistema de puntuación global de riesgo.

## 📊 Sistema de Risk Score

La herramienta calcula un Risk Score acumulativo (0–100) basado en los hallazgos detectados.

## 📄 Reportes generados

Al ejecutar la herramienta se generan automáticamente:

- Reporte en texto plano (.txt)
- Reporte visual en HTML (.html)

El reporte HTML incluye:

- Risk Score destacado
- Nivel de exposición
- Resumen por módulo
- Fecha de ejecución
- Versión de la herramienta

Diseño limpio, profesional y fácil de compartir.

## 🚀 Uso

## Ejecución normal:

./privesc-guard.sh

## Ejecutar solo un módulo (puedes seleccionar el módulo que quieras)

./privesc-guard.sh --only suid

## Omitir un módulo:

./privesc-guard.sh --skip docker

## Lanzar sin generar reportes:

./privesc-guard.sh --no-report


## 📁 Estructura del proyecto

```bash
PrivEsc-Guard/
├── core/
├── modules/
├── output/
│   └── reports/
├── assets/
├── privesc-guard.sh
└── README.md
```
