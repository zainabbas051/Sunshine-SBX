({
    
    doInit: function(component, event, helper) {
      helper.getenableRequestBtn(component);  
     // helper.getCurrentUserDetail(component); 
    
    },
    
    showHideBtn: function(component, event, helper) {
      
     //  var button = component.find('btnReq');
     //   var status = component.find(enableRequestBtn);

      // button.set('v.disabled',!status);
    },
    
    showHideRequestedData: function(component, event, helper) {
      
        var show =component.get("v.showRequested");
        component.set("v.Requested",show);
    },
	
    myAction : function(component, event, helper) {
		
	},
     clickNew : function(component,event,helper){
        
        component.set('v.isNew',true);
    },
    back : function(component,event,helper){
        
        component.set('v.isNew',false);
    }
})