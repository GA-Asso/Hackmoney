# Cashback ID 🦄💰

**Cross-Chain Identity & Yield Generation**

**Tech Stack:** Sui Network (High-Speed Execution), LI.FI (Cross-Chain Swaps/Onboarding), ENS (Identity), Uniswap v4 (Hooks/Yield)
**Tagline:** "Tu nombre es tu cuenta. Tu compra es tu inversión."

---

## �� Deployed Contracts & Components

### Sui Testnet
| Component | Object ID | Status |
|-----------|-----------|--------|
| **Package** |  | ✅ Published |
| **Profile Module** |  | ✅ Active |
| **Checkout Module** |  | ✅ Active |

### EVM (Sepolia)
| Contract | Address | Status |
|----------|---------|--------|
| **CashbackHook** |  | ✅ Deployed |
| **PoolManager** |  | ✅ Official |

---

## 🛠️ Quick Start

### Prerequisites
- Node.js >= 18
- Sui CLI (para contratos Move)
- Foundry (para contratos Solidity)

### Installation



### Run Frontend Demo



---

## 🎯 How It Works



1. **Onboarding Cross-Chain (LI.FI):** El usuario puede entrar desde cualquier cadena (Ethereum, Polygon, Arbitrum, etc.) usando el widget de LI.FI integrado, que convierte sus fondos a SUI.
2. **Identidad (ENS):** Resolvemos nombres ENS (ej. ) para vincularlos a direcciones Sui mediante text records (), unificando la identidad on-chain.
3. **Cashback (Sui Move):** 
   - Se crea un  (objeto Sui).
   - Los pagos procesados generan cashback automático.
   - El estado es gestionado en la red de alta velocidad de Sui.

---

## 📁 Project Structure



---

## �� Plan de Implementación

### Fase 1: Identidad y Onboarding (✅ Completado)
- Integración de **LI.FI Widget** para swaps cross-chain a Sui.
- Resolución de **ENS** en frontend para mapear identidades EVM → Sui.
- Creación de perfiles en Sui ().

### Fase 2: Ejecución de Pagos (✅ Completado)
- Módulo  en Sui Move.
- API  para procesar pagos y calcular cashback.
- Integración de  para operaciones atómicas.

### Fase 3: Yield Layer (🚧 En Progreso)
- Conexión del  de Uniswap v4 para generar rendimiento en los fondos de cashback (cross-chain strategy).

---

## 🗺️ Arquitectura Actualizada



---

## 📌 Notas Importantes
- **LI.FI Integration:** Reemplaza la necesidad de usar Uniswap directamente en el frontend para el onboarding. Permite a los usuarios traer liquidez desde cualquier cadena compatible.
- **Sui Speed:** Toda la lógica de usuario final (perfil, historial, reclamo de cashback) vive en Sui para aprovechar su baja latencia y costos.
- **Telegram Bot:** Agente activo (@PumaAgent_bot) para notificaciones y gestión rápida de perfil.

## 📜 License
MIT
