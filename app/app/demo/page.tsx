"use client";
import { useState, useEffect } from "react";
import { JsonRpcProvider } from "ethers";
import { SuiClient } from "@mysten/sui.js/client";
import dynamic from 'next/dynamic';
import type { WidgetConfig } from '@lifi/widget';
type ParsedJson = { [key: string]: unknown };
interface SuiEvent { type: string; timestampMs: string; parsedJson?: ParsedJson }

const LiFiWidget = dynamic(
  () => import('@lifi/widget').then((module) => module.LiFiWidget),
  { ssr: false }
);

const widgetConfig: WidgetConfig = {
  integrator: 'openclaw-demo',
  containerStyle: {
    border: '1px solid rgb(234, 234, 234)',
    borderRadius: '16px',
    maxWidth: '100%',
  },
  variant: 'compact',
  subvariant: 'default',
  appearance: 'light',
  theme: {
    palette: {
      primary: { main: '#3b82f6' },
    },
  },
};

export default function DemoPage() {
  const [ensName, setEnsName] = useState("usuario.cashbackid.eth");
  const [resolved, setResolved] = useState<string>("");
  const [pkgId, setPkgId] = useState<string>("0xbdabfb7fb7822e83b2d8ba86d211347812bb3a6d454f64828ea3c17453f4e9aa");
  
  // User Profile State
  const [userName, setUserName] = useState("Gerry");
  const [profileId, setProfileId] = useState<string>("");
  const [userLoading, setUserLoading] = useState(false);
  
  // Merchant POS State
  const [amount, setAmount] = useState<string>("100000000"); // 0.1 SUI
  const [posLoading, setPosLoading] = useState(false);
  const [lastTx, setLastTx] = useState<string>("");

  const [events, setEvents] = useState<SuiEvent[]>([]);
  const [loading, setLoading] = useState(false);

  // Stats
  const [totalCashback, setTotalCashback] = useState(0);

  // ENS Resolver (Mock or Real)
  async function resolveEns() {
    setLoading(true);
    try {
      if (ensName.endsWith(".cashbackid.eth")) {
         setResolved("0x" + "1".repeat(64)); 
      } else {
         const provider = new JsonRpcProvider("https://rpc.sepolia.org");
         const resolver = await provider.getResolver(ensName);
         if (resolver) {
             const ethAddr = await resolver.getAddress();
             setResolved(ethAddr ? `ETH: ${ethAddr.slice(0,6)}... (Sui Link Simulation)` : "No encontrado");
         } else {
             setResolved("No resolver found");
         }
      }
    } catch (e: unknown) {
      const message = e instanceof Error ? e.message : String(e);
      setResolved("error: " + message);
    } finally {
      setLoading(false);
    }
  }

  async function createProfile() {
    setUserLoading(true);
    try {
      const res = await fetch("/api/create-profile", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ packageId: pkgId, name: userName })
      });
      const data = await res.json();
      if (data.profileId) {
        setProfileId(data.profileId);
        alert("Perfil creado: " + data.profileId);
      } else {
        alert("Error: " + JSON.stringify(data));
      }
    } catch (e: any) {
      alert("Error: " + e.message);
    } finally {
      setUserLoading(false);
    }
  }

  async function processPayment() {
    if (!profileId) return alert("Primero crea un perfil de usuario");
    setPosLoading(true);
    try {
      const res = await fetch("/api/pay", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ 
            packageId: pkgId, 
            profileId: profileId,
            amount: parseInt(amount),
            merchantAddress: "0xc494eba1ce7f138bfa3a2ccc79fcfe9055b8b004e4690569d2d5a3c30850c79b" 
        })
      });
      const data = await res.json();
      if (data.digest) {
        setLastTx(data.digest);
        fetchSuiEvents(); 
      } else {
        alert("Error pago: " + JSON.stringify(data));
      }
    } catch (e: unknown) {
      const message = e instanceof Error ? e.message : String(e);
      alert("Error pago: " + message);
    } finally {
      setPosLoading(false);
    }
  }

  async function fetchSuiEvents() {
    setLoading(true);
    try {
      const client = new SuiClient({ url: "https://fullnode.testnet.sui.io:443" });
      const resp = await client.queryEvents({
        query: { MoveModule: { package: pkgId, module: "checkout" } },
        limit: 20,
        order: "descending"
      });
      
      setEvents((resp.data ?? []) as SuiEvent[]);
      
      // Calculate total cashback
      let total = 0;
      (resp.data ?? []).forEach((evt) => {
        const e = evt as unknown as SuiEvent;
        if (e.type.includes("PaymentProcessed")) {
          if (e.parsedJson && "cashback" in e.parsedJson) {
            const v = (e.parsedJson as ParsedJson).cashback as string | number | undefined;
            const s = typeof v === "number" ? v.toString() : (v ?? "0") as string;
            total += parseInt(s);
          }
        }
      });
      setTotalCashback(total);

    } catch (e: unknown) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
      fetchSuiEvents();
      const interval = setInterval(fetchSuiEvents, 10000);
      return () => clearInterval(interval);
  }, [pkgId]);

  return (
    <div style={{ padding: 24, fontFamily: "system-ui", backgroundColor: "#ffffff", color: "#000000", minHeight: "100vh", maxWidth: "800px", margin: "0 auto" }}>
      <h1 style={{borderBottom: "2px solid #eee", paddingBottom: 16}}>Cashback ID Demo</h1>

      <section style={{ marginTop: 24, padding: 16, border: "1px solid #e5e7eb", borderRadius: 8 }}>
        <h2 style={{marginTop: 0}}>1. Identidad & Onboarding (Cross-Chain)</h2>
        <p style={{fontSize: 14, color: "#666"}}>Usa tu nombre ENS de Ethereum para encontrar tu cuenta en Sui.</p>
        <div style={{display: "flex", gap: 8, alignItems: "center", marginBottom: 16}}>
            <input 
                style={{ border: "1px solid #ccc", padding: 8, borderRadius: 4, flex: 1, color: "#000000" }} 
                value={ensName} 
                onChange={(e) => setEnsName(e.target.value)} 
                placeholder="vitalik.eth" 
            />
            <button 
                onClick={resolveEns} 
                disabled={loading}
                style={{ padding: "8px 16px", backgroundColor: "#000", color: "#fff", borderRadius: 4, border: "none", cursor: "pointer" }}
            >
                Resolver ENS
            </button>
        </div>
        {resolved && <div style={{marginBottom: 16, fontSize: 12, color: "#059669", padding: 8, backgroundColor: "#d1fae5", borderRadius: 4}}>Resultado: {resolved}</div>}

        <div style={{display: "flex", gap: 8, alignItems: "center"}}>
            <input 
                style={{ border: "1px solid #ccc", padding: 8, borderRadius: 4, flex: 1, color: "#000000" }} 
                value={userName} 
                onChange={(e) => setUserName(e.target.value)} 
                placeholder="Nombre para Perfil Sui" 
            />
            <button 
                onClick={createProfile} 
                disabled={userLoading || !!profileId}
                style={{ padding: "8px 16px", backgroundColor: profileId ? "#10b981" : "#4b5563", color: "#fff", borderRadius: 4, border: "none", cursor: "pointer" }}
            >
                {profileId ? "Perfil Activo" : "Crear Perfil en Sui"}
            </button>
        </div>
        
        {/* Uniswap Integration Widget Placeholder - REPLACED WITH LI.FI */}
        <div style={{marginTop: 16, padding: 12, border: "1px solid #e5e7eb", borderRadius: 8, backgroundColor: "#ffffff"}}>
            <div style={{fontSize: 14, fontWeight: "bold", color: "#111827", marginBottom: 8}}>
                Deposit to Sui (Powered by LI.FI)
            </div>
            <p style={{fontSize: 12, color: "#666", marginBottom: 12}}>
                Transfiere fondos desde ETH, Polygon, Arbitrum, Solana, etc. directamente a tu cuenta Sui.
            </p>
            <div style={{ height: 440, overflow: "hidden" }}>
                 <LiFiWidget integrator="openclaw-demo" config={widgetConfig} />
            </div>
        </div>

        {profileId && <div style={{marginTop: 8, fontSize: 12, color: "#666"}}>Profile ID: {profileId}</div>}
      </section>

      <section style={{ marginTop: 24, padding: 16, border: "1px solid #e5e7eb", borderRadius: 8, backgroundColor: "#f9fafb" }}>
        <h2 style={{marginTop: 0}}>2. Comercio (POS)</h2>
        <p style={{fontSize: 14, color: "#666"}}>Simula una compra para generar cashback.</p>
        <div style={{display: "flex", gap: 8, alignItems: "center", marginTop: 12}}>
            <input 
                type="number"
                style={{ border: "1px solid #ccc", padding: 8, borderRadius: 4, flex: 1, color: "#000000" }} 
                value={amount} 
                onChange={(e) => setAmount(e.target.value)} 
                placeholder="Monto (MIST)" 
            />
            <button 
                onClick={processPayment} 
                disabled={posLoading || !profileId}
                style={{ padding: "8px 16px", backgroundColor: "#2563eb", color: "#fff", borderRadius: 4, border: "none", cursor: "pointer" }}
            >
                {posLoading ? "Procesando..." : "Cobrar y Dar Cashback"}
            </button>
        </div>
        {lastTx && (
            <div style={{marginTop: 8, fontSize: 12}}>
                Última Tx: <a href={`https://suiscan.xyz/testnet/tx/${lastTx}`} target="_blank" style={{color: "#2563eb"}}>Ver en Explorer</a>
            </div>
        )}
      </section>

      <section style={{ marginTop: 24 }}>
        <h2>3. Tu Billetera (Dashboard)</h2>
        <div style={{display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16}}>
            <div style={{padding: 16, backgroundColor: "#ecfdf5", borderRadius: 8, border: "1px solid #a7f3d0"}}>
                <div style={{fontSize: 14, color: "#065f46"}}>Cashback Acumulado</div>
                <div style={{fontSize: 24, fontWeight: "bold", color: "#047857"}}>{(totalCashback / 1000000000).toFixed(4)} SUI</div>
            </div>
            <div style={{padding: 16, backgroundColor: "#eff6ff", borderRadius: 8, border: "1px solid #bfdbfe"}}>
                <div style={{fontSize: 14, color: "#1e40af"}}>Crecimiento (Simulado)</div>
                <div style={{fontSize: 24, fontWeight: "bold", color: "#1d4ed8"}}>+4.2%</div>
            </div>
        </div>
      </section>

      <section style={{ marginTop: 24 }}>
        <h3>Historial de Eventos (Blockchain)</h3>
        <button onClick={fetchSuiEvents} disabled={loading} style={{ padding: "4px 8px", fontSize: 12 }}>Refrescar</button>
        <div style={{ marginTop: 8, maxHeight: 300, overflow: "auto", border: "1px solid #eee", padding: 8 }}>
          {events.length === 0 ? (
            <div>Sin eventos</div>
          ) : (
             events.map((evt, i) => (
                 <div key={i} style={{marginBottom: 8, paddingBottom: 8, borderBottom: "1px solid #eee", fontSize: 12}}>
                     <div><strong>{evt.type.split("::").pop()}</strong></div>
                     <div>Time: {new Date(parseInt(evt.timestampMs)).toLocaleTimeString()}</div>
                     <pre style={{margin: 0, color: "#666"}}>{JSON.stringify(evt.parsedJson, null, 2)}</pre>
                 </div>
             ))
          )}
        </div>
      </section>
      
      <div style={{marginTop: 40, fontSize: 10, color: "#ccc"}}>
        Package ID: {pkgId}
      </div>
    </div>
  );
}
