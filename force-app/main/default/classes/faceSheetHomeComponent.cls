//Test Class : faceSheetHomeComponentTest
public class faceSheetHomeComponent {

    public client_chart__c ccRecord {
        get;
        set;
    }

    public Insurance_Information__c insuranceInformation {
        get;
        set;
    }

    public Insurance_Verification__c insuranceVerification {
        get;
        set;
    }

    Public Opportunity oppInfo {
        get;
        set;
    }

    public string ccRecordId;
    public boolean editView {
        get;
        set;
    }
    public boolean editInsuranceView {
        get;
        set;
    }
    public Id currentPicture {
        get;
        set;
    }
    Private Static FINAL String fixedFileName = 'profilePhoto.jpg';
    public boolean displayPopup {
        get;
        set;
    }

    Public Contact ContIns {
        get;
        set;
    }
    ID ClientContRecordTypeID;
    public List < contact > ContactLst {
        set;
        private get;
    }

    public List < Allergies__c > AllergiesLst {
        set;
        Private get;
    }

    //CONSTANT
    final string AUTH_REC = 'Authorization for Release of Confidential Information';

    public string ContClientID {
        get;
        set;
    }
    public contact conIns {
        get;
        set;
    }

    public boolean IsEditContact {
        get;
        set;
    }

    public void closePopup() {
        displayPopup = false;
    }

    public void showPopup() {
        displayPopup = true;
        ContIns =  new Contact();
        IsEditContact =false;
    }
    
    
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
    
    public final string AWSURL{
        
        get;
        set;
    }
    
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('FaceSheet');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    

