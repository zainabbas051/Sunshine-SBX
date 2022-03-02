public without sharing class HousingRentalCollection_Ctrl extends Aura_Ctrl_UploadPaymentReceipt{

 @AuraEnabled 
    public static string fetchUser(){
       User u = [select id,Name from User where id =: userInfo.getUserId()];
        return u.Name;
    }
    
   @AuraEnabled
    public static List<Payment_Plan_Line_Items__c> getPaymentLineItem(string OppId){

        
        List<Payment_Plan_Line_Items__c> ppLineItem = [Select Name,Payment_Plan__c,Payment_Plan__r.Name,Due_Date__c,Sunshine_Center__c,
                                                        Amount_For_Collection__c,Status__c,Closed_Date__c ,
                                                        Payment_Receipt_URL__c, Date_of_Cash_Collection__c
                                                        FROM 
                                                        Payment_Plan_Line_Items__c WHERE 
                                                        Type_of_Collection__c = 'Housing' and Opportunity__c =: OppId and Status__c IN ('Open','Closed') and Amount_For_Collection__c >0];
        
       
        return ppLineItem;
    }
      
    @AuraEnabled
    public static List<Card_Information__c> getCardInfoList(string OppId){
    
    List<Card_Information__c> cl=[select id,Card_Number__c, Name_on_Card__c, CVV__c, Expiration_Month__c, Expiration_Year__c from Card_Information__c where Payment_Plan__r.Opportunity__c =:OppId and Active__c = true];
    return cl;
    
    }
    
    @AuraEnabled
    public static boolean ValidateCVV(string cardId,Decimal CVV){
    
    Card_Information__c cl;
    try{
     cl=[select id,Card_Number__c, Name_on_Card__c, CVV__c, Expiration_Month__c, Expiration_Year__c 
                            from Card_Information__c where Id =:cardId and CVV__c =:CVV limit 1];
                            }
    catch(Exception e) {
 
       cl = null;

     }
     
     if(cl== null) return false;
     return true;

    
    }
    
    @auraEnabled
    public static string processPayment(List<Payment_Plan_Line_Items__c> paymentPlanLst,
                                        string fileName,
                                        Card_Information__c cardDetails,
                                        decimal totalDueAmount,
                                        Boolean saveNewCard){
        
        string ppl;
        try{
            ppl =  PaymentLineItemService.processPayment(paymentPlanLst,
                                                        fileName,
                                                        cardDetails,
                                                        totalDueAmount,
                                                        saveNewCard);
        }
       catch(Exception ex){
            system.debug('Error===> ' + ex.getMessage() + ' ' + ex.getlineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        return ppl;
    }

    @auraEnabled
    public static List<string> processPdf(List<string> ppl){

        List<string> pdfContents;
        try{
            pdfContents = PaymentLineItemService.processPdfs(ppl);
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return pdfContents;
    }

    @auraEnabled
    public static List<Payment_Plan_Line_Items__c> createPaymentLineItem(List<Payment_Plan_Line_Items__c> paymentPlanLst,decimal otherAmount
                                                                         ){

        List<Payment_Plan_Line_Items__c> ppl;
        try{
            ppl = PaymentLineItemService.createPaymentLineItem(paymentPlanLst,otherAmount);
        }
        catch(Exception ex){
         
            throw new AuraHandledException(ex.getMessage());
        }
        return ppl;
    }

    @auraEnabled
    public static void savePaymentLineItem(List<Payment_Plan_Line_Items__c> newPaymentLineItem){
        try{
           insert newPaymentLineItem;
        }
        catch(Exception ex){
         
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @auraEnabled
    public static Opportunity getOpptyDetail(string OppId){
        
        return [Select Id,Name,Sunshine_Center_Name__c from Opportunity where Id =: OppId];
    }
    
    @AuraEnabled
    public static awsBucket__c getAWSSetting(){
    System.debug('awsBucket__c.getInstance() => '+awsBucket__c.getInstance('salesforce'));
    return awsBucket__c.getInstance('salesforce');
}
    


}