import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

/// Testing functions
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const addMessage = functions.https.onRequest(async (request, response) => {
    const original = request.query.text;
    functions.logger.info(`user sent ${original}`);
});


const ROLES = ['staff', 'client']

/// Sign-up
export const registerClient = functions.https.onRequest(async (request, response) => {
    const username = request.query.username as string;
    const password = request.query.password as string;
    const role = request.query.role as string;
    const name = request.query.name as string;

    const db = admin.firestore();
    const staff_ref = db.collection('staff');
    const client_ref = db.collection('clients');
    const users_ref = db.collection('users');

    // Check whether user already exists
    const tent_user_id = await users_ref.where('username', '==', username).get();
    if (!tent_user_id.empty) {
        response.send(`username ${username} already exists`);
        return;
    }

    const id = 0; // Find a way to generate user id
    if (!(role in ROLES)) {
        response.send(`illegal role ${role} required`);
        return;
    }

    // Add to roles collection
    users_ref.doc(id.toString()).set({
        'username': username,
        'password': password,
        'role': role
    });
    
    if (role == 'staff') {
        // Add to staff collection
        staff_ref.doc(id.toString()).set({
            'name': name,
        });
    }
    else {
        // Add to clients collection
        client_ref.doc(id.toString()).set({
            'name': name,
            'personal file': {},
            'client notes': [],
            'appointment history': []
        });
    }

});