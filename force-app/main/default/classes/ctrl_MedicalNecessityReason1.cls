public class ctrl_MedicalNecessityReason1{
    
    public Case caseRecord{get;set;}
    public list<Provider_Dispute__c> lstProviderDisputes{get;set;}
    public Provider_Dispute__c p{get;set;}
    
    public ctrl_MedicalNecessityReason1(){
        
        id CaseId = system.CurrentPageReference().getParameters().get('id');
        
          
        system.debug('%%%%%%%' +system.CurrentPageReference().getParameters().get('pd_id') );
        string recId = system.CurrentPageReference().getParameters().get('pd_id');
        system.debug('%%^^$$^$$' + recId );
         system.debug('%%^^$$^$$ --- ' + CaseId );
        lstProviderDisputes = [select id,Enclosures__c,Insurance_Provider_Address__c from Provider_Dispute__c
                             where Id =: recId  order by ID desc limit 1];
         system.debug('%%%%%%%' + lstProviderDisputes);
       
        
      //  Provider_Dispute__c = [Select Id ,Related_Case__r.Sunshine_Center__c,
       
      //  lstProviderDisputes = new list<Provider_Dispute__c>();
      //  lstProviderDisputes = [select id,Enclosures__c from Provider_Dispute__c where id=: system.CurrentPageReference().getParameters().get('pd_id')];
         system.debug('%%^^$$^$$' + p );
        
        caseRecord = [select id, Sunshine_Center__c, Insurance_Provider__c, CreatedDate, Opportunity__r.Name,
        Insurance_Provider_Claim_Number__c, Date_of_Birth__c,Bill_From_Date__c, Bill_To_Date__c, Owner.Name, Owner.Phone,
        Opportunity__r.Sunshine_Center__r.BillingPostalCode,Opportunity__r.Sunshine_Center__r.BillingStreet, Opportunity__r.Sunshine_Center__r.BillingState,
        Opportunity__r.Sunshine_Center__r.BillingCity, Opportunity__r.Insurance_Provider__r.BillingStreet, Opportunity__r.Insurance_Provider__r.BillingState,
        Opportunity__r.Insurance_Provider__r.BillingPostalCode, Opportunity__r.Insurance_Provider__r.BillingCity, Opportunity__r.Insurance_Policy__c
         from Case where id=: CaseId];
      
      
    }
}