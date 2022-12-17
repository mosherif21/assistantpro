import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.database();
const tokenSnapshot=
  "products/refrigeratorTray1000/d8bfc0ff35c9/notificationTokens";
exports.Notifications = functions.database
    .ref("products/refrigeratorTray1000/d8bfc0ff35c9/currentQuantity")
    .onUpdate((snap) => {
      const count = snap.after.val();
      db.ref("products/refrigeratorTray1000/d8bfc0ff35c9/minQuantity")
          .once("value", (snapshot) => {
            if (snapshot.exists()) {
              const minQuantity = snapshot.val();
              if (count < minQuantity) {
                db.ref("products/refrigeratorTray1000/d8bfc0ff35c9/usage")
                    .once("value", (usageSnapshot) => {
                      const usageName = usageSnapshot.val();
                      const notificationBody: string =
                        "Your "+usageName+"tray contains only "+count;
                      const payload = {
                        notification: {
                          title: "Refrigerator Tray ALERT",
                          body: notificationBody,
                          badge: "1",
                          sound: "default",
                        },
                      };
                      db.ref(tokenSnapshot)
                          .once("value", (tokenSnapshot) => {
                            if (tokenSnapshot.exists()) {
                              tokenSnapshot.forEach((childSnapshot) => {
                                const token = Object.keys(childSnapshot.val());
                                admin.messaging().sendToDevice(token, payload);
                              });
                            }
                          });
                    });
              }
            }
          });
    });