    public faceSheetHomeComponent() {
        
        
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        ClientContRecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Client Chart Contact').getRecordTypeId();

        ContIns = new contact();

        editView = False;
        editInsuranceView = false;
        ccRecordId = apexPages.currentPage().getParameters().get('id');
        
        GetClientChart();
    
        List < Insurance_Information__c > lstInsurInf = [SELECT Id, Name, Opportunity__c, Address_2__c, Address__c, City__c, Country__c, Employer__c, Group_Number__c, Insurance_Policy__c, 
        Insurance_Provider_Phone_Number__c, Insurance_Providers__c, Insurance_Status__c, Related_Opportunity_VOB_Status__c, SSN_Last_4__c, State__c, Subscriber_DOB__c, Subscriber_Name__c, 
        VOB_Request__c, Zip_Code__c, Insurance_Provider__c FROM Insurance_Information__c
        where Insurance_Status__c = 'Primary'
        and Opportunity__c = :ccRecord.Opportunity__c limit 1];
        if (lstInsurInf.size() > 0) {
            insuranceInformation = lstInsurInf.get(0);
        }

        oppInfo = [select id, Latest_VOB_Request__c, Latest_VOB_Request__r.VOB_Request_Status__c, Name, Owner.MobilePhone, Owner.name, insurance_provider__c, client_dob__c
        from opportunity where id = :ccRecord.Opportunity__c limit 1];

        List < Insurance_Verification__c > lstInsurVerif = [SELECT Id, Opportunity__c, Additional_Notes__c, Assignment_of_Benefits_Accepted__c, COB_on_File__c, Calendar_Plan_Year__c,
                Carve_Out_Phone_Number__c, Carve_Out_Policy_Number__c, Carve_Out_for_Behavioral_Health__c, Cobra__c, Covered__c, Detox_Benefits_Covered__c, Detox_Benefits_Days_Used__c, 
                Detox_Benefits_Lifetime_Maximum_Used__c, Detox_Benefits_Lifetime_Maximum__c, Detox_Benefits_Max_Days_Per_Year__c, Detox_Benefits_Max_Per_Day__c, Effective_Date__c, 
                Free_Standing_Facility__c, HC_Acupuncture_Coverage__c, HC_Acupuncture_Max_Days_Per_Year__c, HC_Acupuncture_Max_Per_Day__c, HC_Massage_Coverage__c, HC_Massage_Max_Days_Per_Year__c, 
                HC_Massage_Max_Per_Day__c, Holistic_Coverage_Acupunture__c, Holistic_Coverage_Massage__c, IOP_Covered__c, IOP_Days_Used__c, IOP_Lifetime_Maximum_Used__c, IOP_Lifetime_Maximum__c, 
                IOP_Max_Days_Per_Year__c, IOP_Max_Per_Day__c, Insurance_Notes__c, Insurance_Rep_1__c, Insurance_Rep_2__c, Insurance_Rep_3__c, JCAHO_CARF_Req_Levels__c, Medical_Benefits_DED_Apply_to_OOP__c,
                Medical_Benefits_DED__c, Medical_Benefits_DED_met__c, Medical_Benefits_Individual_or_Family__c, Medical_Benefits_Lifetime_Maximum_Used__c, Medical_Benefits_Lifetime_Maximum__c, Medical_Benefits_OOP__c,
                Medical_Benefits_OOP_met__c, Medical_Claims_5_digit_Payer_ID__c, Medical_Claims_City__c, Medical_Claims_Phone__c, Medical_Claims_State__c, Medical_Claims_Street_Address_1__c, 
                Medical_Claims_Street_Address_2__c, Medical_Claims_Zip_Code__c, Medical_Substance_Deductibles_Combined__c, Month_to_Month__c, OP_Covered__c, OP_Days_Used__c, OP_Lifetime_Maximum_Used__c, 
                OP_Lifetime_Maximum__c, OP_Max_Days_Per_Year__c, OP_Max_Per_Day__c, Out_of_State_Restrictions__c, Part_Hospital_Covered__c, Part_Hospital_Days_Used__c, Part_Hospital_Lifetime_Maximum_Used__c,
                Part_Hospital_Lifetime_Maximum__c, Part_Hospital_Max_Days_Per_Year__c, Part_Hospital_Max_Per_Day__c, Payment_to_Facility_or_Subscriber__c, Pharmacy_Benefits_RX_BIN__c, Pharmacy_Benefits_RX_Group__c, 
                Pharmacy_Benefits_RX_ID__c, Pharmacy_Benefits_RX_PCN__c, Pharmacy_Phone__c, Pharmacy_Vendor__c, Policy_Exclusions__c, Pre_Existing_Terms__c, Precert_Company__c, Precert_Penalty_Terms__c, 
                Precert_Phone_Number__c, Precertification_Company_Name__c, Precertification_Company_Phone__c, Precertification_Required_Detox__c, Precertification_Required_IOP__c, Precertification_Required_OP__c,
                Precertification_Required_Part_Hospital__c, Precertification_Required_Residential__c, Rate_Type__c, Reference_Number_1__c, Reference_Number_2__c, Reference_Number_3__c, 
                Related_Insurance_Information__c, Residential_Benefits_Covered__c, Residential_Benefits_Days_Used__c, Residential_Benefits_Lifetime_Maximum__c, Residential_Benefits_Max_Days_Per_Year__c, 
                Residential_Benefits_Max_Per_Day__c, Residential_Lifetime_Maximum_Used__c, State_Lic_Accepted__c, Subscriber_s_Employer__c, Substance_Abuse_Copay_Admit_Fee__c, Substance_Abuse_DED_Apply_to_OOP__c,
                Substance_Abuse_DED__c, Substance_Abuse_DED_met__c, Substance_Abuse_Individual_or_Family__c, Substance_Abuse_OOP__c, Substance_Abuse_OOP_met__c, Substance_Claims_5_digit_Payer_ID__c,
                Substance_Claims_City__c, Substance_Claims_Phone__c, Substance_Claims_State__c, Substance_Claims_Street_Address_1__c, Substance_Claims_Street_Address_2__c, Substance_Claims_Zip_Code__c, 
                Termination_Date__c, VOB_Rep_1__c, VOB_Rep_2__c, VOB_Rep_3__c, VOB_Request__c, Will_Plan_Terminate_when_Client_Turns_26__c FROM Insurance_Verification__c
                where Opportunity__c = :ccRecord.Opportunity__c limit 1];
                
        if (lstInsurVerif.size() > 0) {
            insuranceVerification = lstInsurVerif.get(0);
        }

        
    }
    
    void GetClientChart(){
        
            
        ccRecord = [Select id, Name, Recordtype.Name, RecordtypeId, Special_Diet__c, Admit_Date_Time__c, Age__c, Discharge_Date_Time__c, Primary_Counsellor__c, Building__c, Primary_Therapist__c, Primary_Therapist__r.name, 
                    Client_Image_URL2__c, Contact__c, Gender__c, Occupation__c, Client_Status__c, Payment__c, Employer_Name__c, Employer_Phone__c, Race__c, Ethnicity__c, UR_Representation__c, 
                    UR_Representation__r.name, Marital_Status_2__c, Dob__c,Height__c ,weight__c , Phone__c, Email__c, Address__c, Room__c, Referrer__r.name, Admissions_Coordinator__r.Phone, Client_Information_Validated__c, Track_Post_Detox__c,
                    Opportunity__c, Case_Manager__r.name, Latest_Concurrent_Review__r.Level_Of_Care__c, U_R_Location__c,Program__c, Bed__c, Client_ID_URL2__c, Admissions_Coordinator__c, Admissions_Coordinator__r.Name, Veteran_Status__c, 
                    Street__c, City__c, State__c, Country__c, Postal_Code__c,Primary_Counsellor__r.Name,Diet__c, Client_Insurance_Card_Front_URL__c, Client_Insurance_Card_Back_URL__c  from Client_Chart__c where id = :ccRecordId LIMIT 1];
    }

