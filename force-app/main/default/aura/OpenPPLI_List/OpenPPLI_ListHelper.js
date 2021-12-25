({
    getPPLIsByFilter : function(component) {

        var action = component.get("c.getPPLIsByFilter");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var empId = component.get("v.employeeId");
        var caseFilter = component.get("v.selectedCaseFilter");
        debugger;
        action.setParams({
            'pageSize' : pageSize,
            'pageNumber' : pageNumber,
            'empId' : empId,
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                var resultData = a.getReturnValue();
                var temojson = JSON.parse(JSON.stringify(resultData).split('ListOfPPLis').join('_children'));
                console.log('#resultData.length='+temojson.length);
                component.set("v.isLastPage", false);
                if(temojson < component.get("v.pageSize")){
                    component.set("v.isLastPage", true); 
                }
                
                console.log(temojson);
                component.set("v.dataSize", resultData.length);
                component.set("v.data",JSON.parse(temojson));
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    },

    getAllPPLIs : function(component){

        var action = component.get("c.getAllPPLIs");
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
                /*var resultData = a.getReturnValue();
                var temojson = JSON.parse(JSON.stringify(resultData).split('ListOfPPLis').join('_children'));
                console.log('#resultData.length='+temojson.length);
                component.set("v.isLastPage", false);
                if(temojson < component.get("v.pageSize")){
                    component.set("v.isLastPage", true); 
                }*/
                var resultData = a.getReturnValue();
                var temojson = JSON.parse(JSON.stringify(resultData).split('ListOfPPLis').join('_children'));
                console.log('#resultData.length='+temojson.length);
                component.set("v.isLastPage", false);
                if(temojson < component.get("v.pageSize")){
                    component.set("v.isLastPage", true); 
                }
                console.log(temojson);
                var jsonObj = JSON.parse(temojson);

                var totalData = 0;
                for(x = 0 ;x <= jsonObj.length-1; x++)
                {
                  totalData += jsonObj[x]._children.length;
                }
                component.set("v.dataSize", totalData);
                component.set("v.data", jsonObj);
                /*
                console.log(temojson);
                component.set("v.dataSize", resultData.length);
                component.set("v.data",JSON.parse(temojson));
                */
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    },

    getAllPPLIsUpdated : function(component){

        var action = component.get("c.getAllPPLIs");
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
                /*var resultData = a.getReturnValue();
                var temojson = JSON.parse(JSON.stringify(resultData).split('ListOfPPLis').join('_children'));
                console.log('#resultData.length='+temojson.length);
                component.set("v.isLastPage", false);
                if(temojson < component.get("v.pageSize")){
                    component.set("v.isLastPage", true); 
                }*/
                var resultData = a.getReturnValue();
                var temojson = JSON.parse(JSON.stringify(resultData).split('ListOfPPLis').join('_children'));
                component.set("v.alldata", temojson);
                console.log(temojson);
                //createClientPPLIMap(temojson);
                var jsonObj = JSON.parse(temojson);
                console.log('@jsonObj='+JSON.parse(temojson));
                var totalData = 0;
                for(x = 0 ;x <= jsonObj.length-1; x++)
                {
                    totalData += jsonObj[x]._children.length;
                }
                
                component.set("v.dataSize", totalData);
                this.manageDataPaging(component, event);
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    },
    
    manageDataPaging : function(component, event)
    {
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");
        var recordCounter = component.get("v.recordCounter");
        var jsonString = component.get("v.alldata");
        var jsonObj = JSON.parse(jsonString);
        var totalData = component.get("v.dataSize");
        
        var recordToShow = pageSize * pageNumber;
        var pagedData = [];
        var childrenData = [];
        var childCount = 0;
        component.set("v.pagedData",[]);
        for(x = 0 ;x <= jsonObj.length-1; x++)
        {
            var _children = [];
            for(var y = 0; y<=jsonObj[x]._children.length -1; y++)
            {
                if(childCount >= recordCounter && childCount  <= recordToShow-1)
                {
                    recordCounter +=1;
                    _children.push(jsonObj[x]._children[y]);
                    childrenData.push(obj);
                }
                childCount += 1;

            }
            
            if(_children.length > 0)
            {
                var obj = jsonObj[x];
                obj._children = _children;
                pagedData.push(obj);
                
            	
                
            }
            
            if(recordCounter == recordToShow)
                break;
            
        }
        
        component.set("v.pagedData",childrenData);
        component.set("v.recordCounter",recordCounter);
        component.set("v.data", pagedData);
        
        component.set("v.isLastPage", false);
        if(recordCounter == totalData)
        {
            component.set("v.isLastPage", true); 
        }
        
    },
    
    expandAllRows: function(component, event) {
        var delayInMilliseconds = 2000; //1 second
        setTimeout(function() {
            var tree = component.find('trGrid');
            if(tree)
            {
                var ele = tree.getElement(); 
                if(ele.getRootNode().readyState == "complete" && tree.attributes.data.Kh != null)
                {
                    tree.expandAll();
                }
            }
            else{
                this.expandAllRows(component, event);
            }
        }, delayInMilliseconds);
        
    },

    clickToExpandAll : function(component) {
        const grid =  this.template.querySelector( 'lightning-tree-grid' );
        grid.expandAll();
    },

    createClientPPLIMap: function(dataVar){
        const dataMap = new Map();
        if(dataVar){
            var jsonObj = JSON.parse(dataVar);
            for(x = 0 ;x <= jsonObj.length-1; x++){
                dataMap.set(jsonObj[x].ClientName, jsonObj[x]._children);
            }
        }
        console.log('#dataMap='+dataMap);
    }


})