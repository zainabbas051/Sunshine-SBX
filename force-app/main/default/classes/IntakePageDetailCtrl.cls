/*
Test class : IntakePageDetailCtrl_Test
*/
public class IntakePageDetailCtrl {

    public Intake_Forms__c IntakeForm {
        get;
        set;
    }
    public string RecordTypeName {
        get;
        set;
    }
    public string readOnly {
        get;
        set;
    }
    public Id intakeFormID {
        get;
        set;
    }
    public Id ID {
        get;
        set;
    }
    public List < Intake_Forms__c > lstDeviceIntakeForm {
        get;
        set;
    }

    public String Client_imageURL {
        get;
        set;

    }

    public String Staff_imageURL {
        get;
        set;

    }
    
    public Intake_Forms__c IntakeCheckList {
        get;
        set;
    }
    public Integer IndexToDelete {
        get;
        set;
    }
    public string RecordId {
        get;
        set;
    }
    public string ImageUrlAddress {
        get;
        set;
    }
    public string SelectedSignedOption {
        get;
        set;
    }
    ID ClientContRecordTypeID {
        get;
        set;
    }

    final string RECORDTYPE_ACKPRES = 'Acknowledgment of Presence in Treatment';
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
    final string AWSURL;
    
     public List<string> AttachmentFileName {get;set;}
    
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('Consents');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    

    public IntakePageDetailCtrl() {

        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        lstDeviceIntakeForm = new List < Intake_Forms__c > ();
        intakeFormID = ApexPages.CurrentPage().getParameters().get('Intake');

        system.debug('$$$$$$$$$' + intakeFormID);
        ID = ApexPages.CurrentPage().getParameters().get('ID');
        readOnly = (ApexPages.CurrentPage().getParameters().get('readOnly') != null) ? 'false': 'true';
        IntakeForm = [Select ID, Client_Chart__c, Name, RecordTypeID, RecordType.Name,RecordType.DeveloperName, Client_Chart__r.Discharge_Date_Time__c, Client_Chart__r.Treatment_Center__r.Name, 
                        Client_Chart__r.Name, Client_Chart__r.Admit_Date_Time__c, Refrigerator_and_snack_area__c, Date__c, Additional_luggage_in_storage__c, Locker_Number__c ,
                        Driver_s_license__c, Driver_s_license_Issued_By__c, Other_IDs__c, Other_ID_s_Description__c, Insurance_Card_s__c, Cash__c, Cash_Amount__c, Checks_blank__c, 
                        check_numbers__c, Checks_written__c, Checks_Payee__c, Wallet__c, Credit_or_debit_cards__c, Credit_or_debit_card_Details__c, Sharps__c, Sharp_Description__c,
                        Aerosol_cans_Number__c, Aerosol_cans_Comments__c, Items_containing_Alcohol_Number__c, Items_containing_Alcohol_Comments__c, Weapons_Sharps__c,
                        Weapons_Sharps_Comments__c, Drug_Paraphernalia__c, Drug_Paraphernalia_Comments__c, Sexual_Paraphernalia_Number__c, Sexual_Paraphernalia_Comments__c,
                        T_shirt_Shirts_Number__c, T_shirt_Shirts_Comments__c, Long_Sleeve_Shirts_Number__c, Long_Sleeve_Shirts_Comments__c, Sweaters_Number__c,
                        Sweaters_Comments__c, Jackets_Number__c, Jackets_Comments__c, Shorts_Number__c, Shorts_Comments__c, Dresses_or_Skirts_Number__c,
                        Dresses_or_Skirts_Comments__c, Jeans_Number__c, Jeans_Comments__c, Other_Pants_Number__c, Other_Pants_Comments__c, Socks_Number__c,
                        Socks_Comments__c, Underwear_Number__c, Underwear_Comments__c, Bras_Number__c, Bras_Comments__c, Shoes_Number__c, Shoes_Comments__c, Hats_Number__c,
                        Hats_Comments__c, Belts_Number__c, Belts_Comments__c, Jewelry_Number__c, Jewelry_Comments__c, Books_Number__c, Books_Comments__c, Personal_Hygiene_Items_Number__c,
                        Personal_Hygiene_Items_Comments__c, Electronic_Items_Number__c, Electronic_Items_Comments__c, Misc_Items__c, Misc_Items_Comments__c, Other_items__c, 
                        Other_items_Description__c, Status__c, Item__c, Notes__c, condition__c, Charger_Included__c, Review_Client_Handbook__c, Nurse_s_Station__c, Times_procedures__c,
                        Location_of_Therapist_office__c, Telephone_locations__c, Laundry_room__c, Names_of_Physician__c, Smoking_Fresh_air_breaks__c, Tour_and_Orientation__c, 
                        Review_of_Client__c, Signed_Receipt_of_Client__c, I_understand_prescribed__c, Abstain_from_the_use__c, I_understand_that_frequent__c, I_agree_to_provide_a_urine__c, 
                        I_understand_refusal_to_provide__c, I_understand_that_absolutely__c, I_understand_that_I_cannot__c, Please_contact_me_by_e_mail__c, Email_Address__c, 
                        contact_me_by_telephone__c, Shared_phone_number__c, Personal_Phone_Number__c, Work_phone_number__c, Phone_number__c, May_we_say_we_are_calling__c, Image_Url__c,
                        Signed_User__c, Closed_Date__c, Client_Image_Url__c, Client_Signed_User__c, Patient_Closed_Date__c, Work_Phone_Field__c, Personal_Phone_Field__c, SignedBy__c,Intake_Form__c,
                        Locker_Number_L__c, Locker_Number_L__r.Locker_Status__c,Is_Cloned__c,
                        Attachment1_Id_URl__c, Attachment2_Id_URl__c,
                        Attachment3_Id_URl__c, Attachment4_Id_URl__c, Attachment5_Id_URl__c, Attachment6_Id_URl__c, 
                        Attachment7_Id_URl__c, Attachment8_Id_URl__c, Attachment9_Id_URl__c, Attachment10_Id_URl__c
                        from Intake_Forms__c where ID = :intakeFormID limit 1];

        RecordTypeName = IntakeForm.RecordType.Name;
        ClientContRecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Client Chart Contact').getRecordTypeId();

        lstDeviceIntakeForm = getDevices();
        
      if(RecordTypeName == 'Admit Agreement' ){
            
            AttachmentFileName = new List<string>();
            CreateAttachmentFileName();
        }
    
        //lstContact = getContact();
        // lstContact_Emergency = getEmergencyContact();
    }
    
