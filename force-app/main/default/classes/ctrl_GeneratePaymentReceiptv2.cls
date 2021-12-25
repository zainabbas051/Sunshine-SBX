public class ctrl_GeneratePaymentReceiptv2{

    public Authorize_Net_Transaction_Info__c TransInfo { get; set; }
    
    
    public ctrl_GeneratePaymentReceiptv2(){
        
        string Trans_ID = system.CurrentPageReference().getParameters().get('Id');
        
        Authorize_Net_Transaction_Info__c auth = [select id, createddate, Sunshine_Center_F__c, Name_on_Card__c, Street_Address_F__c, State_F__c, Zip_Code_F__c, Total_Amount__c, Submit_Date_Time__c,
                        Inbound_API_Response__c, Outbound_API_JSON__c, Transaction_ID__c, Transaction_Type__c, Transaction_Status__c, Authorization_Code__c,
                     City_F__c, Card_Type__c, Card_Number__c, Expiration_Date__c from
                      Authorize_Net_Transaction_Info__c Order by createddate desc limit 1];
        TransInfo = auth;
    }
}