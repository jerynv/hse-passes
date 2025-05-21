import * as fs from "fs";
import wss from "./wss.js";
import server from "./http.js";
import { logIt } from "./data.js";
import { log } from "console";


logIt("Starting server...", "info");

server;
wss;

//on console close / stop clear the passes file to {}
process.on("SIGINT", () => {
    logIt("Sever shutting down...", "info");
    fs.writeFileSync("./db/passes.json", JSON.stringify({}));
    process.exit();
});