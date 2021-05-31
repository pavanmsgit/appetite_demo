const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
const link = "notifications/{notification_id}";
exports.sendPush=functions.firestore.document(link).onWrite((change, context)=>{
  const title=change.after.data().title;
  const description=change.after.data().description;
  const token=change.after.data().token;
  console.log("title:"+title);
  console.log("description:"+description);
  console.log("token:"+token);
  const payload={
    notification: {
      title: title,
      body: description,
    },
  };
  return admin.messaging().sendToDevice(token, payload);
});
