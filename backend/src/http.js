import e from "express";
import express from "express";
import { createServer } from "http";
import { studentLogin, TeacherLogin } from "./auth.js";

const app = express();
const server = createServer(app);
const ip = "192.168.5.42";
const PORT = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use((req, res, next) => {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Methods", "POST");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type");
    next();
});

const postHandlers = {
    StudentLogin: (res, data) => {
        // your logic here
        studentLogin(res, data);
    },
    TeacherLogin: (res, data) => {  
        // your logic here
        TeacherLogin(res, data);
    },
    Ping: (req, res) => {
        res.json({
            success: true,
            message: "Pong",
            time: new Date().toISOString(),
        });
    },
};

app.post("/api", (req, res) => {
    const { Operation, Data } = req.body;
    const handler = postHandlers[Operation];
    console.log("Received HTTP request:", req.body);
    if (!handler) return res.status(400).json({ error: "Unknown action" });
    handler(res, Data);
});

server.listen(PORT, ip, () => {
    console.log(`HTTP server is running on http://${ip}:${PORT}`);
});
server.on("error", (error) => {
    console.error("HTTP server error:", error);
});
server.on("close", () => {
    console.log("HTTP server is closing");
});
server.on("clientError", (error, socket) => {
    console.error("Client error:", error);
    socket.end("HTTP/1.1 400 Bad Request\r\n\r\n");
});

export default server;
