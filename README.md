# 💳 Cashback ID: The Invisible Rewards Protocol

**Hackathon:** ETH Global - HackMoney 2026  
**Tech Stack:** Sui Network (High-Speed Execution), ENS (Identity), LI.FI (Cross-Chain)
**Tagline:** "Tu nombre es tu cuenta. Tu compra es tu inversión."

---

## 🎯 Business Model Canvas

### 1️⃣ Customer Segments (Segmentos de Cliente)
*   **Usuarios Finales (Gen Z & Alpha):** Consumidores que odian la burocracia bancaria y buscan que cada peso gastado genere valor futuro.
*   **Comercios Modernos (Web2.5):** Negocios que quieren sistemas de lealtad sin pagar las comisiones del 3-5% de las redes de crédito tradicionales.
*   **Marcas & Advertisers:** Empresas que buscan recompensar directamente a sus clientes fieles sin intermediarios.

### 2️⃣ Value Proposition (Propuesta de Valor)
*   **Para el Usuario:** Una tarjeta que convierte el cashback en capital productivo automáticamente. No son "puntos", es dinero real que crece en pools de Uniswap.
*   **Para el Comercio:** Reducción drástica de costos operativos y acceso a una base de usuarios nativos digitales identificados por ENS.
*   **Diferenciador Tecnológico:** Liquidación instantánea en Sui, ahorro automatizado en Uniswap v4 e identidad legible en ENS.

### 3️⃣ Channels
*   DMs directos en X/Twitter a founders/PMs de apps de loyalty/rewards Web3, con mini video demo del flujo “ENS + cashback en stablecoins en 1 clic”.
*   Outreach a proyectos de loyalty sobre Sui/EVM y participación en hackathons/comunidades (ENS, Sui, DeFi) mostrando el protocolo como pieza reutilizable.

### 4️⃣ Customer Relationships
*   Soporte “concierge” para las primeras 3 integraciones: ustedes hacen casi todo el setup técnico y ayudan a diseñar el esquema de cashback.
*   Canal directo (Telegram/Discord) con respuesta rápida y revisiones mensuales de métricas y roadmap compartido, para que sientan co-creación del protocolo.

### 5️⃣ Revenue Streams
*   Fee por transacción de 0.5–1% del volumen de cashback procesado, cobrado al partner B2B, no al usuario final.
*   Fee opcional sobre parte del yield generado con el cashback invertido, potencialmente compartido con el partner; en el futuro, planes enterprise con suscripción mensual y setup fee.

### 6️⃣ Key Resources
*   Infraestructura: RPCs de Sui/EVM, hosting backend/front, colas/event streaming para eventos de PTBs y hooks, logging y monitoring básico.
*   Herramientas de analytics para seguir volumen de cashback, retención por partner y comportamiento de usuarios.
*   Equipo mínimo: 1 dev fullstack cripto (Sui + EVM) y 1 founder-product enfocado en partners y UX, más acceso a soporte/comunidad de ENS, Sui y Uniswap.

### 7️⃣ Key Activities
*   Hablar continuamente con proyectos de loyalty/rewards Web3 para integrarlos, definir su modelo de cashback y lanzar pilotos.
*   Mantener y mejorar contratos (Sui Objects de loyalty, hook Uniswap v4) e infraestructura backend para estabilidad y seguridad.
*   Iterar el dashboard y UX para merchants/apps y usuarios finales usando datos de uso y feedback directo.

### 8️⃣ Key Partners
*   ENS, Sui y Uniswap como protocolos core que dan soporte técnico, credibilidad y canales de distribución.
*   Agencias Web3 e integradores técnicos que implementan programas de loyalty para marcas/Web2.5 usando Cashback ID como motor bajo el capó.
*   Comunidades y ecosistemas de devs (Hack Money, comunidades ENS/Sui/DeFi) donde otros builders integran el protocolo en sus propias apps de rewards.

### 9️⃣ Cost Structure
*   Infra mensual: RPCs, hosting, bases de datos, monitoring.
*   Herramientas de analytics, diseño y desarrollo.
*   Incentivos de cashback para pilotos con los primeros partners.
*   Costos de equipo (founders + devs) en fase early.

---

## 📋 MVP Scope: Cashback ID

