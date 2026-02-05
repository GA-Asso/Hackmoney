# Proyecto Cashback "Capital Productivo"

## Visión General

Este proyecto busca crear un sistema de cashback innovador que convierte los reembolsos obtenidos por compras en capital productivo de forma automática y transparente para el usuario. En lugar de acumular "puntos" estáticos, los fondos se depositan en pools de liquidez de finanzas descentralizadas (DeFi) para generar rendimiento.

La experiencia de usuario está diseñada para ser "DeFi-Abstracted", ocultando la complejidad de la blockchain y ofreciendo una interacción sencilla y fluida.

## Arquitectura Tecnológica

El sistema se basa en una combinación de tecnologías de vanguardia:

- **Uniswap v4:** Se utilizará un "hook" para interceptar las comisiones de intercambio (swap fees) y redirigirlas a los pools de liquidez designados.
- **Sui Blockchain:** Se aprovecharán los Programmable Transaction Blocks (PTBs) y el sistema zkLogin para una gestión de identidad segura y pagos rápidos con una experiencia de usuario similar a Web2.
- **Ethereum Name Service (ENS):** Se gestionarán identidades de usuario a través de subdominios con el formato `nombre.cashbackid.eth`, permitiendo a los usuarios configurar sus perfiles y direcciones de recepción.

## Fases del Proyecto

### Fase 0: Preparación del Entorno
- [x] Creación del README.md
- [ ] Estructura de directorios
- [ ] Configuración inicial de `.gitignore`

### Fase 1: El Corazón del Protocolo (Smart Contracts)
- **Uniswap v4 Hook (Solidity):** Diseño e implementación del hook para depositar fondos en pools de liquidez.
- **Contratos de Sui (Move):** Desarrollo de la lógica para PTBs, gestión de identidad y pagos.

### Fase 2: La Capa de Identidad (ENS)
- Integración con ENS para la gestión de subdominios `nombre.cashbackid.eth`.
- Desarrollo de la lógica para la configuración de perfiles de usuario.

### Fase 3: La Interfaz de Usuario (App)
- Creación de una aplicación web simple que abstraiga la complejidad de DeFi.
- Integración con Sui zkLogin para una autenticación y experiencia de usuario fluidas.
