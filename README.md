# PrivEsc-Guard

PrivEsc-Guard is a Linux security auditing and hardening tool focused on detecting common **local privilege escalation vectors**.

## 🎯 Purpose

The goal of this project is to help system administrators and security professionals:

- Identify insecure configurations that may lead to privilege escalation
- Understand the associated risk of each finding
- Apply clear and actionable mitigation steps
- Improve overall Linux system hardening

## 🔍 Scope

PrivEsc-Guard focuses exclusively on **local privilege escalation checks**, including but not limited to:

- SUID / SGID binaries
- sudo misconfigurations
- Insecure file permissions
- Cron jobs
- Linux capabilities
- Docker socket exposure

> This tool does **not** exploit vulnerabilities.  
> It is designed for **audit, visibility and hardening** purposes.

## 🚧 Project Status

This project is currently under active development.  
Initial versions focus on core architecture and basic security checks.

## ⚠️ Disclaimer

PrivEsc-Guard is intended for **authorized systems only**.  
The author is not responsible for misuse or damage caused by this tool.
