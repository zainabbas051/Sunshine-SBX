//Test Class : ClientChartUtil_Test
public class ClientChartUtil {
    public map<string, string> mapOfClientChartRT;
    public map<string, string> mapOfClinicalEvalRT;
    public map<string, string> mapOfClinic2EvalRT;
    public map<string, string> mapOfClinic3EvalRT;
    public map<string, string> mapOfTxDcRT;
    public map<string, string> mapOfContactRT;
    public map<string, string> mapOfIntakeFormsRT;
    public map<string, string> mapOfMedicalRT;
    public map<string, string> mapOfAssessmentIRToolsRT;

    public Client_Chart__c ClientRecord;

    public ClientChartUtil() {
        getRecordTypes();
    }

    public void createClientChart(Opportunity Opp) {

        ClientRecord = new Client_Chart__c();
        ClientRecord.Client_Status__c = 'Pre Admission';
        ClientRecord.Admissions_Coordinator__c = Opp.OwnerId;
        ClientRecord.Name = Opp.Name;
        ClientRecord.Phone__c = opp.Phone__c;
        ClientRecord.Email__c = opp.Email__c;
        ClientRecord.DOB__c = opp.DOB__c;
        ClientRecord.Gender__c = opp.Sex__c;
        ClientRecord.Employer_Name__c = opp.Current_Employer__c;
        ClientRecord.Marital_Status_2__c = opp.Marital_Status__c;
        ClientRecord.Race__c = opp.Race__c;
        ClientRecord.Ethnicity__c = opp.Ethnicity__c;
        ClientRecord.Veteran_Status__c = opp.Veteran_Status__c;
        ClientRecord.Diet__c = opp.Diet__c;
        ClientRecord.Opportunity__c = opp.id;
        ClientRecord.Height__c = string.valueOf(opp.Height__c);
        ClientRecord.weight__c = opp.Weight__c;
        ClientRecord.Phone__c = opp.Incoming_Number__c;
        ClientRecord.DOB__c = opp.DOB__c;
        ClientRecord.RecordtypeId = mapOfClientChartRT.containsKey(opp.Sunshine_Center_Name__c) ? mapOfClientChartRT.get(opp.Sunshine_Center_Name__c) : mapOfClientChartRT.get('Monarch Shores');
        ClientRecord.Treatment_Center__c = opp.Sunshine_Center_Name__c != null ? Sunshine_Center_Id__c.getValues(opp.Sunshine_Center_Name__c).Account_Id__c : Sunshine_Center_Id__c.getValues('Monarch Shores').Account_Id__c;
        for (Insurance_Information__c ii : [Select id, Address__c, Address_2__c, City__c, State__c, Zip_Code__c, Country__c, Employer__c from Insurance_Information__c where Insurance_Status__c = : 'Primary' AND Opportunity__c = : opp.id]) {
            ClientRecord.Street__c = ii.Address__c;
            if (ii.Address_2__c != null)
                ClientRecord.Street__c = ClientRecord.Street__c + ', ' + ii.Address_2__c;
            ClientRecord.City__c = ii.City__c;
            ClientRecord.State__c = string.valueOf(ii.State__c);
            ClientRecord.Country__c = ii.Country__c;
            ClientRecord.Postal_Code__c = ii.Zip_Code__c;
            ClientRecord.Employer_Name__c = ii.Employer__c;
        }
        try {
            insert ClientRecord;
            Opportunity OpptoUpdate = new Opportunity(id = opp.id, Is_Client_Chart_Created__c = true);
            update OpptoUpdate;
        } catch (exception e) {
            system.debug('exc in Client=' + e.getMessage());
        }
    }

    public void createChildrenOfClient(Client_Chart__c Client) {
        Sunshine_Center_Id__c scid = Sunshine_Center_Id__c.getValues(Client.RecordType.Name);

        //Opportunity OppForDrugs = GetDrugsFromOpportunity(Client.Opportunity__c);
        createContact(Client);
        //createPreAddAssess(Client);
        Clinical_Evaluation__c ceOppForDrugs = updatePAA(Client);
        createFFE(Client, ceOppForDrugs );
        createPsychEval(Client, ceOppForDrugs );
        createBioPsychSocial(Client, ceOppForDrugs );
        createHistNPhys(Client, ceOppForDrugs );
        createDetoxTrtPlan(Client);
        createMasterTrtPlan(Client);
        createDischargePlan(Client);
        createPersonalItemsReturned(Client);
        createIntakeAllRecords(Client);
        if (scid.Requires_Admit_Order__c == True) {
            createAdmitOrder(Client);
        }
        createAssessmentIRTools(Client);
        createDrugScreen(Client);
        if (Client.Gender__c == 'Female')
            createUrinePregnancy(Client);

        Client_Chart__c tempCC = new Client_Chart__c(id = Client.Id, Related_Forms_Created_On_Admit__c = True);
        Update tempCC;


    }

