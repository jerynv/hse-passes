import e from "express";
import express from "express";
import { createServer } from "http";
import { studentLogin, TeacherLogin } from "./auth.js";
import { logIt } from "./data.js";
import { isObject } from "util";

// this file is practically perfect.

const app = express();
const server = createServer(app);
// const ip = "192.168.5.42";
const ip = "0.0.0.0";
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
        studentLogin(res, data);
    },
    TeacherLogin: (res, data) => {
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
    //we got to make sure the req.body is a valid json object
    if (typeof req.body !== "object") {
        logIt("Received invalid JSON object", "error");
        return res.status(400).json({ error: "Invalid JSON object" });
    }
    const { operation, data } = req.body;
    const handler = postHandlers[operation];
    logIt("Received HTTP request: " + JSON.stringify(req.body), "log");
    if (!handler) return res.status(400).json({ error: "Unknown action" });
    handler(res, data);
});

server.listen(PORT, ip, () => {
    console.log(`HTTP server is running on http://${ip}:${PORT}`);
});
server.on("error", (error) => {
    logIt("HTTP server error:" + error, "error");
});
server.on("close", () => {
    logIt("HTTP server is closing", "log");
});
server.on("clientError", (error, socket) => {
    console.error("Client error:", error);
    socket.end("HTTP/1.1 400 Bad Request\r\n\r\n");
});

export default server;
