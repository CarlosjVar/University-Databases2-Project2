const express = require('express');
const path = require('path');


var app = express();
const port= 8080;
app.use('/sendFile',express.static(__dirname+'/WebFiles'))
// app.get('/sendFile',(req,res)=>
// {
//     res.sendFile(path.join(__dirname,'/index.html'));
// })
app.use('/',express.static(__dirname+'/templates')
)
app.get('/go',(req,res)=>
{
    res.redirect('sendFile')
})

app.listen(port,()=>
    {
        console.log(`Listening on port ${port}`);
    });