    public void createPreAddAssess(Client_Chart__c Client) {
        Client_Chart__c cl = [select id, opportunity__r.Sex__c, opportunity__r.Age__c,
                              opportunity__r.Drug_of_Choice_1__c, opportunity__r.Age_of_First_Use_Drug_1__c,
                              opportunity__r.Date_of_Last_Use_Drug_1__c, opportunity__r.Drug_of_Choice_2__c,
                              opportunity__r.Age_of_First_Use_Drug_2__c, opportunity__r.Date_of_Last_Use_Drug_2__c,
                              opportunity__r.Drug_of_Choice_3__c, opportunity__r.Age_of_First_Use_Drug_3__c,
                              opportunity__r.Date_of_Last_Use_Drug_3__c,  opportunity__r.DOC_Notes__c,  opportunity__r.Withdrawal_Symptoms__c,
                              opportunity__r.Supporting_Withdrawal_Notes__c,  opportunity__r.Previous_Treatment_Episodes__c,
                              opportunity__r.Client_Aware_of_No_Return_Flight__c,  opportunity__r.Psychiatric_Co_occurring_Issues__c,
                              opportunity__r.Trauma__c,  opportunity__r.Trauma_Notes__c,  opportunity__r.Psychiatric_Diagnosis__c,
                              opportunity__r.Self_Diagnosed__c,  opportunity__r.Current_Suicidal_Ideations__c,
                              opportunity__r.Past_Suicidal_Ideations__c,  opportunity__r.Detox_Needed__c,  opportunity__r.Current_Medications__c,
                              opportunity__r.Prescribed_but_not_Taken_Medication__c,  opportunity__r.Reason_Why_Not_Taking__c,
                              opportunity__r.Height__c,  opportunity__r.Weight__c,  opportunity__r.Body_Mass_Index_BMI__c,
                              opportunity__r.Medical_Conditions__c,  opportunity__r.History_of_Seizures__c,  opportunity__r.Any_Pending_Charges__c,
                              opportunity__r.Probation_Parole__c,  opportunity__r.Upcoming_Court_Dates__c,  opportunity__r.Sexual_Offenses__c,
                              opportunity__r.History_of_Violence__c,  opportunity__r.History_of_Arson__c,  opportunity__r.Legal_history_Notes__c,
                              opportunity__r.Legal_Contact_Required__c,  opportunity__r.Legal_Contact_Info__c,  opportunity__r.Previous_ACAs__c,
                              opportunity__r.Previous_Treatment_Notes__c,  opportunity__r.Longest_Sobriety__c,  opportunity__r.Triggers__c,
                              opportunity__r.Dangerous_Behavior_while_Using__c,  opportunity__r.Current_Use_Details_Drug_1__c,
                              opportunity__r.Method_of_Use_Drug_1__c,  opportunity__r.Frequency_of_Use_Drug_1__c,
                              opportunity__r.Current_Use_Details_Drug_2__c,  opportunity__r.Method_of_Use_Drug_2__c,
                              opportunity__r.Frequency_of_Use_Drug_2__c,  opportunity__r.Current_Use_Details_Drug_3__c,
                              opportunity__r.Method_of_Use_Drug_3__c,  opportunity__r.Frequency_of_Use_Drug_3__c,
                              opportunity__r.Negative_Consequences_of_Using__c,  opportunity__r.Family_Contact_Name__c,
                              opportunity__r.Family_Contact_Relationship__c,  opportunity__r.Family_Contact_Phone__c,
                              opportunity__r.Family_Contact_Email__c,  opportunity__r.Other_Issues__c, opportunity__r.Previous_Suicide_Attempts__c,
                              opportunity__r.Suicide_Notes__c,  opportunity__r.Family_History_of_Suicide__c,
                              opportunity__r.Family_History_of_Mental_Disorder__c,  opportunity__r.Family_History_Notes__c,
                              opportunity__r.Self_Injurious_Mutilating_Behavior__c,  opportunity__r.Aggressive_Behavior__c,
                              opportunity__r.Psych_Notes__c,  opportunity__r.Recent_Hospitalization_Surgery__c,
                              opportunity__r.Medical_History_Notes__c,  opportunity__r.Ambulation__c,  opportunity__r.Allergies__c,
                              opportunity__r.Allergic_Reaction__c,  opportunity__r.Current_Pain_Management__c,
                              opportunity__r.Willing_to_Discontinue_Pain_Meds__c,  opportunity__r.Currently_Pregnant__c,
                              opportunity__r.Other_Medical_Issues__c,  opportunity__r.Current_Employer__c,  opportunity__r.Employment_Status__c,
                              opportunity__r.Length_of_Employment__c,  opportunity__r.FMLA_Needed__c,  opportunity__r.Other_Employment_Info__c,
                              opportunity__r.Lives_with_Name_Age__c,  opportunity__r.Supportive_Environment__c,
                              opportunity__r.Family_Contact_Email_2__c, opportunity__r.Family_Contact_Email_3__c, opportunity__r.Family_Contact_Name_2__c,
                              opportunity__r.Family_Contact_Name_3__c, opportunity__r.Family_Contact_Relationship_2__c, opportunity__r.Family_Contact_Relationship_3__c,
                              opportunity__r.Family_Contact_Phone_2__c, opportunity__r.Family_Contact_Phone_3__c,
                              opportunity__r.Other_Housing_Issues__c,  opportunity__r.Days_Committed_to_Treatment__c from Client_Chart__c
                              where id = : Client.id];


        Clinical_Evaluation__c ce = new Clinical_Evaluation__c();
        Clinical_Evaluation_3__c ce1 = new Clinical_Evaluation_3__c();
        ce.Client_Chart__c = Client.id;
        ce.RecordTypeId = mapOfClinicalEvalRT.get('Pre Admission Assesment');
        ce.Status__c = 'Open';
        //ce.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(),Client.Admit_Date_Time__c.day(),Client.Admit_Date_Time__c.Hour(),Client.Admit_Date_Time__c.Minute(),Client.Admit_Date_Time__c.Second()).addHours(3);
        ce.PAA_Opportunity__c = cl.opportunity__c;
        ce.Family_Contact_Email_2__c = cl.opportunity__r.Family_Contact_Email_2__c;
        ce.Family_Contact_Email_3__c = cl.opportunity__r.Family_Contact_Email_3__c;
        ce.Family_Contact_Name_2__c = cl.opportunity__r.Family_Contact_Name_2__c;
        ce.Family_Contact_Name_3__c = cl.opportunity__r.Family_Contact_Name_3__c;
        ce.Family_Contact_Phone_2__c = cl.opportunity__r.Family_Contact_Phone_2__c;
        ce.Family_Contact_Phone_3__c = cl.opportunity__r.Family_Contact_Phone_3__c;
        ce.Family_Contact_Relationship_2__c = cl.opportunity__r.Family_Contact_Relationship_2__c;
        ce.Family_Contact_Relationship_3__c = cl.opportunity__r.Family_Contact_Relationship_3__c;
        ce.PAA_Sex__c = cl.opportunity__r.Sex__c;
        ce.PAA_Age__c = cl.opportunity__r.Age__c;
        //ce.PAA_Precipitating_Event__c = cl.opportunity__r.Precipitating_Event__c;
        //ce.Why_Treatment_Now__c = cl.opportunity__r.Why_Treatment_Now__c;
        ce.PAA_Drug_of_Choice_1__c = cl.opportunity__r.Drug_of_Choice_1__c;
        ce.PAA_Age_of_First_Use_Drug_1__c = cl.opportunity__r.Age_of_First_Use_Drug_1__c;
        ce.PAA_Date_of_Last_Use_Drug_1__c = cl.opportunity__r.Date_of_Last_Use_Drug_1__c;
        ce.PAA_Drug_of_Choice_2__c = cl.opportunity__r.Drug_of_Choice_2__c;
        ce.PAA_Age_of_First_Use_Drug_2__c = cl.opportunity__r.Age_of_First_Use_Drug_2__c;
        ce.PAA_Date_of_Last_Use_Drug_2__c = cl.opportunity__r.Date_of_Last_Use_Drug_2__c;
        ce.PAA_Drug_of_Choice_3__c = cl.opportunity__r.Drug_of_Choice_3__c;
        ce.PAA_Age_of_First_Use_Drug_3__c = cl.opportunity__r.Age_of_First_Use_Drug_3__c;
        ce.PAA_Date_of_Last_Use_Drug_3__c = cl.opportunity__r.Date_of_Last_Use_Drug_3__c;
        ce.PAA_DOC_Notes__c = cl.opportunity__r.DOC_Notes__c;
        ce.PAA_Withdrawal_Symptoms__c = cl.opportunity__r.Withdrawal_Symptoms__c;
        ce.PAA_Supporting_Withdrawal_Notes__c = cl.opportunity__r.Supporting_Withdrawal_Notes__c;
        ce.PAA_Previous_Treatment_Episodes__c = cl.opportunity__r.Previous_Treatment_Episodes__c;
        ce.PAA_Client_Aware_of_No_Return_Flight__c = cl.opportunity__r.Client_Aware_of_No_Return_Flight__c;
        ce.PAA_Psychiatric_Co_occurring_Issues__c = cl.opportunity__r.Psychiatric_Co_occurring_Issues__c;
        ce.PAA_Trauma__c = cl.opportunity__r.Trauma__c;
        ce.PAA_Trauma_Notes__c = cl.opportunity__r.Trauma_Notes__c;
        ce.PAA_Psychiatric_Diagnosis__c = cl.opportunity__r.Psychiatric_Diagnosis__c;
        ce.PAA_Self_Diagnosed__c = cl.opportunity__r.Self_Diagnosed__c;
        ce.PAA_Current_Suicidal_Ideations__c = cl.opportunity__r.Current_Suicidal_Ideations__c;
        ce.PAA_Past_Suicidal_Ideations__c = cl.opportunity__r.Past_Suicidal_Ideations__c;
        ce.PAA_Detox_Needed__c = cl.opportunity__r.Detox_Needed__c;
        ce.PAA_Current_Medications__c = cl.opportunity__r.Current_Medications__c;
        ce.PAA_Prescribed_but_not_Taken_Medication__c = cl.opportunity__r.Prescribed_but_not_Taken_Medication__c;
        ce.PAA_Reason_Why_Not_Taking__c = cl.opportunity__r.Reason_Why_Not_Taking__c;
        ce.PAA_Height__c = cl.opportunity__r.Height__c;
        ce.PAA_Weight__c = cl.opportunity__r.Weight__c;
        ce.PAA_Body_Mass_Index_BMI__c = cl.opportunity__r.Body_Mass_Index_BMI__c;
        ce.PAA_Medical_Conditions__c = cl.opportunity__r.Medical_Conditions__c;
        ce.PAA_History_of_Seizures__c = cl.opportunity__r.History_of_Seizures__c;
        ce.PAA_Any_Pending_Charges__c = cl.opportunity__r.Any_Pending_Charges__c;
        ce.PAA_On_Probation_Parole__c = cl.opportunity__r.Probation_Parole__c;
        ce.PAA_Upcoming_Court_Dates__c = cl.opportunity__r.Upcoming_Court_Dates__c;
        ce.PAA_Sexual_Offenses__c = cl.opportunity__r.Sexual_Offenses__c;
        ce.PAA_History_of_Violence__c = cl.opportunity__r.History_of_Violence__c;
        ce.PAA_History_of_Arson__c = cl.opportunity__r.History_of_Arson__c;
        ce.PAA_Legal_history_Notes__c = cl.opportunity__r.Legal_history_Notes__c;
        ce.PAA_Legal_Contact_Required__c = cl.opportunity__r.Legal_Contact_Required__c;
        ce.PAA_Legal_Contact_Info__c = cl.opportunity__r.Legal_Contact_Info__c;
        ce.PAA_Previous_ACAs__c = cl.opportunity__r.Previous_ACAs__c;
        ce.PAA_Previous_Treatment_Notes__c = cl.opportunity__r.Previous_Treatment_Notes__c;
        ce.PAA_Longest_Sobriety__c = cl.opportunity__r.Longest_Sobriety__c;
        ce.PAA_Triggers__c = cl.opportunity__r.Triggers__c;
        ce.PAA_Dangerous_Behavior_while_Using__c = cl.opportunity__r.Dangerous_Behavior_while_Using__c;
        ce.PAA_Current_Use_Details_Drug_1__c = cl.opportunity__r.Current_Use_Details_Drug_1__c;
        ce.PAA_Method_of_Use_Drug_1__c = cl.opportunity__r.Method_of_Use_Drug_1__c;
        ce.PAA_Frequency_of_Use_Drug_1__c = cl.opportunity__r.Frequency_of_Use_Drug_1__c;
        ce.PAA_Current_Use_Details_Drug_2__c =  cl.opportunity__r.Current_Use_Details_Drug_2__c;
        ce.PAA_Method_of_Use_Drug_2__c = cl.opportunity__r.Method_of_Use_Drug_2__c;
        ce.PAA_Frequency_of_Use_Drug_2__c = cl.opportunity__r.Frequency_of_Use_Drug_2__c;
        ce.PAA_Current_Use_Details_Drug_3__c = cl.opportunity__r.Current_Use_Details_Drug_3__c;
        ce.PAA_Method_of_Use_Drug_3__c = cl.opportunity__r.Method_of_Use_Drug_3__c;
        ce.PAA_Frequency_of_Use_Drug_3__c = cl.opportunity__r.Frequency_of_Use_Drug_3__c;
        ce.PAA_Negative_Consequences_of_Using__c = cl.opportunity__r.Negative_Consequences_of_Using__c;
        ce.PAA_Family_Contact_Name__c = cl.opportunity__r.Family_Contact_Name__c;
        ce.PAA_Family_Contact_Relationship__c = cl.opportunity__r.Family_Contact_Relationship__c;
        ce.PAA_Family_Contact_Phone__c = cl.opportunity__r.Family_Contact_Phone__c;
        ce.PAA_Family_Contact_Email__c = cl.opportunity__r.Family_Contact_Email__c;
        ce.PAA_Other_Issues__c = cl.opportunity__r.Other_Issues__c;
        ce.PAA_Previous_Suicide_Attempts__c = cl.opportunity__r.Previous_Suicide_Attempts__c;
        ce.PAA_Suicide_Notes__c = cl.opportunity__r.Suicide_Notes__c;
        ce.PAA_Family_History_of_Suicide__c = cl.opportunity__r.Family_History_of_Suicide__c;
        ce.PAA_Family_History_of_Mental_Health__c = cl.opportunity__r.Family_History_of_Mental_Disorder__c;
        ce.PAA_Family_History_Notes__c = cl.opportunity__r.Family_History_Notes__c;
        ce.PAA_Self_Injurious_Mutilating_Behavior__c = cl.opportunity__r.Self_Injurious_Mutilating_Behavior__c;
        ce.PAA_Aggressive_Behavior__c = cl.opportunity__r.Aggressive_Behavior__c;
        ce.PAA_Psych_Notes__c = cl.opportunity__r.Psych_Notes__c;
        ce.PAA_Recent_Hospitalization_Surgery__c = cl.opportunity__r.Recent_Hospitalization_Surgery__c;
        ce.PAA_Medical_History_Notes__c = cl.opportunity__r.Medical_History_Notes__c;
        ce.PAA_Ambulation__c = cl.opportunity__r.Ambulation__c;
        ce.Allergies__c = cl.opportunity__r.Allergies__c;
        ce.PAA_Allergic_Reaction__c = cl.opportunity__r.Allergic_Reaction__c;
        ce.PAA_Under_Care_of_Dr_for_Pain_Management__c = cl.opportunity__r.Current_Pain_Management__c;
        ce.PAA_Willing_to_Discontinue_all_Pain_Meds__c = cl.opportunity__r.Willing_to_Discontinue_Pain_Meds__c;
        ce.PAA_Currently_Pregnant__c = cl.opportunity__r.Currently_Pregnant__c;
        ce.PAA_Other_Medical_Issues__c = cl.opportunity__r.Other_Medical_Issues__c;
        ce.PAA_Current_Employer__c = cl.opportunity__r.Current_Employer__c;
        ce.PAA_Employment_Status__c = cl.opportunity__r.Employment_Status__c;
        ce.PAA_Length_of_Employment__c = cl.opportunity__r.Length_of_Employment__c;
        ce.PAA_FMLA_Needed__c = cl.opportunity__r.FMLA_Needed__c;
        ce.PAA_Other_Employment_Info__c = cl.opportunity__r.Other_Employment_Info__c;
        ce.PAA_Lives_with_Name_Age__c = cl.opportunity__r.Lives_with_Name_Age__c;
        ce.PAA_Supportive_Environment__c = cl.opportunity__r.Supportive_Environment__c;
        ce.PAA_Other_Housing_Issues__c = cl.opportunity__r.Other_Housing_Issues__c;
        ce.PAA_Days_Committed_to_Treatment__c = cl.opportunity__r.Days_Committed_to_Treatment__c;
        try {
            insert ce;
            ce1.Clinical_Evaluation__c = ce.id;
            insert ce1;
        } catch (exception e) {
            system.debug('exc in PAA=' + e.getMessage());
        }
    }

