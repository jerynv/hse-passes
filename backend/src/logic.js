import moment from "moment";
import * as fs from "fs";
import { v4 } from "uuid";
import { join } from "path";
import { getStudentInfo, getTeacherInfo, getUserInfo } from "./auth.js";
import { stringify } from "querystring";
import { userInfo } from "os";
import { logIt } from "./data.js";
import { json } from "stream/consumers";

const __dirname = new URL(".", import.meta.url).pathname;
const baseDismissalTime = 15 * 60 * 1000; // 15 minutes in milliseconds

async function savePassRequest(data) {
    // {
    //     "4-24-2024": {
    //         "randomuuid": {
    //             "CurrentClassUUID": "uuid",
    //             "SenderId": "251378",
    //             "ReceiverId": "213780",
    //             "PassName": "Bathroom",
    //             "PassType": "Bathroom Pass",
    //             "PassStatus": "Pending",
    //             "PassTime": "Epoch time"
    //             "Urgency": 0,
    //             "Note": "note",
    //         }
    //     }
    // }
    const { ClassUUID, Id, PassName, PassType, Urgency, Note } = data;
    const filePath = join(__dirname, "db/passes.json");
    let passes = {};
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        passes = JSON.parse(fileData);
    } catch (error) {
        return { success: false, message: "Error reading passes file" };
    }

    const date = moment().format("MM-DD-YYYY");
    if (!passes[date]) {
        passes[date] = {};
    }
    const passUUID = v4();
    const classInfo = await GetClassInfo(ClassUUID);
    const studentInfo = await getStudentInfo(Id);
    const similarPass = Object.values(passes[date]).find(
        (pass) =>
            pass.SenderId === Id &&
            pass.PassStatus === "Pending" &&
            pass.PassType === PassType &&
            pass.CurrentClassUUID === ClassUUID &&
            pass.PassName === PassName &&
            pass.ReceiverId === classInfo["TeacherId"] &&
            pass.PassTime + baseDismissalTime > Date.now()
    );

    if (similarPass) {
        return {
            success: false,
            message: "You already have a pending pass request for this type.",
        };
    }

    const moreThanTwoPasses = Object.values(passes[date]).filter(
        (pass) =>
            pass.SenderId === Id &&
            pass.PassStatus === "Pending" &&
            pass.PassTime + baseDismissalTime > Date.now()
    );

    if (moreThanTwoPasses.length >= 2) {
        return {
            success: false,
            message: "You already have 2 pending pass requests.",
        };
    }

    passes[date][passUUID] = {
        PassId: passUUID,
        CurrentClassUUID: ClassUUID,
        SenderId: Id,
        SenderName: studentInfo["First_Name"] + " " + studentInfo["Last_Name"],
        ReceiverId: classInfo["TeacherId"],
        PassName: PassName,
        PassType: PassType,
        PassStatus: "Pending",
        PassTime: Date.now(),
        Urgency: Urgency,
        Note: Note,
    };

    try {
        await fs.promises.writeFile(filePath, JSON.stringify(passes, null, 2));
    } catch (error) {
        return { success: false, message: "Error writing passes file" };
    }

    return {
        success: true,
        message: "Pass request saved successfully",
        pass: passes[date][passUUID],
    };
}
async function savePassRequestPerson(data) {
    //could be a teacher requesting a student or another teacher, or a student requesting a teacher

    let { ClassUUID, Id, ReceiverId, PassName, PassType, Urgency, Note } = data;
    const filePath = join(__dirname, "db/passes.json");
    let passes = {};
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        passes = JSON.parse(fileData);
    } catch (error) {
        return { success: false, message: "Error reading passes file" };
    }
    const date = moment().format("MM-DD-YYYY");
    if (!passes[date]) {
        passes[date] = {};
    }
    const passUUID = v4();
    let studentInfo;
    let teacherInfo;
    if (Id.length > 6) {
        //teacher
        teacherInfo = await getTeacherInfo(Id);
        //if a teacher sent a pass to a student then there will not be a class uuid because their classes are not in the same format, find the relative uuid for the student

        const similarPass = Object.values(passes[date]).find(
            (pass) =>
                pass.SenderId === Id &&
                pass.PassType === PassType &&
                pass.CurrentClassUUID === ClassUUID &&
                pass.PassName === PassName &&
                pass.ReceiverId === ReceiverId &&
                pass.PassTime + baseDismissalTime > Date.now()
        );
        if (similarPass) {
            return {
                success: false,
                message:
                    "You already have a pending pass request for this type.",
            };
        }

        const requestingAPersonWhoIsRequestingYou = Object.values(
            passes[date]
        ).find(
            (pass) =>
                pass.SenderId === ReceiverId &&
                pass.ReceiverId === Id &&
                pass.PassTime + baseDismissalTime > Date.now()
        );
        if (requestingAPersonWhoIsRequestingYou) {
            return {
                success: false,
                message:
                    "You already have a pending pass request for this pass.",
            };
        }
        //teachers can send as many passes as they want
        passes[date][passUUID] = {
            PassId: passUUID,
            CurrentClassUUID: ClassUUID,
            SenderId: Id,
            SenderName:
                teacherInfo["Prefix"] +
                " " +
                teacherInfo["Last_Name"] +
                " " +
                teacherInfo["First_Name"],
            ReceiverId: ReceiverId,
            PassName: PassName,
            PassType: PassType,
            PassStatus: "Pending",
            PassTime: Date.now(),
            Urgency: Urgency,
            Note: Note,
        };
        try {
            await fs.promises.writeFile(
                filePath,
                JSON.stringify(passes, null, 2)
            );
        } catch (error) {
            return { success: false, message: "Error writing passes file" };
        }
        return {
            success: true,
            message: "Pass request saved successfully",
            pass: passes[date][passUUID],
        };
    } else {
        studentInfo = await getStudentInfo(Id);
        const classInfo = await GetClassInfo(ClassUUID);

        //if the user Already has a Teacher pass then they cannot request another one

        const teacherPass = Object.values(passes[date]).find(
            (pass) =>
                pass.SenderId === Id &&
                pass.PassType === "Teacher Pass" &&
                pass.PassTime + baseDismissalTime > Date.now()
        );

        if (teacherPass) {
            return {
                success: false,
                message:
                    "You already have a pending pass request for this type.",
            };
        }

        const similarPass = Object.values(passes[date]).find(
            (pass) =>
                pass.SenderId === Id &&
                pass.PassType === PassType &&
                pass.CurrentClassUUID === ClassUUID &&
                pass.PassName === PassName &&
                pass.ReceiverId === classInfo["TeacherId"] &&
                pass.PassTime + baseDismissalTime > Date.now()
        );
        if (similarPass) {
            return {
                success: false,
                message:
                    "You already have a pending pass request for this type.",
            };
        }
        const moreThanTwoPasses = Object.values(passes[date]).filter(
            (pass) =>
                pass.SenderId === Id &&
                pass.PassTime + baseDismissalTime > Date.now()
        );
        if (moreThanTwoPasses.length >= 2) {
            return {
                success: false,
                message: "You already have 2 pending pass requests.",
            };
        }
        const requestingAPersonWhoIsRequestingYou = Object.values(
            passes[date]
        ).find(
            (pass) =>
                pass.SenderId === ReceiverId &&
                pass.ReceiverId === Id &&
                pass.PassTime + baseDismissalTime > Date.now()
        );
        if (requestingAPersonWhoIsRequestingYou) {
            return {
                success: false,
                message:
                    "You already have a pending pass or and active pass for this.",
            };
        }

        passes[date][passUUID] = {
            PassId: passUUID,
            CurrentClassUUID: ClassUUID,
            SenderId: Id,
            SenderName:
                studentInfo["First_Name"] + " " + studentInfo["Last_Name"],
            ReceiverId: classInfo["TeacherId"],
            PassName: PassName,
            PassType: PassType,
            PassStatus: "Pending",
            PassTime: Date.now(),
            Urgency: Urgency,
            Note: Note,
        };
        try {
            await fs.promises.writeFile(
                filePath,
                JSON.stringify(passes, null, 2)
            );
        } catch (error) {
            return { success: false, message: "Error writing passes file" };
        }
        return {
            success: true,
            message: "Pass request saved successfully",
            pass: passes[date][passUUID],
        };
    }
}
async function GetClassInfo(classUUID) {
    const filePath = join(__dirname, "db/classes.json");
    let classes = [];
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        classes = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading classes file:", error);
        return [];
    }
    const classInfo = classes[classUUID];
    if (!classInfo) {
        console.error("Class not found");
        return null;
    }
    return classInfo;
}
async function dumpPassPresets() {
    const filePath = join(__dirname, "db/passPresets.json");
    let passPresets = [];
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        passPresets = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading pass presets file:", error);
        return [];
    }
    return passPresets;
}
async function dumpTeacherInfoForStudents(id) {
    //only return teacher name which will be prefiix plus the teacher name,
    //and the teacher id

    const filePath = join(__dirname, "db/teachers.json");
    let teachers = [];
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        teachers = JSON.parse(fileData);
    } catch (error) {
        return [];
    }

    const teacherKeys = Object.keys(teachers);
    const teacherInfo = teacherKeys.map((key) => {
        const teacher = teachers[key];
        return {
            TeacherId: key,
            TeacherName:
                teacher["Prefix"] +
                " " +
                teacher["Last_Name"] +
                ", " +
                teacher["First_Name"],
        };
    });

    //remove the one with Hse as the first name
    const filteredTeacherInfo = teacherInfo.filter(
        (teacher) =>
            teacher.TeacherName !== " , Hse" && teacher.TeacherId !== String(id)
    );

    return filteredTeacherInfo;
}
async function dumpStudentInfoForTeachers() {
    const filePath = join(__dirname, "db/users.json");
    let users = [];
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        users = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading users file:", error);
        return [];
    }
    const studentKeys = Object.keys(users);
    const studentInfo = studentKeys.map((key) => {
        const student = users[key];
        return {
            StudentId: key,
            Classes: student["Classes"],
            StudentName: student["First_Name"] + " " + student["Last_Name"],
        };
    });
    return studentInfo;
}
async function dumpPendingPassesForTeachers(teacherId) {
    const filePath = join(__dirname, "db/passes.json");
    let passes = {};
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        passes = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading passes file:", error);
        return [];
    }
    const date = moment().format("MM-DD-YYYY");
    if (!passes[date]) {
        console.log("No passes for today");
        return [];
    }
    const pendingPasses = Object.values(passes[date]).filter(
        (pass) =>
            pass["ReceiverId"] === String(teacherId) &&
            pass["PassStatus"] === "Pending" &&
            pass["PassTime"] + baseDismissalTime > Date.now()
    );

    const pendingPassesWithStudentInfo = pendingPasses.map((pass) => {
        return {
            ...pass,
            StudentName: pass.SenderName,
            StudentId: pass.SenderId,
        };
    });

    return pendingPassesWithStudentInfo;
}
async function dumpPendingPassesForStudents(id) {
    const filePath = join(__dirname, "db/passes.json");
    let passes = {};
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        passes = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading passes file:", error);
        return [];
    }
    const date = moment().format("MM-DD-YYYY");
    if (!passes[date]) {
        console.log("No passes for today");
        return [];
    }
    const pendingPasses = Object.values(passes[date]).filter(
        (pass) =>
            pass["ReceiverId"] === String(id) &&
            pass["PassStatus"] === "Pending" &&
            pass["PassTime"] + baseDismissalTime > Date.now()
    );
    const pendingPassesWithClassInfo = pendingPasses.map((pass) => {
        return {
            ...pass,
            ClassName: pass.PassName,
            ClassUUID: pass.CurrentClassUUID,
            TeacherId: pass.ReceiverId,
        };
    });
    return pendingPassesWithClassInfo;
}
async function dumpOutGoingRequests(id) {
    const filePath = join(__dirname, "db/passes.json");
    let passes = {};
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        passes = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading passes file:", error);
        return [];
    }
    const date = moment().format("MM-DD-YYYY");
    if (!passes[date]) {
        console.log("No passes for today");
        return [];
    }
    const outGoingRequests = Object.values(passes[date]).filter(
        (pass) =>
            pass["SenderId"] === String(id) &&
            pass["PassStatus"] === "Pending" &&
            pass["PassTime"] + baseDismissalTime > Date.now()
    );
    const outGoingRequestsWithClassInfo = outGoingRequests.map((pass) => {
        return {
            ...pass,
        };
    });
    return outGoingRequestsWithClassInfo;
}
async function AcceptPassRequest(data) {
    const { PassId, ClassUUID } = data;
    console.log("Accepting pass request", data);
    const filePath = join(__dirname, "db/passes.json");
    let passes = {};
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        passes = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading passes file:", error);
        return { success: false, message: "Error reading passes file" };
    }
    const date = moment().format("MM-DD-YYYY");
    if (!passes[date]) {
        console.log("No passes for today");
        return { success: false, message: "No passes for today" };
    }
    const pass = Object.values(passes[date]).find(
        (pass) => pass.PassId === PassId
    );
    if (!pass) {
        console.log("Pass not found");
        return { success: false, message: "Pass not found" };
    }
    if (pass.PassStatus !== "Pending") {
        console.log("Pass already accepted");
        return { success: false, message: "Pass already accepted" };
    }
    const classInfo = await GetClassInfo(ClassUUID);
    if (!classInfo) {
        console.log("Class not found");
        return { success: false, message: "Class not found" };
    }
    const UserInfo = await getUserInfo(pass.SenderId);
    if (!UserInfo) {
        console.log("User not found");
        return { success: false, message: "User not found" };
    }
    const receiverUserInfo = await getUserInfo(pass.ReceiverId);
    if (!receiverUserInfo) {
        console.log("Teacher not found");
        return { success: false, message: "Teacher not found" };
    }

    let secondListener = false;

    if (classInfo["TeacherId"] !== pass.SenderId) {
        secondListener = true;
    }

    const passInfo = {
        ...pass,
        PassStatus: "Accepted",
        AcceptedTime: Date.now(),
    };

    passes[date][PassId] = passInfo;
    try {
        await fs.promises.writeFile(filePath, JSON.stringify(passes, null, 2));
    } catch (error) {
        console.error("Error writing passes file:", error);
        return { success: false, message: "Error writing passes file" };
    }
    const passInfoWithClassInfo = {
        ...passInfo,
        ClassName: classInfo["ClassName"],
        ClassUUID: classInfo["ClassUUID"],
        ReciverName:
            (receiverUserInfo["Prefix"] ?? "") +
            receiverUserInfo["First_Name"] +
            " " +
            receiverUserInfo["Last_Name"],
        SenderName:
            (userInfo["Prefix"] ?? "") +
            UserInfo["First_Name"] +
            " " +
            UserInfo["Last_Name"],
        Destination: passes[date][PassId]["SenderName"],
    };
    let notify = [];
    if (secondListener) {
        notify = [classInfo["TeacherId"], pass["SenderId"]];
    } else {
        notify = [pass["SenderId"]];
    }
    console.log("Notify", notify);
    return {
        success: true,
        message: "Pass request accepted successfully",
        pass: passInfoWithClassInfo,
        notify,
    };
}
async function dumpActivePasses(id) {
    const filePath = join(__dirname, "db/passes.json");
    let passes = {};
    try {
        const fileData = await fs.promises.readFile(filePath, "utf-8");
        passes = JSON.parse(fileData);
    } catch (error) {
        console.error("Error reading passes file:", error);
        return [];
    }
    const date = moment().format("MM-DD-YYYY");
    if (!passes[date]) {
        console.log("No passes for today");
        return [];
    }
    const activePasses = Object.values(passes[date]).filter(
        (pass) =>
            pass["SenderId"] === String(id) &&
            pass["PassStatus"] === "Accepted" &&
            pass["PassTime"] + baseDismissalTime > Date.now()
    );
    //if the id is a teacher and the pass type was a Person Request then the destination is the student name
    //if the id is a student and the pass type was a Person Request then the destination is the teacher name

    if (activePasses.length === 0) {
        console.log("No active passes");
        //check for passtypes Person Request with the reciever id as the id
        const activePassesWithPersonRequest = Object.values(
            passes[date]
        ).filter(
            (pass) =>
                pass["ReceiverId"] === String(id) &&
                pass["PassStatus"] === "Accepted" &&
                pass["PassTime"] + baseDismissalTime > Date.now()
        );
        if (activePassesWithPersonRequest.length > 0) {
            const activePassesWithPersonRequestInfo =
                activePassesWithPersonRequest.map((pass) => {
                    return {
                        ...pass,
                        Destination: pass.SenderName,
                    };
                });
            return activePassesWithPersonRequestInfo;
        }
        return [];
    }

    if (id.length > 6 && activePasses[0].PassType === "Person Request") {
        //teacher
        const activePassesWithStudentInfo = activePasses.map((pass) => {
            return {
                ...pass,
                Destination: pass.PassName,
            };
        });
        return activePassesWithStudentInfo;
    } else if (activePasses[0].PassType === "Teacher Pass") {
        //student
        const activePassesWithClassInfo = activePasses.map((pass) => {
            return {
                ...pass,
                Destination: pass.PassName,
                ClassName: pass.PassName,
                ClassUUID: pass.CurrentClassUUID,
                TeacherId: pass.ReceiverId,
            };
        });
        return activePassesWithClassInfo;
    }

    return activePassesWithClassInfo;
}

