public class ctrl_ProofOfTimelyFilling{
    
    public Case caseRecord{get;set;}
    public list<Provider_Dispute__c> lstProviderDisputes{get;set;}
    
    public ctrl_ProofOfTimelyFilling(){
        
        id CaseId = system.CurrentPageReference().getParameters().get('id');
        
        caseRecord = [select id, Sunshine_Center__c, Insurance_Provider__c, CreatedDate, Opportunity__r.Name,
        Insurance_Provider_Claim_Number__c, Date_of_Birth__c,Bill_From_Date__c, Bill_To_Date__c, Owner.Name, Owner.Phone,
        Opportunity__r.Sunshine_Center__r.BillingPostalCode,Opportunity__r.Sunshine_Center__r.BillingStreet, Opportunity__r.Sunshine_Center__r.BillingState,
        Opportunity__r.Sunshine_Center__r.BillingCity, Opportunity__r.Insurance_Provider__r.BillingStreet, Opportunity__r.Insurance_Provider__r.BillingState,
        Opportunity__r.Insurance_Provider__r.BillingPostalCode, Opportunity__r.Insurance_Provider__r.BillingCity, Opportunity__r.Insurance_Policy__c,
        Billed_Amount__c
         from Case where id=: CaseId];
        
        lstProviderDisputes = new list<Provider_Dispute__c>();
        lstProviderDisputes = [select id,Enclosures__c,Insurance_Provider_Address__c  from Provider_Dispute__c where id=: system.CurrentPageReference().getParameters().get('pd_id')];
    }
}