    public Clinical_Evaluation__c updatePAA(Client_Chart__c client) {
        string ClientID = client.id;

        Clinical_Evaluation__c ce = [select id, Due_Date_Time__c, PAA_Drug_of_Choice_1__c, PAA_Age_of_First_Use_Drug_1__c, PAA_Date_of_Last_Use_Drug_1__c,
                                     PAA_Current_Use_Details_Drug_1__c, PAA_Frequency_of_Use_Drug_1__c, PAA_Method_of_Use_Drug_1__c,
                                     PAA_Drug_of_Choice_2__c, PAA_Current_Use_Details_Drug_2__c, PAA_Age_of_First_Use_Drug_2__c,
                                     PAA_Frequency_of_Use_Drug_2__c,  PAA_Method_of_Use_Drug_2__c,  PAA_Date_of_Last_Use_Drug_2__c,
                                     PAA_Drug_of_Choice_3__c,  PAA_Current_Use_Details_Drug_3__c,  PAA_Age_of_First_Use_Drug_3__c,
                                     PAA_Frequency_of_Use_Drug_3__c,  PAA_Method_of_Use_Drug_3__c,  PAA_Date_of_Last_Use_Drug_3__c
                                     from Clinical_Evaluation__c where Client_Chart__c = : ClientID AND Recordtype.Name = 'Pre Admission Assesment' limit 1];
        ce.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(3);

        update ce;
        return ce;
    }

    public void createFFE(Client_Chart__c Client, Clinical_Evaluation__c DrugsOpp) {
        Clinical_Evaluation__c ce = new Clinical_Evaluation__c();
        Clinical_Evaluation_3__c ce1 = new Clinical_Evaluation_3__c();
        ce.Client_Chart__c = Client.id;
        ce.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(3);
        ce.RecordTypeId = mapOfClinicalEvalRT.get('Face to Face Evaluation');
        ce.Status__c = 'Open';

        ce = MapFieldsWithOppDrugs(ce, DrugsOpp);

        try {
            insert ce;
            ce1.Clinical_Evaluation__c = ce.id;
            insert ce1;
        } catch (exception e) {
            system.debug('exc in FFE=' + e.getMessage());
        }
    }

    public void createPsychEval(Client_Chart__c Client, Clinical_Evaluation__c DrugsOpp) {
        Sunshine_Center_Id__c scid = Sunshine_Center_Id__c.getValues(Client.RecordType.Name);
        if (!scid.Dr_Alva_Forms__c) {
            Clinical_Evaluation__c ce = new Clinical_Evaluation__c();
            Clinical_Evaluation_3__c ce1 = new Clinical_Evaluation_3__c();
            ce.Client_Chart__c = Client.id;
            ce.due_date_time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(32);
            ce.RecordTypeId = mapOfClinicalEvalRT.get('Phsych Evaluation');
            ce.Status__c = 'Open';

            ce = MapFieldsWithOppDrugs(ce, DrugsOpp);


            try {
                insert ce;
                ce1.Clinical_Evaluation__c = ce.id;
                insert ce1;
            } catch (exception e) {
                system.debug('exc in PsychEv=' + e.getMessage());
            }
        } else {
            Clinical_Evaluation_3__c ce3 = new Clinical_Evaluation_3__c();
            ce3.Client_Chart__c = Client.id;
            ce3.due_date_time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(32);
            ce3.RecordTypeId = mapOfClinic3EvalRT.get('Phsych Evaluation');
            ce3.HP_Status__c = 'Open';

            try {
                insert ce3;
            } catch (exception e) {
                system.debug('exc in PsychEv=' + e.getMessage());
            }
        }

    }




    public void createBioPsychSocial(Client_Chart__c Client, Clinical_Evaluation__c DrugsOpp) {
        Clinical_Evaluation_2__c ce = new Clinical_Evaluation_2__c();
        Clinical_Evaluation_3__c ce1 = new Clinical_Evaluation_3__c();
        ce.Client_Chart__c = Client.id;
        ce.RecordTypeId = mapOfClinic2EvalRT.get('Bio-Psychosocial Assessment');
        ce1.HP_Status__c = 'Open';
        ce1.due_date_time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(72);

        BPDrugInfoResult bpResult = MapFieldWithOppDrugs_BP(ce, ce1, DrugsOpp);
        if (bpResult != null) {
            ce = bpResult.CE2;
            ce1 = bpResult.CE3;
        }

        try {

            insert ce;

            ce1.Clinical_Evaluation_2__c = ce.id;
            ce1.RecordtypeID = mapOfClinic3EvalRT.get('Bio-Psychosocial Assessment');
            insert ce1;
        } catch (exception e) {
            system.debug('exc in BioPsychSoc=' + e.getMessage());
        }
    }

    public void createHistNPhys(Client_Chart__c Client, Clinical_Evaluation__c DrugsOpp) {
        Clinical_Evaluation_3__c ce = new Clinical_Evaluation_3__c();
        ce.Client_Chart__c = Client.id;
        ce.RecordTypeId = mapOfClinic3EvalRT.get('History And Physical');
        ce.HP_Status__c = 'Open';
        ce.due_Date_time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(32);

        ce = MapFieldWithOppDrugs_HP(ce, DrugsOpp);
        try {
            insert ce;
        } catch (exception e) {
            system.debug('exc in HistAndPhy=' + e.getMessage());
        }
    }

    public void createDetoxTrtPlan(Client_Chart__c Client) {
        Tx_and_D_C_Plans__c detoxTrt = new Tx_and_D_C_Plans__c();
        detoxTrt.Status__c = 'Open';
        detoxTrt.Client_Chart__c = Client.id;
        detoxTrt.RecordTypeId = mapOfTxDcRT.get('Detox Treatment Plan');
        detoxTrt.Due_Date_time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(24);
        try {
            insert detoxTrt;

            list<Detox_Objectives__c> objectiveList = new List<Detox_Objectives__c>();

            Detox_Objectives__c objective1 = new Detox_Objectives__c();
            objective1.Tx_and_D_C_Plans__c = detoxTrt.id;
            objective1.Objective__c = 'Objective 1';
            objective1.Objective_Description_Long__c = 'Client will have any and all detox and medical protocols developed by client’s physician.';
            objective1.Intervention__c = 'a.) Staff will review pre-admission assessment. \r\n b.) Nursing and/or medical staff will complete face-to-face evaluation of client and document.\r\n' +
                                         +'c.) Physician will complete Psychiatry evaluation and document within 24 hours of client arrival.\r\n d.) Medical Staff will complete Health and Physical within 24 hours of client arrival and document.\r\n' +
                                         +'e.) Any detox protocol necessary will be created and documented by Medical staff. \r\n f.) Any medications that are required will be ordered and documented based on above mentioned procedures and physician orders.';
            objective1.Staff_Responsible__c = 'Medical Staff';
            objectiveList.add(objective1);

            Detox_Objectives__c objective2 = new Detox_Objectives__c();
            objective2.Tx_and_D_C_Plans__c = detoxTrt.id;
            objective2.Objective__c = 'Objective 2';
            objective2.Objective_Description_Long__c = 'Client will follow detox protocol as outlined in orders to maintain homeostasis & prevent physical complications.';
            objective2.Intervention__c = 'A. Staff will monitor patients vital signs on as needed basis. \r\n B. Staff will utilize vital signs as a tool to evaluate need for medication.\r\n' +
                                         +'C. Nursing staff will complete nursing assessment including what and how much the patient drinks and/or uses mood-alternating drugs, time and amount of last usage. \r\n ' +
                                         +'D. Staff to monitor patients mental status & physical symptoms. Evaluate for presence of tremors, irritability, diaphoresis, sleep disturbances, orientation and misperception, misinterpretation of real stimuli (hallucinosis), seizures, or hallucinations.\r\n' +
                                         +'E. Staff will alert the physician to any changes in symptomatology that occur. \r\n F. Staff will offer fluids frequently.\r\n' +
                                         +'G. Staff will promote rest and sleep through relaxation & decrease of external stimuli. \r\n H. Physician and/or Nursing will educate patient on medications.';
            objective2.Staff_Responsible__c = 'Nursing Staff';
            objectiveList.add(objective2);

            Detox_Objectives__c objective3 = new Detox_Objectives__c();
            objective3.Tx_and_D_C_Plans__c = detoxTrt.id;
            objective3.Objective__c = 'Objective 3';
            objective3.Objective_Description_Long__c = 'Successfully transfer client from primary detox programming to residential programming under clinical care.';
            objective3.Intervention__c = 'Client will participate in the initial clinical assessment utilizing the Biopsychosocial assessment tool. Client will be assessed' +
                                         +'for substance use/abuse, trauma, and reviewed for any potentially missed or co-occurring diagnoses. Clinician will provide a documented interpretive diagnostic summery upon completion of assessment.';
            objective3.Staff_Responsible__c = 'Clinical Staff';
            objectiveList.add(objective3);

            Detox_Objectives__c objective4 = new Detox_Objectives__c();
            objective4.Tx_and_D_C_Plans__c = detoxTrt.id;
            objective4.Objective__c = 'Objective 4';
            objective4.Objective_Description_Long__c = 'Upon completion of detox protocol and medical needs being met in accordance with detoxification procedures, client will be cleared by Medical team to transfer to Residential programming and begin all regular scheduled clinical programming.';
            objective4.Intervention__c = 'a.) Client will receive the assigned track color wrist band and remove the red wrist band indicative of transfer from detox to residential programming given by medical staff. \r\n' +
                                         +'b.) Client will meet with case manager for Master Treatment Plan focusing on clinical goals and interventions within seven days of arrival. \r\n' +
                                         +'c.) Client will continue to meet with physicians and medical team as needed with scheduled weekly sessions to monitor any post-acute withdrawal symptoms.';
            objective4.Staff_Responsible__c = 'Clinical Staff and Medical Staff';
            objectiveList.add(objective4);

            Detox_Objectives__c objective5 = new Detox_Objectives__c();
            objective5.Tx_and_D_C_Plans__c = detoxTrt.id;
            objective5.Objective__c = 'Objective 5';
            objective5.Objective_Description_Long__c = 'Client will discuss discharge plans with therapist in 1:1 session.';
            objective5.Intervention__c = 'Staff will assist patient in developing appropriate discharge plans at the end of detox.';
            objective5.Staff_Responsible__c = 'Clinical Staff';
            objectiveList.add(objective5);

            insert objectiveList;
        } catch (exception e) {
            system.debug('exc in detoxTrt=' + e.getMessage());
        }
    }

