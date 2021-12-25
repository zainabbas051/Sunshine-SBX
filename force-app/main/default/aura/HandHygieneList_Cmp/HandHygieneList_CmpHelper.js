({
    getAllData : function(component) {

        var action = component.get("c.getAllHandHygieneReports");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var empSunshine = component.get("v.selectedSunshine");
        action.setParams({
            'pageSize' : pageSize,
            'pageNumber' : pageNumber,
            'empSunshine' : empSunshine
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                var resultData = a.getReturnValue();
                resultData.forEach(function(record){
                    record.linkName = '/ccp/s/reportformreadonly?Id='+record.Id+'&reporttype=HandHygieneReport';
                });
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

    getSearchDate : function(component){
        debugger;
        var action = component.get("c.getSearchHandHygiene");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var selectedSunShine = component.get("v.selectedSunshine");
        action.setParams({
            'startDate' :  component.get("v.minDate"),
            'endDate' : component.get("v.maxDate"),
            'sunshineCenterName' : selectedSunShine,
            'pageSize' : pageSize,
            'pageNumber' : pageNumber
        });

        action.setCallback(this, function (a) {
            debugger;
            var state = a.getState();
            if(state == 'SUCCESS'){
                var resultData = a.getReturnValue();
                resultData.forEach(function(record){
                    record.linkName = '/ccp/s/reportformreadonly?Id='+record.Id+'&reporttype=HandHygieneReport';
                });
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
    getEmployeeSunshine : function(component){
        var action = component.get("c.getEmpSunshine");
        var empId = component.get("v.employeeId");
        action.setParams({
            'empId' : empId
        });
        debugger;
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                var resultData = a.getReturnValue();
                component.set("v.selectedSunshine",resultData);
                if(resultData == null){
                    component.set("v.selectedSunshine",'All');
                    component.set("v.sunshineEnabled",true);
                }
                this.getAllData(component);
            }
           
        });
        $A.enqueueAction(action);
    }
})