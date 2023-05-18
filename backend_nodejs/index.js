var express = require('express');
var bodyParser = require('body-parser')
let app = express();

// link : https://deeppatel23.medium.com/rest-api-with-node-js-and-firebase-4d618f1bbc60

const { getTasks , numberItem, 
    numberTaskEchue,numberTaskEnCours, numberTaskNotEnCours } = require("./endpoints/tasks");

 const { 
    getTasksNumberUser,
    numberTaskEchueForUser, 
    numberTaskEnCoursForUser,
    numberTaskNotEnCoursForUser,
    getTasksForUser,
    updateTask,
    deleteTask,
    addTask } = require("./endpoints/tasks_private");


const { updateTaskPublic } = require("./endpoints/tasks_public");

app.use(express.json());

app.use(bodyParser.urlencoded({
    extended: true
}));



const PORT = process.env.PORT || 5050;


app.get("/api/v1/tasks", getTasks);


app.get("/api/v1/tasks/number", numberItem);
app.get("/api/v1/tasks/public/echue", numberTaskEchue);
app.get("/api/v1/tasks/public/encours", numberTaskEnCours);
app.get("/api/v1/tasks/public/notencours", numberTaskNotEnCours);



app.get("/api/v1/tasks/user/:userID", getTasksForUser);
app.get("/api/v1/tasks/private/user/:userID", getTasksNumberUser);
app.get("/api/v1/tasks/private/echue/user/:userID", numberTaskEchueForUser);
app.get("/api/v1/tasks/private/encours/user/:userID", numberTaskEnCoursForUser);
app.get("/api/v1/tasks/private/notencours/user/:userID", numberTaskNotEnCoursForUser);
app.delete("/api/v1/tasks/private/delete/:id",deleteTask);
app.patch("/api/v1/tasks/private", updateTask);
app.post("/api/v1/tasks/private", addTask);



app.patch("/api/v1/tasks/public/user/:userAdmin", updateTaskPublic);


app.get('/', (req, res) => {
    res.send('This is my demo project')
})




app.listen(PORT, function () { console.log(`Demo project at: ${PORT}!`); });