import fs from "fs";
let logging = true;

function logIt(message, type = "log") {
    const date = new Date();
    const formattedDate = date.toISOString().replace("T", " ").slice(0, 19);
    const logMessage = `[${formattedDate}] [${type.toUpperCase()}] ${message}`;
    const logFilePath = "./logs/server.log";
    //we dont really want to open the entire file every time we log something so we will just append to the file
    fs.appendFileSync(logFilePath, logMessage + "\n", (err) => {});
    if (logging) {
        console[type](logMessage);
    }
}

export { logIt };
