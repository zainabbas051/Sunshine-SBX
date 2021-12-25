public virtual class Ctrl_UploadPaymentReceipt {

    public Ctrl_UploadPaymentReceipt(){    
    }
    
     public Ctrl_UploadPaymentReceipt(ApexPages.StandardController stdController) {

       
    }

   
    public string inputFileBlob {get;set;}
    
    public Blob outputFile {get;set;}
    
    public string bodyContent2 {
        get;
        set;
    }
    public string bodyContent {
        get;
        set;
    }
    public string PDisFile {
        get;
        set;
    }
    public boolean callJs {
        get;
        set;
    }
    public string PPRsuffix {
        get;
        set;
    }
    public string PaymentPlanLineItemID {
        get;
        set;
    }
    public string TransId {
        get;
        set;
    }
    
    public boolean createUrl_boolean {
        get;
        set;
    }


    public string baseurl {
        get {
            return URL.getSalesforceBaseUrl().toExternalForm() + '/apex/PaymentPlanDetail?id=' + ApexPages.currentPage().getParameters().get('PPID');
        }
        set;
    }
 public id currentUserId {
        get {
            return userInfo.getUserId();
        }
        set;
    }
    
    string jsonParam;
    
    Boolean success;

    public void UploadPaymentQuery(string ppliId){
        
         system.debug('$$$$$' + ppliId);
        Payment_Plan_Line_Items__c ppliObj = [select id,Payment_Plan__r.Opportunity__r.Name, Payment_Plan__r.Sunshine_Center__c,Payment_Plan__r.Name,Name,Collection_Reference_ID__c
                         FROM Payment_Plan_Line_Items__c where id =: ppliId];
      
      PPRsuffix = label.Production_or_Sanbox + '/' + ppliObj.Payment_Plan__r.Sunshine_Center__c + '/' + ppliObj.Payment_Plan__r.Opportunity__r.Name + '/Payment Plan Documents/' + ppliObj.Payment_Plan__r.Name + '/Payment Plan Line Items/'+ppliObj.Name;
        PaymentPlanLineItemID=ppliObj.id;
        //TransId=AuthtransId;
       // system.debug('++AuthTrans' + AuthtransId );
        success = true;
    }
    
    public static void UploadPaymentQueryAura(string ppliId){
        
         system.debug('$$$$$' + ppliId);
        Payment_Plan_Line_Items__c ppliObj = [select id,Payment_Plan__r.Opportunity__r.Name, Payment_Plan__r.Sunshine_Center__c,Payment_Plan__r.Name,Name,Collection_Reference_ID__c
                         FROM Payment_Plan_Line_Items__c where id =: ppliId];
      
     string PPRsuffix = label.Production_or_Sanbox + '/' + ppliObj.Payment_Plan__r.Sunshine_Center__c + '/' + ppliObj.Payment_Plan__r.Opportunity__r.Name + '/Payment Plan Documents/' + ppliObj.Payment_Plan__r.Name + '/Payment Plan Line Items/'+ppliObj.Name;
       ID PaymentPlanLineItemID=ppliObj.id;
        //TransId=AuthtransId;
       // system.debug('++AuthTrans' + AuthtransId );
      boolean  success = true;
    }
   
    Public void createPPLIReceiptUrl() {

       
        if(success)
           createUrl_boolean = true;

    }

    public void CreateUrl() {

        PageReference pdf;
        
        try {
            
                pdf = Page.PaymentPlanReceiptTamplate;
             Authorize_Net_Transaction_Info__c TransInfo = [SELECT ID, Inbound_API_Response__c,Total_Amount__c,Name_on_Card__c,Sunshine_Center_F__c,Street_Address_F__c,Authorization_Code__c,Card_Number__c,Card_Type__c,
                     City_F__c,Expiration_Date__c,Name__c,State_F__c,Submit_Date_Time__c,Transaction_ID__c,Transaction_Status__c,
                     Transaction_Type__c,Zip_Code_F__c FROM Authorize_Net_Transaction_Info__c
                     WHERE Payment_Plan_Line_Items__c =: PaymentPlanLineItemID 
                     order by createddate desc limit 1];
            jsonParam =  JSON.serialize(TransInfo);

            system.debug('++trands-'+TransId);
            pdf.getParameters().put('trans_id', jsonParam);

            Blob body;

            if (Test.IsRunningTest()) {
                body = Blob.valueOf('UNIT.TEST');
            } else {
                body = pdf.getContentAsPDF();
            }
            System.debug('++++body' + body);
              System.debug('++++body' + callJs );
            bodyContent2 = EncodingUtil.base64Encode(body);
            callJs = true;
             System.debug('++++body' + callJs );
        } catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Something went wrong' + e.getMessage() + e.getLineNumber()));
            createUrl_boolean = false;
            callJs = false;
        }
    }
       
}