    void CreateAttachmentFileName(){
        
         if(IntakeForm.Attachment1_Id_URl__c!= null){
             
            
            AttachmentFileName .add(SubString(IntakeForm.Attachment1_Id_URl__c)); 
        }
        
        if(IntakeForm.Attachment2_Id_URl__c!= null){
            AttachmentFileName .add(SubString(IntakeForm.Attachment2_Id_URl__c)); 
        
        }
        
        
        if(IntakeForm.Attachment3_Id_URl__c!= null){
             AttachmentFileName .add(SubString(IntakeForm.Attachment3_Id_URl__c)); 
        }
        
        if(IntakeForm.Attachment4_Id_URl__c!= null){
             AttachmentFileName .add(SubString(IntakeForm.Attachment4_Id_URl__c)); 
        }
        
        if(IntakeForm.Attachment5_Id_URl__c!= null){
              AttachmentFileName .add(SubString(IntakeForm.Attachment5_Id_URl__c)); 
        }
        
        if(IntakeForm.Attachment6_Id_URl__c!= null){
            AttachmentFileName .add(SubString(IntakeForm.Attachment6_Id_URl__c));  
        }
        
        if(IntakeForm.Attachment7_Id_URl__c!= null){
              AttachmentFileName .add(SubString(IntakeForm.Attachment7_Id_URl__c)); 
        }
        
        if(IntakeForm.Attachment8_Id_URl__c!= null){
              AttachmentFileName .add(SubString(IntakeForm.Attachment8_Id_URl__c)); 
        }
        
        if(IntakeForm.Attachment9_Id_URl__c!= null){
             AttachmentFileName .add(SubString(IntakeForm.Attachment9_Id_URl__c)); 
        }
        
        if(IntakeForm.Attachment10_Id_URl__c!= null){
            AttachmentFileName .add(SubString(IntakeForm.Attachment10_Id_URl__c)); 
        }
    }
    
    string SubString(String aUrl){
        
         integer lastIndexOf =aUrl.lastIndexOf('/');
          
          string subResult = aUrl.substring(lastIndexOf +1);
          subResult = subResult.replace('%',' ');
          return subResult;
    }
    
   public pageReference AddAttachment(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_IntakeAttachments?id='+intakeFormID);
        return pr;
    } 
 
    
    
