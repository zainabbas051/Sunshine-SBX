({
	init : function(component, event, helper) {
        helper.readUrl(component);
    },
    
    selectIncidentReport : function(component, event, helper) {
      
        component.set('v.ReportType','IncidentReport');
    }
    ,
    selectIncfectionControlReport : function(component, event, helper) {
      
        component.set('v.ReportType','IncfectionControlReport');
    }
    ,
    selectHandHygieneReport : function(component, event, helper) {
      
        component.set('v.ReportType','HandHygieneReport');
    }
})