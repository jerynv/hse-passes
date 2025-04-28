import { WebSocketServer } from "ws";
import { v4 } from "uuid";
import sleep from "sleep-promise";

const wss = new WebSocketServer({ port: 8080, host: "192.168.5.42" });
const clients = new Map();

wss.on("connection", (ws) => {
    const clientConnectionTime = new Date();

    console.log(`Client connected at ${clientConnectionTime}`);

    ws.on("error", (error) => {
        console.error(`WebSocket error for client ${ws.userId}:`, error);
    });

    ws.on("message", async (message) => {
        let FormattedMessage = {};
        try {
            FormattedMessage = JSON.parse(message);
        } catch (e) {
            ws.send("Error parsing message");
            return;
        }
        console.log(`Received message: ${message}`);
        switch (FormattedMessage.Operation) {
            case "setUser":
                if (clients.has(FormattedMessage.Data.id)) {
                    console.warn(
                        `User ID already exists, replacing connection`
                    );
                    let existingClient = clients.get(FormattedMessage.Data.id);
                    existingClient.close();
                    clients.delete(FormattedMessage.Data.id);
                    console.log(
                        `Closed existing connection for user ID: ${FormattedMessage.Data.id}`
                    );
                }
                let userId = FormattedMessage.Data.id;
                if (!FormattedMessage.Data || !userId) {
                    console.log(`Error: Missing user ID for client`);
                    ws.send("Error: Missing user ID");
                    return;
                }
                console.log(`Setting user ID for client: ${userId}`);
                clients.set(userId, ws);
                ws.userId = userId;
                ws.send(
                    JSON.stringify({
                        Operation: "verifyIntegrity",
                        Data: { success: true },
                    })
                );
                break;
            case "SendPassRequest":
                console.log(
                    `Received pass request from client ${ws.userId}`
                );
                
                break;
        }
    });

    ws.on("close", () => {
        //get the client id
    });
});

wss.on("error", (error) => {
    console.error("WebSocket error:", error);
});

console.log(
    "WebSocket server is running on ws://" +
        wss.options.host +
        ":" +
        wss.options.port
);

//wait 30 seconds then send a pin message to client 251378
// setTimeout(() => {
//     const userId = "251378";
//     const ws = clients.get(userId);
//     if (ws) {
//         ws.send(
//             JSON.stringify({
//                 Operation: "Pin",
//                 Data: {
//                     id: userId,
//                     pin: 1234,
//                 },
//             })
//         );
//     } else {
//         console.log(`Client ${userId} not connected`);
//     }
// }, 30000);

export default {wss, clients};
