const express = require('express');
const path = require('path');
const cors = require('cors')
const body_parser = require('body-parser')
fs = require('fs');


var app = express();
app.use(cors());
app.use(body_parser.json())

const port= 8080;
app.use('/sendFile',express.static(__dirname+'/WebFiles'))


app.use('/',express.static(__dirname+'/templates')
)
app.get('/go',(req,res)=>
{
    res.redirect('sendFile')
})
app.post('/transform',(req,res)=>
{


    data = req.body
  

      for(let i = 0;i<Object.keys(data).length;i++)
      {
        let equipo = data[i]
        let jugadores = equipo.children;

        for(let o = 0;o<Object.keys(jugadores).length;o++)
        {
          let fixedPlayer = jugadores[o][0];
          data[i].children[o] = fixedPlayer
        }
      }
      // console.log(equipos);
      let result = {
        "Name": "Root",
        "children": data
      }
      for(let i = 0;i<Object.keys(result.children).length;i++)
      {
          console.log(result.children[i]);
      }
      fs.writeFile('./WebFiles/files/jsonParsed', JSON.stringify(result),(err)=>{
          if(err)
          {
              console.log(err)
          }
      })
    



      res.redirect(307,'http://localhost/8080/sendFile');
})
app.listen(port,()=>
    {
        console.log(`Listening on port ${port}`);
    });