    public void createMasterTrtPlan(Client_Chart__c Client) {
        Tx_and_D_C_Plans__c MasterTrt = new Tx_and_D_C_Plans__c();
        MasterTrt.Status__c = 'Open';
        MasterTrt.Client_Chart__c = Client.id;
        MasterTrt.RecordTypeId = mapOfTxDcRT.get('Master Treatment Plan');
        MasterTrt.Due_Date_time__c  = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(168);
        try {
            insert MasterTrt;

        } catch (exception e) {
            system.debug('exc in MasterTrt=' + e.getMessage());
        }
    }

    public void createDischargePlan(Client_Chart__c Client) {
        Tx_and_D_C_Plans__c DischargePlan = new Tx_and_D_C_Plans__c();
        DischargePlan.Status__c = 'Open';
        DischargePlan.Client_Chart__c = Client.id;
        DischargePlan.RecordTypeId = mapOfTxDcRT.get('Discharge Plan');
        DischargePlan.SignedBy__c = 'None';
        DischargePlan.Admit_Date__c = Client.Admit_Date_Time__c.Date();
        DischargePlan.Discharge_Address__c = Client.Address__c;
        if (Client.Discharge_Date_Time__c != null)
            DischargePlan.Due_Date_time__c = Client.Discharge_Date_Time__c;
        try {
            insert DischargePlan;

        } catch (exception e) {
            system.debug('exc in DischargePlan=' + e.getMessage());
        }
    }

    public void createPersonalItemsReturned(Client_Chart__c Client) {
        Tx_and_D_C_Plans__c DischargePlan = new Tx_and_D_C_Plans__c();
        DischargePlan.Status__c = 'Open';
        DischargePlan.Client_Chart__c = Client.id;
        DischargePlan.SignedBy__c = 'None';
        DischargePlan.RecordTypeId = mapOfTxDcRT.get('Personal Items Returned at Discharge');
        if (Client.Discharge_Date_Time__c != null)
            DischargePlan.Due_Date_time__c = Client.Discharge_Date_Time__c;
        try {
            insert DischargePlan;

        } catch (exception e) {
            system.debug('exc in DischargePlan=' + e.getMessage());
        }
    }

    public void createContact(Client_Chart__c Client) {

        List<Contact> contInsertList = new List<Contact>();

        Client_Chart__c cl = [select id, opportunity__r.Family_Contact_Email__c, opportunity__r.Family_Contact_Name__c, opportunity__r.Family_Contact_Phone__c, opportunity__r.Family_Contact_Relationship__c,
                              opportunity__r.Family_Contact_Email_2__c, opportunity__r.Family_Contact_Name_2__c, opportunity__r.Family_Contact_Phone_2__c, opportunity__r.Family_Contact_Relationship_2__c,
                              opportunity__r.Family_Contact_Email_3__c, opportunity__r.Family_Contact_Name_3__c, opportunity__r.Family_Contact_Phone_3__c, opportunity__r.Family_Contact_Relationship_3__c, opportunity__r.AccountId
                              from Client_Chart__c where id = : Client.id];

        if (cl.opportunity__r.Family_Contact_Name__c != null && !string.isBlank(cl.opportunity__r.Family_Contact_Name__c)) {
            contact con = new contact();
            con.lastname = cl.opportunity__r.Family_Contact_Name__c;
            con.email = cl.opportunity__r.Family_Contact_Email__c;
            con.Phone = cl.opportunity__r.Family_Contact_Phone__c;
            con.Relationship__c = cl.opportunity__r.Family_Contact_Relationship__c;
            con.RecordTypeId = mapOfContactRT.get('Client Chart Contact');
            con.Client_Chart__c = cl.id;
            con.Status__c = 'PHI Unauthorized';
            con.AccountId = cl.opportunity__r.AccountId;
            con.Type__c = 'Family';
            contInsertList.add(con);

        }

        if (cl.opportunity__r.Family_Contact_Name_2__c != null && !string.isBlank(cl.opportunity__r.Family_Contact_Name_2__c)) {
            contact con = new contact();
            con.lastname = cl.opportunity__r.Family_Contact_Name_2__c;
            con.email = cl.opportunity__r.Family_Contact_Email_2__c;
            con.Phone = cl.opportunity__r.Family_Contact_Phone_2__c;
            con.Relationship__c = cl.opportunity__r.Family_Contact_Relationship_2__c;
            con.RecordTypeId = mapOfContactRT.get('Client Chart Contact');
            con.Client_Chart__c = cl.id;
            con.Status__c = 'PHI Unauthorized';
            con.AccountId = cl.opportunity__r.AccountId;
            con.Type__c = 'Family';
            contInsertList.add(con);

        }

        if (cl.opportunity__r.Family_Contact_Name_3__c != null && !string.isBlank(cl.opportunity__r.Family_Contact_Name_3__c)) {
            contact con = new contact();
            con.lastname = cl.opportunity__r.Family_Contact_Name_3__c;
            con.email = cl.opportunity__r.Family_Contact_Email_3__c;
            con.Phone = cl.opportunity__r.Family_Contact_Phone_3__c;
            con.Relationship__c = cl.opportunity__r.Family_Contact_Relationship_3__c;
            con.RecordTypeId = mapOfContactRT.get('Client Chart Contact');
            con.Client_Chart__c = cl.id;
            con.Status__c = 'PHI Unauthorized';
            con.AccountId = cl.opportunity__r.AccountId;
            con.Type__c = 'Family';
            contInsertList.add(con);

        }

        try {
            if (contInsertList.size() > 0) {
                insert contInsertList;
                createPHIAuthorizations(contInsertList);
            }
        } Catch(Exception e) {
            system.debug('exc in Contacts Insert=' + e.getMessage());
        }
    }

    public void createPHIAuthorizations(List<Contact> contactList) {

        ID AuthRecTypeID =  Schema.SObjectType.PHI_Log__c.getRecordTypeInfosByName().get('Authorization for Release of Confidential Information').getRecordTypeId();
        List<PHI_Log__c> lstPhLog = new List<PHI_Log__c>();

        if (!contactList.isEmpty()) {
            for (Contact cont : contactList) {
                PHI_Log__c newPhiLog = new PHI_Log__c();
                newPhiLog.RecordTypeID = AuthRecTypeID;
                newPhiLog.Client_Chart__c = cont.Client_Chart__c;
                newPhiLog.Contact__c = cont.id;
                newPhiLog.status__c = 'Open';
                lstPhLog.add(newPhiLog);
            }
        }
        try {
            if (!lstPhLog.isEmpty()) {
                insert lstPhLog;
            }
        } Catch(Exception e) {
            system.debug('exc in PHI Auth Insert=' + e.getMessage());
        }


    }

    public void createIntakeAllRecords(Client_Chart__c Client) {

        List<Intake_Forms__c> lstOfNewIntakeForm = new List<Intake_Forms__c>();
        if (mapOfIntakeFormsRT.keySet().size() > 0) {
            for (String recordTypeName : mapOfIntakeFormsRT.keySet()) {

                Intake_Forms__c NewIntakeForm = new Intake_Forms__c ();
                NewIntakeForm.Client_Chart__c = Client.id;
                NewIntakeForm.RecordTypeID = mapOfIntakeFormsRT.get(recordTypeName);
                NewIntakeForm.Name = recordTypeName;
                NewIntakeForm.Status__c = 'Open';
                NewIntakeForm.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(3);
                lstOfNewIntakeForm.add(NewIntakeForm);

            }

            try {
                if (lstOfNewIntakeForm.size() > 0)
                    insert  lstOfNewIntakeForm;
            } catch (exception e) {
                system.debug('exc in Intake Forms Insert=' + e.getMessage());
            }
        }
    }

    public void createIntakeAdmitAgreement(Client_Chart__c Client) {


        RecordType rt = [select id, name, SobjectType from RecordType where DeveloperName = 'Admit_Agreement'];
        Intake_Forms__c NewIntakeForm = new Intake_Forms__c ();
        NewIntakeForm.Client_Chart__c = Client.id;
        NewIntakeForm.RecordTypeID = rt.id;
        NewIntakeForm.Name = rt.name;
        NewIntakeForm.Status__c = 'Open';
        // NewIntakeForm.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(),Client.Admit_Date_Time__c.day(),Client.Admit_Date_Time__c.Hour(),Client.Admit_Date_Time__c.Minute(),Client.Admit_Date_Time__c.Second()).addHours(3);
        insert  NewIntakeForm;

    }

    public void updateIntakeAdmitAgreement(Client_Chart__c client) {
        string ClientID = client.id;

        Intake_Forms__c NewIntakeForm = [select id, Due_Date_Time__c
                                         from Intake_Forms__c where Client_Chart__c = : ClientID AND Recordtype.DeveloperName = :'Admit_Agreement' limit 1];
        NewIntakeForm.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(3);

        update NewIntakeForm;
    }

    public void createAdmitOrder(Client_Chart__c Client) {

        list<Medical__c> medicalRecordsList = new List<Medical__c>();

        //Inserting Admit Orders
        Medical__c admitOrder = new Medical__c();
        admitOrder.Client_Chart__c = Client.id;
        admitOrder.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(32);
        admitOrder.RecordTypeId = mapOfMedicalRT.get('Admit Order');
        admitOrder.Status__c = 'Open';
        medicalRecordsList.add(admitOrder);

        try {
            if (medicalRecordsList.size() > 0)
                insert medicalRecordsList;
        } catch (exception e) {
            system.debug('exc in Medical Records =' + e.getMessage());
        }
    }

    public void createDrugScreen(Client_Chart__c Client) {

        list<Medical__c> medicalRecordsList = new List<Medical__c>();

        //Inserting Drug Screen
        Medical__c drugScreen = new Medical__c();
        drugScreen.Client_Chart__c = Client.id;
        drugScreen.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(32);
        drugScreen.RecordTypeId = mapOfMedicalRT.get('BAC and Drug Screen');
        drugScreen.Status__c = 'Open';
        medicalRecordsList.add(drugScreen);

        try {
            if (medicalRecordsList.size() > 0)
                insert medicalRecordsList;
        } catch (exception e) {
            system.debug('exc in Medical Records =' + e.getMessage());
        }
    }

    public void createUrinePregnancy(Client_Chart__c Client) {

        list<Medical__c> medicalRecordsList = new List<Medical__c>();

        //Checking if the client is Female, then Inserting Uring Pregnancy Test
        if (Client.Gender__c == 'Female') {
            Medical__c urinePregnancyTest = new Medical__c();
            urinePregnancyTest.Client_Chart__c = Client.id;
            urinePregnancyTest.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(32);
            urinePregnancyTest.RecordTypeId = mapOfMedicalRT.get('Urine Pregnancy Test');
            urinePregnancyTest.Status__c = 'Open';
            medicalRecordsList.add(urinePregnancyTest);
        }

        try {
            if (medicalRecordsList.size() > 0)
                insert medicalRecordsList;
        } catch (exception e) {
            system.debug('exc in Medical Records =' + e.getMessage());
        }
    }

