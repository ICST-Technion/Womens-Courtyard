import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const serviceAccount = require("./admin-sdk.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

// Sign-up
export const registerClient = functions.https.onCall( async (data, context) => {
    // functions.logger.info(`user sent data ${data}`);
    // for (var key in data) {
    //     functions.logger.info(`data has key ${key}`)
    // }
    // functions.logger.info(`hi! data is ${data}`);

    const username = data.username as string;
    const password = data.password as string;
    const role = data.role as string;
    const name = data.name as string;

    // functions.logger.debug(`request: value ${request}, type ${typeof request}`);
    // functions.logger.debug(`username: value ${username}, type ${typeof username}`);
    // functions.logger.debug(`password: value ${password}, type ${typeof password}`);
    // functions.logger.debug(`role: value ${role}, type ${typeof role}`);
    // functions.logger.debug(`name: value ${name}, type ${typeof name}`);

    const db = admin.firestore();
    const staffRef = db.collection("staff");
    const clientRef = db.collection("clients");
    const usersRef = db.collection("users");
    const mdRef = db.collection("metadata");

    // Check whether user already exists
    const tentUserId = await usersRef.where("username", "==", username).get();
    if (!tentUserId.empty) {
        functions.logger.info(`username ${username} already exists`);
        return {"success": false, "data": `username ${username} already exists`};
    }

    // Verify the role requirement
    if (!(role == "staff" || role == "client")) {
        functions.logger.info(`illegal role ${role} required`);
        return {"success": false, "data": `illegal role ${role} required`};
    }

    // Get the new ID
    const nextIdDoc = await mdRef.doc("next_id").get();
    var nextId = 1;
    if (!nextIdDoc.exists) {
        functions.logger.warn("nextId data does not exist! this is only acceptable when testing.");
    }
    else {
        nextId = nextIdDoc.get("next_id");
    }
    mdRef.doc("next_id").set({"next_id": nextId+1});
    const id = nextId;

    
    functions.logger.info("should pass.")

    // Add to roles collection
    usersRef.doc(id.toString()).set({
        "username": username,
        "password": password,
        "role": role
    });
    
    
    if (role == "staff") {
        // Add to staff collection
        staffRef.doc(id.toString()).set({
            "name": name,
        });
    }
    else {
        // Add to clients collection
        clientRef.doc(id.toString()).set({
            "name": name,
            "personal file": {},
            "client notes": [],
            "appointment history": []
        });
    }

    return {"success": true, data: ""};

});

export const generateToken = functions.https.onCall( async (data, context) => {
    
    const username = data.username as string;
    const password = data.password as string;

    const db = admin.firestore();
    const usersRef = db.collection("users");

    // Get user data
    const userQuery = await usersRef.where("username", "==", username).get();
    if (userQuery.empty) {
        functions.logger.info(`username ${username} does not exist`);
        return {"success": false, "data": `Username ${username} does not exist`};
    }
    else if (userQuery.size > 1) {
        functions.logger.warn(`multiple users with name ${username} exist.`);
        return {"success": false, "data": `Internal database error`};
    }
    
    // Verify user's password
    const userEntry = userQuery.docs[0];
    if (password != userEntry.data().password) {
        functions.logger.info(`username ${username} attempted wrong password ${password}`);
        return {"success": false, "data": `Wrong password`};
    }

    // If passed all checks
    functions.logger.info(`user ${username} passed login checks`);
    const role = userEntry.data().role
    const additionalClaims = { "role": role };
    try {
        const customToken = await admin.auth().createCustomToken(userEntry.id, additionalClaims);
        functions.logger.info(`user ${username} got generated token`);
        return {"success": true, "data": {"role": role, "token": customToken}};
        functions.logger.error("SHOULD NOT GET HERE - AFTER RETURN");
    }
    catch (error) {
        functions.logger.warn(`login failed with error ${error}`);
        return {"success": false, "data": "Internal database error"};
    }
    functions.logger.warn("login failed (control flow error)");
    return {"success": false, "data": "Internal database error"};
});
