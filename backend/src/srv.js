import * as fs from "fs";
import wss from "./wss.js";
import server from "./http.js";

server;
wss;


//on console close / stop clear the passes file to {}
process.on("SIGINT", () => {
    console.log("\nServer is shutting down...");
    fs.writeFileSync("./db/passes.json", JSON.stringify({}));
    process.exit();
});