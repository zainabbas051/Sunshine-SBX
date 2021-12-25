({
    file: '', //holding file instance
    myFile: '',
    fileType: '', //holding file type
    fileReaderObj: '',
    base64FileData: '',
    MainFileUploaded: 'false',
    IconFileUploaded: 'false',
    handleSubmit: function(component,row) {

     this.updateOngoingCertifications(component,row,'Request Reinbursement');


    },

    uploadFileInAWS: function(component,helper,row) {
     component.set("v.spinner",true);
        debugger;
        var file;
        var file1
		debugger;
        if(component.find("MainfileUpload").get("v.files") != null){
            file1 = component.find("MainfileUpload").get("v.files")[0];
        }
        var fileContent1 = component.get('v.fileContent1');
        if(fileContent1 != undefined){
            this.updateOngoingCertificationsJs(component, fileContent1, file1,row,'Request Reinbursement');
        }
    },

    updateOngoingCertificationsJs : function(component, aFileContent, file, row,type){
      
        debugger;      
        var rowId=row.Id;
        var fileName = $A.localizationService.formatDate(new Date(), "YYYYMMDDhhmmss") + '_'+ file.name;
        var fileUrl = 'http://revenuecollections.s3.amazonaws.com/Production/'+fileName;
        var action = component.get("c.updateOngoingCertifications");
        action.setParams({ EmpcertId : rowId ,
                         updateType : type,
                         awsUrl : fileUrl,certDate : null});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.fileUploadJs(component, aFileContent, file,type,fileName);   
            }
        });
        $A.enqueueAction(action);
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
    },

    fileUploadJs : function(component, aFileContent, file, type,fileName){

        debugger;
        const AWS = window.AWS;
        AWS.config.region = 'us-west-2';
        AWS.config.update({accessKeyId: 'AKIAIPYELBFZS47EKG7A', secretAccessKey: '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'});
        var blobContent = this.dataURItoBlob(aFileContent,file.type);
        var params = {ContentType: file.type, Body: blobContent};
        var bucket = new AWS.S3(
        {
          params:
            { 
            
              Bucket: 'revenuecollections',
              Key: 'Production/ClinicalPortal/Reimbursement/' + fileName
            }
        });
        
        bucket.upload(params, function (err, data) {

            if(err == null){
               // $A.get('e.force:refreshView').fire(); 
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "The certification has been successfully " + type 
                     
                }); 
                
                location.reload();
            }
            
        });
        
    },

    getColumn : function(component) {

        var actions = [
           
            
        ];
        
        component.set('v.columns', [
			
            {label: 'Certification Name', fieldName: 'Certification_Name__c', type: 'text'},
            {label: 'Status', fieldName: 'Status__c', type: 'text'},
            {label: 'Submitted/Completed Date', fieldName: 'Submitted_Completed_Date__c', type: 'date' , typeAttributes: { month: '2-digit', day: '2-digit', year : "numeric"}}  
     
           
        	
        ]);
    },

    getData : function(component,helper){
       debugger;
        var empID=component.get("v.empID");
        var action = component.get("c.GetCompletedCertification");
        action.setParams({ empID : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
            }
        });
        $A.enqueueAction(action);
    }
})