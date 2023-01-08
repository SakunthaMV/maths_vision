const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.checkFunction = functions.https.onCall(async (data, context) => {
    return "Function Work Correctly."
});