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
      return db.ref("products/refrigeratorTray1000/d8bfc0ff35c9/minQuantity")
          .once("value", (snapshot) => {
            if (snapshot.exists()) {
              const minQuantity = snapshot.val();
              if (count < minQuantity) {
                console.log(count);
                console.log(minQuantity);
                db.ref("products/refrigeratorTray1000/d8bfc0ff35c9/usage")
                    .once("value", (usageSnapshot) => {
                      if (usageSnapshot.exists()) {
                        const usageName = usageSnapshot.val();
                        let notificationBody ="";
                        if (count==0) {
                          notificationBody =
                            "Your "+usageName+" tray is empty";
                        } else {
                          notificationBody =
                            "Your "+usageName+" tray contains only "+count;
                        }
                        const pay = {
                          notification: {
                            title: "Refrigerator Tray ALERT",
                            body: notificationBody,
                            badge: "1",
                          },
                          data: {
                            body: notificationBody,
                          },
                        };
                        const options = {
                          priority: "high",
                        };
                        db.ref(tokenSnapshot)
                            .once("value", (tokenSnapshot) => {
                              if (tokenSnapshot.exists()) {
                                const tokens:Array<string>=[];
                                tokenSnapshot.forEach((childSnapshot) => {
                                  console.log(childSnapshot.val());
                                  tokens.push(childSnapshot.val());
                                });
                                admin.messaging()
                                    .sendToDevice(tokens, pay, options)
                                    .then((response)=> {
                                      console
                                          .info("Successfully sent");
                                    }).catch(function(error) {
                                      console.warn("Error", error);
                                    });
                              }
                            });
                      }
                    });
              }
            }
          });
    });
