({
    getAllData : function(component) {

        var action = component.get("c.getAllHandHygieneReports");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var empSunshine = component.get("v.selectedSunshine");
        let empSunshineAccess = [];
        empSunshineAccess = component.get("v.selectedSunshineAccess");
      
     if(component.get("v.selectedSunshineAccess") != null){

           component.set("v.sunshineEnabled", true);

       }
       
        action.setParams({
            'pageSize' : pageSize,
            'pageNumber' : pageNumber,
            'empSunshine' : empSunshine,
            'empSunshineAccess' : empSunshineAccess,
            'startDate' :  component.get("v.minDate"),
            'endDate' : component.get("v.maxDate")
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
            'pageNumber' : pageNumber,
            'sunshineCentersAccess' : component.get("v.selectedSunshineAccess")
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
              //  component.set("v.selectedSunshine",resultData);
                component.set("v.selectedSunshineAccess",resultData);
                component.set("v.selectedSunshine",'All');
                if(resultData == null){
                    component.set("v.selectedSunshine",'All');
                    component.set("v.sunshineEnabled",true);
                }
                this.getAllData(component);
            }
           
        });
        $A.enqueueAction(action);
    },
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.data");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'DateAndTime__c'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        //set sorted data to accountData attribute
        component.set("v.data",data);
    }
})