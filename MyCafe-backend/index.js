require("dotenv").config();
const dotenv = require("dotenv");
const express = require("express");
const cors = require("cors");
const app = express();
const mongoose = require("mongoose");
const bodyparser = require("body-parser");

const http = require("http");
const server = http.createServer(app);
const db = mongoose.connection;

app.use(express.json());
app.use(express.static("public"));
app.use(bodyparser.urlencoded({ extended: true }));
server.listen(process.env.PORT || 4000, () => {
  console.log("listening on 4000");
});

app.use(express.json());
app.use(cors());
dotenv.config();
const schema = new mongoose.Schema({
  username: String,
  password: String,
});
const schema2 = new mongoose.Schema({
  username: String,
  data: {
    id: [String],
    date_time: [String],
    order: [String],
    status: [String],
  },
});
mongoose.connect(process.env.DBURL);
const user2 = mongoose.model("users", schema);
const userdata2 = mongoose.model("userdata", schema2);
function createusers( username,  password)
{
  const person2 = db.collection("users").insertOne({ username: username, password: password },async (err, user) => {
      if (err != null){ console.log(err);return 'error';}
      else if (user != null) {console.log(user);return 'useralready present';}
    }
  );
  return 'done';
}
function createuserdata(username)
{
  const person3 = db.collection("userdata").insertOne({username: username,data: { id: [], date_time: [], order: [], status: [] },},
    async (err, user) => {
      if (err != null) {
        console.log(err);
        return 'error';
      } 
    }
  );
  
  return 'done';
}
function createbalance(username)
{
  const person4 = db.collection("balance").insertOne({username: username,balance:0,},async (err, user) => {
        if (err != null) {
          console.log(err);
         return 'error';
        } 
      }
    );
    return 'done';
}
app.post("/register", function (req, res) {
  let username = (req.body.username); //
  let password = req.body.password; // hashed password
  console.log(username + " " + password);
  const person = db
    .collection("users")
    .findOne({ username: username }, async (err, user) => {
      if (err) {
        res.json("error");
        return;
      } else if (user == null) {
        let  status = createusers(username,password);
        status = createuserdata(username);
        status = createbalance(username);        
        res.json(status);
        
      } else {
        // res.json("found");
        res.sendStatus(400);
        return;
      }
    });
   
 
    
});
app.post("/login", function (req, res) {
  let username = req.body.username; //
  let password = req.body.password; // hashed password
  const person = db
    .collection("users")
    .findOne({ username: username }, async (err, user) => {
      if (err) res.json("error");
      else if (user == null) res.sendStatus(401);
      else if (password != user.password)
        res.sendStatus(401); //  password didnt matched so unauotized
      else res.json("login"); //login
    });
});
app.get("/getdata", function (req, res) {
  //http://localhost:4000/getdata?username=Parimal12345
  let username = req.query.username;
  const user = db
    .collection("userdata")
    .findOne({ username: username }, async (err, data) => {
      if (err) res.json("error");
      else res.json(data); //login
    });
});
app.get("/getbalance", function (req, res) {
  //http://localhost:4000/getbalance?username=Parimal12345
  let username = req.query.username;
  const user = db
    .collection("balance")
    .findOne({ username: username }, async (err, data) => {
      if (err) res.json("error");
      else 
      {
        console.log(data);
        res.json(data.balance);
       } //login
    });
});
app.post("/adddata", function (req, res) {
  let username = req.body.username;
  let id = req.body.id;
  let time = req.body.date_time;
  console.log(time);
  let order = req.body.order;
  let status = req.body.status;
  const user = db.collection("userdata").findOne({ username: username }, async (err, data) => {
      if (err) {
        res.json("error");
        return;
      } else {
        let id2=[id];let time2=[time];let order2=[order];
         let status2=[status];
        for( var i =0;data["data"]["id"]!=null && i<data["data"]["id"].length;i++)
        id2.push(data["data"]["id"][i])
        for( var i =0;data["data"]["time"]!=null && i<data["data"]["time"].length;i++)
        time2.push(data["data"]["time"][i]);
        for( var i =0;data["data"]["order"]!=null && i<data["data"]["order"].length;i++)
        order2.push(data["data"]["order"][i]);
        for( var i =0;data["data"]["status"]!=null && i<data["data"]["status"].length;i++)
        status2.push(data["data"]["status"][i]);
       let data2={id:id2,time:time2,order:order2,status:status2};
        console.log(data2);
        const person = db.collection("userdata").updateOne({username:username},{$set:{username:username,data:data2}},async(err)=>{
          console.log(err);
        });
      }
    });

  res.sendStatus(200);
});
app.post("/updatebalance", function (req, res) {
  let username = req.body.username;
  let cost = req.body.cost;//number
  let operation = req.body.operation;
  db.collection("balance").findOne({ username: username }, async (err, current) => {
      if (err) res.sendStatus(404);
      else {
        const person = db.collection("balance").updateOne({username:username},{$set:{username:username,balance:operation=="+"?(Number(current.balance)+Number(cost)):(Number(current.balance)-Number(cost))}},async(err)=>{
          console.log(err);
        });
        res.sendStatus(200);
      } //login
    });
});