    public List<SelectOption> getOpenLockers() {
        
            
            List<SelectOption> options = new List<SelectOption>();
            for(UtlizationReviewOrder__c iUti : [Select ID , Name from UtlizationReviewOrder__c WHERE  Locker_Status__c = 'Open'  OR(Intake_Form__c != NULL AND Intake_Form__c = : IntakeForm.Intake_Form__c) order by createdDate]){
                options.add(new SelectOption(iUti.ID,iUti.Name));
         
            }
            return options;
    }
    
    
    public String admitDate{
        get{
            String admit_date = '';
            if(IntakeForm.Client_Chart__r.Admit_Date_Time__c != null)
            admit_date = IntakeForm.Client_Chart__r.Admit_Date_Time__c.Month()+'/'+IntakeForm.Client_Chart__r.Admit_Date_Time__c.Day()+'/'+IntakeForm.Client_Chart__r.Admit_Date_Time__c.Year();
            
            return admit_date; 
        }set;
    }

    public void getAttachment() {

        Staff_imageURL = '/servlet/servlet.FileDownload?file=';
        Client_imageURL = '/servlet/servlet.FileDownload?file=';

    
        List < Attachment > documentList = [select id, name from attachment where
        ParentID = :intakeFormID limit 2];
        
        system.debug('$$$$$$' + documentList);

        if (!documentList.isEmpty()) {

            for (Attachment attr: documentList) {

                if (attr.Name == 'Staff') Staff_imageURL = Staff_imageURL + attr.id;
                else Client_imageURL = Client_imageURL + attr.id;
            }

        }
    }
    public void changeStatus() {

        //if status is open
        if (IntakeForm.status__c == 'Open') {

            IntakeForm.status__c = 'In Progress';
            IntakeForm.SignedBy__c = 'None';
        }
              
        if(IntakeForm.recordType.DeveloperName == 'Admit_Agreement'){
                 IntakeForm.SignedBy__c = 'Client';
       
        }
        
            update IntakeForm;
        
    }

    public PageReference SaveData() {

        
        upsert IntakeForm;

        if (!lstDeviceIntakeForm.isEmpty()) upsert lstDeviceIntakeForm;

       

        PageReference pr = new PageReference('/apex/IntakePageDetail');
        pr.getParameters().put('ID', ID);
        pr.getParameters().put('Intake', IntakeFormID);
        pr.getParameters().put('rt', ApexPages.CurrentPage().getParameters().get('rt'));
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;

    }

    public void AddIntakeDevices() {
        Id devRecordTypeId = Schema.SObjectType.Intake_Forms__c.getRecordTypeInfosByName().get('Devices').getRecordTypeId();
        lstDeviceIntakeForm.add(new Intake_Forms__c(Intake_Form__c = intakeFormID, RecordTypeID = devRecordTypeId ,Status__c = 'Open'));
        system.debug('@@@@@' + lstDeviceIntakeForm);
    }

   

    List < Intake_Forms__c > getDevices() {

        return [Select Item__c, Notes__c, condition__c, Charger_Included__c from Intake_Forms__c
        where Intake_Form__c = :intakeFormID];

    }

    

    public void RemoveFromList() {

        system.debug('@@@@@' + IndexToDelete);
        system.debug('@@@@@' + RecordId);

        if (RecordId != '') {

            Delete[Select Id from Intake_Forms__c where Id = :RecordId];
            lstDeviceIntakeForm = getDevices();
        } else if (IndexToDelete != null) {
            system.debug('@@@@@' + lstDeviceIntakeForm);

            lstDeviceIntakeForm.remove(IndexToDelete);
        }
    }
    
    public PageReference CloneRecord(){
        
        IntakeForm.Is_Cloned__c = true;
        update IntakeForm;
        
        Intake_Forms__c cloneIntakeForm = IntakeForm;
        
        cloneIntakeForm.Status__c = 'Open';
        cloneIntakeForm.SignedBy__c ='None';
   
        cloneIntakeForm.Image_Url__c = null;
        cloneIntakeForm.Signed_User__c = null;
        cloneIntakeForm.Closed_Date__c = null;
        cloneIntakeForm.Client_Image_Url__c = null;
        cloneIntakeForm.Client_Signed_User__c = null;
        cloneIntakeForm.Patient_Closed_Date__c = null;
        cloneIntakeForm.Intake_Form__c = IntakeForm.ID;
        cloneIntakeForm.ID = null;
        cloneIntakeForm.Is_Cloned__c = false;
        insert cloneIntakeForm;
        
        
        
        PageReference pr = new PageReference('/apex/IntakePageDetail');
         pr.getParameters().put('ID',cloneIntakeForm.Client_Chart__r.ID);
         pr.getParameters().put('Intake',cloneIntakeForm.ID );
         pr.getParameters().put('rt', ApexPages.CurrentPage().getParameters().get('rt'));
         pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
         return pr;
       
        /*PageReference pr = new PageReference('/apex/IntakePageDetail');
        pr.getParameters().put('ID', ID);
        pr.getParameters().put('Intake', IntakeFormID);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;*/
    
        
    }
    
