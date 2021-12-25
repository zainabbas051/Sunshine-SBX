({
    saveComments : function(component, event, helper) {
        helper.saveComments(component);
    },

    defaultAction : function(component, event, helper) {

        helper.getAllComments(component);
    }
})