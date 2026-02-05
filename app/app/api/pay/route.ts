import { NextResponse } from "next/server";
import { SuiClient } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import { fromB64 } from "@mysten/sui.js/utils";

export async function POST(req: Request) {
  try {
    const { packageId, profileId, amount, merchantAddress } = await req.json();
    const privateKey = process.env.SUI_PRIVATE_KEY;
    
    if (!privateKey) throw new Error("SUI_PRIVATE_KEY missing");
    
    let keypair;
    const bytes = fromB64(privateKey);
    if (bytes.length === 33 && bytes[0] === 0) {
         keypair = Ed25519Keypair.fromSecretKey(bytes.slice(1));
    } else {
         keypair = Ed25519Keypair.fromSecretKey(bytes);
    }

    const client = new SuiClient({ url: "https://fullnode.testnet.sui.io:443" });
    
    const tx = new TransactionBlock();
    tx.setGasBudget(100000000);

    const [coin] = tx.splitCoins(tx.gas, [tx.pure.u64(amount)]);
    
    tx.moveCall({
      target: `${packageId}::checkout::process_payment`,
      arguments: [
        tx.object(profileId),
        coin,
        tx.pure.address(merchantAddress || keypair.toSuiAddress())
      ],
    });

    const result = await client.signAndExecuteTransactionBlock({
      signer: keypair,
      transactionBlock: tx,
      options: {
        showEffects: true,
        showEvents: true,
      },
    });

    return NextResponse.json({ 
        digest: result.digest,
        events: result.events 
    });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : String(error);
    console.error("Error processing payment:", message);
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
