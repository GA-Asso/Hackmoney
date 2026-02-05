import { NextResponse } from "next/server";
import { getFullnodeUrl, SuiClient } from "@mysten/sui/client";
import { Ed25519Keypair } from "@mysten/sui/keypairs/ed25519";
import { Transaction } from "@mysten/sui/transactions";
import { fromBase64 } from "@mysten/sui/utils";

export async function POST(req: Request) {
  try {
    const { packageId, profileId, amount, merchantAddress } = await req.json();
    const privateKey = process.env.SUI_PRIVATE_KEY;
    
    if (!privateKey) throw new Error("SUI_PRIVATE_KEY missing");
    
    let keypair;
    const bytes = fromBase64(privateKey);
    if (bytes.length === 33 && bytes[0] === 0) {
         keypair = Ed25519Keypair.fromSecretKey(bytes.slice(1));
    } else {
         keypair = Ed25519Keypair.fromSecretKey(bytes);
    }

    const client = new SuiClient({ url: getFullnodeUrl("testnet") });
    
    const tx = new Transaction();
    tx.setGasBudget(100000000);

    const [coin] = tx.splitCoins(tx.gas, [tx.pure.u64(amount)]);
    
    tx.moveCall({
      target: \`\${packageId}::checkout::process_payment\`,
      arguments: [
        tx.object(profileId),
        coin,
        tx.pure.address(merchantAddress || keypair.toSuiAddress())
      ],
    });

    const result = await client.signAndExecuteTransaction({
      signer: keypair,
      transaction: tx,
      options: {
        showEffects: true,
        showEvents: true,
      },
    });

    return NextResponse.json({ 
        digest: result.digest,
        events: result.events 
    });
  } catch (error: any) {
    console.error("Error processing payment:", error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
