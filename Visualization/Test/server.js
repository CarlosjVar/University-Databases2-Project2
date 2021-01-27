const express = require('express');
const path = require('path');


var app = express();
const port= 8080;
app.use(express.static(__dirname))
app.get('/',(req,res)=>
{
    res.sendFile(path.join(__dirname,'/index.html'));
})
app.listen(port,()=>
    {
        console.log(`Listening on port ${port}`);
    });


