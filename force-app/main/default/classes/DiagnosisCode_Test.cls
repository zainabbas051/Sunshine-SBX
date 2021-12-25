@isTest
private class DiagnosisCode_Test
{

    Public Static Client_Chart__c ClientID ;
    Public Static Clinical_Evaluation__c CE;
    Public Static Clinical_Evaluation__c CE1;
    Public Static Clinical_Evaluation_2__c CE2;
    Public Static Clinical_Evaluation_3__c CE3;
    Public Static Clinical_Evaluation_3__c CE3Ext;
    Public Static Clinical_Evaluation_3__c CE3Ext1;
    Public Static Tx_and_D_C_Plans__c Dplan;
    Public Static Tx_and_D_C_Plans__c Detplan;

    public Static testmethod void DiagnosisCode_Test()
    {
    
        PrepareData1();
        PrepareData2();        
    }
    
    public Static testmethod void PrepareData1()
    {
        TabViews__c tv = new TabViews__c();
         tv.Name = 'Medical';
         tv.Button_Access_Type__c = 'Admin';
         insert tv;
        
        ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        Insert ClientID;
        
        System.debug('ClientID : ' + ClientID);
        
        awsBucket__c AWS = new awsBucket__c();
        AWS.Name='FREEPU';
        AWS.accessKeyId__c='Testaccesskey';
        AWS.Bucket__c='TestBucket';
        AWS.secretAccessKey__c='Tessecretkey';
        insert AWS; 
        
        DiagnosisCode__c setting = new DiagnosisCode__c();
        setting.Name = 'Test Setting';
        setting.Description__c = 'CodeForFever';
        insert setting;
        
        system.debug('setting' + setting);
        
        CE = new Clinical_Evaluation__c();
        CE.Client_Chart__c = ClientID.id;
        Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Phsych Evaluation').getRecordTypeId();
        CE.RecordtypeId = BPSARecordTypeId ;
        CE.Diagnosis_Code__c = 'Test;Test2;Test3';
        
        insert CE;
        
        CE3Ext = new Clinical_Evaluation_3__c();
        CE3Ext.Clinical_Evaluation__c = CE.Id;
        insert CE3Ext;
        
        CE1 = new Clinical_Evaluation__c();
        CE1.Client_Chart__c = ClientID.id;
        Id BPSARecordTypeId1 = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Phsych Evaluation').getRecordTypeId();
        CE1.RecordtypeId = BPSARecordTypeId ;
        CE1.Diagnosis_Code__c = 'Test;Test2;Test3';
        
        insert CE1;
        
        CE3Ext1 = new Clinical_Evaluation_3__c();
        CE3Ext1.Clinical_Evaluation__c = CE1.Id;
        insert CE3Ext1;
        
        
        Dplan = new Tx_and_D_C_Plans__c();
        Dplan.Client_Chart__c = ClientID.id;
        Dplan.Diagnosis__c = 'test1; test2;';
        Dplan.RecordTypeId = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Discharge Plan').getRecordTypeId();
        insert Dplan;
        
        Detplan = new Tx_and_D_C_Plans__c();
        Detplan.Client_Chart__c = ClientID.id;
        Detplan.Diagnosis__c = 'test1; test2;';
        Detplan.RecordTypeId = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Detox Treatment Plan').getRecordTypeId();
        insert Detplan;
        
        Order__c ord = new Order__c();
        ord.status__c = 'Active';
        ord.Client_Chart__c = ClientID.id;
        ord.Start_Date__c = dateTime.Now();
        insert ord;
        
        Order__c ord1 = new Order__c();
        ord1.status__c = 'Inactive';
        ord1.Client_Chart__c = ClientID.id;
        ord1.Clinical_Evaluation_3__c = CE3Ext1.id;
        ord1.Start_Date__c = dateTime.Now();
        insert ord1;
        
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        ApexPages.currentPage().getParameters().put('ceId', CE.id);
        ApexPages.currentPage().getParameters().put('type', 'Phsych Evaluation');
        ApexPages.currentPage().getParameters().put('readOnly', 'true');
       
        
        diagnosiscode DC = new diagnosiscode();
        DC.SelectedSignedOption = 'Staff';
        DC.isEdit = true;
        DC.Cancel();
        //ApexPages.currentPage().getParameters().put('ceId', CE.id);
        DC.Save();
        DC.Edit();
        DC.CloseSignatureForm();
        
        DC.SelectedSignedOption = 'Patient';
        DC.CloseSignatureForm();
        DC.BackToCE();
        DC.updateMedications();
        
        ApexPages.currentPage().getParameters().put('ceId', CE3Ext1.id);
        PsychEvaluation2 pe2 = new PsychEvaluation2();
        pe2.SelectedSignedOption = 'Staff';
        pe2.isEdit = true;
        pe2.Cancel();
        //ApexPages.currentPage().getParameters().put('ceId', CE.id);
        pe2.getAllMeds();
        pe2.updateMedications();
        pe2.Save();
        pe2.Edit();
        pe2.CloseSignatureForm();
        pe2.back();
        pe2.CEId = null;
        pe2.Cancel();
        pe2.Save();
        pe2.quicksave();
        Boolean Flag = pe2.buttonAccessType;
    }
    
        public Static testmethod void PrepareData2()
        {
            ClientID = new Client_Chart__c();
            ClientID.Name = 'Test Client';
            ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
            Insert ClientID;
            ApexPages.currentPage().getParameters().put('Id', ClientID.id);
            ApexPages.currentPage().getParameters().put('ceId', null);
            ApexPages.currentPage().getParameters().put('type', 'Phsych Evaluation');
            ApexPages.currentPage().getParameters().put('readOnly', 'false');
            
            awsBucket__c AWS = new awsBucket__c();
            AWS.Name='FREEPU';
            AWS.accessKeyId__c='Testaccesskey';
            AWS.Bucket__c='TestBucket';
            AWS.secretAccessKey__c='Tessecretkey';
            insert AWS; 
            
            Order__c order = new Order__c();
            order.Client_Chart__c = ClientID.id;
            order.Status__c = 'Inactive';
            order.Start_Date__c = dateTime.Now();
            insert order;
            
            diagnosiscode DC = new diagnosiscode();
            DC.SelectedSignedOption = 'Patient';
            DC.Cancel();
            //DC.CloseSignatureForm();
            //DC.Save();
        }
}