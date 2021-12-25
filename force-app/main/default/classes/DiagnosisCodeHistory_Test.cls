@isTest
private class DiagnosisCodeHistory_Test{

    Public Static Client_Chart__c ClientID ;
    Public Static Clinical_Evaluation__c CE;
    Public Static Clinical_Evaluation_2__c CE2;
    Public Static Clinical_Evaluation_3__c CE3;
    Public Static Tx_and_D_C_Plans__c Dplan;
    Public Static Tx_and_D_C_Plans__c Detplan;

    public Static testmethod void DiagnosisCodeHistory_Test()
    {
        ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        Insert ClientID;
        
        CE = new Clinical_Evaluation__c();
        CE.Client_Chart__c = ClientID.id;
        CE.Diagnosis_Code__c = 'test1; test2';
        Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Phsych Evaluation').getRecordTypeId();
        CE.RecordtypeId = BPSARecordTypeId ;
        insert CE;
        
        CE2 = new Clinical_Evaluation_2__c();
        CE2.Client_Chart__c = ClientID.id;
        CE2.AA_NA_exp__c = 'Test AA_NA_exp__c';
        //Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation_2__c.getRecordTypeInfosByName().get('Phsych Evaluation').getRecordTypeId();
        //CE2.RecordtypeId = BPSARecordTypeId ;
        insert CE2;
        
        CE3 = new Clinical_Evaluation_3__c();
        CE3.Name = 'Test Clinical Evaluation 3';
        CE3.Clinical_Evaluation_2__c = CE2.ID;
        CE3.HP_Diagnosis_Code__c = 'test1; test2';
        CE3.Client_Chart__c = ClientID.id;
        Id RecordTypeId = Schema.SObjectType.Clinical_Evaluation_3__c.getRecordTypeInfosByName().get('History And Physical').getRecordTypeId();
        CE3.RecordtypeId = RecordTypeId;
        insert CE3;
        
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
        
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        ApexPages.currentPage().getParameters().put('ceId', CE.id);
        
        Allergies__c ALgObj = new Allergies__c();
        ALgObj.Allergen__c = 'alg1,alg2,alg3,alg4';
        ALgObj.Client_Chart__c = ClientID.id;
        insert ALgObj;
        
        Tx_and_D_C_Plans__c TxObj =  new  Tx_and_D_C_Plans__c();
        Id TxObjRecordTypeId = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Discharge Plan').getRecordTypeId();
        TxObj.RecordtypeId = TxObjRecordTypeId  ;
        TxObj.Client_Chart__c = ClientID.id;
        insert TxObj ;
        
        DiagnosisCodeHistory DCH = new DiagnosisCodeHistory();
        
        
        
    
    }

}