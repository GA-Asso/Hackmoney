"use client";
import { useState } from "react";
import { JsonRpcProvider } from "ethers";
import { SuiClient, getFullnodeUrl } from "@mysten/sui.js/client";

export default function DemoPage() {
  const [ensName, setEnsName] = useState("vitalik.eth");
  const [resolved, setResolved] = useState<string>("");
  const [pkgId, setPkgId] = useState<string>("");
  const [events, setEvents] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  async function resolveEns() {
    setLoading(true);
    try {
      const provider = new JsonRpcProvider("https://rpc.sepolia.org");
      const addr = await provider.resolveName(ensName);
      setResolved(addr ?? "not found");
    } catch (e: any) {
      setResolved("error: " + e?.message);
    } finally {
      setLoading(false);
    }
  }

  async function fetchSuiEvents() {
    setLoading(true);
    try {
      const client = new SuiClient({ url: getFullnodeUrl("testnet") });
      const resp = await client.queryEvents({
        query: { Package: pkgId },
        limit: 20,
      });
      setEvents(resp.data ?? []);
    } catch (e: any) {
      setEvents([{ error: e?.message }]);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div style={{ padding: 24, fontFamily: "system-ui" }}>
      <h1>Hackmoney Demo: ENS + Sui Events</h1>

      <section style={{ marginTop: 16 }}>
        <h2>Resolver ENS (Sepolia)</h2>
        <input value={ensName} onChange={(e) => setEnsName(e.target.value)} placeholder="nombre ENS" />
        <button onClick={resolveEns} disabled={loading} style={{ marginLeft: 8 }}>Resolver</button>
        <div style={{ marginTop: 8 }}>Dirección: {resolved || "-"}</div>
      </section>

      <section style={{ marginTop: 24 }}>
        <h2>Eventos Sui (PaymentProcessed / CashbackReceived)</h2>
        <input value={pkgId} onChange={(e) => setPkgId(e.target.value)} placeholder="packageId" />
        <button onClick={fetchSuiEvents} disabled={loading} style={{ marginLeft: 8 }}>Consultar</button>
        <div style={{ marginTop: 8 }}>
          {events.length === 0 ? (
            <div>Sin eventos</div>
          ) : (
            <pre style={{ whiteSpace: "pre-wrap" }}>{JSON.stringify(events, null, 2)}</pre>
          )}
        </div>
      </section>
    </div>
  );
}
