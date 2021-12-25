//Test Class : AssesmentDetailCtrlTest
public class AssesmentDetailCtrl {

    public string RecordType {
        get;
        set;
    }

    public Boolean IsEdit {
        get;
        set;
    }

    public string ID {

        get;
        set;
    }

    public Assessment_IR_Tools__c assessment {

        get;
        set;
    }
    
    public User UserObj {
        
        get;
        set;
    }
    
    //hidden field
    public string SelectedSignedOption {
        get;
        set;
    }
    public string ImageUrlAddress {
        get;
        set;
    }
    
      //AWS
    public string accessKeyId {
        get;
        set;
    }
    public string secretAccessKey {
        get;
        set;
    }
    public string OrgName {
        get;
        set;
    }
    
    public string BodyChartUrl{
        
        get;
        set;
    }
    
    final string AWSURL;
    
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('Assessments');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
        }
    
    public AssesmentDetailCtrl() {
        
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        ID irId = ApexPages.CurrentPage().getParameters().get('IR');
        
        UserObj = [Select Name ,title, User_Role__c from User where ID =: UserInfo.getUserID() limit 1];

        assessment = [Select RecordType.Name, Client_Chart__c,RecordType.DeveloperName,Where_is_the_pain__c,
            Behavorial_Contract_Comments__c, Date_Time__c, Name_s_of_Individuals_Involved__c,
            Name_Title_of_Person_Observing_Reporting__c, Incidents__c, Other_Incidents__c,
            Level_of_Severity__c, Medication_Errors__c, Investigation_of_Incident__c, Recommendations_and_Actions__c,
            Follow_Up__c, Client_Chart__r.Treatment_Center__c,Client_Chart__r.Treatment_Center__r.Name ,Client_Chart__r.Name,
            Action_s_taken__c, Other_Action_s_taken__c, What_you_had_to_eat_in_the_past_24_hours__c, Date__c,
            Weight_of_5_over_past_30_days__c,Personal_Risk_Reduction_CheckBox__c ,
            Is_there_any_history_of_an_eating_disord__c, Eats_fewer_than_2_meals_per_day__c,
            Eats_few_fruits_vegetables_or_milk_pro__c, Has_tooth_or_mouth_problems__c, Eats_alone_most_of_the_time__c,
            Complains_of_being_thirsty_all_the_time__c, Chronic_Diarrhea__c, Constipation__c, Nausea_Vomiting__c,
            Frequent_Reflux_Indigestion__c, Hx_Non_compliance_with_therapeutic_diet__c, Current_Eating_Disorder__c,
            Knowledge_Deficit__c, Appetite__c, Total_Score__c, Referral_to_Nutritionist_or_Physician__c,
            Referral_to_Nutritionist_Date__c, Current_Duration__c, Current_Effects_on_Daily_Life__c,
            Current_Pain_Level__c, Current_Treatment_Benificial__c, Current_Triggers__c, need_additional_treatment__c,
            Date_of_Reassessment__c, Describe_current_pain_quality__c, Has_the_quality_of_the_pain_changed__c,
            Pain_Goal__c, Pain_level_has__c, Referral__c,Referal_Needed__c ,
            If_Yes_pain_score_of__c, If_Yes_list_medications_and_treatments__c,
            How_long_have_you_had_the_pain__c, Does_it_ever_go_away_or_is_it_constant__c,
            If_Yes_what__c, What_do_you_usually_take_for_your_pain__c,
            Does_it_work__c, Date_Time_Place__c, Pain_Score__c,
            Past_Suicidal_Statement__c, Past_Suicidal_Ideation__c,
            Attempt_at_Harm_to_self_or_others__c, Significant_Loss_Grief__c, Family_Support_Systems__c,
            Lethality_of_Attempts_to_self_or_others__c, npatient_treatment_due_to_suicide_attemp__c,
            History_of_Family_or_Friend_Suicide__c, Alternation_in_Thought_Process__c,
            Explanation__c, Explanation2__c, OVERALL_RISK_FOR_CURRENT_INTERNAL_STRESS__c,
            OVERALL_RISK_FOR_CURRENT_INTERNAL_STRES2__c, PROTECTIVE_FACTORS__c,
            OVERALL_RISK_OF_CURRENT_MEANS__c, CURRENT_INTERNAL_STRESSORS__c,
            Chronic_Medical_Condition__c, Crisis_or_Traumatic_Event__c, Administrator_Time__c,
            Current_Suicidal_Ideation__c, Access_to_lethal_means__c, Access_to_guns__c,
            Check_all_that_apply__c, PERSONAL_RISK_REDUCTION_FACTORS__c, factors_reduce_the_client_s_risk__c,
            Which_factors_Why__c, When__c, Does_patient_require_re_assessment__c, OVERALL_ESTIMATION__c,
            OVERALL_ESTIMATION_Picklist__c, OVERALL_ASSESSMENT_OF_SUICIDAL_RISK__c, RECOMMENDATIONS__c,
            NOTIFICATIONS__c, Physician_Name__c, Administrator_Name__c, Clinical_Director_Name__c, Other_Name__c,
            Administrator_Date__c, Physician_Date__c, Clinical_Director_Date__c, Other_Date__c,
            Physician_Time__c, Clinical_Director_Time__c, Other_Time__c,
            Staff_Involved__c, Medication_Error__c, Other_Incident__c,
            Describe_the_event_in_detail__c, Reported_to_Physician_Date_Time__c,
            Describe_Adverse_Reaction__c, Corrective_Action_Taken__c, Reported_to_Supervisor_Date_Time__c, SignedBy__c, Status__c,
            Staff_Image_URL__c,Staff_Signed_User__c,Staff_Closed_Date__c, Client_Image_Url__c, Client_Signed_User__c, Client_Closed_Date__c,
            Intern_Signature_URL__c,Intern_Signed_User__c, Intern_Closed_Date__c,Incident_Reports__c,IsThereAnyHistoryCheckBox__c,
            receiving_any_treatment_for_your_pain__c,Any_significant_reoccurring__c,any_medications__c,Do_you_currently_have_any_physical_pain__c,
            Explanation_Of_the_Above_2__c,Is_Explanation_Of_the_Above__c,Ask_Client_To_Describe_The_Pain__c, Adverse_Reaction__c
            from Assessment_IR_Tools__c where ID =: irId limit 1
        ];
        
        
        RecordType = assessment.RecordType.Name;
        ID = assessment.Client_Chart__c;
        IsEdit = (ApexPages.CurrentPage().getParameters().get('edit') != null) ? true : false;

    }

    public List < SelectOption > getscore() {
        List < SelectOption > options = new List < SelectOption > ();

        Schema.DescribeFieldResult fieldResult = Assessment_IR_Tools__c.Pain_Score__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry p: ple) {
            options.add(new SelectOption(p.getLabel(), p.getValue()));
        }
        return options;
    }

    public void calcScore() {
        integer total = 0;
        total += extractNumber(assessment.Eats_fewer_than_2_meals_per_day__c);
        total += extractNumber(assessment.Eats_few_fruits_vegetables_or_milk_pro__c);
        total += extractNumber(assessment.Has_tooth_or_mouth_problems__c);
        total += extractNumber(assessment.Eats_alone_most_of_the_time__c);
        total += extractNumber(assessment.Complains_of_being_thirsty_all_the_time__c);
        total += extractNumber(assessment.Chronic_Diarrhea__c);
        total += extractNumber(assessment.Constipation__c);
        total += extractNumber(assessment.Nausea_Vomiting__c);
        total += extractNumber(assessment.Frequent_Reflux_Indigestion__c);
        total += extractNumber(assessment.Hx_Non_compliance_with_therapeutic_diet__c);
        total += extractNumber(assessment.Current_Eating_Disorder__c);
        total += extractNumber(assessment.Knowledge_Deficit__c);
        total += extractNumber(assessment.Appetite__c);
        assessment.Total_Score__c = total;


    }

    private integer extractNumber(string text) {
        if (text != null) {
            //list<string> lstExtracted = text.split('(');
            //system.debug(lstExtracted);
            //return integer.valueof(lstExtracted[1].replace(')',''));
            text = text.replace('(', '');
            text = text.replace(')', '');
            return integer.valueof(text.substring(text.length() - 1));
        }
        return 0;
    }
    
    public PageReference CloseAssesmentForm(){
        
        //update AssementForm with the user signature    
         if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == NULL) {

                assessment.Staff_Image_URL__c = AWSURL + ImageUrlAddress;
                assessment.Staff_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
                assessment.Staff_Closed_Date__c = DateTime.Now();
                assessment.SignedBy__c = 'Staff';
            } else if (SelectedSignedOption == 'Patient') {

                assessment.Client_Image_Url__c = AWSURL + ImageUrlAddress;
                assessment.Client_Signed_User__c = '(Patient) ' + assessment.Client_Chart__r.Name;
                assessment.Client_Closed_Date__c = DateTime.Now();
                assessment.SignedBy__c = 'Client';
            } else if (userObj.User_Role__c != NULL) {

                assessment.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
                assessment.Intern_Signed_User__c = 'Intern present: ' + userObj.Name + ',' + userObj.Title;
                assessment.Intern_Closed_Date__c = DateTime.Now();
                assessment.SignedBy__c = 'Client';
                assessment.Status__c = 'Review Pending';
            }
            
            if((RecordType == 'Nutritional Screen' || RecordType == 'Medication Incident Report' || RecordType == 'Suicide Risk Assessment' || RecordType == 'Pain Screen' || RecordType == 'Pain Reassessment') && (assessment.Staff_Signed_User__c != null || String.isNotBlank(assessment.Staff_Signed_User__c ))){
                
                assessment.Status__c = 'Complete';
                assessment.SignedBy__c = 'All'; // signing is complete
            }
            else if ((assessment.Staff_Signed_User__c != null || String.isNotBlank(assessment.Staff_Signed_User__c )) && (assessment.Client_Signed_User__c != null || String.isNotBlank(assessment.Client_Signed_User__c ))) {
                assessment.Status__c = 'Complete';
                assessment.SignedBy__c = 'All'; // signing is complete
              

            }
            
        
        update assessment;
        return null;
    }
    
    public void changeStatus(){
        
        if(assessment.Status__c == 'Open'){
             assessment.Status__c = 'In progress';
             assessment.SignedBy__c = 'None';
             
              if(RecordType == 'Nutritional Screen' || RecordType == 'Medication Incident Report' || RecordType == 'Suicide Risk Assessment' || RecordType == 'Pain Screen' || RecordType == 'Pain Reassessment')
                     assessment.SignedBy__c = 'Client';
                 
             update assessment;
         }
    }

    public pageReference submit() {
       
       string rtype = ApexPages.CurrentPage().getParameters().get('rt')!=null?ApexPages.CurrentPage().getParameters().get('rt'):'';
        
            //Using this field to save Body Chart Image.
        assessment.Where_is_the_pain__c = AWSURL + BodyChartUrl;
      
        upsert assessment;
         PageReference pr = new PageReference('/apex/AssesmentDetailPage');
         pr.getParameters().put('ID',ID);
         pr.getParameters().put('IR',assessment.ID);
         pr.getParameters().put('rt',rtype);
         pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
         return pr;
    }  

}