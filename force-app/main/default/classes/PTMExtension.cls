//Test Class : PTMExtensionTest
public without sharing class PTMExtension{

    private final Case caseRecord;
    private final logInsuranceClaimCall insuranceClaim;  
    public id caseRecordId;
    public case tempCaseRecord{Get;set;}
    public boolean readOnly{get;set;}
    public string Status='';
    public id frEditIndex{get;set;}
    public id frSentIndex{get;set;}
    public id frSaveIndex{get;set;}  
    
    public PTMExtension(logInsuranceClaimCall logInsuranceClaimCall) {
         this.insuranceClaim= logInsuranceClaimCall;
          System.debug('insuranceClaim: ' + insuranceClaim);
          loadData(); 
    }     
    
    public list<fedexReq> fedexReqList{
        get{
            if(fedexReqList== null)
                fedexReqList= new List<fedexReq>();
            return fedexReqList;
        }set;
    }    
    
     public void loadData(){
        string  caseId = ApexPages.currentPage().getParameters().get('id');
        if(fedexReqList.size()>0)           
          fedexReqList.clear();
           
          for(Fedex_Envelope_Request__c fer: [SELECT Id, Name, Envelope_Created_Date__c, Envelope_Sent_Date__c, Envelope_Tracking__c, Status__c FROM Fedex_Envelope_Request__c  WHERE Related_Case__c =: caseId ORDER BY CreatedDate DESC NULLS LAST]){
            fedexReq fr = new fedexReq(fer.id, fer.Name, fer.Status__c, fer.Envelope_Created_Date__c, fer.Envelope_Sent_Date__c, fer.Envelope_Tracking__c, True); 
                 fedexReqList.add(fr);
             }
            
        }
    
    
     public pageReference addFedexReq(){
        String message='';  
        Boolean tempflag = false;
        if(fedexReqList.size()>0){
            for(fedexReq fr : fedexReqList){
                if(fr.status != 'Sent'){
                    tempflag = true;
                   
                }
            } 
        }
        If (tempflag == false){ 
            Fedex_Envelope_Request__c tempFER = new Fedex_Envelope_Request__c();
             if (!Test.IsRunningTest())
   
            tempFER.Related_Case__c = ApexPages.currentPage().getParameters().get('id');
            system.debug('related case::' +tempFER.Related_Case__c);
            insert tempFER;
            
            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/insuranceCaseViewPage?id='+tempFER.Related_Case__c);
            return pr;
        }else{
          message='Please make sure all previous Rows are in Sent Status to create a new Fedex Request Row!!';
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
       }
       return null;
    } 
    
    
      public void editFedexRequest(){
        if(frEditIndex != null){
            for(fedexReq fr : fedexReqList){
                if(fr.fr_id == frEditIndex){
                    fr.readOnly=False;
                    break;
                }
            }
        }
    }
    
    public void sentFedexRequest(){
        if(frSentIndex != null){
            for(fedexReq fr : fedexReqList){
               if(fr.fr_id == frSentIndex){
                   Fedex_Envelope_Request__c fer = new Fedex_Envelope_Request__c(id = frSentIndex);
                    if(checkRequiredFieldsSentFedexItem(fr) == False){
                       break;
                    }else{
                       fer.Status__c = 'Sent';
                        fr.readOnly=False;
                     
                   try{
                        update fer;
                       }catch(exception e){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));
                    }                   
                   
                    break;
                }
             }
           } 
           loadData(); 
        }
    }
    
     public void saveFedexRequest(){
        if(frSaveIndex != null){
            for(fedexReq fr : fedexReqList){
                if(fr.fr_id == frSaveIndex ){
                    fr.readOnly = True;
                    Fedex_Envelope_Request__c fer = new Fedex_Envelope_Request__c(id = frSaveIndex);
                    fer.Envelope_Created_Date__c = fr.envcreatedt ;
                    fer.Envelope_Sent_Date__c = fr.envsentdt;
                    fer.Envelope_Tracking__c = fr.envtrackingno;
                    
                    try{
                        update fer;
                       }catch(exception e){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,e.getMessage()));
                    }
                    
                    break;
                }
            }
            loadData();
        }
    } 
    
    
     public boolean checkRequiredFieldsSentFedexItem(fedexReq  frRecord){
        String message='';      
        Boolean success=true;
                
        if(frRecord.envcreatedt == null ){
            success=false;
            message='Please Make Sure Envelope Created Date has been punched in the  Fedex Request Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        if(frRecord.envsentdt == null ){
            success=false;
            message='Please Make Sure Envelope Sent Date has been punched in the Fedex Request Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        if(frRecord.envtrackingno == null){
            success=false;
            message='Please Make Sure Envelope Tracking # has been punched in the Fedex Request Line Item You Are Trying to CLOSE!!';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        }
        
        return success;
    }
     public List<SelectOption> getstatusValues() {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Not Sent','Not Sent'));
            options.add(new SelectOption('Sent','Sent'));
        return options;
    }
    public String getStatus() {
        return Status;
    }
    public void setStatus(String status) {
        this.Status = status;
    }
    
   public class fedexReq{
       public id fr_id{get;set;} 
       public string fr_name{get;set;}
       public boolean readOnly{get;set;}
       public date envcreatedt{get;set;}
       public date envsentdt{get;set;}
       public string envtrackingno{get;set;}
       public string status{get;set;}  
     
       public fedexReq(string fr_id, String fr_name, string status, date envcreatedt, date envsentdt, string envtrackingno, boolean readOnly){
            this.fr_id = fr_id;
            this.fr_name = fr_name;
            this.status = status;
            this.envcreatedt = envcreatedt; 
            this.readOnly = readOnly;
            this.envsentdt = envsentdt;
            this.envtrackingno = envtrackingno;
         } 
     } 
 }