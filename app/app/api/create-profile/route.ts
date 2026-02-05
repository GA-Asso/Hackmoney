import { NextResponse } from "next/server";
import { getFullnodeUrl, SuiClient } from "@mysten/sui/client";
import { Ed25519Keypair } from "@mysten/sui/keypairs/ed25519";
import { Transaction } from "@mysten/sui/transactions";
import { fromBase64 } from "@mysten/sui/utils";

export async function POST(req: Request) {
  try {
    const { packageId, name } = await req.json();
    const privateKey = process.env.SUI_PRIVATE_KEY;
    
    if (!privateKey) throw new Error("SUI_PRIVATE_KEY missing");
    
    let keypair;
    try {
        // Strip the first byte if it is the flag byte for Ed25519 (0x00)
        // Sui keystore format is base64(flag + secret_key)
        const bytes = fromBase64(privateKey);
        if (bytes.length === 33 && bytes[0] === 0) {
             keypair = Ed25519Keypair.fromSecretKey(bytes.slice(1));
        } else {
             keypair = Ed25519Keypair.fromSecretKey(bytes);
        }
    } catch (e) {
        console.error("Key error", e);
        throw new Error("Invalid Private Key format");
    }

    const client = new SuiClient({ url: getFullnodeUrl("testnet") });
    
    const tx = new Transaction();
    tx.setGasBudget(100000000); 

    tx.moveCall({
      target: \`\${packageId}::profile::create_and_transfer_to_sender\`,
      arguments: [
        tx.pure.string(name),
        tx.pure.string("Neutro")
      ],
    });

    const result = await client.signAndExecuteTransaction({
      signer: keypair,
      transaction: tx,
      options: {
        showEffects: true,
        showObjectChanges: true,
      },
    });

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
  } catch (error: any) {
    console.error("Error creating profile:", error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
