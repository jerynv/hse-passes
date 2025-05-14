export class MessageTypeBasic {
    constructor(messageDict, callbackWithMessage) {
        //a perfectly valid message "messageDict" needs to look like this
        // {
        //     "operation": "", right now this can get away with being an empty string or any string but in the future it should be required that it is a valid operation, so just a string
        //    "data": {
        //      "refId": "251378", // number or string but needs to be a parseable number, only 6 or 7 digits everyting else call the callback function with the error message
        //      }
        // }

        if (
            typeof messageDict !== "object" ||
            messageDict === null ||
            messageDict === undefined
        ) {
            throw new Error("MessageType constructor expects an object", {
                code: "INVALID_MESSAGE_OBJECT",
            });
        }

        if (
            !messageDict.hasOwnProperty("operation") ||
            !messageDict.hasOwnProperty("data")
        ) {
            throw new Error(
                "MessageType constructor expects an object with operation and data properties",
                {
                    code: "INVALID_MESSAGE_OBJECT_PROPERTIES",
                }
            );
        }
        // if (messageDict.operation === "") {  // this is a valid operation but in the future it should be required that it is a valid operation, so just a string
        //     throw new Error("MessageType constructor expects a valid operation", {
        //         code: "INVALID_MESSAGE_OBJECT_OPERATION",
        //     });
        // }

        if (messageDict.data === null || messageDict.data === undefined) {
            throw new Error(
                "MessageType constructor expects a valid data object",
                {
                    code: "INVALID_MESSAGE_OBJECT_DATA",
                }
            );
        }

        if (typeof messageDict.data !== "object") {
            throw new Error(
                "MessageType constructor expects a valid data object",
                {
                    code: "INVALID_MESSAGE_OBJECT_DATA",
                }
            );
        }

        if (messageDict.data.hasOwnProperty("refId") === false) {
            throw new Error(
                "MessageType constructor expects a valid data object with refId property",
                {
                    code: "INVALID_MESSAGE_OBJECT_DATA_REFID",
                }
            );
        }

        if (
            messageDict.data.refId === "" ||
            messageDict.data.refId === null ||
            messageDict.data.refId === undefined ||
            messageDict.data.refId === NaN ||
            parseInt(messageDict.data.refId) === NaN ||
            !messageDict.data.refId.length === 6 ||
            !messageDict.data.refId.length === 7
        ) {
            throw new Error(
                "MessageType constructor expects a valid data object with refId property",
                {
                    code: "INVALID_MESSAGE_OBJECT_DATA_REFID",
                }
            );
        }
    }
}

export class PassSchema {
    constructor(passDict) {
        if (typeof passDict !== "object" || passDict === null) {
            throw new Error("PassType constructor expects an object");
        }

        if (
            !passDict.hasOwnProperty("id") ||
            !passDict.hasOwnProperty("name") ||
            !passDict.hasOwnProperty("description") ||
            !passDict.hasOwnProperty("type") ||
            !passDict.hasOwnProperty("startDate") ||
            !passDict.hasOwnProperty("endDate") ||
            !passDict.hasOwnProperty("passType")
        ) {
            throw new Error(
                "PassType constructor expects an object with id, name, description, type, startDate, endDate and passType properties"
            );
        }

        this.id = passDict.id;
        this.name = passDict.name;
        this.description = passDict.description;
        this.type = passDict.type;
        this.startDate = passDict.startDate;
        this.endDate = passDict.endDate;
        this.passType = passDict.passType;
    }
}

