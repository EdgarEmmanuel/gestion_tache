let admin = require("firebase-admin");

let serviceAccount = require("./flutter-gestion-tache-firebase-firebase-adminsdk-u2ay4-95b546e892.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://flutter-gestion-tache-firebase-default-rtdb.firebaseio.com"
});


exports.sendNotification= async (req, res) => {
    try{
        let payload = {
            // notification: {
            //     title: 'Nouvelle Tache Publique',
            //     body: 'new notification'
            // },
            data: {
                score: '850',
                time: '2:45',
                title: 'Nouvelle Tache Publique',
                body: 'new notification'
              },
        }

        await admin.messaging().sendToTopic("taches_publiques", payload);
    }catch(e){
        console.log(e);
    }
}