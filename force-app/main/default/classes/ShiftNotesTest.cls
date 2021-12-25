@isTest
private class ShiftNotesTest{

    static{
        awsBucket__c aws = new awsBucket__c();
        aws.accessKeyId__c =  'AKIAIKHBOKKMOFRNX5XQ';
        aws.secretAccessKey__c = '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';
        aws.Bucket__c = 'freepu';
        aws.Name = 'FREEPU';
        insert aws;
        }
        
    //test method for ShiftNotesClientCtrl class
    static testmethod void ShiftNotesClientCtrl(){
        
         test.startTest();
                  
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
         scid.name = a.Name;
         scid.Account_id__c = a.id;
         scid.House_Based_Selection__c = True;
         insert scid;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         cl.Admit_Date_Time__c= DateTime.Now().AddDays(-10);
         cl.Discharge_Date_Time__c = DateTime.Now().AddDays(30);
         insert cl;
         
         Incident_Report__c ir = new Incident_Report__c();
         ir.Status__c = 'Open';
         ir.RecordTypeId =  Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Shift Note').getRecordTypeId();
         ir.Sunshine_Center__c = a.id;
         insert ir;
         
         UtlizationReviewOrder__c ur = new UtlizationReviewOrder__c();
         ur.Client_Chart__c = cl.id;
         ur.Incident_Report__c = ir.id;
         ur.Shift_Notes__c = 'test';
         insert ur;
         
         
         
         Test.setCurrentPageReference(Page.ShiftNotesClient);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores');
         
         ShiftNotesClientCtrl shiftNotes = new ShiftNotesClientCtrl();
         shiftNotes.getCurrentWeek();
         shiftNotes.getPreviousWeek();
         shiftNotes.GetNextWeek();
         
         test.stopTest();
    }
    
    //test method for ShiftNotesCtrl class
    static testmethod void ShiftNotesCtrl(){
        
        
        test.startTest();
                  
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
         scid.name = a.Name;
         scid.Account_id__c = a.id;
         scid.House_Based_Selection__c = True;
         insert scid;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         cl.Client_Status__c = 'Admitted';
         cl.Admit_Date_Time__c =datetime.now().addDays(-1);
         //cl.Admit_Date_Time__c= DateTime.Now().AddDays(-10);
         cl.Discharge_Date_Time__c = DateTime.Now().AddDays(30);
         insert cl;
         
          Incident_Report__c ir = new Incident_Report__c();
         ir.Status__c = 'Open';
         ir.RecordTypeId =  Schema.SObjectType.Incident_Report__c.getRecordTypeInfosByName().get('Shift Note').getRecordTypeId();
         ir.Sunshine_Center__c = a.id;
         insert ir;
         
         UtlizationReviewOrder__c ur = new UtlizationReviewOrder__c();
         ur.Client_Chart__c = cl.id;
         ur.Incident_Report__c = ir.id;
         ur.Shift_Notes__c = 'test';
         insert ur;
         
         
         
         Bed_Board_Configuration__c bbc = new Bed_Board_Configuration__c();
         bbc.House_Name__c = 'La Cuesta';
         bbc.Sunshine_Center__c = a.id;
         insert bbc;
         
         Test.setCurrentPageReference(Page.ShiftNotes);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores');
       //commented by danish because i need to deply shiftnotesclient
         ShiftNotesCtrl shiftNotes = new ShiftNotesCtrl();
         
         shiftNotes.selectedHouse = bbc.id;
         PageReference pr1 = shiftNotes.AddNewShiftNote();
         
         shiftNotes.getPreviousWeek();
         shiftNotes.GetNextWeek();
         
         
         test.stopTest();
    }
}