    public void createAssessmentIRTools(Client_Chart__c Client) {

        list<Assessment_IR_Tools__c> assessmentRecordsList = new List<Assessment_IR_Tools__c>();

        //Inserting Drug Screen
        Assessment_IR_Tools__c painScreen = new Assessment_IR_Tools__c();
        painScreen.Client_Chart__c = Client.id;
        painScreen.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(3);
        painScreen.RecordTypeId = mapOfAssessmentIRToolsRT.get('Pain Screen');
        painScreen.Status__c = 'Open';
        assessmentRecordsList.add(painScreen);

        Assessment_IR_Tools__c nutritionalScreen = new Assessment_IR_Tools__c();
        nutritionalScreen.Client_Chart__c = Client.id;
        nutritionalScreen.Due_Date_Time__c = datetime.newInstance(Client.Admit_Date_Time__c.year(), Client.Admit_Date_Time__c.month(), Client.Admit_Date_Time__c.day(), Client.Admit_Date_Time__c.Hour(), Client.Admit_Date_Time__c.Minute(), Client.Admit_Date_Time__c.Second()).addHours(3);
        nutritionalScreen.RecordTypeId = mapOfAssessmentIRToolsRT.get('Nutritional Screen');
        nutritionalScreen.Status__c = 'Open';
        assessmentRecordsList.add(nutritionalScreen);

        try {
            if (assessmentRecordsList.size() > 0)
                insert assessmentRecordsList;
        } catch (exception e) {
            system.debug('exc in Medical Records =' + e.getMessage());
        }
    }


    public void getRecordTypes() {
        mapOfClientChartRT = new map<string, string>();
        mapOfClinicalEvalRT = new map<string, string>();
        mapOfClinic2EvalRT = new map<string, string>();
        mapOfClinic3EvalRT = new map<string, string>();
        mapOfTxDcRT = new map<string, string>();
        mapOfContactRT = new map<string, string>();
        mapOfIntakeFormsRT = new map<string, string>();
        mapOfMedicalRT = new map<string, string>();
        mapOfAssessmentIRToolsRT = new map<string, string>();

        for (RecordType rt : [select id, name, SobjectType, DeveloperName from RecordType]) {
            if (rt.SobjectType == 'Client_Chart__c')
                mapOfClientChartRT.put(rt.name, rt.id);

            else if (rt.SobjectType == 'Clinical_Evaluation__c')
                mapOfClinicalEvalRT.put(rt.name, rt.id);

            else if (rt.SobjectType == 'Clinical_Evaluation_2__c')
                mapOfClinic2EvalRT.put(rt.name, rt.id);

            else if (rt.SobjectType == 'Clinical_Evaluation_3__c')
                mapOfClinic3EvalRT.put(rt.name, rt.id);

            else if (rt.SobjectType == 'Tx_and_D_C_Plans__c')
                mapOfTxDcRT.put(rt.name, rt.id);

            else if (rt.SobjectType == 'Contact')
                mapOfContactRT.put(rt.name, rt.id);

            else if (rt.SobjectType == 'Intake_Forms__c' && rt.Name != 'Devices' && rt.DeveloperName != 'Admit_Agreement')
                mapOfIntakeFormsRT.put(rt.name, rt.id);

            else if (rt.SobjectType == 'Medical__c')
                mapOfMedicalRT.put(rt.name, rt.id);

            else if (rt.SobjectType == 'Assessment_IR_Tools__c')
                mapOfAssessmentIRToolsRT.put(rt.name, rt.id);
        }
    }


    public Opportunity GetDrugsFromOpportunity(string OppId) {
        Opportunity OppDrugs = new Opportunity();

        List<Opportunity> Opps = [Select Id, Name,
                                  Drug_of_Choice_1__c, Current_Use_Details_Drug_1__c, Age_of_First_Use_Drug_1__c,
                                  Frequency_of_Use_Drug_1__c, Method_of_Use_Drug_1__c, Date_of_Last_Use_Drug_1__c,
                                  Drug_of_Choice_2__c, Current_Use_Details_Drug_2__c, Age_of_First_Use_Drug_2__c,
                                  Frequency_of_Use_Drug_2__c, Method_of_Use_Drug_2__c, Date_of_Last_Use_Drug_2__c,
                                  Drug_of_Choice_3__c, Current_Use_Details_Drug_3__c, Age_of_First_Use_Drug_3__c,
                                  Frequency_of_Use_Drug_3__c, Method_of_Use_Drug_3__c, Date_of_Last_Use_Drug_3__c
                                  from Opportunity where Id = : OppId Limit 1];
        if (Opps.size() > 0) {
            OppDrugs = Opps[0];
        }

        return OppDrugs;
    }
    public Clinical_Evaluation__c MapFieldsWithOppDrugs(Clinical_Evaluation__c ce, Clinical_Evaluation__c DrugsOpp) {
        if (DrugsOpp != null) {
            if (DrugsOpp.PAA_Drug_of_Choice_1__c != null)
                ce.FFE_AlcoholDrugH_Name1__c = DrugsOpp.PAA_Drug_of_Choice_1__c;

            if (DrugsOpp.PAA_Current_Use_Details_Drug_1__c != null)
                ce.FFE_AlcoholDrugH_Amount1__c = DrugsOpp.PAA_Current_Use_Details_Drug_1__c;

            if (DrugsOpp.PAA_Age_of_First_Use_Drug_1__c != null)
                ce.FFE_AlcoholDrugH_Age1__c = string.valueOf(DrugsOpp.PAA_Age_of_First_Use_Drug_1__c);

            if (DrugsOpp.PAA_Frequency_of_Use_Drug_1__c != null)
                ce.FFE_AlcoholDrugH_Rate1__c = DrugsOpp.PAA_Frequency_of_Use_Drug_1__c;

            if (DrugsOpp.PAA_Method_of_Use_Drug_1__c != null)
                ce.FFE_AlcoholDrugH_Route1__c = DrugsOpp.PAA_Method_of_Use_Drug_1__c;

            if (DrugsOpp.PAA_Date_of_Last_Use_Drug_1__c != null)
                ce.FFE_AlcoholDrugH_DateLastUse1__c = string.valueOf(DrugsOpp.PAA_Date_of_Last_Use_Drug_1__c);

            if (DrugsOpp.PAA_Drug_of_Choice_2__c != null)
                ce.FFE_AlcoholDrugH_Name2__c = DrugsOpp.PAA_Drug_of_Choice_2__c;

            if (DrugsOpp.PAA_Current_Use_Details_Drug_2__c != null)
                ce.FFE_AlcoholDrugH_Amount2__c = DrugsOpp.PAA_Current_Use_Details_Drug_2__c;

            if (DrugsOpp.PAA_Age_of_First_Use_Drug_2__c != null)
                ce.FFE_AlcoholDrugH_Age2__c = string.valueOf(DrugsOpp.PAA_Age_of_First_Use_Drug_2__c);

            if (DrugsOpp.PAA_Frequency_of_Use_Drug_2__c != null)
                ce.FFE_AlcoholDrugH_Rate2__c = DrugsOpp.PAA_Frequency_of_Use_Drug_2__c;

            if (DrugsOpp.PAA_Method_of_Use_Drug_2__c != null)
                ce.FFE_AlcoholDrugH_Route2__c = DrugsOpp.PAA_Method_of_Use_Drug_2__c;

            if (DrugsOpp.PAA_Date_of_Last_Use_Drug_2__c != null)
                ce.FFE_AlcoholDrugH_DateLastUse2__c = string.valueOf(DrugsOpp.PAA_Date_of_Last_Use_Drug_2__c);

            if (DrugsOpp.PAA_Drug_of_Choice_3__c != null)
                ce.FFE_AlcoholDrugH_Name3__c = DrugsOpp.PAA_Drug_of_Choice_3__c;

            if (DrugsOpp.PAA_Current_Use_Details_Drug_3__c != null)
                ce.FFE_AlcoholDrugH_Amount3__c = DrugsOpp.PAA_Current_Use_Details_Drug_3__c;

            if (DrugsOpp.PAA_Age_of_First_Use_Drug_3__c != null)
                ce.FFE_AlcoholDrugH_Age3__c = string.valueOf(DrugsOpp.PAA_Age_of_First_Use_Drug_3__c);

            if (DrugsOpp.PAA_Frequency_of_Use_Drug_3__c != null)
                ce.FFE_AlcoholDrugH_Rate3__c = DrugsOpp.PAA_Frequency_of_Use_Drug_3__c;

            if (DrugsOpp.PAA_Method_of_Use_Drug_3__c != null)
                ce.FFE_AlcoholDrugH_Route3__c = DrugsOpp.PAA_Method_of_Use_Drug_3__c;

            if (DrugsOpp.PAA_Date_of_Last_Use_Drug_3__c != null)
                ce.FFE_AlcoholDrugH_DateLastUse3__c = string.valueOf(DrugsOpp.PAA_Date_of_Last_Use_Drug_3__c);
        }

        return ce;
    }

