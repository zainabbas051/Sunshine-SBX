public inherited sharing class PaymentLineItemService {
    
    static string sunShineCentre;
    static List<string> refIds;
    static Map<Id,Payment_Plan_Line_Items__c> mapPpl;
    static Authorize_Net_Transaction_Info__c authTransInfo;
    static List<Authorize_Net_Transaction_Info__c> lstAuthTransInfo;
    
    public static List<Payment_Plan_Line_Items__c> createPaymentLineItem(List<Payment_Plan_Line_Items__c> paymentPlanLst,
                                                                        decimal otherAmount){
        
        List<Payment_Plan_Line_Items__c> paymentNewPpl = new List<Payment_Plan_Line_Items__c>();
        paymentPlanLst = getOpenPaymentPlan(paymentPlanLst);
        Payment_Plan_Line_Items__c clonePpl;
        for(integer i = 0 ; i< otherAmount / 50; i++){
            clonePpl = paymentPlanLst[0].clone(false,true);
            clonePpl.Amount_For_Collection__c = 50;
            clonePpl.Type_of_Collection__c = 'Housing';
            paymentNewPpl.add(clonePpl);
        }

        insert paymentNewPpl;
        paymentPlanLst.addAll(paymentNewPpl);
        paymentNewPpl.clear();
        return paymentPlanLst;

    }

    public static string processPayment(List<Payment_Plan_Line_Items__c> paymentPlanLst,string fileName,string cardNumber, string CVC,decimal totalDueAmount){
        
        Card_Information__c cardInf = getCardDetail(cardNumber);
        validateCardDetail(cardInf);
        mapPpl = new Map<Id,Payment_Plan_Line_Items__c>(paymentPlanLst);
        PaymentAuthorization pp;
        //lstAuthInfo = new List<Authorize_Net_Transaction_Info__c>(); 
        pp = new PaymentAuthorization(paymentPlanLst[0].Id,cardInf ,totalDueAmount,sunShineCentre);
        string paymentLineItem = updateRecordLineItemAfterResponse(paymentPlanLst,pp,cardInf,fileName,totalDueAmount);
        if(string.isEmpty(paymentLineItem)){
          return null;
        }
   
        insert lstAuthTransInfo;
        update paymentPlanLst;
        return paymentLineItem;
    }
    
    
   
    
    static Card_Information__c getCardDetail(string cardID){
        
         Card_Information__c iCard = [select id, Card_Number__c, Name_On_Card__c, Expiration_Month__c, Expiration_Year__c, CVV__c, AWS_Link__c, 
                                      Billing_Address__c, Billing_City__c, Billing_State__c, Billing_Zip__c, Payment_Plan_Authorization_URL__c, 
                                      Card_Approved__c, Credit_Card_Authorization_Ext1__c, Credit_Card_Authorization_Ext2__c from Card_Information__c
                                      where Card_Number__c=:cardID limit 1];
        return iCard;
    }
    
    static void validateCardDetail(Card_Information__c cardInfo){
      
      Integer currentYear = System.Today().year(); 
      Integer currentMonth = System.Today().month();
      String str = cardInfo.Expiration_Year__c;
      if(str.length()==2){
        str='20'+ cardInfo.Expiration_Year__c;
      }
      Integer cardYear = Integer.valueof(str);
      Integer cardMonth = Integer.valueof(cardInfo.Expiration_Month__c);
        if(cardYear< currentYear || ( cardMonth < currentMonth && cardYear == currentYear)){
      
            throw new PaymentPlanException ('Invalid Card Expiration Month-Year');
      
      }
    }
    
    static List<Payment_Plan_Line_Items__c> getOpenPaymentPlan(List<Payment_Plan_Line_Items__c> paymentPlanLst){
        
        sunShineCentre = paymentPlanLst[0].Sunshine_Center__c;
        List<Payment_Plan_Line_Items__c> openPaymentPlan = new List<Payment_Plan_Line_Items__c>();
        refIds = new List<string>();
        for(Payment_Plan_Line_Items__c ppl : paymentPlanLst){
            if(ppl.Status__c.equals('Open')){
                openPaymentPlan.add(ppl);
                refIds.add(ppl.Id);
            }
        }
        paymentPlanLst.clear();
        return openPaymentPlan;
    }
    
    
    public static string updateRecordLineItemAfterResponse(List<Payment_Plan_Line_Items__c> lstPaymentLine,
                                                            PaymentAuthorization pp,
                                                            Card_Information__c ci,
                                                            string fileName,
                                                            decimal totalDueAmount){

        string jsonRequest = pp.JSONReq;
        string jsonRespone = pp.GetPaymentAuthorization();
        string amount = String.valueOf(totalDueAmount);
        //Authorize_Net_Transaction_Info__c authObj;
        AuthorizeNetResponse responseObj = AuthorizeNetResponse.parse(jsonRespone);
        string errorMsg = '';
        
        if(responseObj?.transactionResponse == null){
            throw new PaymentPlanException ('Invalid Transaction');
        }
        if(responseObj?.transactionResponse?.errors != null &&
           !responseObj?.transactionResponse?.errors?.isEmpty()){
               
           errorMsg = responseObj.transactionResponse.errors[0].errorText; 
        }
        
        lstAuthTransInfo = new List<Authorize_Net_Transaction_Info__c>();
        Set<string> setOfLineItemId = new Set<String>();
        for(Payment_Plan_Line_Items__c paymentLine : lstPaymentLine){
        
          if(paymentLine.Status__c=='Open'){
            authTransInfo = new Authorize_Net_Transaction_Info__c(Payment_Plan_Line_Items__c = paymentLine.ID,
                                                        Outbound_API_JSON__c = jsonRequest,
                                                        Inbound_API_Response__c = jsonRespone,
                                                        Total_Amount__c = string.valueOf(paymentLine.Amount_For_Collection__c));
            paymentLine.Actual_Mode_of_Collection__c = 'Debit/Credit Card';
            paymentLine.Card_Information__c = ci.Id;
            paymentLine.Collection_Reference_ID__c = responseObj?.transactionResponse?.transId;
            paymentLine.Card_Transaction_Message__c = errorMsg;
            string receipt = 'http://revenuecollections.s3.amazonaws.com/Sandbox/ClinicalPortal/Reimbursement/' + fileName + '_'+paymentLine.Id+'.pdf';
            captureOtherInfo(paymentLine,responseObj,authTransInfo);
            paymentLine.Payment_Receipt_URL__c = (paymentLine.Card_Transaction_Status__c == 'Approved') ?  receipt : '';
            if(paymentLine.Card_Transaction_Status__c != 'Approved'){
          
               return '';
            }
            setOfLineItemId.add(paymentLine.Id);
            lstAuthTransInfo.add(authTransInfo);
         }
         }
         return Json.serialize(setOfLineItemId);
    }
    
    static string createPdfUrl(Id authId, Id paymentPLanLineItem){
        
        PageReference pdf = Page.PaymentPlanReceiptTemplate;
        pdf.getParameters().put('trans_id',authId);
        Blob body;   
        body = pdf.getContentAsPDF();
        string bodyContent =  EncodingUtil.base64Encode(body);
        return JSON.serialize(new WrapperClass(bodyContent,paymentPLanLineItem));
    }
    
   
    public class WrapperClass {
     
        public String pdfContent;
        public String paymentLineItemId; 

        public WrapperClass(String pdfContent, String paymentLineItemId){
            this.pdfContent = pdfContent;
            this.paymentLineItemId = paymentLineItemId;
        }
    }
    
    
    
    static void captureOtherInfo(Payment_Plan_Line_Items__c paymentline, 
                                 AuthorizeNetResponse responseObj,
                                 Authorize_Net_Transaction_Info__c authObj){
         switch on responseObj.transactionResponse.responseCode {
                when '1' {       
                    paymentline.Card_Transaction_Status__c='Approved';
                    paymentline.Status__c = 'Closed';
                    paymentline.Closed_Date__c = date.Today();
                    authObj.Authorization_Code__c=responseObj.transactionResponse.authCode;
                    authObj.Transaction_ID__c=responseObj.transactionResponse.transId;
                    authObj.Transaction_Type__c='Authorization w/ Auto Capture';
                    authObj.Card_Number__c=responseObj.transactionResponse.accountNumber;
                    authObj.Submit_Date_Time__c= string.valueOfGmt(system.now());
                    authObj.Transaction_Status__c='Captured';
                    authObj.Card_Type__c= responseObj.transactionResponse.accountType;
                }   
                when '2' {      
                    paymentline.Card_Transaction_Status__c='Declined';
                }
                when '3' {       
                    paymentline.Card_Transaction_Status__c='Error';
                }
                when '4' {       
                    paymentline.Card_Transaction_Status__c='Held for Review';
                }
            }
    }

    public static List<string> processPdfs(List<string> lstPli){

        List<Payment_Plan_Line_Items__c> lstPpl = [select id,(select id, 
                        Inbound_API_Response__c, Outbound_API_JSON__c,
                     City_F__c, Card_Type__c, Card_Number__c, Expiration_Date__c from
                      Authorize_Net_Transaction_Infos__r Order by createddate desc limit 1) from Payment_Plan_Line_Items__c  WHERE ID IN :lstPli ];
        
        List<string> lstWrapperResponse = new List<string>();
        for(Payment_Plan_Line_Items__c ppli : lstPpl){
            
            if(ppli.Authorize_Net_Transaction_Infos__r.isEmpty()){
                continue;
            }
            lstWrapperResponse.add(createPdfUrl(ppli.Authorize_Net_Transaction_Infos__r[0].Id,ppli.Id));
        }
        return lstWrapperResponse;
    }
    
    public class PaymentPlanException extends Exception {}
}