### 🚀 El Flujo "Invisible" (UX)
1.  **Identity:** El usuario reclama su perfil con un click (usando Google/Apple vía Sui zkLogin). Se le asigna un subdominio `nombre.cashbackid.eth`.
2.  **Spend:** El usuario paga en un comercio físico o digital con su tarjeta (Apple Pay / Google Pay).
3.  **Execute:** Sui procesa la transacción en <1s. El contrato detecta el % de cashback pactado.
4.  **Yield:** El cashback se envía a un Hook de Uniswap v4 que lo deposita en un pool de liquidez, generando intereses desde el minuto 1.
5.  **Control:** El usuario ve su saldo crecer en una app simple, sin términos técnicos como "gas", "slippage" o "liquidity pools".

### ✅ Features del MVP (Must-Haves)
*   **Fast Checkout (Sui):** Uso de *Programmable Transaction Blocks* para validar identidad y pago en un solo paso.
*   **ENS Profile Manager:** Interfaz para que el usuario elija en sus text records si quiere su cashback en Stablecoins, ETH o activos ambientales.

---

## 🎨 Branding & Killer UX

### 💎 Estrategia de Diseño: "DeFi-Abstracted"
*   **No Cripto-Jerga:** En lugar de "Wallet Address", usamos "ID de Pago". En lugar de "Staking", usamos "Crecimiento".
*   **Visualización Dinámica:** La tarjeta digital en la app cambia de intensidad de brillo conforme el cashback del usuario genera más rendimientos.

### 🌈 Identidad Visual
*   **Paleta de Colores:**
    *   Deep Obsidian (`#0B0E11`) - El fondo premium.
    *   Electric Mint (`#00FFA3`) - El color del dinero activo y el crecimiento.
    *   Sui Blue (`#4DA2FF`) - Para elementos de velocidad y confianza.
*   **Tipografía:** Inter o Satoshi (Moderna, geométrica y altamente legible).

### 📣 Marketing & Slogan
*   **Slogan Principal:** *"Tu identidad paga."*
*   **Campaign Idea:** "¿Por qué tu banco se queda con tus puntos? En Cashback ID, tus compras trabajan para ti."
*   **Publicidad:** Visuales de una tarjeta física transparente donde se ven "engranajes" digitales (los Hooks) moviéndose cada vez que se hace un pago.

---

## 🛠️ Tech Integration (Hackathon Tracks)

### 🤖 ETH Global - HackMoney 2026: Uniswap v4 Track

*   **Descripción:** Build on Uniswap v4 to explore agent-driven financial systems. Projects may involve agents that programmatically interact with Uniswap v4 pools for liquidity management, trade execution, routing, coordination, or other behaviors enabled by onchain state. Submissions should emphasize reliability, transparency, and composability over speculative intelligence. The use of Hooks is optional and encouraged where it meaningfully supports the design.
*   **Requisitos de Calificación:**
    *   TxID transactions (testnet and/or mainnet)
    *   GitHub repository
    *   README.md
    *   Demo link or setup instructions
    *   Demo video (max 3 min)


### 🕶️ Uniswap v4 Privacy DeFi

*   **Descripción:** Build on Uniswap v4 to explore privacy-enhancing financial systems in decentralized markets. Projects may introduce mechanisms that improve how information is handled during onchain trading and liquidity provision, such as reducing unnecessary information exposure, improving execution quality, or designing market behavior that is more resilient to adverse selection and extractive dynamics. Submissions should emphasize responsible, transparent system design that preserves onchain verifiability and protocol integrity. The use of Hooks is optional and encouraged where it meaningfully supports the design.
*   **Requisitos de Calificación:**
    *   TxID transactions (testnet and/or mainnet)
    *   GitHub repository
    *   README.md
    *   Demo link or setup instructions
    *   Demo video (max 3 min)

## 🔗 Links y Recursos

*   Uniswap Builder Toolkit: [https://uniswaplabs.notion.site/hackmoney](https://uniswaplabs.notion.site/hackmoney) ↗
*   Uniswap Docs: [https://docs.uniswap.org/contracts/v4/overview](https://docs.uniswap.org/contracts/v4/overview) ↗
*   Uniswap v4 Template: [https://github.com/uniswapfoundation/v4-template](https://github.com/uniswapfoundation/v4-template) ↗
*   Uniswap v4 Course: [https://updraft.cyfrin.io/courses/uniswap-v4](https://updraft.cyfrin.io/courses/uniswap-v4) ↗
*   OpenZeppelin Hooks Library: [https://docs.openzeppelin.com/uniswap-hooks](https://docs.openzeppelin.com/uniswap-hooks) ↗