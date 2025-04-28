import * as moment from 'moment';

export async function savePassRequest(data) {
    // {
    //     "4-24-2024": {
    //         "randomuuid": {
    //             "CurrentClassUUID": "uuid",
    //             "SenderId": "251378",
    //             "ReceiverId": "2513780",
    //             "PassName": "Pass Name",
    //             "PassType": "Bathroom Pass",
    //             "PassStatus": "Pending",
    //             "PassTime": "Epoch time"
    //             "Urgency": 0,
    //             "Note": "note",
    //         }
    //     }
    // }
    const { classUUID, SenderId, PassName, PassType, Urgency, Note } = data;
    const filePath = join(__dirname, "db/passes.json");
}