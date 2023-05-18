var express = require('express');
var bodyParser = require('body-parser')
let app = express();

// link : https://deeppatel23.medium.com/rest-api-with-node-js-and-firebase-4d618f1bbc60

const { getTasks, deleteTask , addTask, updateTask, numberItem, numberTaskEchue,numberTaskEnCours } = require("./endpoints/tasks");
app.use(express.json());

app.use(bodyParser.urlencoded({
    extended: true
}));



const PORT = process.env.PORT || 5050;


app.get("/api/v1/tasks", getTasks);
app.delete("/api/v1/taskDelete/:id",deleteTask);
app.post("/api/v1/tasks", addTask);
app.get("/api/v1/tasks/number", numberItem);
app.get("/api/v1/tasks/public/echue", numberTaskEchue);
app.get("/api/v1/tasks/public/encours", numberTaskEnCours);

app.patch("/api/v1/tasks", updateTask);


app.get('/', (req, res) => {
    res.send('This is my demo project')
})




app.listen(PORT, function () { console.log(`Demo project at: ${PORT}!`); });