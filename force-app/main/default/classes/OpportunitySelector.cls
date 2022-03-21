public inherited sharing class OpportunitySelector {
   
    public static List<Opportunity> getOpportunities(){

      //  return [SELECT id,name,Phone__c from Opportunity where StageName='Admitted' limit 5];
      return [select Id, Name,Phone__c, (select id,contactId,opportunityId,Contact.Phone from OpportunityContactRoles where IsPrimary=true) from Opportunity where StageName='Admitted' and Phone__c <> null ];
    }
    
    public static List<Opportunity> getOpportunities(string SunshineCenter){

      //  return [SELECT id,name,Phone__c from Opportunity where StageName='Admitted' limit 5];
      return [select Id, Name,Phone__c, (select id,contactId,opportunityId,Contact.Phone from OpportunityContactRoles where IsPrimary=true) from Opportunity where StageName='Admitted' and Sunshine_Center_Name__c =:SunshineCenter Order by Name];
    }

    public static List<Opportunity> getOpportunitiesWithPaymentPlan(Set<Id> opptyIds){

        return [SELECT Id,
                (SELECT 
                  Id 
                  FROM 
                  Payment_Plan__r) 
                FROM 
                Opportunity 
                WHERE ID IN : opptyIds];
    }

}