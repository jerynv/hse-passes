import * as fs from "fs";
import { join } from "path";
import { v4 } from "uuid";
import * as argon2 from "argon2";

const __dirname = new URL(".", import.meta.url).pathname;

export async function studentLogin(res, data) {
    const { id, password } = data;

    if (!id || !password) {
        return res
            .status(400)
            .json({ error: "Missing username or password SL-E000" });
    }

    const filePath = join(__dirname, "db/users.json");

    let users = [];

    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        users = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading users file:", error);
        return res.status(401).json({ error: "Internal server error SL-E000" });
    }

    let user = users[id];

    if (!user) {
        return res.status(401).json({ error: "Invalid credentials SL-E001" });
    }

    const isPasswordValid = await argon2.verify(user["Password"], password);

    if (!isPasswordValid) {
        return res.status(401).json({ error: "Invalid credentials SL-E002" });
    }

    if (!user) {
        return res.status(401).json({ error: "Invalid credentials SL-E003" });
    }

    const token = v4();
    user = {
        ClassInfo: await GetClassInfo(user["Classes"]),
        ...user,
    };
    //console.log(user);
    const { Password, ...userWithoutPassword } = user;

    return res.json({ token, user: userWithoutPassword });
}

export async function TeacherLogin(res, data) {
    const { id, password } = data;

    if (!id || !password) {
        return res
            .status(400)
            .json({ error: "Missing username or password SL-E000" });
    }

    const filePath = join(__dirname, "db/teachers.json");

    let users = [];

    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        users = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading users file:", error);
        return res.status(401).json({ error: "Internal server error SL-E000" });
    }

    let user = users[id];

    if (!user) {
        return res.status(401).json({ error: "Invalid credentials SL-E001" });
    }

    const isPasswordValid = await argon2.verify(user["Password"], password);

    if (!isPasswordValid) {
        return res.status(401).json({ error: "Invalid credentials SL-E002" });
    }

    if (!user) {
        return res.status(401).json({ error: "Invalid credentials SL-E003" });
    }

    const token = v4();
    user = {
        ClassInfo: await GetClassInfo(user["Classes"]),
        ...user,
    };
    //console.log(user);
    const { Password, ...userWithoutPassword } = user;
    console.log(userWithoutPassword);
    return res.json({ token, user: userWithoutPassword });
}

export async function studentRegister(res, data) {
    const { id, password, first_name, last_name } = data;
    const filePath = join(__dirname, "db/users.json");
    let users = [];

    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        users = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading users file:", error);
        return res.status(500).json({ error: "Internal server error SR-E000" });
    }

    if (users.id) {
        return res.status(400).json({ error: "User already exists SR-E001" });
    }

    const hashedPassword = await argon2.hash(password);
    const newUser = {
        Password: hashedPassword,
        first_name,
        last_name,
        HasPickedClasses: false,
    };

    users.push(newUser);
    try {
        await fs.promises.writeFile(filePath, JSON.stringify(users, null, 2));
    } catch (error) {
        console.error("Error writing users file:", error);
        return res.status(500).json({ error: "Internal server error SR-E002" });
    }

    return res.status(201).json({ message: "User registered successfully" });
}

async function GetClassInfo(classes) {
    const filePath = join(__dirname, "db/classes.json");
    let classInfo;

    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        classInfo = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading classes file:", error);
        return [];
    }

    //the classes is set up as a dictionary indexed 1-9 as classs periods they have values set as the uuid of certain classes i want to return the class info for all 1-9 as a dictionary of 1-9 as the key and the class info as the value
    const classInfoDict = {};
    for (let i = 0; i <= 9; i++) {
        //hardcoded to 9 for now dont expect more than 9 classes 8 is pathways a 9 is pathways b
        let key = Object.keys(classes);
        let classId = classes[key[i]];
        // console.log(classId);
        if (classId) {
            const classData = classInfo[classId];
            if (classData) {
                classInfoDict[i + 1] = classData;
            } else {
                classInfoDict[i + 1] = null; // or handle the case where the class ID is not found
            }
        } else {
            classInfoDict[i + 1] = null; // or handle the case where the class ID is not provided
        }
    }
    return classInfoDict;
}

export function getStudentInfo(id) {
    const filePath = join(__dirname, "db/users.json");
    let users = [];

    try {
        const fileData = fs.readFileSync(filePath, "utf-8");
        users = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading users file:", error);
        return null;
    }

    let user = users[id];

    if (!user) {
        return null;
    }

    const { Password, ...userWithoutPassword } = user;

    return userWithoutPassword;
}

export function getTeacherInfo(id) {
    const filePath = join(__dirname, "db/teachers.json");
    let users = [];

    try {
        const fileData = fs.readFileSync(filePath, "utf-8");
        users = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading users file:", error);
        return null;
    }

    let user = users[id];

    if (!user) {
        return null;
    }

    const { Password, ...userWithoutPassword } = user;

    return userWithoutPassword;
}

export const getUserInfo = async (id) => {
    if (id.length == 7) {
        return await getTeacherInfo(id);
    } else if (id.length == 6) {
        return await getStudentInfo(id);
    } else {
        return null;
    }
};
