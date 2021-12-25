/*
    controller class for UtilizationReviewHomeComponent    
    @author: Huma Zafar
    Test Class : UtilizationReviewHomeControllerTest2
*/
public with sharing class UtilizationReviewHomeController {
    
    Id ContRecordTypeId;
    ID ConcurrentReviewRecordTypeId;


    public boolean displayMainPage{get;set;}
    
    public list<Utilization_Review__c> lstReviews {get;set;}
    
    public list<RecordType> lstRecordTypes{get;set;}
    
    public boolean displayCareManager{get;set;}
    public boolean displayReview{get;set;}
    public boolean displayUR{get;set;}
    public string rtype {get; set;}
    
    public boolean displayPopUp{get;set;}
    
    id ccId;
    public client_chart__c ccRecord {
        get;
        set;
    }
    public Insurance_Information__c insuranceInformation{
      get;
      set;
     }
 
   public Insurance_Verification__c insuranceVerification{
     get;
     set;
     }
   
   Public Opportunity oppInfo{
     get;
     set;
   }
   public Boolean IsCareManager {
       get;
       set;
     }
   public String test {
       get;
       set;
     }
    public contact CaremanagerIns {
        get;
        set;
     }
     
    public boolean IsEdit {
        get;
        set;
     }
     
     public string conId {
         get;
         set;
     }
     
     public Utilization_Review__c ConcurrentreviewIns{
         get;
         set;
     }
     
     public List < contact > ConCareManagers {
         set;
         private get;
     }
     
    public boolean isEditReview{
        get;
        set;
     }
     
     public List<Utilization_Review__c> AuthorizationLst{
         set;
         private get;
     }
     
     public string EvId{
         get;
         set;
     }

 
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('UtilizationReview');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
  
    
    public UtilizationReviewHomeController(){
        
        displayMainPage = true;
        
        ccId = ApexPages.CurrentPage().getParameters().get('id');
        
        loadReviews();
        
        displayPopUp = false;
        displayCareManager = false;
        displayReview = false;
        displayUR = false;
        
        rtype = apexPages.currentPage().getParameters().get('rt')!=null ? apexPages.currentPage().getParameters().get('rt'):'';
        ContRecordTypeId = Constants.InsuranceCaseManagerRecordTypeId;
        ConcurrentReviewRecordTypeId = Constants.ConcurrentReviewRecordTypeId;
        ConcurrentreviewIns = new Utilization_Review__c();
        ConcurrentreviewIns.recordtypeid = ConcurrentReviewRecordTypeId ;
        CaremanagerIns = new contact();

        ccRecord = [Select id, Name, Special_Diet__c, Age__c, Discharge_Date_Time__c, Primary_Counsellor__c, Building__c, Primary_Therapist__c, Primary_Therapist__r.name, Client_Image_URL2__c,
   Contact__c, Gender__c, Occupation__c, Client_Status__c, Payment__c, Employer_Name__c, Employer_Phone__c, Race__c, Ethnicity__c,
   UR_Representation__c, UR_Representation__r.name, Marital_Status_2__c, Dob__c, Phone__c, Email__c, Address__c, Room__c, Referrer__r.name,
   Client_Information_Validated__c, Track_Post_Detox__c, Opportunity__c,Case_Manager__r.name, U_R_Location__c, Program__c, Bed__c, 
   Client_ID_URL2__c from Client_Chart__c where id = : ccId LIMIT 1
  ];
  
    insuranceInformation = new Insurance_Information__c();
  
    List <Insurance_Information__c> lstInsurInf = [SELECT Id, Name, Opportunity__c, Address_2__c, Address__c, City__c, Country__c, 
                          Employer__c, Group_Number__c, Insurance_Policy__c, Insurance_Provider_Phone_Number__c, 
                          Insurance_Providers__c, Insurance_Status__c, Related_Opportunity_VOB_Status__c, SSN_Last_4__c, 
                          State__c, Subscriber_DOB__c, Subscriber_Name__c, VOB_Request__c, Zip_Code__c, Insurance_Provider__c FROM Insurance_Information__c
                          where Insurance_Status__c='Primary' and Opportunity__c=:ccRecord.Opportunity__c limit 1];
    if(!lstInsurInf.isEmpty()){  
        insuranceInformation = lstInsurInf.get(0);
    }  
  
    for(Opportunity o : [select id, Latest_VOB_Request__c, Latest_VOB_Request__r.VOB_Request_Status__c, Name, Owner.MobilePhone, Owner.name, insurance_provider__c, client_dob__c
                         from opportunity where id=:ccRecord.Opportunity__c limit 1]) { 
        oppInfo = o;
    }
    
    insuranceVerification = new Insurance_Verification__c();
    
    List < Insurance_Verification__c > lstInsurVerif =[SELECT Id, Opportunity__c, Additional_Notes__c, Assignment_of_Benefits_Accepted__c, 
                          COB_on_File__c, Calendar_Plan_Year__c, Carve_Out_Phone_Number__c, Carve_Out_Policy_Number__c, 
                          Carve_Out_for_Behavioral_Health__c, Cobra__c, Covered__c, Detox_Benefits_Covered__c, Detox_Benefits_Days_Used__c,
                          Detox_Benefits_Lifetime_Maximum_Used__c, Detox_Benefits_Lifetime_Maximum__c, Detox_Benefits_Max_Days_Per_Year__c, 
                          Detox_Benefits_Max_Per_Day__c, Effective_Date__c, Free_Standing_Facility__c, HC_Acupuncture_Coverage__c, 
                          HC_Acupuncture_Max_Days_Per_Year__c, HC_Acupuncture_Max_Per_Day__c, HC_Massage_Coverage__c, HC_Massage_Max_Days_Per_Year__c, 
                          HC_Massage_Max_Per_Day__c, Holistic_Coverage_Acupunture__c, Holistic_Coverage_Massage__c, IOP_Covered__c, IOP_Days_Used__c, 
                          IOP_Lifetime_Maximum_Used__c, IOP_Lifetime_Maximum__c, IOP_Max_Days_Per_Year__c, IOP_Max_Per_Day__c, Insurance_Notes__c, 
                          Insurance_Rep_1__c, Insurance_Rep_2__c, Insurance_Rep_3__c, JCAHO_CARF_Req_Levels__c, Medical_Benefits_DED_Apply_to_OOP__c, 
                          Medical_Benefits_DED__c, Medical_Benefits_DED_met__c, Medical_Benefits_Individual_or_Family__c, Medical_Benefits_Lifetime_Maximum_Used__c,
                          Medical_Benefits_Lifetime_Maximum__c, Medical_Benefits_OOP__c, Medical_Benefits_OOP_met__c, Medical_Claims_5_digit_Payer_ID__c, 
                          Medical_Claims_City__c, Medical_Claims_Phone__c, Medical_Claims_State__c, Medical_Claims_Street_Address_1__c, Medical_Claims_Street_Address_2__c,
                          Medical_Claims_Zip_Code__c, Medical_Substance_Deductibles_Combined__c, Month_to_Month__c, OP_Covered__c, OP_Days_Used__c, 
                          OP_Lifetime_Maximum_Used__c, OP_Lifetime_Maximum__c, OP_Max_Days_Per_Year__c, OP_Max_Per_Day__c, Out_of_State_Restrictions__c, 
                          Part_Hospital_Covered__c, Part_Hospital_Days_Used__c, Part_Hospital_Lifetime_Maximum_Used__c, Part_Hospital_Lifetime_Maximum__c, 
                          Part_Hospital_Max_Days_Per_Year__c, Part_Hospital_Max_Per_Day__c, Payment_to_Facility_or_Subscriber__c, Pharmacy_Benefits_RX_BIN__c, 
                          Pharmacy_Benefits_RX_Group__c, Pharmacy_Benefits_RX_ID__c, Pharmacy_Benefits_RX_PCN__c, Pharmacy_Phone__c, Pharmacy_Vendor__c, Policy_Exclusions__c,
                          Pre_Existing_Terms__c, Precert_Company__c, Precert_Penalty_Terms__c, Precert_Phone_Number__c, Precertification_Company_Name__c, 
                          Precertification_Company_Phone__c, Precertification_Required_Detox__c, Precertification_Required_IOP__c, Precertification_Required_OP__c,
                          Precertification_Required_Part_Hospital__c, Precertification_Required_Residential__c, Rate_Type__c, Reference_Number_1__c, Reference_Number_2__c,
                          Reference_Number_3__c, Related_Insurance_Information__c, Residential_Benefits_Covered__c, Residential_Benefits_Days_Used__c, 
                          Residential_Benefits_Lifetime_Maximum__c, Residential_Benefits_Max_Days_Per_Year__c, Residential_Benefits_Max_Per_Day__c, 
                          Residential_Lifetime_Maximum_Used__c, State_Lic_Accepted__c, Subscriber_s_Employer__c, Substance_Abuse_Copay_Admit_Fee__c, 
                          Substance_Abuse_DED_Apply_to_OOP__c, Substance_Abuse_DED__c, Substance_Abuse_DED_met__c, Substance_Abuse_Individual_or_Family__c, 
                          Substance_Abuse_OOP__c, Substance_Abuse_OOP_met__c, Substance_Claims_5_digit_Payer_ID__c, Substance_Claims_City__c, Substance_Claims_Phone__c, 
                          Substance_Claims_State__c, Substance_Claims_Street_Address_1__c, Substance_Claims_Street_Address_2__c, Substance_Claims_Zip_Code__c, 
                          Termination_Date__c, VOB_Rep_1__c, VOB_Rep_2__c, VOB_Rep_3__c, VOB_Request__c, Will_Plan_Terminate_when_Client_Turns_26__c FROM Insurance_Verification__c
                          where Opportunity__c=:ccRecord.Opportunity__c limit 1];
        if (!lstInsurVerif.isEmpty()) {
            insuranceVerification = lstInsurVerif.get(0);
        }
    
  
    }   
    
    public PageReference addUtilizationReview(){
        
        Utilization_Review__c ut = new Utilization_Review__c();
        ut.RecordTypeId = Schema.SObjectType.Utilization_Review__c.getRecordTypeInfosByName().get('Utilization Review').getRecordTypeId();
        ut.status__c = 'Open';
        ut.Client_Chart__c = ccId;
        try{
            User u = [select id, name, city, state, street,PostalCode from User where Name =: label.PhysicianName];
            if(u!=null){
                ut.Physician__c= u.id;
                ut.Physician_Address_Street__c = u.Street;
                ut.Physician_City__c = u.City;
                ut.Physician_State__c = u.State;
                ut.Physician_Zip_Code__c = u.PostalCode ;
            }
        }
        catch(QueryException e){
        }
        insert ut;
        
            
        PageReference pr = new PageReference('/apex/utlization_review');
        pr.getParameters().put('id', ccId);
        pr.getParameters().put('UtilId', ut.ID);
        pr.getParameters().put('rt',rtype);
        pr.getParameters().put('readOnly','false');
        pr.setRedirect(true);
        return pr;
    }
    
    public void closePopup() {
        displayPopup = false;
    }
    
    public void showPopup() {
        CareManagerIns = new contact();
        ConcurrentreviewIns = new Utilization_Review__c();
        ConcurrentreviewIns.recordtypeid = ConcurrentReviewRecordTypeId;
        
        displayPopup = true;
        
     }
     
    public void SaveCareManager() {
        CaremanagerIns.recordtypeid = ContRecordTypeId;
        CaremanagerIns.Client_Chart__c = ccId;
     
        insert CareManagerIns;
        
        displayPopup = false;
        CareManagerIns = new contact();
        IsEdit = false;
        IsCareManager = false;
        
    }
    
    public void ChangeStatusToComplete(){
        
        Utilization_Review__c cr = new Utilization_Review__c();
        cr.ID = EvID;
        cr.Status__c = 'Complete';
        update cr;
        
    }
    
    public list < contact > getConCareManagers() {
        ConCareManagers = [select name, phone,Status__c,  Insurance_Company__r.name, Comments__c from contact where Client_Chart__c = : ccId and recordtypeid = : ContRecordTypeId];
        return ConCareManagers;
     }

    public void EditCareManger() {
        CareManagerIns = [select FIRSTname, Status__c ,lastname, phone, Insurance_Company__r.name, Comments__c from contact where Client_Chart__c = : ccId and recordtypeid = : ContRecordTypeId and id = : conID];
        IsEdit = true;
        displayPopup = true;
    }
 
    public void UpdateCareManager() {
        update CareManagerIns;
        displayPopup = false;
        IsEdit = false;
        IsCareManager = false;
        CareManagerIns = new contact();
    }
    
    public void deleteCareManger() {
        Database.delete(ConId);
    }
    
    public PageReference SaveAuthorization() {
        list<Utilization_Review__c> authCurrentLst = new list<Utilization_Review__c>();
        list<Utilization_Review__c> authupdateLst  = new list<Utilization_Review__c>();

        
         //adding unchek lst review requirement
        if(ConcurrentreviewIns.Last_Coverage_Date__c){
            authCurrentLst= getAuthorizationLst();
            for (Utilization_Review__c cr: authCurrentLst){
                if(cr.Last_Coverage_Date__c){
                    cr.Last_Coverage_Date__c=false;
                    authupdateLst.add(cr);
                }
            }
            
         }
         ConcurrentreviewIns.Client_Chart__c = ccId;
         ConcurrentreviewIns.status__c  ='Review Pending';
         insert ConcurrentreviewIns;
        
         if(authupdateLst.size()>0){
             update authupdateLst;
         }
        
         PageReference pr = new PageReference('/apex/UtilizationReviewHomePage');
         pr.getParameters().put('ID', ccId);
         pr.getParameters().put('rt',rtype);
         pr.setRedirect(true);
         return pr;
    }

    public list <Utilization_Review__c> getAuthorizationLst() {
        AuthorizationLst= [select id, Authorization_date__c, Number_of_days__c, Status__c, Frequency__c, Level_of_care__c,
                           Start_date__c, End_date__c, Last_coverage_date__c, Authorization_number__c, Next_review_date__c, 
                           Comments__c, Next_Care_Level__c, Next_Care_Level_Date__c, Insurance_Company__c, Insurance_Company__r.name
                           from Utilization_Review__c where Client_Chart__c = : ccId and recordtypeid = : ConcurrentReviewRecordTypeId ORDER BY Start_date__c];
        return AuthorizationLst;
        
    }
 
    public void EditAuthorization() {
        ConcurrentreviewIns= [select id, Authorization_date__c, Number_of_days__c, Status__c, Frequency__c, Level_of_care__c,
                              Start_date__c, End_date__c, Last_coverage_date__c, Authorization_number__c, Next_review_date__c, 
                              Comments__c, Next_Care_Level__c, Next_Care_Level_Date__c, Insurance_Company__c, Insurance_Company__r.name
                              from Utilization_Review__c where Client_Chart__c = : ccId and recordtypeid = : ConcurrentReviewRecordTypeId and id = :EvID];
      isEditReview= true;
      displayPopup = true;
      evId='';
    }

    public PageReference UpdateAuthorization() {
        list<Utilization_Review__c> authCurrentLst = new list<Utilization_Review__c>();
        list<Utilization_Review__c> authupdateLst  = new list<Utilization_Review__c>();

        
         //adding unchek lst review requirement
        if(ConcurrentreviewIns.Last_Coverage_Date__c){
            authCurrentLst= getAuthorizationLst();
            for (Utilization_Review__c cr: authCurrentLst){
                if(cr.Last_Coverage_Date__c){
                    cr.Last_Coverage_Date__c=false;
                    authupdateLst.add(cr);
                }
            }
            
         }
    
        update ConcurrentreviewIns;
        if(authupdateLst.size()>0){
            update authupdateLst;
        }
        
        ConcurrentreviewIns= new Utilization_Review__c();
        
        PageReference pr = new PageReference('/apex/UtilizationReviewHomePage');
        pr.getParameters().put('ID', ccId);
        pr.getParameters().put('rt',rtype);
        pr.setRedirect(true);
        return pr;
    }
    
    public void deleteAuthorization() {
        Database.delete(EvID);
    }

   
    private void loadReviews(){
        lstReviews = new list<Utilization_Review__c>();
        lstReviews = [select id, RecordType.Name, Status__c,Client_Chart__c,Staff_Closed_Date__c,Staff_Signed_User__c, Intern_Signed_User__c  from Utilization_Review__c 
        where Client_Chart__c =:ccId AND RecordTypeId =: Constants.UtilizationReviewRecordTypeId];
    }
    
    public void OpenNewForm(){
        string parameter = system.CurrentPageReference().getParameters().get('param');
        if(parameter == 'Care Manager Concurrent Review'){
            displayMainPage = false;
            displayCareManager = true;
            displayReview = false;
            displayUR = false;
        }
        else if(parameter == 'Concurrent Review'){
            displayMainPage = false;
            displayCareManager = false;
            displayReview = true;
            displayUR = false;
        }
        else if(parameter == 'Utilization Review'){
            displayMainPage = false;
            displayCareManager = false;
            displayReview = false;
            displayUR = true;
        }
    }
    
    public void back(){
        displayMainPage = true;
        
        displayPopUp = false;
        
        displayCareManager = false;
        displayReview = false;
        displayUR = false;
        
        loadReviews();
    }
    
    public void showForms(){
        displayPopUp = true;
        lstRecordTypes = [SELECT Id,Name FROM RecordType WHERE SobjectType='Utilization_Review__c'];
    }
}