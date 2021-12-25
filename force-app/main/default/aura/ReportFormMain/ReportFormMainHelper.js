({
	readUrl : function(component){
        debugger;
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
 
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
 
            if (sParameterName[0] === 'Id') { //lets say you are looking for param name - firstName
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
                component.set('v.RecordId',sParameterName[1]);

            }
            if (sParameterName[0] === 'reporttype') { //lets say you are looking for param name - firstName
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
                sParameterName[1] = sParameterName[1].replace('+',' ');
                component.set('v.reportType',sParameterName[1]);
              
               
            }
        }
    }
})