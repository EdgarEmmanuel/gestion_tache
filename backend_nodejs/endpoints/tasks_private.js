const { db } = require("../util/firebase");
const { collection, getDocs, addDoc, updateDoc, doc , deleteDoc } = require("firebase/firestore"); 


exports.getTasksNumberUser = async (req, response) => {
    const querySnapshot = await getDocs(collection(db, "tasks"));
    const {userID} = req.params;

    //console.log(userID);
    try{
        let number = 0;

        querySnapshot.forEach((doc) => {
            if(doc.data()['userID']== userID)
            {
                number += 1;
            }

          });
          
          response.status(201).json({ number: number });
                            
    } catch (error) {
        console.log(error);       
    }
};

var dateInPast = function(firstDate, secondDate) {
    if (firstDate.setHours(0, 0, 0, 0) <= secondDate.setHours(0, 0, 0, 0)) {
      return true;
    }
  
    return false;
};


exports.numberTaskEchueForUser = async (req, res) => {
    const querySnapshot = await getDocs(collection(db, "tasks"));   
    const {userID} = req.params;
        try{
            let number = 0;
    
            querySnapshot.forEach((doc) => {
                    if( doc.data()['userID']== userID ){
                        let t = doc.data()["date_echeance"] ;
                        let date_echeance = new Date(t.seconds * 1000 + t.nanoseconds / 1000000);
                        var today = new Date();
                        if(dateInPast(date_echeance, today)){
                            number += 1;
                        }
                    }
              });
         res.status(201).json({ number : number });
        
        } catch (error) {
        console.log(error);     
        }
};


exports.numberTaskEnCoursForUser = async (req, res) => {
    const querySnapshot = await getDocs(collection(db, "tasks"));   
    const {userID} = req.params;
        try{
            let number = 0;
    
            querySnapshot.forEach((doc) => {
                if(doc.data()['userID']== userID)
                {
                    let t = doc.data()["date_echeance"] ;
                    let date_echeance = new Date(t.seconds * 1000 + t.nanoseconds / 1000000);
                    var today = new Date();
                    if(date_echeance.setHours(0,0,0,0) == today.setHours(0,0,0,0)) {
                        number += 1;
                    }
                }
              });
         res.status(201).json({ number : number });
        
        } catch (error) {
        console.log(error);     
        }
};

exports.numberTaskNotEnCoursForUser = async (req, res) => {
    const querySnapshot = await getDocs(collection(db, "tasks"));   
    const {userID} = req.params;
        try{
            let number = 0;
    
            querySnapshot.forEach((doc) => {
                if(doc.data()['userID']== userID)
                {
                    let t = doc.data()["date_echeance"] ;
                    let date_echeance = new Date(t.seconds * 1000 + t.nanoseconds / 1000000);
                    var today = new Date();
                    if(!dateInPast(date_echeance, today)) {
                        number += 1;
                    }
                }
              });
         res.status(201).json({ number : number });
        
        } catch (error) {
        console.log(error);     
        }
};


exports.getTasksForUser = async (req, response) => {
    const querySnapshot = await getDocs(collection(db, "tasks"));
    const {userID} = req.params;
    try{
        let data = [];

        querySnapshot.forEach((doc) => {
            if(doc.data()['userID']== userID)
            {
                let doc_id = doc.ref.id ;
                let t = doc.data()["date_echeance"] ;
                let date = new Date(t.seconds * 1000 + t.nanoseconds / 1000000);
                let obj = { id: doc.id, date_echeance_second: date, doc_id: doc_id, ...doc.data()}
                data.push(obj);
            }

          });
          response.status(201).json(data);
                            
    } catch (error) {
        console.log(error);       
    }
};


exports.updateTask = async (request, response) => {
    try{

        const date = new Date(request.body.date_echeance);

        const docRef = doc(db, "tasks", request.body.doc_id);

        const data = {
            //id: parseInt(request.body.id),
            title: request.body.title,
            description: request.body.description,
            date_echeance: date,
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