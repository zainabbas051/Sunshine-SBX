/*
    Purpose: controller class for lead verification page, saves input data to lead verification object
*/
public with sharing class ctlLeadVerification {
    
    //current Lead record
    public Lead currentLead{get;set;}
    
    //current oppty record
    public Opportunity currentOppty{get;set;}
    
    //lead verification record
    public Lead_Verification__c leadVerification{get;set;}
    
    public Boolean readOnly{get;set;}    
    
    //record id from page parameter
    private string RecordId;
    
    private string LeadId;
    private string OpptyId;
    
    public Boolean isLead{get;set;}
    
    //constructor
    public ctlLeadVerification(){
        
         //get obj id of Lead to see if task was created against Lead
        Schema.DescribeSObjectResult Lead_DSR = Lead.SObjectType.getDescribe();
        LeadId = Lead_DSR.getKeyPrefix();
        
        //get obj id of Opportunity to see if task was created against Opportunity
        Schema.DescribeSObjectResult Oppty_DSR = Opportunity.SObjectType.getDescribe();
        OpptyId = Oppty_DSR.getKeyPrefix();
        
        //get id from page parameter
        RecordId = ApexPages.currentPage().getParameters().get('id');
        
        currentLead  = new Lead();
        currentOppty = new Opportunity();
        
        if(RecordId.startswith(LeadId)){
            
            isLead = true;
            
            currentLead = [select id,FirstName,LastName,Patient_DOB__c,SSN_Last_4__c,Subscriber_Name__c,Subscriber_DOB_Text__c,
                Insurance_Providors__c, Insurance_Provider_Phone_Number__c,Insurance_Policy__c,Group_Number__c 
                from Lead where id=: RecordId ];
        }
        else if(RecordId.startswith(OpptyId)){
            
            isLead = false;
            
            currentOppty = [select id, Name, Client_DOB__c, SSN_Last_4__c, Subscriber_Name__c, Subscriber_DOBtext__c,
            Insurance_Providers__c, Insurance_Provider_Phone_Number__c, Insurance_Policy__c, Group_Number__c
             from Opportunity where id=: RecordId ];
        }
        try{
            leadVerification = [Select Zip__c, X5_digit_Payer_ID__c, UA_Residential__c, UA_Residential_Percent__c,
             UA_Residential_Lifetime_Limits__c, UA_Residential_Lifetime_Limits_Used__c, UA_Residential_Days_Yr__c,
             UA_Residential_Days_Used__c, UA_Residential_Amount__c, UA_OOP_met__c, UA_OOP__c, UA_Detox__c, UA_Detox_Percent__c,
             UA_Detox_Lifetime_Limits__c, UA_Detox_Lifetime_Limits_Used__c, UA_Detox_Days_Yr__c, UA_Detox_Days_Used__c,
             UA_Detox_Amount__c, UA_DED_met__c, UA_DED__c, Substance_Abuse_Residential_percent__c, Substance_Abuse_Residential__c,
             Substance_Abuse_Residential_Days_Yr__c, Substance_Abuse_Residential_Days_Used__c,
             Substance_Abuse_Residential_Amount__c, Substance_Abuse_OOP_met__c, Substance_Abuse_OOP__c, 
             Substance_Abuse_Detox_percent__c, Substance_Abuse_Detox__c, Mental_Health_DED_met__c, 
             Substance_Abuse_Detox_Lifetime_Limits__c, Substance_Abuse_Detox_Days_Yr__c, Substance_Abuse_Detox_Days_Used__c,
             Substance_Abuse_Detox_Amount__c, Substance_Abuse_DED_met__c, Substance_Abuse_DED__c, Subscriber_s_SSN__c,
             Subscriber_s_Employer__c, Subs_Abuse_Residential_Lifetime_Limits__c, Subs_Abuse_Detox_Lifetime_Limits_Used__c,
             Subs_Ab_Residential_Lifetime_Limits_Used__c, Street_Address_2__c, Street_Address_1__c, State__c, Rx__c,
             Relationship__c, Rate_Type__c, RX_Phone__c, Precertification_Company__c, Precert_Penalty__c, Precert_Penalty_Terms__c,
             Pre_Existing__c, Pre_Existing_Terms__c, Plan_Year__c, Plan_Type__c, Phone__c, Pharmacy_Benefit__c, Name,
             Mental_Health_Residential__c, Mental_Health_Residential_Percent__c, Mental_Health_Residential_Days_Yr__c,
             Mental_Health_Residential_Days_Used__c, Mental_Health_Residential_Amount__c, Mental_Health_Res_Lifetime_Limits__c,
             Mental_Health_Res_Lifetime_Limits_Used__c, Mental_Health_OOP_met__c, Mental_Health_OOP__c, Mental_Health_Detox__c,
             Mental_Health_Detox_Percent__c, Mental_Health_Detox_Lifetime_Limits__c, Mental_Health_Detox_Lifetime_Limits_Used__c,
             Mental_Health_Detox_Days_Yr__c, Mental_Health_Detox_Days_Used__c, Mental_Health_Detox_Amount__c, 
             Mental_Health_DED__c, Medical_Residential__c, Medical_Residential_Percent__c, Medical_Residential_Lifetime_Limits__c,
             Medical_Residential_Lifetime_Limits_Used__c, Medical_Residential_Days_Yr__c, Medical_Residential_Days_Used__c,
             Medical_Residential_Amount__c, Medical_OOP_met__c, Medical_OOP__c, Medical_Detox__c, Medical_Detox_Percent__c,
             Medical_Detox_Lifetime_Limits__c, Medical_Detox_Lifetime_Limits_Used__c, Medical_Detox_Days_Yr__c,
             Medical_Detox_Days_Used__c, Medical_Detox_Amount__c, Medical_DED_met__c, Medical_DED__c, License_Requirement__c, Lead__c,
             Initial_Date_Time__c, Initial_Coordinator__c, Id, Free_Standing_Facility__c, Effective__c, Confirmation__c, Comments__c,
             City__c, COBRA__c, Bill_To_Name__c, Alcohol_Substance_Combined__c, Active__c
             From Lead_Verification__c where Lead__c =: RecordId  Or Opportunity__c =: RecordId ];
                          
             readOnly = true;
        }
        catch(QueryException e){
            leadVerification = new Lead_Verification__c();
            readOnly = false;
        }
    }
            
    //method for inserting/updating lead verification record
    public PageReference saveLeadVerification(){
        try{
            if(leadVerification.id!=null){
                update leadVerification;
            }
            else{
                if(isLead){
                    leadVerification.Lead__c = currentLead.Id;
                }
                else{
                    leadVerification.Opportunity__c = OpptyId ;
                }                
                insert leadVerification;
            }
        }
        catch(DmlException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }        
        return new PageReference('/'+RecordId);
    }
    
    public pageReference EditPage(){
        readOnly = false;
        return null;
    }
    
    public PageReference cancel(){
        return new PageReference('/'+RecordId);
    }
    
}