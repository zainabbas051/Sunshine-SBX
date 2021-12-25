public class ctrl_GeneratePaymentReceipt{

    public Authorize_Net_Transaction_Info__c TransInfo { get; set; }
    
    
    public ctrl_GeneratePaymentReceipt(){
        
        string Trans_ID = system.CurrentPageReference().getParameters().get('trans_id');
        system.debug('oooTrans_ID'+Trans_ID);
        TransInfo = (Authorize_Net_Transaction_Info__c)JSON.deserialize(Trans_ID,Authorize_Net_Transaction_Info__c.class);
    }
}