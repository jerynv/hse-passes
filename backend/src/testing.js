import { WebSocketServer } from "ws";
import { v4 } from "uuid";
import sleep from "sleep-promise";
import * as logic from "./logic.js";
// import { passType } from "./schema.js";
import { getStudentInfo, getTeacherInfo, getUserInfo } from "./auth.js";

const wss = new WebSocketServer({
    port: 8080,
    //host: "192.168.5.42",
    host: "0.0.0.0",
});

const clients = new Map();

const websocketLogic = {
    setUser: logic.setUser,
};

wss.on("connection", (ws) => {
    const clientConnectionTime = new Date();

    console.log(`Client connected at ${clientConnectionTime}`);

    ws.on("error", (error) => {
        //i would want to close the connection as well if the error does not do so as well
        if (!clients.has(ws.userId)) {
            ws.close();
            console.log(
                `Client ${ws.userId} disconnected due to error: ${error.message}`
            );
            return;
        }

        console.error(
            `Due to error: closing connection for client ${ws.userId}`
        );

        clients.get(ws.userId).close();
        clients.delete(ws.userId);
    });

    ws.on("message", async (message) => {
        let formattedMessage = {};

        try {
            formattedMessage = JSON.parse(message);
        } catch (e) {
            ws.send("Error parsing message");
            return;
        }

        console.log(`Received message: ${message}`);

        try {
            websocketLogic[formattedMessage.operation](
                ws,
                clients,
                formattedMessage.data
            );
        } catch (e) {
            console.log(`Unknown operation: ${formattedMessage.operation}`);
            ws.send(
                JSON.stringify({
                    operation: "ShowError",
                    data: {
                        success: false,
                        title: "Error",
                        message: `Unknown operation: ${formattedMessage.operation}`,
                    },
                })
            );
        }
        return

        switch (FormattedMessage.Operation) {
            case "setUser":
                logic.setUser(ws, wss, FormattedMessage.Data);
                break;
            case "SendPassRequest":
                console.log(`Received pass request from client ${ws.userId}`);
                await savePassRequest(FormattedMessage.Data)
                    .then((result) => {
                        if (result.success) {
                            ws.send(
                                JSON.stringify({
                                    Operation: "PassRequestResponse",
                                    Data: { success: true, pass: result.pass },
                                })
                            );
                            clients.get(result.pass.ReceiverId)?.send(
                                JSON.stringify({
                                    Operation: "PassRequest",
                                    Data: {
                                        success: true,
                                        pass: result.pass,
                                        sender: getStudentInfo(
                                            result.pass.SenderId
                                        ),
                                    },
                                })
                            );
                        } else {
                            ws.send(
                                JSON.stringify({
                                    Operation: "ShowError",
                                    Data: {
                                        success: false,
                                        title: "Error",
                                        message: result.message,
                                    },
                                })
                            );
                        }
                    })
                    .catch((error) => {
                        console.error("Error saving pass request:", error);
                        ws.send(
                            JSON.stringify({
                                Operation: "PassRequestResponse",
                                Data: { success: false },
                            })
                        );
                    });
                break;
            case "TeacherPersonRequest":
                await savePassRequestPerson(FormattedMessage.Data)
                    .then((result) => {
                        if (result.success) {
                            ws.send(
                                JSON.stringify({
                                    Operation: "PassRequestResponse",
                                    Data: { success: true, pass: result.pass },
                                })
                            );
                            clients.get(result.pass.ReceiverId)?.send(
                                JSON.stringify({
                                    Operation: "PassRequest",
                                    Data: {
                                        success: true,
                                        pass: result.pass,
                                        sender: getTeacherInfo(
                                            result.pass.SenderId
                                        ),
                                    },
                                })
                            );
                        } else {
                            ws.send(
                                JSON.stringify({
                                    Operation: "ShowError",
                                    Data: {
                                        success: false,
                                        title: "Error",
                                        message: result.message,
                                    },
                                })
                            );
                        }
                    })
                    .catch((error) => {
                        console.error("Error saving pass request:", error);
                        ws.send(
                            JSON.stringify({
                                Operation: "PassRequestResponse",
                                Data: { success: false },
                            })
                        );
                    });

                break;
            case "StudentPersonRequest":
                await savePassRequestPerson(FormattedMessage.Data)
                    .then((result) => {
                        if (result.success) {
                            ws.send(
                                JSON.stringify({
                                    Operation: "PassRequestResponse",
                                    Data: { success: true, pass: result.pass },
                                })
                            );
                            clients.get(result.pass.ReceiverId)?.send(
                                JSON.stringify({
                                    Operation: "PassRequest",
                                    Data: {
                                        success: true,
                                        pass: result.pass,
                                        sender: getStudentInfo(
                                            result.pass.SenderId
                                        ),
                                    },
                                })
                            );
                        } else {
                            ws.send(
                                JSON.stringify({
                                    Operation: "ShowError",
                                    Data: {
                                        success: false,
                                        title: "Error",
                                        message: result.message,
                                    },
                                })
                            );
                        }
                    })
                    .catch((error) => {
                        console.error("Error saving pass request:", error);
                        ws.send(
                            JSON.stringify({
                                Operation: "PassRequestResponse",
                                Data: { success: false },
                            })
                        );
                    });
                break;
            case "AcceptPassRequest":
                console.log(`Accepting pass request from client ${ws.userId}`);
                await AcceptPassRequest(FormattedMessage.Data)
                    .then((result) => {
                        if (result.success) {
                            ws.send(
                                JSON.stringify({
                                    Operation: "PassAcceptResponse",
                                    Data: {
                                        success: true,
                                        pass: result.pass,
                                    },
                                })
                            );
                            for (let i = 0; i < result.notify.length; i++) {
                                console.log(
                                    `Notifying client ${result.notify[i]}`
                                );
                                if (clients.get(result.notify[i])) {
                                    console.log(
                                        `Client ${result.notify[i]} is connected`
                                    );
                                }
                                clients.get(result.notify[i])?.send(
                                    JSON.stringify({
                                        Operation: "PassUpdate",
                                        Data: {
                                            success: true,
                                            pass: result.pass,
                                        },
                                    })
                                );
                            }
                        } else {
                            ws.send(
                                JSON.stringify({
                                    Operation: "ShowError",
                                    Data: {
                                        success: false,
                                        title: "Error",
                                        message: result.message,
                                    },
                                })
                            );
                        }
                    })
                    .catch((error) => {
                        console.error("Error accepting pass request:", error);
                        ws.send(
                            JSON.stringify({
                                Operation: "PassRequestResponse",
                                Data: { success: false },
                            })
                        );
                    });
                break;
            default:
                console.log(`Unknown operation: ${FormattedMessage.Operation}`);
                ws.send(
                    JSON.stringify({
                        Operation: "ShowError",
                        Data: {
                            success: false,
                            title: "Error",
                            message: `Unknown operation: ${FormattedMessage.Operation}`,
                        },
                    })
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

export default { wss, clients };
