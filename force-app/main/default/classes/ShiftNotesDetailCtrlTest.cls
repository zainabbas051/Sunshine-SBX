@isTest

public class ShiftNotesDetailCtrlTest{
    Public static Account a;
    Public static Client_Chart__c cl;
    Public static Bed_Board_Configuration__c bbc;
    Public static awsBucket__c  aws;
    Public static Incident_Report__c ir;
    Public static UtlizationReviewOrder__c ur ;
   

    static{
        aws = new awsBucket__c();
        aws.accessKeyId__c =  'AKIAIKHBOKKMOFRNX5XQ';
        aws.secretAccessKey__c = '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';
        aws.Bucket__c = 'freepu';
        aws.Name = 'FREEPU';
        insert aws;
        }
        
    public Static void createSampleData(){
        
         a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
         scid.name = a.Name;
         scid.Account_id__c = a.id;
         scid.House_Based_Selection__c = True;
         insert scid;
         
         cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         cl.Client_Status__c = 'Admitted';
         cl.Admit_Date_Time__c =datetime.now().addDays(-1);
         insert cl;
         
         bbc = new Bed_Board_Configuration__c();
         bbc.House_Name__c = 'test';
         insert bbc;
         
         ir = new Incident_Report__c();
         ir.Status__c = 'Open';
         ir.Staff_Signed_User__c = 'test';
         ir.House__c = bbc.id;
         ir.RecordTypeId =  Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Shift Note').getRecordTypeId();
         insert ir;
         
         ur = new UtlizationReviewOrder__c();
         ur.Client_Chart__c = cl.id;
         ur.Incident_Report__c = ir.id;
         ur.Shift_Notes__c = 'test';
         insert ur;
         
         
         
         Test.setCurrentPageReference(Page.ShiftNotes);
         
    }
    
     public Static testmethod void ShiftNotesDetailCtrlTest(){
     
         test.startTest();
         createSampleData();
         
         Test.setCurrentPageReference(Page.ShiftNotes);

         system.currentPageReference().getParameters().put('SNID', ir.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores');
         
         ShiftNotesDetailCtrl sndc = new ShiftNotesDetailCtrl();
         
         sndc.editSN();
         sndc.SaveShiftNotes();
         List<SelectOption> soList = sndc.getHouseItems();
         
         sndc.CloseShiftNote();
         
         list<Incident_Report__c> listSN = sndc.lstShiftNotes;
         DateTime cd = sndc.createdDate;
         string cb = sndc.createdBy;
         string sso = sndc.SelectedSignedOption;
         
         sndc.sethouseId(bbc.id);
         String houseId = sndc.gethouseId();
         //system.currentPageReference().getParameters().put('SNID', ir.id);
         //sndc.CloseShiftNote(); 
         
         
            
             
   }     
}