use client;
import { useState } from react;
import { JsonRpcProvider } from ethers;

export default function DemoPage() {
  const [ensName, setEnsName] = useState(vitalik.eth);
  const [resolved, setResolved] = useState<string>();
  const [pkgId, setPkgId] = useState<string>();
  const [events, setEvents] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  async function resolveEns() {
    setLoading(true);
    try {
      const provider = new JsonRpcProvider(https://rpc.sepolia.org);
      const addr = await provider.resolveName(ensName);
      setResolved(addr ?? not found);
    } catch (e: any) {
      setResolved(error:  + e?.message);
    } finally {
      setLoading(false);
    }
  }

  async function fetchSuiEvents() {
    setLoading(true);
    try {
      const resp = await fetch(https://fullnode.testnet.sui.io, {
        method: POST,
        headers: { content-type: application/json },
        body: JSON.stringify({
          jsonrpc: 2.0, id: 1, method: suix_queryEvents,
          params: [{ Package: pkgId }, null, 20, true],
        }),
      }).then((r) => r.json());
      setEvents(resp.result?.data ?? []);
    } catch (e: any) {
      setEvents([{ error: e?.message }]);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div style={{ padding: 24, fontFamily: system-ui }}>
      <h1>Hackmoney Demo: ENS + Sui Events</h1>

      <section style={{ marginTop: 16 }}>
        <h2>Resolver ENS (Sepolia)</h2>
        <input value={ensName} onChange={(e) => setEnsName(e.target.value)} placeholder=nombre ENS />
        <button onClick={resolveEns} disabled={loading} style={{ marginLeft: 8 }}>Resolver</button>
        <div style={{ marginTop: 8 }}>Dirección: {resolved || -}</div>
      </section>

      <section style={{ marginTop: 24 }}>
        <h2>Eventos Sui (PaymentProcessed / CashbackReceived)</h2>
        <input value={pkgId} onChange={(e) => setPkgId(e.target.value)} placeholder=packageId />
        <button onClick={fetchSuiEvents} disabled={loading} style={{ marginLeft: 8 }}>Consultar</button>
        <div style={{ marginTop: 8 }}>
          {events.length === 0 ? (
            <div>Sin eventos</div>
          ) : (
            <pre style={{ whiteSpace: pre-wrap }}>{JSON.stringify(events, null, 2)}</pre>
          )}
        </div>
      </section>
    </div>
  );
}
