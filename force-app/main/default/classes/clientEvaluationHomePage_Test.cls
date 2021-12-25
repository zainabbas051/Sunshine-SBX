@isTest
private class clientEvaluationHomePage_Test
{
    
    Public Static Client_Chart__c ClientID ;
    Public Static Clinical_Evaluation__c CE;
    
    public Static testmethod void clientEvaluationHomePage_Test()
    {
        Test.startTest();
        PrepareData1();
        Test.stopTest(); 
    }

    public Static testmethod void PrepareData1()

    { 

        ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        Insert ClientID;
        
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        
        clientEvaluationHomePage CEHP = new clientEvaluationHomePage();
        CEHP.RecordTypeName = 'Bio-Psychosocial Assessment';
        CEHP.addNewCEForm();
        CEHP.RecordTypeName = 'Face to Face Evaluation';
        CEHP.addNewCEForm();
        CEHP.RecordTypeName = 'Phsych Evaluation';
        CEHP.addNewCEForm();
        CEHP.RecordTypeName = 'Pre Admission Assesment';
        CEHP.addNewCEForm();
        
        CEHP.addNewHPForm();
        CEHP.OpenHPForm();
        CEHP.addNew();
        CEHP.addNewPreAdd();
        CEHP.readPreAdd('test');
        CEHP.addNewFaceToFace();
        
        CEHP.addNewSelect = true;
        CEHP.backButton();
        CEHP.addNewPreAdd = true;
        CEHP.backButton();
        CEHP.addNewF2F = true;
        CEHP.backButton();
        CEHP.readPreAdd = true;
        CEHP.backButton();
        CEHP.readPreAddPAA = true;
        CEHP.backButton();
        CEHP.readPreAddF2F = true;
        CEHP.backButton();
        
        CEHP.CurrentCERType = 'Pre Admission Assesment';
        CEHP.OpenForm();
        CEHP.CurrentCERType = 'Face to Face Evaluation';
        CEHP.OpenForm();

    }
    
}