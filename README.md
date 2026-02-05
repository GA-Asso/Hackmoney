# 💳 Cashback ID: The Invisible Rewards Protocol

**Hackathon:** ETH Global - HackMoney 2026  
**Tech Stack:** Uniswap v4 (Hooks), Sui Network (High-Speed Execution), ENS (Identity)  
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

### 3️⃣ Revenue Streams (Fuentes de Ingreso)
*   **Performance Fee:** Una pequeña comisión (ej. 5%) sobre el *rendimiento* generado por el cashback (no sobre el principal).
*   **SaaS Dashboard:** Analítica avanzada para comercios sobre hábitos de consumo (preservando la privacidad).
*   **B2B Interchange:** Un fee mínimo por procesamiento de transacciones más barato que Visa/Mastercard.

---

## 📋 MVP Scope: Cashback ID

### 🚀 El Flujo "Invisible" (UX)
1.  **Identity:** El usuario reclama su perfil con un click (usando Google/Apple vía Sui zkLogin). Se le asigna un subdominio `nombre.cashbackid.eth`.
2.  **Spend:** El usuario paga en un comercio físico o digital con su tarjeta (Apple Pay / Google Pay).
3.  **Execute:** Sui procesa la transacción en <1s. El contrato detecta el % de cashback pactado.
4.  **Yield:** El cashback se envía a un Hook de Uniswap v4 que lo deposita en un pool de liquidez, generando intereses desde el minuto 1.
5.  **Control:** El usuario ve su saldo crecer en una app simple, sin términos técnicos como "gas", "slippage" o "liquidity pools".

### ✅ Features del MVP (Must-Haves)
*   **Smart Hook (Uniswap v4):** Lógica que recibe el cashback y lo "enruta" al pool con mejor APR según el perfil del usuario.
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

| Protocolo  | Rol Crítico                                                                                                   | Track Target                    |
| :--------- | :------------------------------------------------------------------------------------------------------------ | :------------------------------ |
| Uniswap v4 | Hooks de Gestión: Automatizan el swap de la recompensa del comercio y su colocación en pools de yield.         | *Agentic Finance / Privacy DeFi*  |
| Sui        | Riel de Pago: Motor de alta frecuencia para el procesamiento de transacciones y zkLogin para onboarding sin fricción. | *Best Overall Sui Project*        |
| ENS        | Centro de Datos: Almacena preferencias de usuario, niveles de riesgo y sirve como el ID público de la tarjeta. | *Most Creative Use of ENS*      |

---

## 📈 Criterios de Éxito - Demo Day

1.  **Velocidad:** Mostrar una compra en Sui que se refleja en el Hook de Uniswap en menos de 2 segundos.
2.  **Simplicidad:** Un usuario nuevo "creando su cuenta" en menos de 10 segundos con su correo.
3.  **Impacto:** Un dashboard que proyecte cuánto dinero extra tendría el usuario en 5 años gracias al interés compuesto del cashback.
