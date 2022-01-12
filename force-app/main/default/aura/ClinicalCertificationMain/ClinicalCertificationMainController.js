({
	handleBudget : function(component, event, helper) {
         helper.getEmployeeData(component);  
             
	},
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     logoutButton: function(c,e,h){
      
        var returnUrl='https://smsmagic-sunshinebh.cs60.force.com/ccp/s/certificationportallogin'; 
        // paste your login page link here, where you want to come back
       window.location.href=returnUrl;       
         
    },
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
       // component.set("v.IsAuthenticated",true);
    },
    onPageReferenceChange : function(component,event,helper){
        debugger;

        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.

            if (sParameterName[0] === 'empId') { //lets say you are looking for param name - firstName
                component.set('v.empID',sParameterName[1]);
            }
            if (sParameterName[0] === 'sup') { //lets say you are looking for param name - firstName
                component.set('v.isSuperVisor',sParameterName[1]);
            }
            if (sParameterName[0] === 'empTier') { //lets say you are looking for param name - firstName
                var str = sParameterName[1];
				var res = str.replace("+", " ");
                component.set('v.empTier',res);
            }
        }
        helper.getEmployeeProfileInfo(component);
       // helper.getSunshineAccess(component);
        
    },
    logoutButton: function(component,event,helper){
      
        var SandboxORProduction = $A.get("$Label.c.Production_or_Sanbox");
        var returnUrl;

        if(SandboxORProduction == 'Sandbox'){

            returnUrl= 'https://smsmagic-sunshinebh.cs60.force.com/ccp/s/certificationportallogin';

        }

        else {

            returnUrl='https://sunshinebh.force.com/ccp/s/certificationportallogin';
        }

        // paste your login page link here, where you want to come back
       window.location.href=returnUrl;       
         
    },
})