({
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
     handleCreateLoad: function (component, event, helper) {
         debugger;
         
           var cmpContentType = component.get("v.DailyContentType");
        var thumbnailUrl=  component.find("ThumbnailImageField").get("v.value");
         component.set("v.thumbnailURL",thumbnailUrl);
         var mainlUrl=  component.find("MainImageField").get("v.value");
         component.set("v.MainURL",mainlUrl);
        
        
        
      
    },
    doInit: function(component, event, helper) {

      // alert(component.get("v.selectedRowId"));
       
      
    },
    handleTagChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
         
        //Update the Selected Values  
        component.set("v.selectedTagList", selectedValues);
    }
     
    ,
    handleFileUploadIcon: function(component, event, helper) {
        debugger;
        var file = component.find("ThumbnailfileUpload").get("v.files")[0];
        var reader = new FileReader();
	   component.find("IconAvatar").set("v.src",URL.createObjectURL(file));
        reader.onload = function() {
            var fileContent = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContent.indexOf(base64) + base64.length;

            fileContent = fileContent.substring(dataStart);
            component.set('v.fileContent', fileContent);
            component.set('v.fileName2', file.name);
        }
        reader.readAsDataURL(file);
         
    },
    handleFileUploadMain: function(component, event, helper) {
        debugger;
        var file = component.find("MainfileUpload").get("v.files")[0];
        var reader = new FileReader();
		
        component.find("mainAvatar").set("v.src",URL.createObjectURL(file));
   
        reader.onload = function() {
            var fileContent = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContent.indexOf(base64) + base64.length;

            fileContent = fileContent.substring(dataStart);
            component.set('v.fileContent1', fileContent);
            component.set('v.fileName1', file.name);
        }
        reader.readAsDataURL(file);
        
    },

    handleAudioVideo : function(component,event,helper){

        debugger;
        var file = event.getSource().get("v.files")[0];
        var reader = new FileReader();
        component.set('v.resourceFile', file);


        reader.onload = function() {
            var fileContent = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContent.indexOf(base64) + base64.length;

            fileContent = fileContent.substring(dataStart);
            component.set('v.resourceContent', fileContent);
            component.set('v.resourceFileName', file.name);
        }
        reader.readAsDataURL(file);
    },

    handleSubmit: function(component, event, helper) {
        debugger;
        event.preventDefault();
       // helper.handleSubmit();
        helper.uploadFileInAWS(component);
    },

    cancelAction: function(component) {
        component.set("v.isNew", false);
    },
    handleSuccess:function(component,event,helper){
      
       // $A.get('e.force:refreshView').fire();
    }
})