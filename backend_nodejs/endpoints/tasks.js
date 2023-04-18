const { db } = require("../util/firebase");
const { collection, getDocs, addDoc } = require("firebase/firestore"); 

exports.getTasks = async (req, res) => {
    const querySnapshot = await getDocs(collection(db, "tasks"));
    //const booksRef = db.collection('tasks');
    try{
        let data = [];

        querySnapshot.forEach((doc) => {
            let t = doc.data()["date_echeance"] ;
            let date = new Date(t.seconds * 1000 + t.nanoseconds / 1000000);
            //.toLocaleTimeString('en-us', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
            
            console.log(date);
            let obj = { id: doc.id, date_echeance_second: date, ...doc.data()}
            data.push(obj);
          });
     res.status(201).json(data);
        
    } catch (error) {
        console.log(error);
        return res
        .status(500)
        .json({ general: "Something went wrong, please try again"});          
    }
};


exports.addTask = async (req, res) => {
    console.log(req.body);
    const querySnapshot = await getDocs(collection(db, "tasks"));
    //const booksRef = db.collection('tasks');
    try{
        let number = 0;

        querySnapshot.forEach((doc) => {
           number += 1;
          });


        const docRef = await addDoc(collection(db, "users"), {
            id: number,
            ...req.body
          });

        res.status(201).json({ response: docRef.id });
        
    } catch (error) {
        return res
        .status(500)
        .json({ general: "Something went wrong, please try again"});          
    }
};