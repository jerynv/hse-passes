import { ClassSchema } from "./schema.js";
import { v4 as uuidv4 } from "uuid";

function testClassSchema(listOfClasses) {
    let AmountPasses = 0;
    let failsId = [];
    let AmountFails = 0;
    for (const classes in listOfClasses) {
        let shouldBeValid = listOfClasses[classes].shouldPass;
        let currentParentClass = listOfClasses[classes];
        let currentClass = listOfClasses[classes]?.class;
        let classId;
        let currentError;
        if (!currentClass?.id) {
            classId = "undefined";
        } else {
            classId = currentClass.id;
        }
        // if (shouldBeValid) {
        //     printWithColor(`Testing class ${classId}... \n`, "blue");
        // } else {
        //     printWithColor(`Testing class ${classId}... \n`, "blue");
        // }
        try {
            const classSchema = new ClassSchema(listOfClasses[classes].class);
            if (shouldBeValid) {
                AmountPasses++;
                // printWithColor(`Class ${classId} is valid \n`, "green");
            } else {
                AmountFails++;
                failsId.push(classId, '\n');
                // printWithColor(`Class ${classId} is invalid \n`, "red");
            }
        } catch (error) {
            currentError = error;
            if (shouldBeValid) {
                AmountFails++;
                failsId.push(classId, '\n');
                // printWithColor(`Class ${classId} is invalid`, "red");
            } else {
                if (error.code !== currentParentClass?.errorCode) {
                    AmountFails++;
                    failsId.push(classId  +
                        " wanted: " +
                            currentParentClass?.errorCode +
                            " got:" +
                            (currentError.code ?? "none") +
                            "\n"
                   );
                    // printWithColor(`Class ${classId} is invalid`, "red");
                } else {
                    AmountPasses++;
                    
                    // printWithColor(`Class ${classId} is valid`, "green");
                }
                // printWithColor(`Class ${classId} is valid: `, "green");
            }
            // printWithColor(` Error: ${error.message} \n`, "yellow");
        }
        if (classes == listOfClasses.length - 1) {
            printWithColor(`Total Classes: ${listOfClasses.length} \n`, "blue");
            printWithColor(`Total Passes: ${AmountPasses} \n`, "green");
            printWithColor(`Total Fails: ${AmountFails} \n`, "red");
            if (failsId.length > 0) {
                printWithColor(
                    `Failed Ids:\n${failsId.join("")}`,
                    "red"
                );
            }
        }
    }
}

function printWithColor(text, color) {
    const colors = {
        red: "\x1b[31m",
        green: "\x1b[32m",
        yellow: "\x1b[33m",
        blue: "\x1b[34m",
        magenta: "\x1b[35m",
        cyan: "\x1b[36m",
        white: "\x1b[37m",
        reset: "\x1b[0m",
    };

    process.stdout.write(`${colors[color]}${text}${colors.reset}`);
}

