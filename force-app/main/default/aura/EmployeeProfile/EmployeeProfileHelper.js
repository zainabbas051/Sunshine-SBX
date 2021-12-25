({
    file: '', //holding file instance
    myFile: '',
    fileType: '', //holding file type
    fileReaderObj: '',
    base64FileData: '',
    MainFileUploaded: 'false',
    IconFileUploaded: 'false',
    handleSubmit: function(component) {


        component.find("recordEditForm").submit();
       // $A.get('e.force:refreshView').fire();


    },

    uploadFileInAWS: function(component) {
        debugger;
        var file;
        var file1

        if(component.find("MainfileUpload").get("v.files") != null){
            file1 = component.find("MainfileUpload").get("v.files")[0];
        }
   
        var fileContent1 = component.get('v.fileContent1');
       
  
        if(fileContent1 != undefined){
            this.fileUpload(component, fileContent1, file1, 'Main');
            return;
        }
        this.handleSubmit(component);
       
       

    },
    updateEmp:function(component){
        debugger;
         var updateEmp = component.get("c.updateEmployee");
        var empObj=component.get("v.EmpProfile");
        updateEmp.setParams({

            selectedEmpObj: empObj,
            
        });
        updateEmp.setCallback(this, function(response) {

            var state = response.getState();

            if (state == 'ERROR') {
                var errors = response.getError();
                console.logs(errors);
            }
            if (state == "SUCCESS") {
                
                
                try {

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'Success',
                        message: 'Content Uploaded Successfully',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.isEdit", false);
                } catch (err) {
                    alert('Error in uploading File');
                }
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(updateEmp);

        
    }
,
    fileUpload: function(component, aFileContent, file, ImageType) {

        var uploadFileToAWS = component.get("c.uploadFileToAWS");
        uploadFileToAWS.setParams({

            strfileName: file.name,
            fileType: file.type,
            fileContent: encodeURIComponent(aFileContent)
        });
        uploadFileToAWS.setCallback(this, function(response) {

            var state = response.getState();

            if (state == 'ERROR') {
                var errors = response.getError();
                console.logs(errors);
            }
            if (state == "SUCCESS") {
                var Url = response.getReturnValue();
                if (ImageType == 'Main') {

                    component.find("MainImageField").set("v.value", Url);
                    this.handleSubmit(component);

                }
                if (ImageType == 'Thumbnail') {
                    component.find("ThumbnailImageField").set("v.value", Url);
                }


                try {

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'Success',
                        message: 'Content Uploaded Successfully',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                } catch (err) {
                    alert('Error in uploading File');
                }
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(uploadFileToAWS);

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
    
    getBudgetDetail : function(component){
        var empID = component.get("v.empID");
        var action = component.get("c.getBudgetDetail");
        action.setParams({ empId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                //alert('success');
                var resultData = response.getReturnValue();
                component.set("v.budgetDetail", resultData);
                component.set("v.budgetUtilization",resultData.Utilized_Budget__c);
                component.set("v.allocatedBudget",resultData.Allocated_Budget__c);
                component.set("v.availableBudget",resultData.Available_BudgetF__c);
                
            }
        });
        $A.enqueueAction(action);
    },
    getEmpProfile : function(component){
        debugger;
        var empID = component.get("v.empID");
        var action = component.get("c.getEmployeeProfileInfo");
        action.setParams({ empId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                //alert('success');
                var resultData = response.getReturnValue();
                component.set('v.showClinicalDashboard',false);
                component.set("v.EmpProfile", resultData); 
            }
        });
        $A.enqueueAction(action);
    }
})