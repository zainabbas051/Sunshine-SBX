@isTest
private class CE_FFE_Edit_Read_Test
{
    
    Public Static Client_Chart__c ClientID ;
    Public Static Clinical_Evaluation__c CE;
    

    public Static testmethod void CE_FFE_Edit_Read_Test()
    { 
        Test.startTest();
        PrepareData2();
        PrepareData1();
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
        Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Face to Face Evaluation').getRecordTypeId();
        CE.RecordtypeId = BPSARecordTypeId ;
        CE.Diagnosis_Code__c = 'Test;Test2;Test3';
        CE.Prior_Substance_abuse_treatment_with_dat__c = 'Yes';
        CE.PAA_family_history_of_substance_abuse__c = 'Yes';
        CE.FFE_Prior_Mental_Health_Dates__c = 'Yes';
        CE.FFE_Prior_IMP_Psychiatric_TX__c = 'Yes';
        CE.FFE_Family_history_of_Psychatric__c = 'Yes';
        CE.FFE_Psychotropic_Meds__c = 'Yes';
        CE.FFE_Self_Mutilating_Behaviour__c = 'Yes';
        CE.FFE_Current_Suicidal_ideations__c = 'Yes';
        CE.FFE_Prior_Suicide_attempts__c = 'Yes';
        CE.FFE_Violence_Homicidal_Ideations__c = 'Yes';
        CE.FFE_Domestic_Violence__c = 'Yes';
        CE.FFE_Perpetrator__c = 'Yes';
        CE.FFE_Legal_Issues__c = '';
        CE.FFE_Has_patient_failed_lower_level_of_Ca__c = '';
        CE.FFE_Difficulty_postponing_gratification__c = '';
        CE.FFE_Does_the_client_have_cravings__c = '';
        CE.FFE_Client_Recognize_Usage_Excessive__c = '';
        CE.FFE_Alcohol_drugs_present_in_environment__c = '';
        CE.FFE_Does_the_client_live_where_treatment__c = '';
        CE.FFE_Does_their_environment_undermine_eff__c = '';
        CE.FFE_Client_occupation_where_continued_us__c = '';
        CE.FFE_Sexual_Behavior_Relational_issues_Re__c = '';
        CE.FFE_Sexual_Behavior_Acting_Out__c = '';
        CE.FFE_Gambling_Addiction_Does_the_client_h__c = '';
        CE.PAA_Prior_Substance_abuse_treatmentC__c = TRUE;
        insert CE;
        
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        ApexPages.currentPage().getParameters().put('ceId', CE.id);
        ApexPages.currentPage().getParameters().put('type', 'Face to Face Evaluation');
        
        awsBucket__c AWS = new awsBucket__c();
        AWS.Name='FREEPU';
        AWS.accessKeyId__c='Testaccesskey';
        AWS.Bucket__c='TestBucket';
        AWS.secretAccessKey__c='Tessecretkey';
        insert AWS; 
        
        Recurring_Assessment__c ra = new Recurring_Assessment__c();
        //ra.Clinical_Evaluation__c = CE.Id; 
        ra.Client_Chart__c = ClientID.Id;
        ra.Status__c = 'Closed';
        ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
        insert ra;
        
        UtlizationReviewOrder__c toCreatedRecord = new UtlizationReviewOrder__c();
        toCreatedRecord.Vital_Sign__c = ra.Id;
        toCreatedRecord.Clinical_Evaluation__c = Ce.Id;
        insert toCreatedRecord;
        
        CE_FFE_Edit_Read EditRecord = new CE_FFE_Edit_Read();
        EditRecord.SelectedSignedOption = 'Staff';
        EditRecord.Edit();
        EditRecord.Save();
        EditRecord.Cancel();
        EditRecord.setCheckBoxes(); 
        EditRecord.checkRender1();
        EditRecord.checkRenderfhs();
        EditRecord.checkRenderpsmht();
        EditRecord.checkRenderdimpp();
        EditRecord.checkRenderdfhpb();
        EditRecord.checkRenderdpm();
        EditRecord.checkRenderdsmb();
        EditRecord.checkRenderdcsi();
        EditRecord.checkRenderdpsa();
        EditRecord.checkRenderdvhi();
        EditRecord.checkRenderddve();
        EditRecord.checkRenderdprep();
        EditRecord.checkRenderdli();
        EditRecord.checkRenderdpflc();
        EditRecord.checkRenderddpg();
        EditRecord.checkRenderddchc();
        EditRecord.checkRenderdcrue();
        EditRecord.checkRenderdadpe();
        EditRecord.checkRenderdaclw();
        EditRecord.checkRenderddtu();
        EditRecord.checkRenderdcowc();
        EditRecord.checkRenderdsbri();
        EditRecord.checkRenderdsbao();
        EditRecord.checkRenderdgadc();
        EditRecord.CloseSignatureForm();
        
        EditRecord.isEdit= false;
        EditRecord.Back();
        EditRecord.getLatestVital();
        boolean isVSProcessed = EditRecord.ProcessVitalSign;
        EditRecord.GetResourceURL('test');
    }
    
