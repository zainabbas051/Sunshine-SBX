({
    GenerateActivitiesColor : function(component) {
        var childCmp = component.find("activitiesCmp")
        childCmp.GenerateActivities();
        //component.set("v.loaded",false);//loading stop
    }
})