const listOfClasses = [
    {
        shouldPass: true,
        class: {
            id: "efa7dffc-f12e-4867-9e11-655b0e47f437",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "2618cf6e-97bd-4671-b9ef-9cb596e1b629",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "2e183be9-deda-4992-a751-8970e9afc473",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "073922eb-9f23-4720-9273-20413d08dea0",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "5ecb1857-dd86-4051-afdd-9aea8fb63442",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "dcc3af0f-9ae2-49e3-ad12-2d848954ac4d",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "69254f98-c106-4338-8564-5ebbeb877082",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "06a75c4b-7621-4faf-b450-77707baeb66a",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "f7e4d933-a34f-460c-afce-7fe289df25e0",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "75593e31-caf0-4cf0-8885-92707b00bc2f",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "Cybersecurity Fundamentals",
            TeacherId: "1234567",
            Room: "F241",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT_PROPERTIES",
        class: {
            id: "da8f1e8f-0cc1-4d46-b4a4-505b5cb57a92",
            period: 1,
            type: "DefaultClass",
            subject: "Math",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT_PROPERTIES",
        class: {
            id: "c22bedbf-ebf6-46e1-bfc7-42fc985b6376",
            period: 1,
            type: "DefaultClass",
            className: "Algebra",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT_PROPERTIES",
        class: {
            id: "d1cde201-0358-4adc-abb9-a0cffe77dc52",
            type: "DefaultClass",
            subject: "Physics",
            className: "AP Physics",
            TeacherId: "1234567",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT_PROPERTIES",
        class: {
            id: "efb46e99-d9bc-4d7b-af02-75d76d4145d9",
            period: 1,
            subject: "Science",
            className: "Biology",
            TeacherId: "1234567",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT_PROPERTIES",
        class: {
            period: 1,
            type: "DefaultClass",
            subject: "English",
            className: "Lit",
            TeacherId: "1234567",
            Room: "E101",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT_PROPERTIES",
        class: {
            id: "0970c4ea-e98f-4ee3-acdf-945747db2966",
            period: 1,
            type: "DefaultClass",
            className: "Lit",
            Room: "E101",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT_PROPERTIES",
        class: {
            id: "975c49c7-85de-4139-8f56-c4d57c6c9e12",
            period: 1,
            type: "DefaultClass",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT_PROPERTIES",
        class: {
            id: "d99e3226-db42-4c3b-9cc3-aed447de5fb2",
            period: 1,
            type: "DefaultClass",
            subject: "",
            className: "",
            TeacherId: "",
            Room: "",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT_PROPERTIES",
        class: {},
    },
    { shouldPass: false, errorCode: "INVALID_CLASS_OBJECT", class: null },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_ID",
        class: {
            id: "1234-invalid-uuid",
            period: 1,
            type: "DefaultClass",
            subject: "Art",
            className: "Painting 101",
            TeacherId: "1234567",
            Room: "B100",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_ID",
        class: {
            id: "1234-invalid-uuid",
            period: 1,
            type: "DefaultClass",
            subject: "Art",
            className: "Painting 101",
            TeacherId: "1234567",
            Room: "B100",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_ID",
        class: {
            id: "1234-invalid-uuid",
            period: 1,
            type: "DefaultClass",
            subject: "Art",
            className: "Painting 101",
            TeacherId: "1234567",
            Room: "B100",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_ID",
        class: {
            id: "1234-invalid-uuid",
            period: 1,
            type: "DefaultClass",
            subject: "Art",
            className: "Painting 101",
            TeacherId: "1234567",
            Room: "B100",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_ID",
        class: {
            id: "1234-invalid-uuid",
            period: 1,
            type: "DefaultClass",
            subject: "Art",
            className: "Painting 101",
            TeacherId: "1234567",
            Room: "B100",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_PERIOD",
        class: {
            id: "4e928679-9da6-4534-aff3-19751624b2bd",
            period: 12,
            type: "DefaultClass",
            subject: "History",
            className: "World War II",
            TeacherId: "1234567",
            Room: "H401",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "b82e208b-86aa-45a2-a4b2-a970b4a567ed",
            period: "2",
            type: "DefaultClass",
            subject: "Geography",
            className: "Earth Sciences",
            TeacherId: "1234567",
            Room: "R303",
        },
    },
    {
        shouldPass: true,
        class: {
            id: "fa4624d8-119d-46f5-8bf9-96c64bcbff99",
            period: 0,
            type: "DefaultClass",
            subject: "Math",
            className: "Algebra II",
            TeacherId: "1234567",
            Room: "F500",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_PERIOD",
        class: {
            id: "c6aa8b24-7ec5-40f1-bf60-86a63eb76d7b",
            period: 99,
            type: "DefaultClass",
            subject: "Science",
            className: "Chemistry",
            TeacherId: "1234567",
            Room: "G401",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_PERIOD",
        class: {
            id: "c966942c-4557-4c36-8791-9e2a36676b31",
            period: "one",
            type: "DefaultClass",
            subject: "Economics",
            className: "Microecon",
            TeacherId: "1234567",
            Room: "C200",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_TEACHER_ID",
        class: {
            id: "897f4e4a-3ffd-4a99-8326-89d40bb7fd51",
            period: 1,
            type: "DefaultClass",
            subject: "Bio",
            className: "Biology Basics",
            TeacherId: "123456",
            Room: "B121",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_TEACHER_ID",
        class: {
            id: "978371b5-cae3-4681-aae6-7eafae24f7ce",
            period: 1,
            type: "DefaultClass",
            subject: "Chem",
            className: "Chemistry",
            TeacherId: "abcdefg",
            Room: "L222",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_TEACHER_ID",
        class: {
            id: "e9b02dd6-3407-430d-a2c3-cd1f6edd1b73",
            period: 1,
            type: "DefaultClass",
            subject: "Lit",
            className: "Literature",
            TeacherId: "12345678",
            Room: "E100",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_TEACHER_ID",
        class: {
            id: "4c76aaa9-5f59-43d6-8c92-f69ccccaa39e",
            period: 1,
            type: "DefaultClass",
            subject: "Lang",
            className: "Spanish I",
            TeacherId: "12-34567",
            Room: "M401",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_TEACHER_ID",
        class: {
            id: "2ed8602d-da27-46c0-80f2-951750b0a811",
            period: 1,
            type: "DefaultClass",
            subject: "Comp Sci",
            className: "JS Basics",
            TeacherId: "      ",
            Room: "F999",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_TYPE",
        class: {
            id: "1719a709-0365-4fb5-b946-33164d73e583",
            period: 1,
            type: "Gym",
            subject: "Physical Ed",
            className: "Fitness",
            TeacherId: "1234567",
            Room: "GYM",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_TYPE",
        class: {
            id: "42365d5c-0a59-4f71-bf7f-9903869ec182",
            period: 1,
            type: "Unknown",
            subject: "Drama",
            className: "Stageplay",
            TeacherId: "1234567",
            Room: "T123",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_TYPE",
        class: {
            id: "216ef483-ded8-4faa-a227-45984245e6b3",
            period: 1,
            type: "Class",
            subject: "Health",
            className: "Mental Health",
            TeacherId: "1234567",
            Room: "H111",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_TYPE",
        class: {
            id: "c891b4e8-87ce-42dc-90ae-85bf23114a4d",
            period: 1,
            type: "usffujsbdf",
            subject: "Art",
            className: "Sculpture",
            TeacherId: "1234567",
            Room: "A123",
        },
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_TYPE",
        class: {
            id: "70a6b9ab-c338-4c6d-ad43-609a0001b6aa",
            period: 1,
            type: null,
            subject: "Math",
            className: "Calc",
            TeacherId: "1234567",
            Room: "M101",
        },
    },
    { shouldPass: false, errorCode: "INVALID_CLASS_OBJECT", class: null },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT",
        class: undefined,
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT",
        class: "Not an object",
    },
    {
        shouldPass: false,
        errorCode: "INVALID_CLASS_OBJECT",
        class: 12345,
    },
    { shouldPass: false, errorCode: "INVALID_CLASS_OBJECT", class: [] },
];

testClassSchema(listOfClasses);
