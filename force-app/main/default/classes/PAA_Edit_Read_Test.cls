@isTest
private class PAA_Edit_Read_Test
{
    
    Public Static Client_Chart__c ClientID ;
    Public Static Clinical_Evaluation__c CE;

    public Static testmethod void PAA_Edit_Read_Test()
    { 
        Test.startTest();
        PrepareData1();
        //PrepareData2();
        Test.stopTest();
    }
    
     public Static testmethod void PrepareData1()
     {
         ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';

        Insert ClientID;
        
        CE = new Clinical_Evaluation__c();
        CE.Client_Chart__c = ClientID.id;
        Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();
        CE.RecordtypeId = BPSARecordTypeId ;
        CE.Diagnosis_Code__c = 'Test;Test2;Test3';
         
        insert CE;
         
         //Constants.accessKeyId = 'Testaccesskey';
         //Constants.OrgName = 'TestOrg';
    
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        ApexPages.currentPage().getParameters().put('ceId', CE.id);
        ApexPages.currentPage().getParameters().put('type', 'Pre Admission Assesment');
        
        awsBucket__c AWS = new awsBucket__c();
        AWS.Name='FREEPU';
        AWS.accessKeyId__c='Testaccesskey';
        AWS.Bucket__c='TestBucket';
        AWS.secretAccessKey__c='Tessecretkey';
        insert AWS; 
        
        PAA_Edit_Read EditRecord = new PAA_Edit_Read();
        
        EditRecord.SelectedSignedOption = 'Staff';
        EditRecord.Edit();
        EditRecord.Save();
        EditRecord.Cancel();
        EditRecord.submit();
        EditRecord.Back();
        //EditRecord.addAllergy();
        //EditRecord.checkRender1();
        //EditRecord.checkRender2();
        //EditRecord.checkRendermh();
        //EditRecord.checkRendermh2();
        //EditRecord.checkRendercsp();
        //EditRecord.checkRendercsp1();
        //EditRecord.checkRenderth();
        //EditRecord.checkRenderth1();
        //EditRecord.checkRenderth2();
        //EditRecord.checkRenderfpah();
        //EditRecord.checkRenderfpah2();
        //EditRecord.checkRenderlp();
        //EditRecord.checkRenderlp2();
        EditRecord.closePopup();
        EditRecord.showPopup();
        //EditRecord.removeAllergy();
        EditRecord.CloseSignatureForm();
     }
     
     public Static testmethod void PrepareData2()
     {
         ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client 2';
                 
        Insert ClientID;
        
        CE = new Clinical_Evaluation__c();
        CE.Client_Chart__c = ClientID.id;
        Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();
        CE.RecordtypeId = BPSARecordTypeId ;
        CE.Diagnosis_Code__c = 'Test;Test2;Test3';
        CE.PAA_We_need_PHI_consent__c = 'No';
        insert CE;
    
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        ApexPages.currentPage().getParameters().put('ceId', null);
        ApexPages.currentPage().getParameters().put('type', 'Pre Admission Assesment');
        
        awsBucket__c AWS = new awsBucket__c();
        AWS.Name='FREEPU';
        AWS.accessKeyId__c='Testaccesskey';
        AWS.Bucket__c='TestBucket';
        AWS.secretAccessKey__c='Tessecretkey';
        insert AWS; 
        
        PAA_Edit_Read EditRecord = new PAA_Edit_Read();
        EditRecord.SelectedSignedOption = 'Patient';
        EditRecord.Edit();
        EditRecord.Save();
        EditRecord.Cancel();
        EditRecord.submit();
        EditRecord.Back();
        //EditRecord.addAllergy();
        //EditRecord.checkRender1();
        //EditRecord.checkRender2();
        //EditRecord.checkRendermh();
        //EditRecord.checkRendermh2();
        //EditRecord.checkRendercsp();
        //EditRecord.checkRendercsp1();
        //EditRecord.checkRenderth();
        //EditRecord.checkRenderth1();
        //EditRecord.checkRenderth2();
        //EditRecord.checkRenderfpah();
        //EditRecord.checkRenderfpah2();
        //EditRecord.checkRenderlp();
        //EditRecord.checkRenderlp2();
        EditRecord.closePopup();
        EditRecord.showPopup();
        //EditRecord.removeAllergy();
        EditRecord.CloseSignatureForm();
        
        EditRecord.Allergy5 = TRUE;
        EditRecord.Allergy4 = TRUE;
        //EditRecord.removeAllergy();
        EditRecord.Allergy3 = TRUE;
        //EditRecord.removeAllergy();
        EditRecord.Allergy2 = TRUE;
        //EditRecord.removeAllergy();
        EditRecord.Allergy1 = TRUE;
        //EditRecord.removeAllergy();
     }
    
}