export class ClassSchema {
    // [
    // "deb23be7-fb99-4ab1-879e-a822a48750eb" : {
    //      "id": "deb23be7-fb99-4ab1-879e-a822a48750eb",
    //      "period": 1,
    //      "type": "DefaultClass", || "Office" || "GuidanceOffice" || "AttendanceOffice"
    //      "subject": "Comp Sci",
    //      "className": "Cybersecurity Fundamentals",
    //      "TeacherId": "2513780",
    //      "Room": "F241"
    //   }
    // ]
    constructor(classDict) {
        if (
            typeof classDict !== "object" ||
            classDict === null ||
            classDict === undefined ||
            Array.isArray(classDict)
        ) {
            const err = new Error();
            err.message = "ClassType constructor expects an object";
            err.code = "INVALID_CLASS_OBJECT";
            throw err;
        }

        if (
            !classDict.hasOwnProperty("id") ||
            !classDict.hasOwnProperty("period") ||
            !classDict.hasOwnProperty("type") ||
            !classDict.hasOwnProperty("subject") ||
            !classDict.hasOwnProperty("className") ||
            !classDict.hasOwnProperty("TeacherId") ||
            !classDict.hasOwnProperty("Room") ||
            classDict.id === "" ||
            classDict.period === "" ||
            classDict.type === "" ||
            classDict.subject === "" ||
            classDict.className === "" ||
            classDict.TeacherId === "" ||
            classDict.Room === ""
        ) {
            const err = new Error();
            err.message =
                "ClassType constructor expects an object with id, period, subject, className, TeacherId and Room properties";
            err.code = "INVALID_CLASS_OBJECT_PROPERTIES";
            throw err;
        }

        const validTypes = [
            "DefaultClass",
            "Office",
            "GuidanceOffice",
            "AttendanceOffice",
        ];

        if (validTypes.includes(classDict.type) === false) {
            const err = new Error();
            err.message = `Invalid 'type': must be one of ${validTypes.join(
                ", "
            )}`;
            err.code = "INVALID_CLASS_TYPE";
            throw err;
        }

        const uuidV4Regex =
            /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

        if (uuidV4Regex.test(classDict.id) !== true) {
            const err = new Error();
            err.message = "ClassType expects a valid uuid for the id property";
            err.code = "INVALID_CLASS_ID";
            throw err;
        }

        if (!/^\d{7}$/.test(classDict.TeacherId)) {
            const err = new Error();
            err.message = "TeacherId must be a 7-digit number.";
            err.code = "INVALID_TEACHER_ID";
            throw err;
        }

        if (!/^\d{1}$/.test(classDict.period)) {
            const err = new Error();
            err.message = "Period must be a single digit number.";
            err.code = "INVALID_PERIOD";
            throw err;
        }

        this.id = classDict.id; //this is the id of the class, this will always be added
        this.period = classDict.period;
        this.type = classDict.type; // DefaultClass || Office || GuidanceOffice || AttendanceOffice
        this.subject = classDict.subject;
        this.className = classDict.className;
        this.TeacherId = classDict.TeacherId;
        this.Room = classDict.Room;
    }
}

var examplePassType = {
    type: "DefaultPass", //this is the type of pass that is being sent, this will always be added, default pass types are
    senderId: "251378", //this is the id of the student that is sending the pass, this will always be added
    receiverId: "2513780", //this is the id of the teacher that the pass is being sent to, this is usually defaulted to the current periods teacher
    requestedTime: new Date("2023-01-01"), //this is the time that the pass was requested, this will always be added
};

//for this example, the user Jeryn Vicari sends a pass to teacher that is not the current teacher who's class hes is currently in
var examplePassType = {
    type: "StudentTeacherRequest",
    senderId: "251378",
    receiverId: "2513780",
    requestedTime: new Date("2023-01-01"),
};

var examplePassTypeAdded = {
    //these are properties that will be added then sent back from every pass related response to the users, users should never send them to the server
    passId: "deb23be7-fb99-4ab1-879e-a822a48750eb",
    ...examplePassType, //the returned pass back to the user will still include the original sent pass information fo identification purposes
    requestedTime: new Date("2023-01-01"), //this is the time that the pass was requested, this will always be added
    startDate: new Date("2023-01-01"), // only returned if the pass is accepted as this will show the actual accepted time of the pass——
    endDate: new Date("2023-01-02"), //this is the date that the pass will expire, this may or may not be added to the response pass, as some passes may not have an expiration date, or some may hae default to the start  of the next period, i request this pass to a teacher that is not the current teacher who's class hes is currently in—the pass default end date is the end of the period now because this teacher now has a "override ownership" of the student
    senderName: "Jeryn Vicari", //this is the name of the sender
    receiverName: "Teacher 2", //this is the name of the receiver
    status: "pending", //this is the status of the pass
    views: {
        // on client side it pretty much just shows / add the pas for the user based on the senders id if the user id is the same as the senderId then is would set views.defaultView to the sender view
        teacherView: {
            studentName: "Jeryn Vicari",
            title: "Jeryn Vicari",
            subject: "Teacher 2",
        },
        receiverView: {
            studentName: "Jeryn Vicari",
            title: "Jeryn Vicari",
            subject: "Upon My Request",
        },
        senderView: {
            teacherName: "Teacher 2",
            title: "Teacher 2",
            subject: "Teacher Request",
        },
    },
};
