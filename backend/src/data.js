let logging = true;
function logIt(message, type = "log") {
    if (logging) {
        const date = new Date();
        const formattedDate = date.toISOString().replace("T", " ").slice(0, 19);
        const logMessage = `[${formattedDate}] [${type.toUpperCase()}] ${message}`;
        console[type](logMessage);
    }
}

export { logIt }