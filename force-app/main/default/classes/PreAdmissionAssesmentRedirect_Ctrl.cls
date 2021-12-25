public class PreAdmissionAssesmentRedirect_Ctrl{
    
    

    
    public PageReference Redirect(){
        
        string OpptyId = apexpages.currentpage().getparameters().get('OpptyId');
        
        Opportunity oppty = [Select id,name from Opportunity where Id =: OpptyId];
        
        List<Pre_Admission_Assessment__c> lst = [SELECT Id FROM Pre_Admission_Assessment__c
                                                    WHERE Opportunity__c =: OpptyId];
        
        if(lst.isEmpty() == false){
            
             PageReference retURL = new PageReference('/'+lst[0].Id+'/e?retURL=%2F'+OpptyId);
             retURL.setRedirect(true);
             return retURL;
        }
        
        
             PageReference retURL = new PageReference('/'+System.Label.PAAPagelayoutID+'/e?saveURL=%2F'+OpptyId+'&'+System.Label.PAAOpportunitylkId.split(';')[0]+'='+OpptyId+'&'+System.Label.PAAOpportunitylkId.split(';')[1]+'='+oppty.Name);
             retURL.setRedirect(true);
             return retURL;
    }

}