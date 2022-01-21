import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
//import * as admin_auth from "firebase-admin/auth";
//import { initializeApp } from "firebase-admin/app";

var serviceAccount = require("./admin-sdk.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

/// Sign-up
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
    const staff_ref = db.collection('staff');
    const client_ref = db.collection('clients');
    const users_ref = db.collection('users');
    const md_ref = db.collection('metadata');

    // Check whether user already exists
    const tent_user_id = await users_ref.where('username', '==', username).get();
    if (!tent_user_id.empty) {
        functions.logger.info(`username ${username} already exists`);
        return {'success': false, 'data': `username ${username} already exists`};
    }

    // Verify the role requirement
    if (!(role == 'staff' || role == 'client')) {
        functions.logger.info(`illegal role ${role} required`);
        return {'success': false, 'data': `illegal role ${role} required`};
    }

    // Get the new ID
    const next_id_doc = await md_ref.doc('next_id').get();
    var next_id = 1;
    if (!next_id_doc.exists) {
        functions.logger.warn('next_id data does not exist! this is only acceptable when testing.');
    }
    else {
        next_id = next_id_doc.get('next_id');
    }
    md_ref.doc('next_id').set({'next_id': next_id+1});
    const id = next_id;

    
    functions.logger.info('should pass.')

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

    return {'success': true, data: ''};

});

export const generateToken = functions.https.onCall( async (data, context) => {
    
    const username = data.username as string;
    const password = data.password as string;

    const db = admin.firestore();
    const users_ref = db.collection('users');

    // Get user data
    const user_query = await users_ref.where('username', '==', username).get();
    if (user_query.empty) {
        functions.logger.info(`username ${username} does not exist`);
        return {'success': false, 'data': `Username ${username} does not exist`};
    }
    else if (user_query.size > 1) {
        functions.logger.warn(`multiple users with name ${username} exist.`);
        return {'success': false, 'data': `Internal database error`};
    }
    
    // Verify user's password
    const user_entry = user_query.docs[0];
    if (password != user_entry.data().password) {
        functions.logger.info(`username ${username} attempted wrong password ${password}`);
        return {'success': false, 'data': `Wrong password`};
    }

    // If passed all checks
    functions.logger.info(`user ${username} passed login checks`);
    const role = user_entry.data().role
    const additional_claims = { 'role': role };
    try {
        const customToken = await admin.auth().createCustomToken(user_entry.id, additional_claims);
        functions.logger.info(`user ${username} got generated token`);
        return {'success': true, 'data': {'role': role, 'token': customToken}};
        functions.logger.error('SHOULD NOT GET HERE - AFTER RETURN');
    }
    catch (error) {
        functions.logger.warn(`login failed with error ${error}`);
        return {'success': false, 'data': 'Internal database error'};
    }
    functions.logger.warn(`login failed (control flow error)`);
    return {'success': false, 'data': 'Internal database error'};
});