    public Clinical_Evaluation_3__c MapFieldWithOppDrugs_HP(Clinical_Evaluation_3__c ce, Clinical_Evaluation__c DrugsOpp) {
        if (DrugsOpp != null) {
            if (DrugsOpp.PAA_Drug_of_Choice_1__c != null)
                ce.HP_Subs_Use_1_Subs__c = DrugsOpp.PAA_Drug_of_Choice_1__c;

            if (DrugsOpp.PAA_Current_Use_Details_Drug_1__c != null)
                ce.HP_Subs_Use_1_Amount__c = DrugsOpp.PAA_Current_Use_Details_Drug_1__c;

            if (DrugsOpp.PAA_Age_of_First_Use_Drug_1__c != null)
                ce.HP_Subs_Use_1_Amount_Last_use__c = string.valueOf(DrugsOpp.PAA_Age_of_First_Use_Drug_1__c);

            if (DrugsOpp.PAA_Frequency_of_Use_Drug_1__c != null)
                ce.HP_Subs_Use_1_Length__c = DrugsOpp.PAA_Frequency_of_Use_Drug_1__c;

            if (DrugsOpp.PAA_Method_of_Use_Drug_1__c != null)
                ce.HP_Subs_Use_1_Route__c = DrugsOpp.PAA_Method_of_Use_Drug_1__c;

            if (DrugsOpp.PAA_Date_of_Last_Use_Drug_1__c != null)
                ce.HP_Subs_Use_1_Date_Last_use__c = string.valueOf(DrugsOpp.PAA_Date_of_Last_Use_Drug_1__c);


            if (DrugsOpp.PAA_Drug_of_Choice_2__c != null)
                ce.HP_Subs_Use_2_Subs__c = DrugsOpp.PAA_Drug_of_Choice_2__c;

            if (DrugsOpp.PAA_Current_Use_Details_Drug_2__c != null)
                ce.HP_Subs_Use_2_Amount__c = DrugsOpp.PAA_Current_Use_Details_Drug_2__c;

            if (DrugsOpp.PAA_Age_of_First_Use_Drug_2__c != null)
                ce.HP_Subs_Use_2_Amount_Last_use__c = string.valueOf(DrugsOpp.PAA_Age_of_First_Use_Drug_2__c);

            if (DrugsOpp.PAA_Frequency_of_Use_Drug_2__c != null)
                ce.HP_Subs_Use_2_Length__c = DrugsOpp.PAA_Frequency_of_Use_Drug_2__c;

            if (DrugsOpp.PAA_Method_of_Use_Drug_2__c != null)
                ce.HP_Subs_Use_2_Route__c = DrugsOpp.PAA_Method_of_Use_Drug_2__c;

            if (DrugsOpp.PAA_Date_of_Last_Use_Drug_2__c != null)
                ce.HP_Subs_Use_2_Date_Last_use__c = string.valueOf(DrugsOpp.PAA_Date_of_Last_Use_Drug_2__c);


            if (DrugsOpp.PAA_Drug_of_Choice_3__c != null)
                ce.HP_Subs_Use_3_Subs__c = DrugsOpp.PAA_Drug_of_Choice_3__c;

            if (DrugsOpp.PAA_Current_Use_Details_Drug_3__c != null)
                ce.HP_Subs_Use_3_Amount__c = DrugsOpp.PAA_Current_Use_Details_Drug_3__c;

            if (DrugsOpp.PAA_Age_of_First_Use_Drug_3__c != null)
                ce.HP_Subs_Use_3_Amount_Last_use__c = string.valueOf(DrugsOpp.PAA_Age_of_First_Use_Drug_3__c);

            if (DrugsOpp.PAA_Frequency_of_Use_Drug_3__c != null)
                ce.HP_Subs_Use_3_Length__c = DrugsOpp.PAA_Frequency_of_Use_Drug_3__c;

            if (DrugsOpp.PAA_Method_of_Use_Drug_3__c != null)
                ce.HP_Subs_Use_3_Route__c = DrugsOpp.PAA_Method_of_Use_Drug_3__c;

            if (DrugsOpp.PAA_Date_of_Last_Use_Drug_3__c != null)
                ce.HP_Subs_Use_3_Date_Last_use__c = string.valueOf(DrugsOpp.PAA_Date_of_Last_Use_Drug_3__c);
        }
        return ce;
    }

