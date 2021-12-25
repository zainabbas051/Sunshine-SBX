@isTest
private class CE_HP_Test{

    Public Static Client_Chart__c ClientID ;
    Public Static Clinical_Evaluation_2__c CE2;
    Public Static Clinical_Evaluation_3__c CE3;
    Public Static CE_BPSA Obj ;//= new CE_BPSA();
    
    
    public Static testmethod void CE_HP_Test(){
        Test.startTest();
        PrepareData1();
        PrepareData2();
        Test.StopTest();
    }
    
    
    public Static testmethod void PrepareData1()
    {
    
        TabViews__c tv = new TabViews__c();
         tv.Name = 'Medical';
         tv.Button_Access_Type__c = 'Admin';
         insert tv;
        
        ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        Insert ClientID;
        
        CE2 = new Clinical_Evaluation_2__c();
        CE2.Client_Chart__c = ClientID.id;
        CE2.AA_NA_exp__c = 'Test AA_NA_exp__c';
        insert CE2;
        
        CE3 = new Clinical_Evaluation_3__c();
        CE3.Name = 'Test Clinical Evaluation 3';
        CE3.Clinical_Evaluation_2__c = CE2.ID;
        CE3.HP_Status__c = 'In Progress';
        CE3.HP_Diagnosis_Code__c = 'co12;ce13;co134';
        CE3.HP_Illness_No__c = true;
        CE3.HP_Surgery_No__c = true;
        CE3.HP_Injuries_No__c = true;
        CE3.HP_History_of_Seizures_No__c = true;
        CE3.HP_Sex_Transmitted_None__c = true;
        CE3.HP_Family_Medical_His_UnRemark__c = true;
        CE3.HP_Current_NonPsych_None__c = true;
        CE3.HP_Review_of_Sys_ENT_None__c = true;
        CE3.HP_Exam_Genitalia_None__c = true;
        
        Insert CE3;
        
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        ApexPages.currentPage().getParameters().put('ceId', CE3.id);
        ApexPages.currentPage().getParameters().put('type', 'History And Physical');
        
        awsBucket__c AWS = new awsBucket__c();
        AWS.Name='FREEPU';
        AWS.accessKeyId__c='Testaccesskey';
        AWS.Bucket__c='TestBucket';
        AWS.secretAccessKey__c='Tessecretkey';
        insert AWS; 
        
        Order__c OrderRec = new order__c();
        OrderRec.Status__c = 'Active';
        OrderRec.Client_Chart__c  = ClientID.id;
        OrderRec.Start_Date__c =  dateTime.NOW();
        insert OrderRec; 
        
        Recurring_Assessment__c ReqAccess = New Recurring_Assessment__c();
        ReqAccess.Name = 'Test Record';
        ReqAccess.Clinical_Evaluation_3__c  = CE3.id;
        ReqAccess.Client_Chart__c = ClientID.id;
        insert ReqAccess;
            
        Recurring_Assessment__c latestVital = New Recurring_Assessment__c();
        latestVital.Name = 'Test Record';
        latestVital.Clinical_Evaluation_3__c  = CE3.id;
        latestVital.Client_Chart__c = ClientID.id;
        insert latestVital;    
        
        CE_HP Hprecord = new CE_HP();
        Hprecord.SelectedSignedOption = 'Staff';
        
        Hprecord.latestVitals = latestVital;    
            
        Hprecord.updateMedications();
        Hprecord.updateVital();
        Hprecord.back();
        Hprecord.cancel();
        Hprecord.edit();
        Hprecord.save();
        Hprecord.CloseSignatureForm();
        Hprecord.checkAllRendering();
        Hprecord.checkAllRendering1();
        Hprecord.checkAllRendering3();
        Hprecord.QuickSave();
        
        CE_HP2 Hprecord2 = new CE_HP2();
        Hprecord2.SelectedSignedOption = 'Staff';
        
        Hprecord2.back();
        Hprecord2.cancel();
        Hprecord2.edit();
        Hprecord2.save();
        Hprecord2.CloseSignatureForm();
        Hprecord2.quicksave();
        Boolean Flag = Hprecord2.buttonAccessType;
        
    }
    
    
    public Static testmethod void PrepareData2()
    {
        
        ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        Insert ClientID;
        
        CE2 = new Clinical_Evaluation_2__c();
        CE2.Client_Chart__c = ClientID.id;
        CE2.AA_NA_exp__c = 'Test AA_NA_exp__c';
        insert CE2;
        
        CE3 = new Clinical_Evaluation_3__c();
        CE3.Name = 'Test Clinical Evaluation 3';
        CE3.Clinical_Evaluation_2__c = CE2.ID;
        CE3.HP_Status__c = 'In Progress';
        CE3.HP_Diagnosis_Code__c = 'co12;ce13;co134';
        CE3.HP_Illness_No__c = false;
        CE3.HP_Surgery_No__c = false;
        CE3.HP_Injuries_No__c = false;
        CE3.HP_History_of_Seizures_No__c = false;
        CE3.HP_Sex_Transmitted_None__c = false;
        CE3.HP_Family_Medical_His_UnRemark__c = false;
        CE3.HP_Current_NonPsych_None__c = false;
        CE3.HP_Review_of_Sys_ENT_None__c = false;
        CE3.HP_Exam_Genitalia_None__c = false;
        
        Insert CE3;
        
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        ApexPages.currentPage().getParameters().put('ceId', CE3.id);
        ApexPages.currentPage().getParameters().put('type', 'History And Physical');
        
        awsBucket__c AWS = new awsBucket__c();
        AWS.Name='FREEPU';
        AWS.accessKeyId__c='Testaccesskey';
        AWS.Bucket__c='TestBucket';
        AWS.secretAccessKey__c='Tessecretkey';
        insert AWS; 
        
        Order__c OrderRec = new order__c();
        OrderRec.Status__c = 'Active';
        OrderRec.Client_Chart__c  = ClientID.id;
        OrderRec.Start_Date__c =  dateTime.NOW();
        insert OrderRec; 
        
        Recurring_Assessment__c ReqAccess = New Recurring_Assessment__c();
        ReqAccess.Name = 'Test Record';
        ReqAccess.Clinical_Evaluation_3__c  = CE3.id;
        ReqAccess.Client_Chart__c = ClientID.id;
        insert ReqAccess;
        
        Recurring_Assessment__c latestVital = New Recurring_Assessment__c();
        latestVital.Name = 'Test Record';
        latestVital.Clinical_Evaluation_3__c  = CE3.id;
        latestVital.Client_Chart__c = ClientID.id;
        insert latestVital;        
            
        CE_HP Hprecord = new CE_HP();
        Hprecord.SelectedSignedOption = 'Patient';
        
        Hprecord.latestVitals = latestVital;     
            
        Hprecord.updateMedications();
        Hprecord.updateVital();
        Hprecord.back();
        Hprecord.cancel();
        Hprecord.edit();
        Hprecord.save();
        Hprecord.CloseSignatureForm();
        Hprecord.checkAllRendering();
        Hprecord.checkAllRendering1();
        Hprecord.checkAllRendering3();
            
        Hprecord.updateVitalsOnLoad();    
        
        
    
    }
    
    }