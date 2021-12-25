({
	SetGADQuestionNumber : function(stringValue,component) {
		
        var GADTotal = 0;
        debugger;
        switch(stringValue){
                
            case 'Not at all':
                GADTotal = 0;
                break;
            case 'Several days':
                GADTotal = 1;
                break;
            case 'More than half the days':
                GADTotal = 2;
                break;
            case 'Nearly every day':
                GADTotal = 3;
                break;
                
       
        }
            //var totalGACScore = component.get('v.ClientOutcomeSurveyObj.Total_GAC_Score__c');
            var totalGADScore = component.get('v.TotalGADScore');
         
           totalGADScore += GADTotal;
           component.set('v.TotalGADScore',totalGADScore);
          
	},
    SetPHQQuestionNumber : function(stringValue,component) {
		
        var PHQTotal = 0;
        debugger;
        switch(stringValue){
                
            case 'Not at all':
                PHQTotal = 0;
                break;
            case 'Several days':
                PHQTotal = 1;
                break;
            case 'More than half the days':
                PHQTotal = 2;
                break;
            case 'Nearly every day':
                PHQTotal = 3;
                break;
             case 'Not difficult at all':
                PHQTotal = 0;
                break;
            case 'Somewhat difficult':
                PHQTotal = 1;
                break;
            case 'Very difficult':
                PHQTotal = 2;
                break;
            case 'Extremely difficult':
                PHQTotal = 3;
                break;
                
       
        }
            //var totalGACScore = component.get('v.ClientOutcomeSurveyObj.Total_GAC_Score__c');
            var totalPHQScore = component.get('v.TotalPHQScore');
         
           totalPHQScore += PHQTotal;
           component.set('v.TotalPHQScore',totalPHQScore);
          
	},
     SetRASQuestionNumber : function(stringValue,component) {
		
        var RASTotal = 0;
        debugger;
        switch(stringValue){
                
            case 'Strongly Disagree':
                RASTotal = 0;
                break;
            case 'Disagree':
                RASTotal = 1;
                break;
            case 'Not Sure':
                RASTotal = 2;
                break;
            case 'Agree':
                RASTotal = 3;
                break;
            case 'Strongly Agree':
                RASTotal = 4;
                break;
                
       
        }
            //var totalGACScore = component.get('v.ClientOutcomeSurveyObj.Total_GAC_Score__c');
            var totalRASScore = component.get('v.TotalRASScore');
         
           totalRASScore += RASTotal;
           component.set('v.TotalRASScore',totalRASScore);
          
	}
})