    public BPDrugInfoResult MapFieldWithOppDrugs_BP(Clinical_Evaluation_2__c ce, Clinical_Evaluation_3__c ce3, Clinical_Evaluation__c DrugsOpp) {
        List<BPDrugsInfo> BPDrugsList = new List<BPDrugsInfo>();
        BPDrugInfoResult result = new BPDrugInfoResult();

        try {
            if (DrugsOpp != null) {
                if (DrugsOpp.PAA_Drug_of_Choice_1__c != null) {
                    BPDrugsInfo bpdi1 = new BPDrugsInfo();

                    if (DrugsOpp.PAA_Drug_of_Choice_1__c != null)
                        bpdi1.Name = DrugsOpp.PAA_Drug_of_Choice_1__c;

                    if (DrugsOpp.PAA_Current_Use_Details_Drug_1__c != null)
                        bpdi1.Amount = DrugsOpp.PAA_Current_Use_Details_Drug_1__c;

                    if (DrugsOpp.PAA_Age_of_First_Use_Drug_1__c != null)
                        bpdi1.Age = string.valueOf(DrugsOpp.PAA_Age_of_First_Use_Drug_1__c);

                    if (DrugsOpp.PAA_Frequency_of_Use_Drug_1__c != null)
                        bpdi1.Frequency = DrugsOpp.PAA_Frequency_of_Use_Drug_1__c;

                    if (DrugsOpp.PAA_Method_of_Use_Drug_1__c != null)
                        bpdi1.Method = DrugsOpp.PAA_Method_of_Use_Drug_1__c;

                    if (DrugsOpp.PAA_Date_of_Last_Use_Drug_1__c != null)
                        bpdi1.LastUsed = string.valueOf(DrugsOpp.PAA_Date_of_Last_Use_Drug_1__c);

                    BPDrugsList.add(bpdi1);
                }

                if (DrugsOpp.PAA_Drug_of_Choice_2__c != null) {
                    BPDrugsInfo bpdi2 = new BPDrugsInfo();

                    if (DrugsOpp.PAA_Drug_of_Choice_2__c != null)
                        bpdi2.Name = DrugsOpp.PAA_Drug_of_Choice_2__c;

                    if (DrugsOpp.PAA_Current_Use_Details_Drug_2__c != null)
                        bpdi2.Amount = DrugsOpp.PAA_Current_Use_Details_Drug_2__c;

                    if (DrugsOpp.PAA_Age_of_First_Use_Drug_2__c != null)
                        bpdi2.Age = string.valueOf(DrugsOpp.PAA_Age_of_First_Use_Drug_2__c);

                    if (DrugsOpp.PAA_Frequency_of_Use_Drug_2__c != null)
                        bpdi2.Frequency = DrugsOpp.PAA_Frequency_of_Use_Drug_2__c;

                    if (DrugsOpp.PAA_Method_of_Use_Drug_2__c != null)
                        bpdi2.Method = DrugsOpp.PAA_Method_of_Use_Drug_2__c;

                    if (DrugsOpp.PAA_Date_of_Last_Use_Drug_2__c != null)
                        bpdi2.LastUsed = string.valueOf(DrugsOpp.PAA_Date_of_Last_Use_Drug_2__c);

                    BPDrugsList.add(bpdi2);
                }

                if (DrugsOpp.PAA_Drug_of_Choice_3__c != null) {
                    BPDrugsInfo bpdi3 = new BPDrugsInfo();

                    if (DrugsOpp.PAA_Drug_of_Choice_3__c != null)
                        bpdi3.Name = DrugsOpp.PAA_Drug_of_Choice_3__c;

                    if (DrugsOpp.PAA_Current_Use_Details_Drug_3__c != null)
                        bpdi3.Amount = DrugsOpp.PAA_Current_Use_Details_Drug_3__c;

                    if (DrugsOpp.PAA_Age_of_First_Use_Drug_3__c != null)
                        bpdi3.Age = string.valueOf(DrugsOpp.PAA_Age_of_First_Use_Drug_3__c);

                    if (DrugsOpp.PAA_Frequency_of_Use_Drug_3__c != null)
                        bpdi3.Frequency = DrugsOpp.PAA_Frequency_of_Use_Drug_3__c;

                    if (DrugsOpp.PAA_Method_of_Use_Drug_3__c != null)
                        bpdi3.Method = DrugsOpp.PAA_Method_of_Use_Drug_3__c;

                    if (DrugsOpp.PAA_Date_of_Last_Use_Drug_3__c != null)
                        bpdi3.LastUsed = string.valueOf(DrugsOpp.PAA_Date_of_Last_Use_Drug_3__c);

                    BPDrugsList.add(bpdi3);
                }

                integer otherCount = 0;
                for (BPDrugsInfo bp : BPDrugsList) {
                    string drugName  = bp.Name;
                    bp.IsMapped = false;
                    if (drugName == 'Heroin') { /*OPIATES*/
                        ce.OPIATES_HEROINE_Age_began_first_use__c   = bp.Age;
                        ce.OPIATES_HEROINE_Amount_of_use__c = bp.Amount;
                        ce.OPIATES_HEROINE_Frequency_of_use__c = bp.Frequency;
                        ce.OPIATES_HEROINE_Last_time_used__c = bp.LastUsed;
                        ce.OPIATES_HEROINE_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Percocet') {
                        ce.OPIATES_PERCODAN_Age_began_first_use__c  = bp.Age;
                        ce.OPIATES_PERCODAN_Amount_of_use__c = bp.Amount;
                        ce.OPIATES_PERCODAN_Frequency_of_use__c  = bp.Frequency;
                        ce.OPIATES_PERCODAN_Last_time_used__c = bp.LastUsed;
                        ce.OPIATES_PERCODAN_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Vicodin') {
                        ce.OPIATES_VICODIN_Age_began_first_use__c   = bp.Age;
                        ce.OPIATES_VICODIN_Amount_of_use__c = bp.Amount;
                        ce.OPIATES_VICODIN_Frequency_of_use__c = bp.Frequency;
                        ce.OPIATES_VICODIN_Last_time_used__c = bp.LastUsed;
                        ce.OPIATES_VICODIN_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Methadone') {
                        ce.OPIATES_METHADONE_Age_began_first_use__c = bp.Age;
                        ce.OPIATES_METHADONE_Amount_of_use__c = bp.Amount;
                        ce.OPIATES_METHADONE_Frequency_of_use__c = bp.Frequency;
                        ce.OPIATES_METHADONE_Last_time_used__c = bp.LastUsed;
                        ce.OPIATES_METHADONE_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Dilaudid' || drugName == 'Oxycontin') {
                        ce.OPIATES_DILAUDID_Age_began_first_use__c  = bp.Age;
                        ce.OPIATES_DILAUDID_Amount_of_use__c = bp.Amount;
                        ce.OPIATES_DILAUDID_Frequency_of_used__c = bp.Frequency;
                        ce.OPIATES_DILAUDID_Last_time_used__c = bp.LastUsed;
                        ce.OPIATES_DILAUDID_Route__c = bp.Method;
                        bp.IsMapped = true;
                    }
                    /*else if(drugName == 'Other')
                    {
                    ce.OPIATES_OTHER_Age_began_first_use__c = bp.Age;
                    ce.OPIATES_OTHER_Amount_of_use__c = bp.Amount;
                    ce.OPIATES_OTHER_Frequency_of_use__c = bp.Frequency;
                    ce.OPIATES_OTHER_Last_time_used__c = bp.LastUsed;
                    ce.OPIATES_OTHER_Route__c = bp.Method;
                    }*/
                    else if (drugName == 'Marijuana' || drugName == 'Cannabis') { /*HALLUCINOGENS*/
                        ce.HALLUCIN_MARIJUANA_Age_began_first_use__c = bp.Age;
                        ce.HALLUCIN_MARIJUANA_Amount_of_use__c = bp.Amount;
                        ce.HALLUCIN_MARIJUANA_Frequency_of_use__c = bp.Frequency;
                        ce.HALLUCIN_MARIJUANA_Last_time_used__c = bp.LastUsed;
                        ce.HALLUCIN_MARIJUANA_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'LSD') {
                        ce.HALLUCIN_LSD_Acid_Age_began_first_use__c = bp.Age;
                        ce.HALLUCIN_LSD_Acid_Amount_of_use__c = bp.Amount;
                        ce.HALLUCIN_LSD_Acid_Frequency_of_use__c = bp.Frequency;
                        ce.HALLUCIN_LSD_Acid_Last_time_used__c = bp.LastUsed;
                        ce.HALLUCIN_LSD_Acid_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'PCP') {
                        ce.HALLUCIN_PCP_Age_began_first_use__c = bp.Age;
                        ce.HALLUCIN_PCP_Amount_of_use__c = bp.Amount;
                        ce.HALLUCIN_PCP_Frequency_of_use__c = bp.Frequency;
                        ce.HALLUCIN_PCP_Last_time_used__c = bp.LastUsed;
                        ce.HALLUCIN_PCP_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Ecstacy') {
                        ce.HALLUCIN_ECSTASY_Age_began_first_use__c = bp.Age;
                        ce.HALLUCIN_ECSTASY_Amount_of_use__c = bp.Amount;
                        ce.HALLUCIN_ECSTASY_Frequency_of_use__c = bp.Frequency;
                        ce.HALLUCIN_ECSTASY_Last_time_used__c = bp.LastUsed;
                        ce.HALLUCIN_ECSTASY_Route__c = bp.Method;
                        bp.IsMapped = true;
                    }
                    /*else if(drugName == 'Other')
                    {
                    ce.HALLUCIN_OTHER_Age_began_first_use__c = bp.Age;
                    ce.HALLUCIN_OTHER_Amount_of_use__c = bp.Amount;
                    ce.HALLUCIN_OTHER_Frequency_of_use__c = bp.Frequency;
                    ce.HALLUCIN_OTHER_Last_time_used__c = bp.LastUsed;
                    ce.HALLUCIN_OTHER_Route__c = bp.Method;
                    }*/
                    else if (drugName == 'Cocaine') { /*STIMULANTS*/
                        ce.STIMULANTS_COCAINE_Age_began_first_use__c = bp.Age;
                        ce.STIMULANTS_COCAINE_Amount_of_use__c = bp.Amount;
                        ce.STIMULANTS_COCAINE_Frequency_of_use__c = bp.Frequency;
                        ce.STIMULANTS_COCAINE_Last_time_used__c = bp.LastUsed;
                        ce.STIMULANTS_COCAINE_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Crack Cocaine') {
                        ce.STIMULANTS_CRACK_Age_began_first_use__c = bp.Age;
                        ce.STIMULANTS_CRACK_Amount_of_use__c = bp.Amount;
                        ce.STIMULANTS_CRACK_Frequency_of_use__c = bp.Frequency;
                        ce.STIMULANTS_CRACK_Last_time_used__c = bp.LastUsed;
                        ce.STIMULANTS_CRACK_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Speed') {
                        ce.STIMULANTS_SPEED_Age_began_first_use__c = bp.Age;
                        ce.STIMULANTS_SPEED_Amount_of_use__c = bp.Amount;
                        ce.STIMULANTS_SPEED_Frequency_of_use__c = bp.Frequency;
                        ce.STIMULANTS_SPEED_Last_time_used__c = bp.LastUsed;
                        ce.STIMULANTS_SPEED_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Amphetamines') {
                        ce.STIMULANTS_AMPHETA_Age_began_first_use__c = bp.Age;
                        ce.STIMULANTS_AMPHETA_Amount_of_use__c = bp.Amount;
                        ce.STIMULANTS_AMPHETA_Frequency_of_use__c = bp.Frequency;
                        ce.STIMULANTS_AMPHETA_Last_time_used__c = bp.LastUsed;
                        ce.STIMULANTS_AMPHETA_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Methamphetamine') {
                        ce.STIMULANTS_METH_Age_began_first_use__c = bp.Age;
                        ce.STIMULANTS_METH_Amount_of_use__c = bp.Amount;
                        ce.STIMULANTS_METH_Frequency_of_use__c = bp.Frequency;
                        ce.STIMULANTS_METH_Last_time_used__c = bp.LastUsed;
                        ce.STIMULANTS_METH_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Caffeine') {
                        ce.STIMULANTS_CAFFEINE_Age_began_first_use__c = bp.Age;
                        ce.STIMULANTS_CAFFEINE_Amount_of_use__c = bp.Amount;
                        ce.STIMULANTS_CAFFEINE_Frequency_of_use__c = bp.Frequency;
                        ce.STIMULANTS_CAFFEINE_Last_time_used__c = bp.LastUsed;
                        ce.STIMULANTS_CAFFEINE_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Nicotine') {
                        ce.STIMULANTS_NICOTINE_Age_began_first_use__c = bp.Age;
                        ce.STIMULANTS_NICOTINE_Amount_of_use__c = bp.Amount;
                        ce.STIMULANTS_NICOTINE_Frequency_of_use__c = bp.Frequency;
                        ce.STIMULANTS_NICOTINE_Last_time_used__c = bp.LastUsed;
                        ce.STIMULANTS_NICOTINE_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Alcohol') {
                        ce.DEPRESSANTS_ALCOHOL_Age_began_first_use__c = bp.Age;
                        ce.DEPRESSANTS_ALCOHOL_Amount_of_use__c = bp.Amount;
                        ce.DEPRESSANTS_ALCOHOL_Last_time_used__c = bp.LastUsed;
                        ce.DEPRESSANTS_ALCOHOL_Frequency_of_use__c = bp.Frequency;
                        ce.DEPRESSANTS_ALCOHOL_Route__c = bp.Method;
                        bp.IsMapped = true;
                    } else if (drugName == 'Barbiturates') {
                        ce.DEPRESSANTS_BARBIT_Age_began_first_use__c = bp.Age;
                        ce.DEPRESSANTS_BARBIT_Amount_of_use__c = bp.Amount;
                        ce.DEPRESSANTS_BARBIT_Last_time_used__c = bp.LastUsed;
                        ce.DEPRESSANTS_BARBIT_Route__c = bp.Method;
                        ce.DEPRESSANTS_BARBIT_Frequency_of_use__c = bp.Frequency;
                        bp.IsMapped = true;
                    } else if (drugName == 'Quaaludes') {
                        ce.DEPRESSANTS_QUAALUDE_Age_began_first_use__c = bp.Age;
                        ce.DEPRESSANTS_QUAALUDE_Amount_of_use__c = bp.Amount;
                        ce.DEPRESSANTS_QUAALUDE_Last_time_used__c = bp.LastUsed;
                        ce.DEPRESSANTS_QUAALUDE_Route__c = bp.Method;
                        ce.DEPRESSANTS_QUAALUDE_Frequency_of_use__c = bp.Frequency;
                        bp.IsMapped = true;
                    } else if (drugName == 'Valium' || drugName == 'Ativan') {
                        ce.TRANQUILIZER_VALIUM_Age_began_first_use__c = bp.Age;
                        ce.TRANQUILIZER_VALIUM_Amount_of_use__c = bp.Amount;
                        ce.TRANQUILIZER_VALIUM_Last_time_used__c = bp.LastUsed;
                        ce.TRANQUILIZER_VALIUM_Route__c = bp.Method;
                        ce.TRANQUILIZER_VALIUM_Frequency_of_use__c = bp.Frequency;
                        bp.IsMapped = true;
                    } else if (drugName == 'Librium' || drugName == 'Klonopin') {
                        ce.TRANQUILIZER_LIBRIUM_Age_began_first_use__c = bp.Age;
                        ce.TRANQUILIZER_LIBRIUM_Amount_of_use__c = bp.Amount;
                        ce.TRANQUILIZER_LIBRIUM_Last_time_used__c = bp.LastUsed;
                        ce.TRANQUILIZER_LIBRIUM_Route__c = bp.Method;
                        ce.TRANQUILIZER_LIBRIUM_Frequency_of_use__c = bp.Frequency;
                        bp.IsMapped = true;
                    } else if (drugName == 'Xanax') {
                        ce.TRANQUILIZER_Xanax_Age_began_first_use__c = bp.Age;
                        ce.TRANQUILIZER_Xanax_Amount_of_use__c = bp.Amount;
                        ce.TRANQUILIZER_Xanax_Last_time_used__c = bp.LastUsed;
                        ce.TRANQUILIZER_Xanax_Route__c = bp.Method;
                        ce.TRANQUILIZER_Xanax_Frequency_of_use__c = bp.Frequency;
                        bp.IsMapped = true;
                    }
                    /*else if(drugName == 'Other')
                    {
                    ce.OTHER_DRUGS_TYPE1_Age_began_first_use__c = bp.Age;
                    ce.OTHER_DRUGS_TYPE1_Amount_of_use__c = bp.Amount;
                    ce.OTHER_DRUGS_TYPE1_Frequency_of_use__c = bp.Frequency;
                    ce.OTHER_DRUGS_TYPE1_Last_time_used__c = bp.LastUsed;
                    ce.OTHER_DRUGS_TYPE1_Route__c = bp.Method;
                    bp.IsMapped = true;
                    }*/


                    if (bp.IsMapped == false) {
                        otherCount  = otherCount + 1;
                        if (otherCount == 1) {
                            ce3.OTHER_DRUGS_TYPE1_Substance__c = bp.Name;
                            ce.OTHER_DRUGS_TYPE1_Age_began_first_use__c = bp.Age;
                            ce.OTHER_DRUGS_TYPE1_Amount_of_use__c = bp.Amount;
                            ce.OTHER_DRUGS_TYPE1_Frequency_of_use__c = bp.Frequency;
                            ce.OTHER_DRUGS_TYPE1_Last_time_used__c = bp.LastUsed;
                            ce.OTHER_DRUGS_TYPE1_Route__c = bp.Method;
                        } else if (otherCount == 2) {
                            ce3.OTHER_DRUGS_TYPE2_Substance__c = bp.Name;
                            ce.OTHER_DRUGS_TYPE2_Age_began_first_use__c = bp.Age;
                            ce.OTHER_DRUGS_TYPE2_Amount_of_use__c = bp.Amount;
                            ce.OTHER_DRUGS_TYPE2_Frequency_of_use__c = bp.Frequency;
                            ce.OTHER_DRUGS_TYPE2_Last_time_used__c = bp.LastUsed;
                            ce.OTHER_DRUGS_TYPE2_Route__c = bp.Method;
                        } else if (otherCount == 3) {
                            ce3.OTHER_DRUGS_TYPE3_Substance__c = bp.Name;
                            ce.OTHER_DRUGS_TYPE3_Age_began_first_use__c = bp.Age;
                            ce.OTHER_DRUGS_TYPE3_Amount_of_use__c = bp.Amount;
                            ce.OTHER_DRUGS_TYPE3_Frequency_of_use__c = bp.Frequency;
                            ce.OTHER_DRUGS_TYPE3_Last_time_used__c = bp.LastUsed;
                            ce.OTHER_DRUGS_TYPE3_Route__c = bp.Method;
                        }
                    }
                }
            }

            result.CE2 = ce;
            result.CE3 = ce3;

        }
        Catch(Exception ex) {
            result = null;
        }

        return result;
    }

