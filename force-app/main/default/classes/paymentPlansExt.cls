//Test Class : paymentPlansExtTest
public with sharing class paymentPlansExt{
    
    private final Opportunity oppRecord;
    public id oppRecordId;
    Public Payment_Plan__c tempPaymentPlan{get;set;}
    
    public integer deleteIndexValue{get;set;}
    
    Public static id tempPaymentPlanId;
    public string paymentPlanType='';
    public string modeOfPayment='';
    public string typeOfCollection = '';
    public List<docWrapper> setNewAttachments{get; set;} //List of Name of Non-uploaded Documents Type
    public String statusUpload {get;set;}
    Public Card_Information__c creditCardInfo{get;set;}
    
    public paymentPlansExt(ApexPages.StandardController stdController) {
        system.debug('constructor loading');
        this.oppRecord = (Opportunity)stdController.getRecord();
        oppRecordId = ApexPages.currentPage().getParameters().get('id');
        
        creditCardInfo = new Card_Information__c();
        
        tempPaymentPlan = new Payment_Plan__c();
        tempPaymentPlan.Opportunity__c = oppRecordId;
        setNewAttachments = new List<docWrapper>();
        setNewAttachments.add(new docWrapper());        
    }
    
    public List<SelectOption> getPaymentPlanTypes() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Custom','Custom'));
            options.add(new SelectOption('Monthly','Monthly'));
        return options;
    }
    public String getpaymentPlanType() {
        return paymentPlanType;
    }
    public void setpaymentPlanType(String paymentPlanType) {
        this.paymentPlanType = paymentPlanType;
    }
    
    public List<SelectOption> getTypeOfCollectionS() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Deductible','Deductible'));
            options.add(new SelectOption('Out of Pocket','Out of Pocket'));
            options.add(new SelectOption('Copays','Copays'));
            options.add(new SelectOption('Pharmacy','Pharmacy'));
            options.add(new SelectOption('Cash Pay','Cash Pay'));
            options.add(new SelectOption('Extension','Extension'));
            options.add(new SelectOption('Housing','Housing'));
            //options.add(new SelectOption('Rx/Housing','Rx/Housing'));
            options.add(new SelectOption('PTM Claims','PTM Claims'));
            options.add(new SelectOption('Journal Entry','Journal Entry'));
        return options;
    }
    public String gettypeOfCollection() {
        return typeOfCollection;
    }
    public void settypeOfCollection(String typeOfCollection) {
        this.typeOfCollection = typeOfCollection;
    }
    public static string paymentPlanId{
        get{
            if(paymentPlanId == null){
                paymentPlanId = tempPaymentPlanId;
            }
            return paymentPlanId;
        }set;
    }
    public List<SelectOption> getModeOfPayments() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Cash','Cash'));
            options.add(new SelectOption('Cheque','Cheque'));
            options.add(new SelectOption('Direct Deposit','Direct Deposit'));
            options.add(new SelectOption('Debit/Credit Card','Debit/Credit Card'));
        
        return options;
    }
    public String getmodeOfPayment() {
        return modeOfPayment;
    }
    public void setmodeOfPayment(String modeOfPayment) {
        this.modeOfPayment = modeOfPayment;
    }
    public string selectedModeOfPayment{
        get{
            return getmodeOfPayment();
        }set;
    }
    
    
    Public List<paymentPlanLineItems> paymentPlanLineItemsList{
        get{
            if(paymentPlanLineItemsList == null){
                paymentPlanLineItemsList = new List<paymentPlanLineItems>();
            }
            return paymentPlanLineItemsList;
        }set;
    }
    
    public void addPaymentPlanLineItems(){
        Integer indexVal = 0;
        if(paymentPlanLineItemsList.size()>0){
            indexVal = paymentPlanLineItemsList[paymentPlanLineItemsList.size()-1].index+1;
        }else{
            indexVal = 0;
        }
        paymentPlanLineItems ppli = new paymentPlanLineItems(indexVal);
        paymentPlanLineItemsList.add(ppli);
        
    }
    
    public void deletePaymentPlanLineItems(){
        try{
            integer listIndex = 0;
            integer tempIndexToDelete = 0;
            for(paymentPlanLineItems ppli : paymentPlanLineItemsList){
                system.debug(deleteIndexValue );//This gives us the index of the record we would like to delete from the UI
                system.debug(ppli.index);
                system.debug(listIndex);
                if(deleteIndexValue == ppli.index){
                    tempIndexToDelete = listIndex;
                    break;
                }
                listIndex++;
            }
            system.debug(tempIndexToDelete);
            paymentPlanLineItemsList.remove(tempIndexToDelete);
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }   
    }
    
    
    public PageReference savePaymentPlan(){
        //tempPaymentPlan.status__c = 'In-Progress';
        tempPaymentPlan.Mode_of_Payment__c = modeOfPayment;
        tempPaymentPlan.Payment_Plan_Type__c = paymentPlanType;
         
        try{
            Savepoint sp = Database.setSavepoint();
            if(checkRequiredFieldsPaymentPlans(tempPaymentPlan) == True){
                System.debug('PP: '+tempPaymentPlan);
                System.debug('Pck: '+checkRequiredFieldsPaymentPlans(tempPaymentPlan));
                insert tempPaymentPlan;
            }else{
                return null;
            }
            if(modeOfPayment == 'Debit/Credit Card'){
                system.debug('setNewAttachments[0] :::'+setNewAttachments[0]);
                Card_Information__c ci = new Card_Information__c();
                ci.Card_Number__c = setNewAttachments[0].cardNumber;
                ci.Name_on_Card__c= setNewAttachments[0].nameOnCard;
                ci.Expiration_Month__c = setNewAttachments[0].expirationMonth;
                ci.Expiration_Year__c = setNewAttachments[0].expirationYear;
                ci.CVV__c = setNewAttachments[0].cvvNumber;
                ci.Billing_Address__c = setNewAttachments[0].billingAddress;
                ci.Billing_City__c = setNewAttachments[0].billingCity;
                ci.Billing_State__c = setNewAttachments[0].billingState;
                ci.Billing_Zip__c = setNewAttachments[0].billingZip;
                ci.Payment_Plan__c = tempPaymentPlan.id;
                system.debug('card info ::'+ci);
                if(checkRequiredFieldsCardInformation(ci) == True)
                    insert ci;
                else{
                    Database.rollback(sp);
                    return null;
                } 
            }    
            List<Payment_Plan_Line_Items__c> ppliInsertList = new List<Payment_Plan_Line_Items__c>();
            if(paymentPlanType == 'Monthly'){
                for(Integer i=0; i<tempPaymentPlan.Number_of_Installments__c;i++){
                    Payment_Plan_Line_Items__c ppli = new Payment_Plan_Line_Items__c();
                    ppli.Due_Date__c = tempPaymentPlan.Start_Date__c.addMonths(i);
                    ppli.Amount_For_Collection__c = tempPaymentPlan.Total_Amount_To_Be_Collected__c/tempPaymentPlan.Number_of_Installments__c;
                    ppli.Payment_Plan__c = tempPaymentPlan.id;
                    system.debug('ppid'+ tempPaymentPlan.id);
                    ppli.Designated_Mode_of_Collection__c = modeOfPayment;
                    ppli.Type_of_Collection__c = typeOfCollection;
                    ppliInsertList.add(ppli);
                }
            } 
             
            if(paymentPlanType == 'Custom'){
                for(paymentPlanLineItems ppli : paymentPlanLineItemsList){
                    Payment_Plan_Line_Items__c ppli2 = new Payment_Plan_Line_Items__c();
                    ppli2.Due_Date__c = ppli.dueDate;
                    ppli2.Amount_For_Collection__c = ppli.amount;
                    ppli2.Payment_Plan__c = tempPaymentPlan.id;
                    ppli2.Designated_Mode_of_Collection__c = modeOfPayment;
                    ppli2.Type_of_Collection__c = typeOfCollection;
                    ppliInsertList.add(ppli2);
                }
            }
            
            if(ppliInsertList.size()>0){
                if(checkRequiredFieldsPPLI(ppliInsertList) == true){
                    System.debug('PPLI'+ppliInsertList);
                    System.debug('PPLIck'+checkRequiredFieldsPPLI(ppliInsertList));
                    insert ppliInsertList;
                }else{
                    Database.rollback(sp);
                    return null;
                }
            } 
        }catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));  
        }
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/PaymentPlanDetail?id='+tempPaymentPlan.id);
        return pr;
    }
    
    
    
    public boolean checkRequiredFieldsPaymentPlans(Payment_Plan__c ppRecord){
        String message='';      
        Boolean success=true;
        if(paymentPlanType == '--None--'){
            success=false;
            message='Please select the Payment Plan Type Before Saving the Payment Plan!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(modeOfPayment == '--None--'){
            success=false;
            message='Please select the Mode of Payment Before Saving the Payment Plan!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(typeOfCollection == '--None--'){
            success=false;
            message='Please select the Type of Collection Before Saving the Payment Plan!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        } 
        if(ppRecord.Start_Date__c == Null){
            success=false;
            message='Please select Start Date Before Saving the Payment Plan!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(ppRecord.Total_Amount_To_Be_Collected__c == Null){
            success=false;
            message='Please select the Total Amout To Be Collected Before Saving the Payment Plan!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(paymentPlanType == 'Monthly' && ppRecord.Number_of_Installments__c == Null){
            success=false;
            message='Please select the Number of Installments Before Saving the Payment Plan!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        return success;
    }
    
    public boolean checkRequiredFieldsCardInformation(Card_Information__c ciRecord){
        String message='';      
        Boolean success=true;
        if(ciRecord.Card_Number__c == '' || ciRecord.Card_Number__c == null){
            success=false;
            message='Please put in a valid Card Number!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(ciRecord.CVV__c == null){
            success=false;
            message='Please put in a valid CVV Number!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        } 
        if(ciRecord.Expiration_Year__c == '' || ciRecord.Expiration_Year__c == null){
            success=false;
            message='Please put in a valid Expiration Year!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(ciRecord.Expiration_Month__c == '' || ciRecord.Expiration_Month__c == null){
            success=false;
            message='Please put in a valid Expiration Month!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(ciRecord.Name_on_Card__c == '' || ciRecord.Name_on_Card__c == null){
            success=false;
            message='Please put in a valid Name on Card!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(ciRecord.Billing_Address__c == '' || ciRecord.Billing_Address__c == null){
            success=false;
            message='Please put in a valid Billing Address!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(ciRecord.Billing_City__c == '' || ciRecord.Billing_City__c == null){
            success=false;
            message='Please put in a valid Billing City!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(ciRecord.Billing_State__c == '' || ciRecord.Billing_State__c == null){
            success=false;
            message='Please put in a valid Billing State!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        if(ciRecord.Billing_Zip__c == '' || ciRecord.Billing_Zip__c == null){
            success=false;
            message='Please put in a valid Billing Zip!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        return success;
    }
    
    public boolean checkRequiredFieldsPPLI(List<Payment_Plan_Line_Items__c> ppliList){
        String message='';      
        Boolean success=true;
        for(Payment_Plan_Line_Items__c ppli : ppliList){
            if(ppli.Amount_For_Collection__c == null){
                success=false;
                message='Please put in a valid Amount for Collection in all Payment Plan Line Items!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
            if(ppli.Due_Date__c == null){
                success=false;
                message='Please put in a valid Due Date in all Payment Plan Line Items!!';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
            }
        }
        return success;
    }
    
    @TestVisible
    public class paymentPlanLineItems{
        public Integer amount{get;set;}
        public date dueDate{get;set;}
        public integer index{get;set;}
        
        public paymentPlanLineItems(Integer index){
            this.index = index;
        }
    }
    
    @TestVisible
    public class docWrapper {
        public string cardNumber{get;set;}
        public string nameOnCard{get;set;}
        public string expirationMonth{get;set;}
        public string expirationYear{get;set;}
        public decimal cvvNumber{get;set;}
        public string billingAddress{get;set;}
        public string billingCity{get;set;}
        public string billingState{get;set;}
        public string billingZip{get;set;}
        public docWrapper(){
            
        }
        
    }
}