public with sharing class claimInvocaCallByQC{
    
    private final INVOCA_FOR_SF__Invoca_Call_Log__c callRecord;
    public string callRecordId;
    Id ClosingAgent = null;
    
    public claimInvocaCallByQC(ApexPages.StandardController controller){
        this.callRecord = (INVOCA_FOR_SF__Invoca_Call_Log__c)controller.getRecord();
        callRecordId = ApexPages.currentPage().getParameters().get('id');
    }
    
     public pagereference cancel1(){
        return new pagereference('/'+label.Call_Claimed_By_QC_Return_URL); 
        return null;
    }
    
    public PageReference claimCallQC() {
        if(ClosingAgent != null){
            callRecord.Call_Claimed__c = True;
            callRecord.Call_Claimed_Date_Time__c = dateTime.Now();
            callRecord.OwnerId = ClosingAgent;
            callRecord.Call_Claimed_By_QC__c = True;
            update callRecord;
        }
        return new pagereference('/'+label.Call_Claimed_By_QC_Return_URL);
        return null;
    }

    
    public List<SelectOption> getItems() {//This method is used to populate the possible closing agents using a custom setting that we have in place.
        List<SelectOption> options = new List<SelectOption>();
        for(User u : [select id, Name from User Where (Profile.Name=:'Custom - CSR' OR Profile.Name=:'Custom - Monarch Shores - CSR' OR Profile.Name=:'Custom - Standard User' OR Profile.Name=:'Custom - Monarch Shores - Standard User' OR Profile.Name=:'Custom - Quality Control' OR Profile.Name=:'Custom - Supervisor User' OR Profile.Name=:'CSR Hybrid') AND isActive=: True]){
            options.add(new SelectOption(u.id,u.Name));
        }
        return options;
    } 
    
    
    public Id getClosingAgent() {
        return ClosingAgent;
    }

    public void setClosingAgent(Id ClosingAgent) {
        this.ClosingAgent = ClosingAgent;
    }

}