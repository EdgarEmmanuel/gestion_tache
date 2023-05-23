const { db } = require("../util/firebase");
const { collection, getDocs, addDoc, updateDoc, doc , deleteDoc } = require("firebase/firestore"); 


exports.updateTaskPublic = async (request, response) => {
    const { userAdmin } = request.params ;
    try{

        const date = new Date(request.body.date_echeance);

        const docRef = doc(db, "tasks", request.body.doc_id);

        const data = {
            //id: parseInt(request.body.id),
            title: request.body.title,
            description: request.body.description,
            date_echeance: date,
            modify_by_user: userAdmin
        };

          updateDoc(docRef, data)
                .then(docRef => {
                    //console.log("An Update Has Been Done");
                })


        return response.status(201).json({ success: true , statusCode: 201 });
        
    } catch (error) {
        return response
        .status(500)
        .json({ general: "Something went wrong, please try again"});          
    }
};



exports.addTaskPublic = async (request, response) => {
    //console.log(request.body);
    const querySnapshot = await getDocs(collection(db, "tasks"));
    try{
        let number = 0;

        querySnapshot.forEach((doc) => {
           number += 1;
          });


        const date = new Date(request.body.date_echeance);

        await addDoc(collection(db, "tasks"), {
            id: number + 1,
            title: request.body.title,
            description: request.body.description,
            date_echeance: date,
            userID: "0",
            created_by_user: request.body.userID,
            modify_by_user: request.body.userID
          });


        

    } catch (error) {
        return response
        .status(500)
        .json({ general: "Echec de j'aout de tache ! "});          
    }
};
