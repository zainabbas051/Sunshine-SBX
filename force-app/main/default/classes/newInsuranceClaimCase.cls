//Test Class : newInsuranceClaimCaseTest
global without sharing class newInsuranceClaimCase{
    
    public id oppId;
    public case tempCaseRecord{
        get{
            if(tempCaseRecord == null)
                tempCaseRecord = new case();
            return tempCaseRecord;    
        }set;
    }
    
    public newInsuranceClaimCase(){
        oppId = ApexPages.currentPage().getParameters().get('oppId'); 
        tempCaseRecord.Opportunity__c = oppId;   
    }
    
    public pageReference cancelRequest(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/logInsuranceClaimCall?id='+oppId);
        return pr;   
    }
    
    public pageReference saveNewCase(){
        if(oppId != null){
            if(checkRequiredFieldsSave(tempCaseRecord) == True){
                try{
                    tempCaseRecord.RecordTypeId = Constants.insuranceClaimRecordTypeId;
                    insert tempCaseRecord;
                    
                    PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/logInsuranceClaimCall?id='+oppId);
                    return pr;
                }catch (exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'OOps some thing went wrong while closing the case : '+e.getMessage()));
                }
            }else{
                return null;
            }
        }
        return null;
    }
    
    public boolean checkRequiredFieldsSave(Case tempCaseRecord){
        String message='';      
        Boolean success=true;
            if(tempCaseRecord.Claim_Type__c == '' || tempCaseRecord.Claim_Type__c == null){
                 success=false;
                 message='Claim Type is required to save the new Case!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempCaseRecord.Bill_Date__c == null){
                 success=false;
                 message='Bill Date is required to save the new Case!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempCaseRecord.Billed_Amount__c== null){
                 success=false;
                 message='Billed Amount is required to save the new Case!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempCaseRecord.Bill_From_date__c== null){
                 success=false;
                 message='Bill From Date is required to save the new Case!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             if(tempCaseRecord.Bill_To_date__c== null){
                 success=false;
                 message='Bill To Date is required to save the new Case!!';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
         return success;
     }
    
}