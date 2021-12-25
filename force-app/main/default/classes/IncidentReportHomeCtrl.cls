/*
    controller class for IncidentReportsHomePage
*/
public class IncidentReportHomeCtrl{

    public string SelectedOption {get; set;}
    
    public list<RecordType> lstRecordTypes{get;set;}
    public list<RecordType> lstRecordTypesMIR{get;set;}
    

    public list<Incident_Report__c> lstClosedIncidentReports {get;set;}
    
    public list<Incident_Report__c> lstContracts{get;set;}
    public list<Incident_Report__c> lstMedicationIR{get;set;}
    
    id ccId;
    
    id IR_RT ;
    
    public IncidentReportHomeCtrl(){    
        
        
        ccId = ApexPages.CurrentPage().getParameters().get('id');
        
        
        
        loadRecords();
        getRecordTypes();
    }
    
    void getRecordTypes(){
        lstRecordTypes = [SELECT Id,Name FROM RecordType WHERE SobjectType='Incident_Report__c' and Id!=:IR_RT and Name not in ('Shift Note','Medication Incident Report')];
        lstRecordTypesMIR = [SELECT Id,Name FROM RecordType WHERE SobjectType='Incident_Report__c' and Id!=:IR_RT and Name in ('Medication Incident Attachment','Medication Incident Report')];
    }
    
    void loadRecords(){
    
        IR_RT = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Incident Report').getRecordTypeId();
    
        list<UtlizationReviewOrder__c> lstURO = [select id,Client_Chart__c, Incident_Report__c,Incident_Report__r.RecordTypeId,
        Incident_Report__r.RecordType.Name
         from UtlizationReviewOrder__c where Client_Chart__c =:ccId ];//and Incident_Report__r.RecordTypeId =:IR_RT];
         
         set<id> setIncidentIds = new set<id>();
         set<id> setContractIds = new set<id>();
         set<id> setMIRIds = new set<id>();
         
         
         for(UtlizationReviewOrder__c URO: lstURO){
             if(URO.Incident_Report__r.RecordTypeId == IR_RT)
                 setIncidentIds.add(URO.Incident_Report__c);
             else if(URO.Incident_Report__r.RecordTypeId != IR_RT && URO.Incident_Report__r.RecordType.Name !='Shift Note'
                    && URO.Incident_Report__r.RecordType.Name !='Medication Incident Report'&& URO.Incident_Report__r.RecordType.Name !='Medication Incident Attachment')
                 setContractIds.add(URO.Incident_Report__c);
             else if(URO.Incident_Report__r.RecordTypeId != IR_RT && URO.Incident_Report__r.RecordType.Name =='Medication Incident Report')
                 setMIRIds.add(URO.Incident_Report__c);
             else if(URO.Incident_Report__r.RecordTypeId != IR_RT && URO.Incident_Report__r.RecordType.Name =='Medication Incident Attachment')
                 setMIRIds.add(URO.Incident_Report__c);
         }
         
        lstClosedIncidentReports = [select id, RecordType.Name, Status__c, CreatedById, Date_Time__c, Incident_Reported_Date__c, Supervisor_Signed_User__c, Supervisor_Closed_Date__c
                 from Incident_Report__c where Status__c = 'Closed' and id in: setIncidentIds and RecordTypeId =:IR_RT ];
                 
        lstContracts= new list<Incident_Report__c>();
        lstContracts = [select id, RecordType.Name, Status__c,
                 Staff_Closed_Date__c,Staff_Signed_User__c  from Incident_Report__c
                        where id in: setContractIds order by ID desc];
        
        lstMedicationIR = new list<Incident_Report__c>();
        lstMedicationIR = [select id, RecordType.Name,RecordType.DeveloperName ,Title_of_Attachment__c,Status__c,
                 Staff_Closed_Date__c,Staff_Signed_User__c  from Incident_Report__c
                        where id in: setMIRIds order by ID desc];
    }
    
    public void SaveNewContracts(){
        
        SelectedOption = SelectedOption.subString(0,SelectedOption.length() - 1);
        
        List<Incident_Report__c> lstOfNewnewContracts = new List<Incident_Report__c>();                
        Incident_Report__c newCont;        
        
        for(string value : SelectedOption.split(',')){
            newCont= new Incident_Report__c();
            //newCont.Client_Chart__c = ccId;
            newCont.RecordTypeID = Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get(value).getRecordTypeId();
               newCont.Status__c ='Open';
              // newCont.SignedBy__c = 'Clien'
           // newARtool.Name =  recordType.name;
           lstOfNewnewContracts.add(newCont);            
            
        }
        if(lstOfNewnewContracts.size()>0)
            insert  lstOfNewnewContracts ;
        
        list<UtlizationReviewOrder__c> lstNewURO = new list<UtlizationReviewOrder__c>();
        UtlizationReviewOrder__c UR;
        
        for(Incident_Report__c ir : lstOfNewnewContracts ){
            UR = new UtlizationReviewOrder__c();            
            
            UR.Client_Chart__c = ccId;
            UR.Incident_Report__c = ir.id;
            lstNewURO.add(UR);
        }
        if(lstNewURO.size()>0)
            insert lstNewURO;
        //bind the list again to get the latest records;
        loadRecords();
    }
}