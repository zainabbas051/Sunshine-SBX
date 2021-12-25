({
    file: '', //holding file instance
    myFile: '',
    fileType: '', //holding file type
    fileReaderObj: '',
    base64FileData: '',
    MainFileUploaded: 'false',
    IconFileUploaded: 'false',
    SaveWithoutAttachment1: 'false',
    SaveWithoutAttachment2: 'false',

    handleSubmit: function(component) {
        debugger;

        component.find("Challengetype").set("v.value",component.get("v.type"));

        component.find("recordEditForm").submit();
       


    },

    uploadFileInAWS: function(component) {
        component.set("v.spinner", true);
        debugger;
        var file;
        var file1;
        var SaveWithoutAttachment= false;
        var SaveWithoutAttachment1= false;
        var fields = component.find("ContentFields");
       
        fields.forEach(function(field) {
         
            if (field.get("v.fieldName") === 'Name') {
                component.set("v.contentName",field.get("v.value"));
            }

        });
        var key='Production/AlumniApp/Challenges/'+component.get("v.type")+'/'+component.get("v.contentName")+'/';
        var mainUrl = 'http://sunshine-alumni-mobile-app.s3.amazonaws.com/'+key;
        var url;
        var today = $A.localizationService.formatDate(new Date(), "YYYYMMDDhhmmss");
        if(component.find("ThumbnailfileUpload").get("v.files") != null){
            file = component.find("ThumbnailfileUpload").get("v.files")[0];
        }
        if(component.find("MainfileUpload").get("v.files") != null){
            file1 = component.find("MainfileUpload").get("v.files")[0];
        }
        

        var fileName; 
        var file1Name; 
       

        if(file != undefined){
            fileName = today +'_' +file.name;
            url = mainUrl+fileName;
            component.find("ThumbnailImageField").set("v.value", url);
        }
        else{
            
            SaveWithoutAttachment=true;
        }

        if(file1 != undefined){
            file1Name = today +'_' +file1.name;
            url = mainUrl+file1Name;
            component.find("MainImageField").set("v.value", url);
        }
        else{
            
            SaveWithoutAttachment1=true;
        }


        this.handleSubmit(component);
        this.prepareFileToUpload(component,file,file1,fileName,file1Name,SaveWithoutAttachment1,SaveWithoutAttachment);
        
        //this.handleSubmit(component);
    },

    prepareFileToUpload : function(component,file,file1,fileName,file1Name,SaveWithoutAttachment1,SaveWithoutAttachment){
		if(SaveWithoutAttachment==true && SaveWithoutAttachment1==true){
            component.set("v.spinner", false);
             $A.get('e.force:refreshView').fire();
        }
        component.set("v.spinner", true);
        debugger;
        var fileContent = component.get('v.fileContent');
        var fileContent1 = component.get('v.fileContent1');
        
        
        if(fileContent != undefined){
            
            this.fileUploadJs(component, fileContent, file,'',fileName);
            if(SaveWithoutAttachment1==true){
                component.set("v.spinner", false);
                 $A.get('e.force:refreshView').fire();
            }
        }

        if(fileContent1 != undefined){
            this.fileUploadJs(component, fileContent1, file1,'Main',file1Name);
             if(SaveWithoutAttachment==true){
                component.set("v.spinner", false);
                  $A.get('e.force:refreshView').fire();
            }
        }
        
       
    },
    fileUploadJs : function(component, aFileContent, file,type,fileName){
		component.set("v.spinner", true);
        const AWS = window.AWS;
        AWS.config.region = 'us-west-2';
        AWS.config.update({accessKeyId: 'AKIAIPYELBFZS47EKG7A', secretAccessKey: '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'});
        var blobContent = this.dataURItoBlob(aFileContent,file.type);
        var params = {ContentType: file.type, Body: blobContent};
        var key='Production/AlumniApp/Challenges/'+component.get("v.type")+'/'+component.get("v.contentName")+'/';
        var bucket = new AWS.S3(
        {
          params:
            { Bucket: 'sunshine-alumni-mobile-app',
              //Key: 'Production/AlumniApp/'+ fileName
              Key: key+ fileName
            }
        });

        bucket.upload(params, function (err, data) {
           
            if(type == 'Main'){
                debugger;
                component.set("v.spinner", false);
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "Content Uploaded Successfully"
                });
                
               $A.get('e.force:refreshView').fire();
            }
            
        });
    },

    dataURItoBlob : function(dataURI, type) {
        // convert base64 to raw binary data held in a string
        var byteString = atob(dataURI);
    
        // separate out the mime component
      //  var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
    
        // write the bytes of the string to an ArrayBuffer
        var ab = new ArrayBuffer(byteString.length);
        var ia = new Uint8Array(ab);
        for (var i = 0; i < byteString.length; i++) {
            ia[i] = byteString.charCodeAt(i);
        }
    
       
        var bb = new Blob([ab], { type: type });
        return bb;
    }


})