    public pageReference uploadClientChartImages() {
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/uploadDocuments_ClientChart?id=' + ccRecordId);
        return pr;
    }

    public boolean displayUploadClientChartImages {
        get {
            if (ccRecord.Client_Image_URL2__c == null || ccRecord.Client_ID_URL2__c == null ||
                ccRecord.Client_Insurance_Card_Back_URL__c == null || ccRecord.Client_Insurance_Card_Front_URL__c == null)
                {
                    return true;    
                } 
                
            else 
                return false;
        }
        set;
    }
    public void editCCRecord() {
        editView = True;
    }

    public void saveCCRecord() {
        if((ccRecord.Admit_Date_Time__c == null || ccRecord.Discharge_Date_Time__c == null) && (ccRecord.Client_Status__c == 'Admitted' || ccRecord.Client_Status__c == 'Discharged'))
        {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Please Provide Admit and Dicharge Time for Admitted/Discharged Client');
            ApexPages.addMessage(errMsg);
        }
        else if(ccRecord.Client_Status__c == 'Admitted' && ccRecord.Program__c ==  null)
        {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Please Select any Program before change Status to Admitted');
            ApexPages.addMessage(errMsg);
        }
        else if(ccRecord.Recordtype.Name == 'Willowsprings Recovery' && ccRecord.Program__c == 'Residential' && ccRecord.Track_Post_Detox__c ==  null)
        {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Please Select Track Post Detox');
            ApexPages.addMessage(errMsg);
        }
        else
        {
            editView = False;
            update ccRecord;
           GetClientChart();
        }
    }

    Public void EditInsuranceComponent() {
        editInsuranceView = true;
    }

    public void SaveContact() {
        ContIns.recordtypeid = ClientContRecordTypeID;
        ContIns.Client_Chart__c = ccRecordId;
        insert ContIns;

        PHI_Log__c newPhiLog = new PHI_Log__c();
        newPhiLog.Client_Chart__c = ccRecordId;
        newPhiLog.Contact__c = ContIns.ID;
        newPhiLog.status__c = 'Open';
        newPhiLog.RecordTypeId = Constants.PhiLogAuthRecordTypeId;
        insert newPhiLog;
        
        displayPopup = false;

        IsEditContact = false;

        ContIns = new contact();
        
        
    }

    public list < contact > getContactLst() {
        ContactLst = [select name, Type__c, Status__c, Relationship__c, Phone, OtherPhone, Email, Address__c, Notes__c, MailingCity, MailingStreet, MailingState, MailingCountry, MailingPostalCode from contact where Client_Chart__c = :ccRecordId and recordtypeid = :ClientContRecordTypeID];
        return ContactLst;
    }

    public void EditContact() {
        ContIns = [select FIRSTname, lastname, Type__c, Relationship__c, Phone, OtherPhone, Email, Address__c, Notes__c, MailingCity, MailingStreet, MailingState, MailingCountry, MailingPostalCode from
        contact where Client_Chart__c = :ccRecordId and recordtypeid = :ClientContRecordTypeID and id = :ContClientID];
        IsEditContact = true;
        displayPopup = true;

    }

    public void UpdateContact() {

        update ContIns;
        displayPopup = false;
        IsEditContact = false;
        ContIns = new contact();

    }

    public void deleteContact() {
        Database.delete(ContClientID);
    }

    Public void SaveInsuranceComponent() {
        editInsuranceView = False;
    }

    public list < Allergies__C > getAllergiesLst() {
        AllergiesLst = [SELECT id, Allergen__c, Allergy_Type__c, Reaction__c, Reaction_Type__c, Onset__c, Treatment__c, Status__c, Source__c, Medical__c, Client_Chart__c
        FROM Allergies__c where Client_Chart__c = :ccRecordId];

        return AllergiesLst;
    }

}