    public void ChangeStatusToInActive(){
        
        
        IntakeForm.Status__c = 'InActive';
        update IntakeForm;
        //update loocker status
        UtlizationReviewOrder__c updateLocker = new  UtlizationReviewOrder__c();
        updateLocker.ID =  IntakeForm.Locker_Number_L__c;
        updateLocker.Locker_Status__c = 'Open';
        updateLocker.Intake_Form__c = null;
        update updateLocker;
    }

   

    public PageReference CloseIntakeForms() {

        //update intake Form with the user signature    
        User u = [Select Name, title from User where ID = :UserInfo.getUserID() limit 1];

        if (SelectedSignedOption == 'Staff') {

            IntakeForm.Image_Url__c = AWSURL + ImageUrlAddress;
            IntakeForm.Signed_User__c = 'Staff present: ' + u.Name + ',' + u.Title;
            IntakeForm.Closed_Date__c = DateTime.Now();
            IntakeForm.SignedBy__c = 'Staff';
        } else if (SelectedSignedOption == 'Patient') {

            IntakeForm.Client_Image_Url__c = AWSURL + ImageUrlAddress;
            IntakeForm.Client_Signed_User__c = '(Patient) ' + IntakeForm.Client_Chart__r.Name;
            IntakeForm.Patient_Closed_Date__c = DateTime.Now();
            IntakeForm.SignedBy__c = 'Client';
        }
    if ((IntakeForm.Signed_User__c != null || String.isNotBlank(IntakeForm.Signed_User__c))&& IntakeForm.recordType.DeveloperName == 'Admit_Agreement'){
        
            IntakeForm.Status__c = 'Closed';
            IntakeForm.SignedBy__c = 'All';
            IntakeForm.Closed_Date__c = DateTime.Now();
        
        
    }
        //IntakeForm.Signed_User__c = '(Patient);
        if ((IntakeForm.Signed_User__c != null || String.isNotBlank(IntakeForm.Signed_User__c)) && (IntakeForm.Client_Signed_User__c != null || String.isNotBlank(IntakeForm.Client_Signed_User__c))) {
            
             IntakeForm.Status__c = 'Closed';
            if(IntakeForm.RecordType.DeveloperName == 'Client_Personal_Items'){
                   IntakeForm.Status__c = 'Active';
                   
                   //make the locker Active
                   UtlizationReviewOrder__c updateLocker = new  UtlizationReviewOrder__c();
                    updateLocker.ID =  IntakeForm.Locker_Number_L__c;
                    updateLocker.Locker_Status__c = 'Occupied';
                    updateLocker.Intake_Form__c = intakeFormID;
                    update updateLocker;
                 
                 if(IntakeForm.Intake_Form__c != null){
                     
                     Intake_Forms__c oldIntakeForm = new Intake_Forms__c();
                     oldIntakeForm.ID = IntakeForm.Intake_Form__c;
                     oldIntakeForm.Status__c = 'InActive';
                     update oldIntakeForm;
                     
                     //UPDATE LOCKER FIELD FOR OLD INTAKE
                     updateLocker = new  UtlizationReviewOrder__c();
                     updateLocker.ID =  [Select Locker_Number_L__c from Intake_Forms__c where ID =: oldIntakeForm.ID limit 1].Locker_Number_L__c;
                     updateLocker.Locker_Status__c = 'Open';
                     updateLocker.Intake_Form__c = null;
                     update updateLocker;
                     
                  
                 }
                
            }
         
            
            IntakeForm.SignedBy__c = 'All';

        }

        update IntakeForm;

       
        PageReference pr = new PageReference('/apex/IntakePageDetail');
        pr.getParameters().put('ID', ID);
        pr.getParameters().put('Intake', intakeFormID);
        pr.getParameters().put('rt', ApexPages.CurrentPage().getParameters().get('rt'));
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;

    }

}