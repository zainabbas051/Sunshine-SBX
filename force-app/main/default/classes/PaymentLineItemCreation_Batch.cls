global class PaymentLineItemCreation_Batch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        string ADMMITTED_STAGE = 'Admitted';
        string HOUSING_COLLECTION = 'Housing';
        List<string> statusLst = new List<String>{'Open','Closed' };
        return Database.getQueryLocator('SELECT id, Total_Rental_Amount_Due__c,Opportunity__c,Opportunity__r.Email,' + 
                '(select id, Amount_For_Collection__c, Payment_Plan__c, Type_of_Collection__c,Status__c FROM Payment_Plan_Line_Items__r ' +
                 'WHERE Type_of_Collection__c =:HOUSING_COLLECTION) AND Status__c IN : statusLst ' +
                 'FROM KIPU_Chart_Audit__c ' + 
                'WHERE Opportunity__r.StageName =: ADMMITTED_STAGE');
    }
    
    global void execute(Database.BatchableContext bc, List<KIPU_Chart_Audit__c> records){
        
        List<Payment_Plan_Line_Items__c> lstPaymentPlan = new List<Payment_Plan_Line_Items__c>();
        Id paymentPlan;
        for(KIPU_Chart_Audit__c record : records){
           
           decimal totalAmountCollected = 0;
           decimal totalAmountPending = 0;
           decimal totalRemainingDues = 0;
           for(Payment_Plan_Line_Items__c iPpl : record.Payment_Plan_Line_Items__r){
               
               paymentPlan = iPpl.Payment_Plan__c;
               if(iPpl.Status__c.equals('Open')){
                   
                   totalAmountPending += iPpl.Amount_For_Collection__c;
                   continue;
               }
               totalAmountCollected += iPpl.Amount_For_Collection__c;
           }
           
          
           
           totalRemainingDues = (totalAmountCollected + totalAmountPending) - record.Total_Rental_Amount_Due__c;
           record.Total_Rental_Amount_Pending__c = totalAmountPending;
           record.Total_Rental_Amount_Collected__c = totalAmountCollected;
           
           if(totalRemainingDues < 50){
               continue;
           }
           lstPaymentPlan.add(new Payment_Plan_Line_Items__c(KIPU_Chart_Audit__c = record.Id,
                                                                 Payment_Plan__c = paymentPlan,
                                                                 Amount_For_Collection__c = totalRemainingDues,
                                                                 Status__c = 'Open',
                                                                 Type_of_Collection__c = 'Housing'));
           
       }
    }    

   
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    } 
}