async function wsSend(ws, userId, message) {
    //this is just a wrapper for the ws instance to send messages
    //this will be used to send messages to the client
    //the message should be a json object with the following format
    // {
    //     "operation": "OperationName",
    //     "data": {
    //
    //         "key": "value"
    //     }
    // }
    // console.log("Sending message to client", message);

    //nicely parse the message json to a one liner for the console
    const parsedMessage = JSON.stringify(message, null, null);
    logIt(`Sending message to ${userId}: ${parsedMessage}`, "log");

    //parsed message also works for sending it to the client
    ws.send(parsedMessage);
}

//these should be all the publicly implemented functions for the ws
// every ws function has a websocket instance passed "so current connection, sender of the operation"  and a pointer to the Websocket Users which contains all the users connected and their ws instances as well. Adn a pointer to the wsData that was passed into the ws instance request / message
// an example of the wsData is the following
// {
//     "operation": "AcceptPassRequest",
//     "data": { // this is the data that will be passed into the ws instance, i gave the entire send message for a better prospective into the workings ‼️
//         "PassId": "deb23be7-fb99-4ab1-879e-a822a48750eb",
//         "SenderId": "251378",
//     }
// }

// an example of the wsUsers is the following
// { // as a map
//     "251378": {
//         "ws": ws,
//     }
// }

