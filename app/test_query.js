
const { SuiClient } = require("@mysten/sui.js/client");

async function main() {
    const client = new SuiClient({ url: "https://fullnode.testnet.sui.io:443" });
    const pkgId = "0xbdabfb7fb7822e83b2d8ba86d211347812bb3a6d454f64828ea3c17453f4e9aa";
    try {
        console.log("Querying events...");
        const resp = await client.queryEvents({
            query: { MoveEvent: `${pkgId}::checkout::PaymentProcessed` },
            limit: 20,
            order: "descending"
        });
        console.log("Success:", resp.data);
    } catch (e) {
        console.error("Error:", e);
    }
}

main();
