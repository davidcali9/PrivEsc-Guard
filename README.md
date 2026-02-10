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

## 🔍 Alcance

PrivEsc-Guard se centra **exclusivamente en la escalada local de privilegios**, incluyendo (pero no limitado a):

- Binarios SUID / SGID
- Configuraciones inseguras de sudo
- Permisos incorrectos en archivos críticos
- Tareas cron mal configuradas
- Linux capabilities peligrosas
- Exposición del socket de Docker

> Esta herramienta **NO explota vulnerabilidades**.  
> Está diseñada para **auditoría, visibilidad y hardening**.

## 🧱 Filosofía del proyecto

PrivEsc-Guard no se limita a detectar problemas.  
Cada hallazgo proporciona:

- Descripción del riesgo
- Explicación del impacto
- Referencias técnicas
- Recomendaciones de mitigación

El objetivo es **aprender y reforzar**, no solo escanear.

## 🚧 Estado del proyecto

Este proyecto se encuentra actualmente en **desarrollo activo**.  
Las primeras versiones se centran en la arquitectura base y los checks fundamentales.

## ⚠️ Disclaimer

PrivEsc-Guard está destinado **únicamente a sistemas donde se tenga autorización expresa**.  
El autor no se hace responsable del uso indebido de esta herramienta.
