({
    getCasesByFilter : function(component) {

        var action = component.get("c.getAllCasesByFilter");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var empId = component.get("v.employeeId");
        var caseFilter = component.get("v.selectedCaseFilter");
        debugger;
        action.setParams({
            'pageSize' : pageSize,
            'pageNumber' : pageNumber,
            'empId' : empId,
            'filter' : caseFilter
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                var resultData = a.getReturnValue();
                component.set("v.isLastPage", false);
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true); 
                }
                component.set("v.dataSize", resultData.length);
                component.set("v.data",resultData);
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    },

    getAllCases : function(component){

        var action = component.get("c.getAllCases");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var empId = component.get("v.employeeId");
        action.setParams({
            'pageSize' : pageSize,
            'pageNumber' : pageNumber,
            'empId' : empId
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                var resultData = a.getReturnValue();
                component.set("v.isLastPage", false);
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true); 
                }
                component.set("v.dataSize", resultData.length);
                component.set("v.data",resultData);
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    }
})