    public Static testmethod void PrepareData2()
    {
        ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        Insert ClientID;
        
        CE = new Clinical_Evaluation__c();
        CE.Client_Chart__c = ClientID.id;
        Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Face to Face Evaluation').getRecordTypeId();
        CE.RecordtypeId = BPSARecordTypeId ;
        CE.Diagnosis_Code__c = 'Test;Test2;Test3';
        CE.Prior_Substance_abuse_treatment_with_dat__c = 'NO';
        CE.PAA_family_history_of_substance_abuse__c = 'NO';
        CE.FFE_Prior_Mental_Health_Dates__c = 'NO';
        CE.FFE_Prior_IMP_Psychiatric_TX__c = 'NO';
        CE.FFE_Family_history_of_Psychatric__c = 'NO';
        CE.FFE_Psychotropic_Meds__c = 'NO';
        CE.FFE_Self_Mutilating_Behaviour__c = 'NO';
        CE.FFE_Current_Suicidal_ideations__c = 'NO';
        CE.FFE_Prior_Suicide_attempts__c = 'NO';
        CE.FFE_Violence_Homicidal_Ideations__c = 'NO';
        CE.FFE_Domestic_Violence__c = 'NO';
        CE.FFE_Perpetrator__c = 'NO';
        CE.FFE_Legal_Issues__c = 'Insight';
        CE.FFE_Has_patient_failed_lower_level_of_Ca__c = 'NO';
        CE.FFE_Difficulty_postponing_gratification__c = 'NO';
        CE.FFE_Does_the_client_have_cravings__c = 'NO';
        CE.FFE_Client_Recognize_Usage_Excessive__c = 'NO';
        CE.FFE_Alcohol_drugs_present_in_environment__c = 'NO';
        CE.FFE_Does_the_client_live_where_treatment__c = 'NO';
        CE.FFE_Does_their_environment_undermine_eff__c = 'NO';
        CE.FFE_Client_occupation_where_continued_us__c = 'NO';
        CE.FFE_Sexual_Behavior_Relational_issues_Re__c = 'NO';
        CE.FFE_Sexual_Behavior_Acting_Out__c = 'NO';
        CE.FFE_Gambling_Addiction_Does_the_client_h__c = 'NO';
        CE.PAA_Prior_Substance_abuse_treatmentC__c = FALSE;
        CE.Status__c = 'Complete';
        insert CE;
        
        ApexPages.currentPage().getParameters().put('Id', ClientID.id);
        ApexPages.currentPage().getParameters().put('ceId', null);
        ApexPages.currentPage().getParameters().put('type', 'Face to Face Evaluation');
        
        awsBucket__c AWS = new awsBucket__c();
        AWS.Name='FREEPU';
        AWS.accessKeyId__c='Testaccesskey';
        AWS.Bucket__c='TestBucket';
        AWS.secretAccessKey__c='Tessecretkey';
        insert AWS; 
        
        Recurring_Assessment__c ra = new Recurring_Assessment__c();
        ra.Client_Chart__c = ClientID.Id;
        //ra.Status__c = 'Closed';
        //ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
        insert ra;
        
        UtlizationReviewOrder__c toCreatedRecord = new UtlizationReviewOrder__c();
        toCreatedRecord.Vital_Sign__c = ra.Id;
        toCreatedRecord.Clinical_Evaluation__c = Ce.Id;
        insert toCreatedRecord;
        
        CE_FFE_Edit_Read EditRecord = new CE_FFE_Edit_Read();
        EditRecord.SelectedSignedOption = 'Patient';
        EditRecord.Edit();
        EditRecord.Save();
        EditRecord.Cancel();
        EditRecord.setCheckBoxes(); 
        EditRecord.checkRender1();
        EditRecord.checkRenderfhs();
        EditRecord.checkRenderpsmht();
        EditRecord.checkRenderdimpp();
        EditRecord.checkRenderdfhpb();
        EditRecord.checkRenderdpm();
        EditRecord.checkRenderdsmb();
        EditRecord.checkRenderdcsi();
        EditRecord.checkRenderdpsa();
        EditRecord.checkRenderdvhi();
        EditRecord.checkRenderddve();
        EditRecord.checkRenderdprep();
        EditRecord.checkRenderdli();
        EditRecord.checkRenderdpflc();
        EditRecord.checkRenderddpg();
        EditRecord.checkRenderddchc();
        EditRecord.checkRenderdcrue();
        EditRecord.checkRenderdadpe();
        EditRecord.checkRenderdaclw();
        EditRecord.checkRenderddtu();
        EditRecord.checkRenderdcowc();
        EditRecord.checkRenderdsbri();
        EditRecord.checkRenderdsbao();
        EditRecord.checkRenderdgadc();
        EditRecord.CloseSignatureForm();
        
        EditRecord.isEdit= false;
        EditRecord.Back();
        EditRecord.getLatestVital();
        boolean isVSProcessed = EditRecord.ProcessVitalSign;
        EditRecord.GetResourceURL('test');
    }
    
}