// and then of course the ws instance is the websocket instance that was passed into the ws instance, cant really show you that one but its just a websocket instance

async function setUser(ws, wsUsers, wsData) {
    // we need to reimplement this !! check marks ✅ indicate the paragraph below was successfully implemented in text ✅✅ double means it works and ☑️☑️ means it was not implemented in this scope but has been implemented in the other scope to accommodate the new changes

    // ✅
    // if (clients.has(FormattedMessage.Data.id)) {
    //     console.warn(`User ID already exists, replacing connection`);
    //     let existingClient = clients.get(FormattedMessage.Data.id);
    //     existingClient.close();
    //     clients.delete(FormattedMessage.Data.id);
    //     console.log(
    //         `Closed existing connection for user ID: ${FormattedMessage.Data.id}`
    //     );
    // }

    // ✅ we pushing this up to above the block above to ease the coding
    // let userId = FormattedMessage.Data.id;

    // ☑️☑️
    // if (!FormattedMessage.Data || !userId) {
    //     console.log(`Error: Missing user ID for client`);
    //     ws.send("Error: Missing user ID");
    //     return;
    // }

    //
    // console.log(`Setting user ID for client: ${userId}`);
    // clients.set(userId, ws);
    // ws.userId = userId;
    // ws.send(
    //     JSON.stringify({
    //         Operation: "verifyIntegrity",
    //         Data: { success: true },
    //     })
    // );

    // ws.send(
    //     JSON.stringify({
    //         Operation: "SetPassPresets",
    //         Data: {
    //             passPresets: await dumpPassPresets(),
    //         },
    //     })
    // );
    // ws.send(
    //     JSON.stringify({
    //         Operation: "SetTeachers",

    //         Data: {
    //             success: true,
    //             Teachers: await dumpTeacherInfoForStudents(userId),
    //         },
    //     })
    // );
    // ws.send(
    //     JSON.stringify({
    //         Operation: "SetActivePasses",

    //         Data: {
    //             success: true,
    //             ActivePasses: await dumpActivePasses(userId),
    //         },
    //     })
    // );
    // ws.send(
    //     JSON.stringify({
    //         Operation: "SetOutGoingRequests",

    //         Data: {
    //             success: true,
    //             OutGoingRequests: await dumpOutGoingRequests(userId),
    //         },
    //     })
    // );
    // if (ws.userId.length == 7) {
    //     console.log("pass dump pending passes for teachers");
    //     ws.send(
    //         JSON.stringify({
    //             Operation: "PendingPassRequestDump",
    //             Data: {
    //                 success: true,
    //                 passes: await dumpPendingPassesForTeachers(ws.userId),
    //             },
    //         })
    //     );
    //     ws.send(
    //         JSON.stringify({
    //             Operation: "SetStudents",
    //             Data: {
    //                 success: true,
    //                 Students: await dumpStudentInfoForTeachers(),
    //             },
    //         })
    //     );
    // } else if (ws.userId.length == 6) {
    //     console.log("pass dump pending passes for students");
    //     ws.send(
    //         JSON.stringify({
    //             Operation: "PendingPassRequestDump",
    //             Data: {
    //                 success: true,
    //                 passes: await dumpPendingPassesForStudents(ws.userId),
    //             },
    //         })
    //     );
    // }

    let userId = wsData.refId;

    logIt(`Setting user ID for client: ${wsData.refId}`);
    if (wsUsers.has(userId)) {
        logIt(`User ID already exists, replacing connection`, "warn");
        let existingClient = wsUsers.get(wsData.refId);
        existingClient.close();
        wsUsers.delete(wsData.refId);
        logIt(
            `Closed existing connection for user ID: ${wsData.refId}`,
            "warn"
        );
    }

    //adds to the big map of all active users
    wsUsers.set(userId, ws);
    //sets the userId for this ws instance maintains the userId for the ws instance
    ws.userId = userId;
    //sends a message to the client to verify the connection
    wsSend(ws, userId, {
        Operation: "verifyIntegrity",
        Data: { success: true },
    });
}

export { setUser, wsSend };
