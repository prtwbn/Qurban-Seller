const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendChatNotification = functions.firestore
  .document('chats/{chatId}')
  .onCreate((snapshot, context) => {
    const messageData = snapshot.data();

    // Pastikan Anda memiliki field atau atribut yang mengindikasikan penerima pesan
    const recipientUserId = messageData.told;

    return admin.firestore().doc(`users/${recipientUserId}`).get().then(userDoc => {
      const registrationTokens = userDoc.data().fcmToken;

      const payload = {
        notification: {
          title: 'Pesan baru dari ' + messageData.senderName,
          body: messageData.last_msg,
        },
        token: registrationTokens
      };

      return admin.messaging().send(payload);
    });
  });
