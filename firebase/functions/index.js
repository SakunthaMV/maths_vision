const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.checkFunction = functions.https.onCall(async (data, context) => {
    return 'hello';
});

exports.createUserData = functions.auth.user().onCreate(async (user) => {
    const currentDate = new Date();
    const createdMonth = currentDate.getMonth() + 1;
    const createdDate = currentDate.getDate();
    const userDocRef = admin.firestore().collection('Users').doc(user.uid);
    return userDocRef.set({
        User_Details: {
            coins: 50,
            xp: 0,
            level: 1,
            currentRank: 0,
            bestRank: 0,
            average_time: 0,
        },
        LogIn_Details: {
            day: createdDate,
            month: createdMonth,
            loginDays: 1,
            Owned_Days: {
                1: false,
                2: false,
                3: false,
                4: false,
                5: false,
                6: false,
                7: false,
            },
        },
        Collection: {
            Coupons: {
                Answer_Coupons: {},
                Video_Coupons: {},
            },
            Double_XP_Cards: {
                Silver_Double_XP: {
                    available: 0,
                    used: 0,
                },
                Golden_Double_XP: {
                    available: 0,
                    used: 0,
                },
            },
            Vouchers: {
                Answer_Vouchers: {
                    available: 0,
                    used: 0,
                },
                Video_Vouchers: {
                    available: 0,
                    used: 0,
                },
            },
            Bonus_Cards: {
                available: 0,
                used: 0,
            },
        },
    }, { merge: true }).then(() => {
        const docIds = ['Golden_Stage', 'Event_Info', 'Stages'];
        const batch = admin.firestore().batch();
        docIds.forEach((docId) => {
            const docRef = userDocRef.collection('Trigonometry_Event').doc(docId);
            switch (docId) {
                case 'Golden_Stage':
                    batch.set(docRef, {
                        Entry_Tasks: {
                            accuracyTask: false,
                            leaderboardTask: false,
                            loginTask: false,
                            rulesDialog: false,
                        },
                        Stage_Info: {
                            completed: 0,
                            correct: 0,
                            xpEarned: 0,
                        },
                    }, { merge: true });
                    break;
                case 'Event_Info':
                    batch.set(docRef, {
                        progress: 0.0,
                        totalCompleted: 0,
                        totalCorrect: 0,
                        xpEarned: 0,
                        currentRank: 0,
                        bestRank: 0,
                        goldenStageUnlocked: false,
                    }, { merge: true });
                    break;
                case 'Stages':
                    for (let i = 1; i < 11; i++) {
                        var stage = 'Stage_' + i;
                        batch.set(docRef, {
                            [stage]: {
                                Info: {
                                    completed: 0,
                                    correct: 0,
                                    xpEarned: 0,
                                    stage: i,
                                    Video: {
                                        purchased: false,
                                        liked: false,
                                        commented: false,
                                    }
                                },
                                Questions_Details: {
                                    Question_1: {
                                        correct: false,
                                        done: false,
                                        xpDoubleUsed: false,
                                        answerBought: false,
                                        question: 1,
                                        selectedValue: '',
                                    }
                                }
                            }
                        }, { merge: true });
                    }
                    break;
            }
        });
        return batch.commit();
    }).then(() => {
        const eventRef = admin.firestore().collection('Events');
        const stageRef = eventRef.doc('Trigonometry').collection('Stages');
        for (let i = 1; i < 11; i++) {
            var stage = 'Stage_' + i;
            stageRef.doc(stage).update({
                TotalUnlocked: admin.firestore.FieldValue.increment(1),
            });
            stageRef.doc(stage).collection('Questions').doc('Question_1').update({
                Unlocked: admin.firestore.FieldValue.increment(1),
            });
        }
        eventRef.doc('Trigonometry').update({
            TotalUnlocked: admin.firestore.FieldValue.increment(10),
        });
        eventRef.doc('All_Events').update({
            AllUnlocked: admin.firestore.FieldValue.increment(10),
        });
    });
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