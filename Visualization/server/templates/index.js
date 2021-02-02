

document.getElementById("FileUpload").addEventListener("click", function(){
    var file = document.getElementById("file-selector").files[0];
    var filereader= new FileReader()
    filereader.onload = (evt)=>{
      let FileData = evt.target.result
      let playerData = JSON.parse(FileData)
      axios.post('/transform',playerData)
    }

    filereader.onerror = function (evt) {
      console.log("error reading file");
    }

    filereader.readAsText(file)
    window.location.href = 'http://localhost:8080/sendFile'
    //location.assign('/sendFile');
  })