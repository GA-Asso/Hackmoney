import { NextResponse } from "next/server";
import { SuiClient } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import { fromB64 } from "@mysten/sui.js/utils";

export async function POST(req: Request) {
  try {
    const { packageId, name } = await req.json();
    const privateKey = process.env.SUI_PRIVATE_KEY;
    
    if (!privateKey) throw new Error("SUI_PRIVATE_KEY missing");
    
    let keypair;
    try {
        const bytes = fromB64(privateKey);
        if (bytes.length === 33 && bytes[0] === 0) {
             keypair = Ed25519Keypair.fromSecretKey(bytes.slice(1));
        } else {
             keypair = Ed25519Keypair.fromSecretKey(bytes);
        }
    } catch (e) {
        console.error("Key error", e);
        throw new Error("Invalid Private Key format");
    }

    const client = new SuiClient({ url: "https://fullnode.testnet.sui.io:443" });
    
    const tx = new TransactionBlock();
    tx.setGasBudget(100000000); 

    tx.moveCall({
      target: `${packageId}::profile::create_and_transfer_to_sender`,
      arguments: [],
    });

    const result = await client.signAndExecuteTransactionBlock({
      signer: keypair,
      transactionBlock: tx,
      options: {
        showEffects: true,
        showObjectChanges: true,
      },
    });

    console.log("TX Result:", JSON.stringify(result, null, 2));
    
    const created = result.objectChanges?.find(
      (change) => change.type === "created" && change.objectType.includes("::profile::CashbackProfile")
    );

    if (!created || !("objectId" in created)) {
       throw new Error("Profile object not found in transaction result");
    }

    return NextResponse.json({ 
        digest: result.digest,
        profileId: created.objectId 
    });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : String(error);
    console.error("Error creating profile:", message);
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
