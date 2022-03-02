//test class : SendEmailConfirmation_CtrlTest
public inherited sharing class HousingPPLIService{
    
    public static void updateKipuChart(List<Payment_Plan_Line_Items__c> paymentLineItems){
        
        Set<Id> opptySet = new Set<Id>(); 
        List<Payment_Plan_Line_Items__c> housingLineItems = new List<Payment_Plan_Line_Items__c>();
        for(Payment_Plan_Line_Items__c paymentLineItem : paymentLineItems){
            
            if(paymentLineItem.KIPU_Chart_Audit__c != null || paymentLineItem.Type_of_Collection__c != 'Housing' ){
                continue;
            }
            opptySet.add(paymentLineItem.Opportunity__c);
            housingLineItems.add(paymentLineItem);
        }
        system.debug('===>' + opptySet.size() );
        if(opptySet.size() == 0){
             return;
        }
        
        Map<Id,KIPU_Chart_Audit__c> mapKipuAudit = new Map<Id,KIPU_Chart_Audit__c>();
        for(KIPU_Chart_Audit__c kipuAudi : [Select Id, Opportunity__c FROM KIPU_Chart_Audit__c WHERE
                                                         Opportunity__c IN : opptySet]){
              
              mapKipuAudit.put(kipuAudi.Opportunity__c,kipuAudi);                                                                                  
        }
        
        if(mapKipuAudit.size() == 0){
            return;
        }
        
        for(Payment_Plan_Line_Items__c paymentLineItem : housingLineItems){
            
            paymentLineItem.KIPU_Chart_Audit__c = mapKipuAudit.get(paymentLineItem.Opportunity__c)?.Id;           
        }
    }
    
}