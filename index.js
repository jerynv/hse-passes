// want to create a neet copyable output of folder contents that lists the files and folders in a folder etc recursiveley every single file and folder inside of a folder

const fs = require('fs');
const path = require('path');

const folderPath = path.join(__dirname, 'app/src/hse_apps/lib');


function listFiles(folderPath) {
    const files = fs.readdirSync(folderPath);
    files.forEach(file => {
        const filePath = path.join(folderPath, file);
        const stats = fs.statSync(filePath);
        if (stats.isDirectory()) {
            console.log(`\n${filePath}`);
            listFiles(filePath);
        } else {
            console.log(filePath);
        }
    });
}

listFiles(folderPath);