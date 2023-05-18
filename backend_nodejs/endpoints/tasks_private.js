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
                if( doc.data()['userID']== userID )
                {
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


exports.getTasksForUser = async (req, response) => {
    const querySnapshot = await getDocs(collection(db, "tasks"));
    try{
        let data = [];

        querySnapshot.forEach((doc) => {
            if(doc.data()['userID']=="0")
            {
            let doc_id = doc.ref.id ;
            let t = doc.data()["date_echeance"] ;
            let date = new Date(t.seconds * 1000 + t.nanoseconds / 1000000);
            let obj = { id: doc.id, date_echeance_second: date, doc_id: doc_id, ...doc.data()}
            data.push(obj);
            }

          });
            
          if (response) {
            response.status(201).json(data);
          } else {
            console.log("Response is undefined");
          }
                            
    } catch (error) {
        console.log(error);
     //   return res
      //  .status(500)
        //.json({ general: "Something went wrong, please try again"});          
    }
};