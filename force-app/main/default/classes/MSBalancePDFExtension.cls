// test class is MSBalancePDFExtensionTest
public class MSBalancePDFExtension{

       // here  is api name used to call and then oppRecord is variable name 
      // private final Opportunity oppRecord;
       private final PTM_Invoice_Process__c invRecord; 
           
       private ID oppID;
       public string dateOfService{get;set;}
       public string Description{get;set;}
       public double balanceAmount{get;set;}
       Public string companyName{get;set;}
       Public string companyAddressLine1{get;set;}
       Public string companyAddressLine2{get;set;}
       Public string collectorName{get;set;}
       Public string collectorPhone{get;set;}
       Public string collectorEmail{get;set;}
       Public string PTMUser{get;set;}
       Public string PTMUserPhone{get;set;}
       Public string PTMUserEmail{get;set;}
       Public string PTMUserid{get;set;}
       Public string policynumber{get;set;}
       Public string insuranceprovider{get;set;}
       Public string provideraddress{get;set;}
       Public string providercity{get;set;}
       Public string providerstate{get;set;}
       Public string providerzipcode{get;set;} 
       Public string invoicenumber{get;set;} 
       Public string opportunityname{get;set;}
       
       
       public MSBalancePDFExtension(ApexPages.StandardController stdController) {
        this.invRecord= (PTM_Invoice_Process__c)stdController.getRecord();
        loadData();//This method will populate the Apex Properties defined above with the respective data
        
       }
       // This is apex property to call in Visulaforce page
        case casetotal;
        public List<case> caseList{
           get{
            if(caseList== Null){
                caseList= new List<case>();
            }
            return caseList;
        }
        set;
        }
      
     
        
        
        public List<Insurance_Information__c> insuranceList{
           get{
            if(insuranceList == Null){
                insuranceList = new List<Insurance_Information__c>();
            }
            return insuranceList;
        }
        set;
        }
        
         public List<PTM_Invoice_Process__c> invList{
           get{
            if(invList == Null){
                invList = new List<PTM_Invoice_Process__c>();
            }
            return invList;
        }
        set;
        }
    
    
        public date todayDate{
        get{
            return date.Today();
           }set;
        
        }
        
        
        
        public void loadData(){
      
          
        String invoiceId = ApexPages.currentPage().getParameters().get('id');//getting the Id mentioned in the currently opened VF Page, which will be the ID of the Oclortunnity
        //String OpportunityId = 'Select Related_Opp__c from PTM_Invoice_Process__c where id = invoiceId';
        
       for(PTM_Invoice_Process__c  inv : [Select id, Name, Related_Opp__c, Related_Opp__r.Name, Related_Opp__r.Sunshine_Center__r.Name, Related_Opp__r.Sunshine_Center__r.BillingStreet, Related_Opp__r.Sunshine_Center__r.BillingCity, Related_Opp__r.Sunshine_Center__r.BillingState, Related_Opp__r.Sunshine_Center__r.BillingPostalCode,createdby.name,createdby.phone,createdby.email from PTM_Invoice_Process__c where Id =: invoiceId]){
            if(inv.Related_Opp__r.Name != null){
                opportunityname = inv.Related_Opp__r.Name;
                oppID =inv.Related_Opp__c;
                PTMUser=inv.createdby.name;
                PTMUserPhone=inv.createdby.phone;
                PTMUserEmail=inv.createdby.email;
                companyName = inv.Related_Opp__r.Sunshine_Center__r.Name;
                companyAddressLine1 = inv.Related_Opp__r.Sunshine_Center__r.BillingStreet;
                companyAddressLine2 = inv.Related_Opp__r.Sunshine_Center__r.BillingCity+' '+inv.Related_Opp__r.Sunshine_Center__r.BillingState+' '+inv.Related_Opp__r.Sunshine_Center__r.BillingPostalCode;
                invList.add(inv);    
            }
        }
           
        for(Case cl: [Select Id,Opportunity__r.Insurance_Collector__r.Phone,Opportunity__r.Insurance_Collector__r.name,Opportunity__r.Insurance_Collector__r.email, Level_of_Care__c, Bill_To_Date__c, Bill_From_Date__c, Billed_Amount__c, Amount_Being_Paid_To_Member__c, Status  from Case Where id in (select PTM_Case__c from Invoice_Junction__c where PTM_Invoice_Process__c =: invoiceId) Order By Bill_From_Date__c asc]){
         
         
         collectorName = cl.Opportunity__r.Insurance_Collector__r.Name;
         collectorPhone = cl.Opportunity__r.Insurance_Collector__r.Phone;
         collectorEmail = cl.Opportunity__r.Insurance_Collector__r.email;
         caseList.add(cl); 
        }
             
                   
         for(Insurance_Information__c i:[select id,Insurance_Policy__c, Insurance_Providers__c, Address__c,City__c, State__c, Zip_Code__c from Insurance_Information__c where (Insurance_Status__c ='Primary' AND Opportunity__c =: oppID)]){
             policynumber = i.Insurance_Policy__c;
             insuranceprovider =  i.Insurance_Providers__c;
             provideraddress = i.Address__c;
             providercity = i.City__c;
             providerstate = i.State__c;
             providerzipcode = i.Zip_Code__c ;
             insuranceList.add(i); 
        }
         }
         
         Public case getcasetotal(){  
           caseTotal = new case(Amount_Being_Paid_To_Member__c = 0);
           for(Case c : caselist){
               if(c.Amount_Being_Paid_To_Member__c!=null)
               casetotal.Amount_Being_Paid_To_Member__c += c.Amount_Being_Paid_To_Member__c;
           }
           return casetotal;
           }
      
 }