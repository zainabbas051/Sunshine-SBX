({
    
   file: '', //holding file instance
    myFile: '',
    fileType: '', //holding file type
    fileReaderObj: '',
    base64FileData: '',
    MainFileUploaded: 'false',
    IconFileUploaded: 'false',
    handleSubmit: function(component,row) {

     this.updateOngoingCertifications(component,row,'Completed');


    },

    uploadFileInAWS: function(component,helper,row) {
        debugger;
        var file;
        var file1
		debugger;
        if(component.find("MainfileUpload").get("v.files") != null){
            file1 = component.find("MainfileUpload").get("v.files")[0];
        }
   
        var fileContent1 = component.get('v.fileContent1');
       
  
        if(fileContent1 != undefined){
           
            this.updateOngoingCertificationsJs(component, fileContent1, file1,row,'Completed');
            //return;
        }
    },

    updateOngoingCertificationsJs : function(component, aFileContent, file, row,type){
      
        debugger;      
        var rowId=row.Id;
        var today = $A.localizationService.formatDate(new Date(), "YYYYMMDDhhmmss");
        var fileName = today+'_'+file.name;
        var fileUrl = 'https://revenuecollections.s3.amazonaws.com/Production/'+fileName;
        var action = component.get("c.updateOngoingCertifications");
        var certDate = component.get("v.certificateDate");
        action.setParams({ EmpcertId : rowId ,
                         updateType : type,
                          awsUrl : fileUrl,certDate : certDate});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.fileUploadJs(component, aFileContent, file,type,fileName);   
            }
        });
        $A.enqueueAction(action);
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
            { Bucket: 'revenuecollections',
              Key: 'Production/'+fileName
            }
        });

        
        
        bucket.upload(params, function (err, data) {
            debugger;
            if(err == null){
              
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "The certification has been successfully " + type 
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
    },

    getUtilizedBudget : function(component){
        var empID = component.get("v.empID");
        var action = component.get("c.getEmployeeDetail");
        action.setParams({ empId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                alert('success');
                var resultData = response.getReturnValue();
                component.set("v.employeeData", resultData);
            }
        });
        $A.enqueueAction(action);
    }
,
    getColumn : function(component) {

        var actions = [
           
            
        ];
       
        component.set('v.columns', [
			
            {label: 'Certification Name', fieldName: 'Certification_Name__c', type: 'text'},
            {label: 'Status', fieldName: 'Status__c', type: 'text',initialWidth: 95},
           
            
            {
                type:  'button',
                typeAttributes: 
                {
                  iconName: 'utility:check',
                  label: 'Completed', 
                  name: 'completeRecord', 
                  title: 'Completed', 
                  disabled: false, 
                  value: ''
                },
                initialWidth: 150,
                cellAttributes: { alignment: 'right' }
              },
           {
                type:  'button',
                typeAttributes: 
                {
                  iconName: 'utility:internal_share',
                  label: 'Request Reinbursement', 
                  name: 'ReinbursementRecord', 
                  title: 'Request Reinbursement', 
                  disabled: false, 
                  value: ''
                },initialWidth: 250,
              }
           
        	
        ]);
    },

    getData : function(component,helper){
       
        var empID=component.get("v.empID");
        var action = component.get("c.GetOngoingCertification");
        action.setParams({ empID : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
              

            }
        });
        $A.enqueueAction(action);
    },
    completeOngoingCertifications : function(component,row){
      
      debugger;
        var rowId=row.Id;
        var action = component.get("c.CompleteCertification");
        
        action.setParams({ EmpcertId : rowId });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
          
                try {

                    $A.get('e.force:refreshView').fire();
                
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: 'Success',
                            message: 'The Certification has been submitted for approval',
                            duration: ' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                    catch (err) {
                        alert('The Certification has been submitted for approval');
                    }
                

                
            }
        });
        $A.enqueueAction(action);
    }
    
    
})