const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.checkFunction = functions.https.onCall(async (data, context) => {
    // return new Promise((resolve) => setTimeout(resolve, 5000)).then(async () => {
    //     return admin.firestore().collection('Users').doc('023fq5MpXbhPQuLmVPxCDgN7nAF3').get().then((doc) => {
    //         const data = doc.data().User_Details.firstName;
    //         return data;
    //     });
    // });
    return 'hello';
});

exports.checkNameCase = functions.auth.user().onCreate(async (user) => {
    return new Promise((resolve) => setTimeout(resolve, 5000)).then(async () => {
        return admin.firestore().collection('Users').doc(user.uid).get().then((doc) => {
            let firstName = doc.data().User_Details.firstName;
            let lastName = doc.data().User_Details.lastName;
            if (firstName[0] !== firstName[0].toUpperCase() || lastName[0] !== lastName[0].toUpperCase()) {
                if (firstName[0] !== firstName[0].toUpperCase()) {
                    firstName = firstName[0].toUpperCase() + firstName.slice(1);
                }
                if (lastName[0] !== lastName[0].toUpperCase()) {
                    lastName = lastName[0].toUpperCase() + lastName.slice(1);
                }
                return admin.firestore().collection('Users').doc(user.uid).update({
                    'User_Details.firstName': firstName,
                    'User_Details.lastName': lastName,
                });
            }
            return null;
        });
    });
});