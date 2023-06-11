import React, { useEffect, useState } from 'react';
import Content from './content'; 
import Orderid from './orderid';

import './App.css';
import firebase from './firebase';
const App = () => {
  const [data, setData] = useState([]);
  

  useEffect(() => {
    const dbRef = firebase.database().ref();

    dbRef.on('value', snapshot => {
      const newData = snapshot.val();

      if (newData) {
        console.log(newData);
        let array=[];
        for(let key in newData)
        {
            let value = newData[key];
            for(let key2 in value)
            {
              let temp={'key':key2,'id':value[key2]["id"],'username':value[key2]["username"], 'order': value[key2]["order"],'date_time':value[key2]["date_time"] };
              array.push(temp);

            }
            // console.log(value[key2]["id"],value[key2]["username"], value[key2]["date_time"],  value[key2]["order"])
        }
        setData(array);
      }
    });

    return () => {
      dbRef.off();
    };
  }, []);

  
  
  const remove=async (key)=>{
    
    const response = await fetch('https://mycafe-backend.onrender.com/adddata', {
      method: 'POST',
      mode:'cors',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({"username":key["username"],"id":key["id"],"order":key["order"],"date_time":key["date_time"]}),
    });

   if(response.status == 200)
   {        
    const newItemRef = firebase.database().ref("/"+key["username"]+"/"+key["key"]);
    newItemRef.remove().then(function() {
    console.log("Data removed successfully!");
    // console.log(firebase.database().ref());
    const newItemRef = firebase.database().ref();
    newItemRef.once('value').then(function(snapshot) {
      var size = snapshot.numChildren();
      console.log('Size of Firebase reference:', size);
      if(size==0)
      window.location.reload();
    });})
 .catch(function(error) {
    console.error("Error removing data:", error);
  });
   }
   

  }
  return (
    <div className="App">
     <div className='heading'>MyCafe Cook</div>
     <div className='extraspace'></div>
     <div className='Table'>
     <div  className='Orderid1'>ID</div>
     <div  className='Username'>User</div>    
     <div  className='Order1'>Order</div>      
    </div>

    <div className='childTable'>
       {
        data.map((item,index)=>(
          
          <div className='Table2'>
          <Orderid content={item["id"]}/>
          <Orderid content={item["username"]}/>
          <Content ordercontent={item["order"]}/>
          <button className='removebutton' onClick={()=>remove(item)}>Order Done</button>
          
          
          </div>
        ))
       }
       
    </div>   



    </div>
  );
}

export default App;
