//Test Class : invoicePDFExtensionTest
public class invoicePDFExtension{

    private final Payment_Plan__c ppRecord;
    private final Insurance_Information__c iiRecord;
    private ID oppID;
    
    public string clientName{get;set;}//Apex Property of String Type with Name Client Name
    Public string insuranceName{get;set;}
    Public string policyNumber{get;set;}
    Public string companyName{get;set;}
    Public string companyAddressLine1{get;set;}
    Public string companyAddressLine2{get;set;}
    
    
    public invoicePDFExtension(ApexPages.StandardController stdController) {
        this.ppRecord= (Payment_Plan__c)stdController.getRecord();
        loadData();//This method will populate the Apex Properties defined above with the respective data
        //sumamt=0;
    }
    
    Public List<Payment_Plan_Line_Items__c> ppliList{
        get{
            if(ppliList == Null){
                ppliList = new List<Payment_Plan_Line_Items__c>();
            }
            return ppliList;
        }
        set;
    }
    
    
    public double sumamt{
        get{
            if(ppliList.size()>0){
                Decimal amount = 0.0;
                for(Payment_Plan_Line_Items__c ppli : ppliList){
                    if(ppli.Amount_For_Collection__c != null){
                        amount = amount + ppli.Amount_For_Collection__c;
                    }
                }
                return amount;
            }
            return 0.0;
        }
        set;
    }
    
    public date todayDate{
        get{
            return date.Today();
        }set;
    }
    
    public void loadData(){
        
        String paymentPlanId = ApexPages.currentPage().getParameters().get('id');//getting the Id mentioned in the currently opened VF Page, which will be the ID of the Payment Plan Record
        
        for(Payment_Plan__c pp : [Select id, Opportunity__r.Name, Opportunity__r.Sunshine_Center__r.Name, Opportunity__r.Sunshine_Center__r.BillingStreet, Opportunity__r.Sunshine_Center__r.BillingCity, Opportunity__r.Sunshine_Center__r.BillingState, Opportunity__r.Sunshine_Center__r.BillingPostalCode,Opportunity__c, (Select id,Due_Date__c,Type_of_Collection__c,Amount_For_Collection__c,Payment_Plan__c from Payment_Plan_Line_Items__r Where Status__c !=: 'Closed' ORDER BY Due_Date__c ASC) from Payment_Plan__c where Id =: paymentPlanId]){
            if(pp.Opportunity__r.Name != null){
                clientName = pp.Opportunity__r.Name;
                oppID = pp.Opportunity__c;
                companyName = pp.Opportunity__r.Sunshine_Center__r.Name;
                companyAddressLine1 = pp.Opportunity__r.Sunshine_Center__r.BillingStreet;
                companyAddressLine2 = pp.Opportunity__r.Sunshine_Center__r.BillingCity+' '+pp.Opportunity__r.Sunshine_Center__r.BillingState+' '+pp.Opportunity__r.Sunshine_Center__r.BillingPostalCode;
                ppliList.addAll(pp.Payment_Plan_Line_Items__r);    
            }
        }
        
         for(Insurance_Information__c ii : [Select id, Insurance_Providers__c,Insurance_Policy__c from Insurance_Information__c where Opportunity__c=: oppID AND Insurance_Status__c =:'Primary']){
           if(ii.Insurance_Providers__c != null){
               insuranceName = ii.Insurance_Providers__c;
           }
           if(ii.Insurance_Policy__c  != null){
               policyNumber = ii.Insurance_Policy__c;
           }
           
         }
    }
    
  


}