@isTest
private class PsychiatricProgressCtlrTest {
    Public Static Client_Chart__c ClientID ;
    
    public Static testmethod void PsychiatricProgressCtlr_Test()
    {
        
        PrepareData1();
           
    }
    
    public Static testmethod void PrepareData1()
    {
        ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        Insert ClientID;
        
        DiagnosisCode__c setting = new DiagnosisCode__c();
        setting.Name = 'Test Setting';
        setting.Description__c = 'CodeForFever';
        insert setting;
        
        Medical__c med = new Medical__c();
        med.Client_Chart__c  = ClientID.Id;
        insert med;    
        
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        ApexPages.currentPage().getParameters().put('mcid', med.id);
        ApexPages.currentPage().getParameters().put('readOnly', '0');
        
        
        PsychiatricProgressCtlr pp = new PsychiatricProgressCtlr();
        pp.editPPNRecord();
        pp.SavePPNRecord();
        pp.updateMedications();
        pp.SavePPNRecordQuick();
    }
}