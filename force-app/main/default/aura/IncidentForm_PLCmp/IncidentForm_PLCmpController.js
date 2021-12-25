({
    cancelForm : function(component, event, helper) {
        component.set('v.showFormPL',false);

    },
    openIncForm : function(component,event,helper){

        var sunshineCenre = component.find("sunshineCentre").get('v.value');
        component.set('v.showForm',true);
        component.set('v.showFormPL',false);
        component.set('v.selectedSunShineCentre',sunshineCenre);
    }
})