    public void updateTXDCDischargeSummary(List<Client_Chart__c> lstNewCl , Map<Id, Client_Chart__c> oldMap, Map<Id, Client_Chart__c> newMap) {
        List<Tx_and_D_C_Plans__c> lstTxdcNew = new List<Tx_and_D_C_Plans__c>();
        Map<Id, Client_Chart__c> mapOfClientChart = new Map<Id, Client_Chart__c>();

        for (Client_Chart__c cl : lstNewCl) {

            if (oldMap.get(cl.Id).Discharge_Date_Time__c != newMap.get(cl.Id).Discharge_Date_Time__c || oldMap.get(cl.Id).Admit_Date_Time__c != newMap.get(cl.Id).Admit_Date_Time__c || oldMap.get(cl.Id).Street__c != newMap.get(cl.Id).Street__c || oldMap.get(cl.Id).City__c != newMap.get(cl.Id).City__c || oldMap.get(cl.Id).State__c != newMap.get(cl.Id).State__c || oldMap.get(cl.Id).Country__c != newMap.get(cl.Id).Country__c || oldMap.get(cl.Id).Postal_Code__c != newMap.get(cl.Id).Postal_Code__c) {
                mapOfClientChart.put(cl.Id, cl);
            }

        }
        string clientAddress;
        for (Tx_and_D_C_Plans__c iTxdc : [select Admit_Date__c, Client_Chart__c, Discharge_Date__c,
                                          Due_Date_time__c, Discharge_Address__c from Tx_and_D_C_Plans__c
                                          where Client_Chart__c IN : mapOfClientChart.keySet() and
                                          RecordType.DeveloperName = 'Discharge_Plan']) {

            if (mapOfClientChart.containsKey(iTxdc.Client_Chart__c)) {
                Client_Chart__c cl = mapOfClientChart.get(iTxdc.Client_Chart__c);
                Datetime dtAdmit = (Datetime) cl.Admit_Date_Time__c;
                Datetime dtDischarge = (Datetime) cl.Discharge_Date_Time__c;
                iTxdc.Admit_Date__c = dtAdmit.date();
                iTxdc.Discharge_Date__c = (dtDischarge != null) ? dtDischarge.date() : null;
                iTxdc.Due_Date_time__c = cl.Discharge_Date_Time__c;
                clientAddress = (string.isNotBlank(cl.Street__c)) ? cl.Street__c + ',' : '';
                clientAddress += (string.isNotBlank(cl.City__c)) ? cl.City__c + ',' : '';
                clientAddress += (string.isNotBlank(cl.State__c)) ? cl.State__c + ',' : '';
                clientAddress += (string.isNotBlank(cl.Country__c)) ? cl.Country__c + ',' : '';
                clientAddress += (string.isNotBlank(cl.Postal_Code__c)) ? cl.Postal_Code__c : '';
                iTxdc.Discharge_Address__c = clientAddress;

                lstTxdcNew.add(iTxdc);

            }

        }

        if (!lstTxdcNew.isEmpty())
            update lstTxdcNew;


    }

    public boolean isDischargeDateChanged(Client_Chart__c updatedClient, Client_Chart__c oldClient) {
        return updatedClient.Discharge_Date_Time__c != oldClient.Discharge_Date_Time__c;
    }

    public void updateDischargeDates(Client_Chart__c client) {
        try {
            Tx_and_D_C_Plans__c dischargePlan = [select Due_Date_time__c, Admit_Date__c from Tx_and_D_C_Plans__c
                                                 where RecordTypeId = :mapOfTxDcRT.get('Discharge Plan')
                                                         AND Client_Chart__c = :client.id];
            dischargePlan.Admit_Date__c = client.Admit_Date_Time__c.Date();
            if (client.Discharge_Date_Time__c != null) dischargePlan.Due_Date_time__c = client.Discharge_Date_Time__c;
            upsert dischargePlan;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            System.debug('before personalItemsPlan  >>> ');
            Tx_and_D_C_Plans__c personalItemsPlan = [select Due_Date_time__c, Admit_Date__c from Tx_and_D_C_Plans__c
                                                    where RecordTypeId = :mapOfTxDcRT.get('Personal Items Returned at Discharge')
                                                            AND Client_Chart__c = :client.id];
            System.debug('personalItemsPlan >>> ' + personalItemsPlan);
            personalItemsPlan.Admit_Date__c = client.Admit_Date_Time__c.Date();
            if (client.Discharge_Date_Time__c != null) personalItemsPlan.Due_Date_time__c = client.Discharge_Date_Time__c;
            upsert personalItemsPlan;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
    }

    public boolean isAdmitDateChanged(Client_Chart__c updatedClient, Client_Chart__c oldClient) {
        return updatedClient.Admit_Date_Time__c != oldClient.Admit_Date_Time__c;
    }

    public void updateDueDate(Client_Chart__c client) {
        Datetime admitTime = Client.Admit_Date_Time__c;
        try {
            Tx_and_D_C_Plans__c detoxTrt = [select Due_Date_time__c from Tx_and_D_C_Plans__c
                                            where RecordTypeId = :mapOfTxDcRT.get('Detox Treatment Plan')
                                                    AND Client_Chart__c = :client.id];
            detoxTrt.Due_Date_time__c = NewDateTime(admitTime, 24);
            upsert detoxTrt;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Tx_and_D_C_Plans__c masterTrt = [select Due_Date_time__c from Tx_and_D_C_Plans__c
                                             where RecordTypeId = :mapOfTxDcRT.get('Master Treatment Plan')
                                                     AND Client_Chart__c = :client.id];
            masterTrt.Due_Date_time__c = NewDateTime(admitTime, 168);
            upsert masterTrt;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Medical__c admitOrder = [select Due_Date_time__c from Medical__c
                                     where RecordTypeId = :mapOfMedicalRT.get('Admit Order')
                                             AND Client_Chart__c = :client.id];
            admitOrder.Due_Date_Time__c = NewDateTime(admitTime, 32);
            upsert admitOrder;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Medical__c drugScreen = [select Due_Date_time__c from Medical__c
                                     where RecordTypeId = :mapOfMedicalRT.get('BAC and Drug Screen')
                                             AND Client_Chart__c = :client.id AND Due_Date_time__c != null limit 1];
            drugScreen.Due_Date_Time__c = NewDateTime(admitTime, 32);
            upsert drugScreen;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Medical__c urinePregnancyTest = [select Due_Date_time__c from Medical__c
                                             where RecordTypeId = :mapOfMedicalRT.get('Urine Pregnancy Test')
                                                     AND Client_Chart__c = :client.id];
            urinePregnancyTest.Due_Date_Time__c = NewDateTime(admitTime, 32);
            upsert urinePregnancyTest;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Assessment_IR_Tools__c painScreen = [select Due_Date_time__c from Assessment_IR_Tools__c
                                                 where RecordTypeId = :mapOfAssessmentIRToolsRT.get('Pain Screen')
                                                         AND Client_Chart__c = :client.id AND Due_Date_time__c != null limit 1];
            painScreen.Due_Date_Time__c = NewDateTime(admitTime, 3);
            upsert painScreen;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Assessment_IR_Tools__c nutritionalScreen = [select Due_Date_time__c from Assessment_IR_Tools__c
                    where RecordTypeId = :mapOfAssessmentIRToolsRT.get('Nutritional Screen')
                                         AND Client_Chart__c = :client.id AND Due_Date_time__c != null limit 1];
            nutritionalScreen.Due_Date_Time__c = NewDateTime(admitTime, 3);
            upsert nutritionalScreen;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Clinical_Evaluation__c preAdmissionAssessment = [select Due_Date_time__c from Clinical_Evaluation__c
                    where RecordTypeId = :mapOfClinicalEvalRT.get('Pre Admission Assesment')
                                         AND Client_Chart__c = :client.id];
            preAdmissionAssessment.Due_Date_Time__c = NewDateTime(admitTime, 3);
            upsert preAdmissionAssessment;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Clinical_Evaluation__c faceToFaceEval = [select Due_Date_time__c from Clinical_Evaluation__c
                                                    where RecordTypeId = :mapOfClinicalEvalRT.get('Face to Face Evaluation')
                                                            AND Client_Chart__c = :client.id];
            faceToFaceEval.Due_Date_Time__c = NewDateTime(admitTime, 3);
            upsert faceToFaceEval;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Clinical_Evaluation_2__c bioPsychoSocialCE2 = [select id from Clinical_Evaluation_2__c
                    where RecordTypeId = :mapOfClinic2EvalRT.get('Bio-Psychosocial Assessment')
                                         AND Client_Chart__c = :client.id];
            Clinical_Evaluation_3__c bioPsychoSocial = [select Due_Date_time__c from Clinical_Evaluation_3__c
                    where Clinical_Evaluation_2__c = :bioPsychoSocialCE2.id];
            bioPsychoSocial.Due_Date_Time__c = NewDateTime(admitTime, 72);
            upsert bioPsychoSocial;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Clinical_Evaluation__c psychEval = [select Due_Date_time__c from Clinical_Evaluation__c
                                                where RecordTypeId = :mapOfClinicalEvalRT.get('Phsych Evaluation')
                                                        AND Client_Chart__c = :client.id];
            psychEval.Due_Date_time__c = NewDateTime(admitTime, 32);
            upsert psychEval;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Clinical_Evaluation_3__c historyEval = [select Due_Date_time__c from Clinical_Evaluation_3__c
                                                    where RecordTypeId = :mapOfClinic3EvalRT.get('History And Physical')
                                                            AND Client_Chart__c = :client.id];
            historyEval.due_Date_time__c = NewDateTime(admitTime, 32);
            upsert historyEval;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        try {
            Map<string, string> intakeFormsRT = new Map<string, string>(mapOfIntakeFormsRT);
            RecordType rt = [select id, name from RecordType where name = 'Admit Agreement'];
            intakeFormsRT.put(rt.name, rt.Id);
            List<Intake_Forms__c> intakeForms = [select Due_Date_time__c from Intake_Forms__c
                                                 where RecordTypeId IN :intakeFormsRT.values()
                                                 AND Client_Chart__c = :client.id];
            for (Intake_Forms__c form : intakeForms) form.Due_Date_Time__c = NewDateTime(admitTime, 3);
            if (intakeForms.size() > 0) upsert intakeForms;

        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
    }

    private static Datetime NewDateTime(Datetime dt, Integer diff) {
        return Datetime.newInstance(dt.year(), dt.month(), dt.day(), dt.Hour(), dt.Minute(), dt.Second()).addHours(diff);
    }


    public class BPDrugsInfo {
        public string Name {get; set;}
        public string Age {get; set;}
        public string LastUsed {get; set;}
        public string Frequency {get; set;}
        public string Amount {get; set;}
        public string Method {get; set;}
        public boolean IsMapped {get; set;}
    }

    public class BPDrugInfoResult {
        public Clinical_Evaluation_2__c CE2 {get; set;}
        public Clinical_Evaluation_3__c CE3 {get; set;}
    }

}