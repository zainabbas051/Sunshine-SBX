/*
    controller class for txdc_dischargeplan vf component. Discharge Plan is a record type of 
    tx and dc plans object.
    @author: Huma Zafar
*/
public with sharing class txdc_dischargeplan {
    
    public Tx_and_D_C_Plans__c txdc{get;set;}    
    
    public boolean EditPage{get;set;}
    
    id txdcId ;
    
     public list < SelectOption > listAllCodes {
        get;
        set;
    }

    public list < string > Codes {
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
    final string AWSURL;
    
    public User userObj{
        get;
        set;
    }
    
    public string RecordType{
        get;
        set;
    }
    
    public List<UtlizationReviewOrder__c> ListOfOrder{
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
    
    public list<Appointment__c> lstAppointments{get;set;}
    public list<Appointment__c> lstProgramReferral{get;set;}
    public list<Appointment__c> lstSupportMeetings{get;set;}
    
    ID clientChartId;
    
      //Make the page readOnly
    public void ReadOnlyPage() {

        EditPage = false;
    }
    
    public Client_Chart__c ClientChart {get;set;}
    
    public txdc_dischargeplan(){
        
        //txdcId = ApexPages.CurrentPage().getParameters().get('rId');
        clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        txdc = new Tx_and_D_C_Plans__c();
        ClientChart = new Client_Chart__c();
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        try{
            
            txdc = [select id, Type__c, Date__c, Admit_Date__c, Discharge_Date__c, Discharge_Address__c, Status__c,SignedBy__c,
                    Level_of_Care_at_Discharge__c, Diagnosis__c, Medications_at_discharge__c, Clinical_Summary__c,Client_Chart__c,
                    Client_Chart__r.Diagnosis_Code__c,Medication_Complaince__c ,Client_Signed_User_Closed__c ,Client_Image_Url_Closed__c,Client_Closed_Date__c,
                    Staff_Signature_URL_Closed__c,Staff_Signed_User_Closed__c,Staff_Closed_Date__c,Intern_Signature_URL__c ,Intern_Signed_User__c ,Intern_Closed_Date__c , 
                    Services_Provided__c, Prognosis__c, Clinical_Recommendations__c,RecordTypeID,Client_Chart__r.Treatment_Center__r.Name,Client_Chart__r.Name
                    from Tx_and_D_C_Plans__c where  Client_Chart__c= :clientChartId and RecordType.Name ='Discharge Plan'];
            
            List<Client_Chart__c> CCList = [Select Id,Name, Diagnosis_Code__c from Client_Chart__c where Id=:clientChartId Limit 1];
            if(CCList.size()>0)
            {
                ClientChart = CCList[0];
            }
            
        }
        catch(exception e){
            txdc = new Tx_and_D_C_Plans__c();
        }
        
     
        RecordType = txdc.RecordTypeID;
        txdcId = txdc.id; 
        EditPage = false;
        userObj = [Select id, name, title, User_Role__c from user where id =: userinfo.getUserID()];
            
        
        if(txdc.status__c == 'Closed')    
            ListOfOrder = loadOrders();
        else 
            UpdateMedicationList();
        
        loadAppointments();
        checkExistingCode();
        fillDiagnosisCodes();
    }

    private void fillDiagnosisCodes() {
        listAllCodes = new list < SelectOption > ();
        List < DiagnosisCode__c > myCs = DiagnosisCode__c.getall().values();
        for (DiagnosisCode__c m: myCs) {
            listAllCodes.add(new SelectOption((m.Name + ' ' + m.Description__c), (m.Name + ' ' + m.Description__c)));
        }
    }

    void checkExistingCode() {
        
        Codes = new List < string > ();
        if( txdc.Diagnosis__c != NULL &&  txdc.Diagnosis__c != '' && txdc.Status__c == 'Closed'){
            for (string exstCode: txdc.Diagnosis__c.split(';')) {
                Codes.add(exstCode);
            }
        }
        else if(ClientChart != null && ClientChart.Diagnosis_Code__c != null)
        {
            txdc.Diagnosis__c  = ClientChart.Diagnosis_Code__c;
            for(string exstCode: ClientChart.Diagnosis_Code__c.split(';'))
            {
                Codes.add(exstCode);    
            }
        }
        
    }    
     public PageReference ActiveTXDxPlans() {
    
      
        //if active then it will go for close after complete signature
      

            if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == null ) {

                txdc.Staff_Signature_URL_Closed__c = AWSURL + ImageUrlAddress;
                txdc.Staff_Signed_User_Closed__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
                txdc.Staff_Closed_Date__c = DateTime.Now();
                txdc.SignedBy__c = 'Staff';
            } else if (SelectedSignedOption == 'Patient') {

                txdc.Client_Image_Url_Closed__c = AWSURL + ImageUrlAddress;
                txdc.Client_Signed_User_Closed__c = '(Patient) ' + txdc.Client_Chart__r.Name;
                txdc.Client_Closed_Date__c = DateTime.Now();
                txdc.SignedBy__c = 'Client';
            } else if (userObj.User_Role__c != null) {

                txdc.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
                txdc.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
                txdc.Intern_Closed_Date__c = DateTime.Now();
                txdc.SignedBy__c = 'Client';
                txdc.Status__c = 'Review Pending';
            }
            
          

            if ((txdc.Staff_Signed_User_Closed__c != null || String.isNotBlank(txdc.Staff_Signed_User_Closed__c )) && (txdc.Client_Signed_User_Closed__c != null || String.isNotBlank(txdc.Client_Signed_User_Closed__c ))) {
                txdc.Status__c = 'Closed';
                txdc.SignedBy__c = 'All'; // signing is complete
              

            }
            
              //order medication
            if(txdc.Status__c == 'Closed'){
            
              // delete loadOrders();
               insert ListOfOrder ;
            }
          
            
         
         
           update txdc;
           return null;
         

        
    }
    
    List<UtlizationReviewOrder__c> LoadOrders(){
        
          return [Select ID,Order__r.Order_Type__c,Order__r.Taper__r.Name,Order__r.Medicine__r.Name,
          Order__r.Frequency__c FROM UtlizationReviewOrder__c where Tx_and_D_C_Plans__c =: txdc.ID];
    }
    
   
    
    void UpdateMedicationList(){
    
       
        ListOfOrder = new List<UtlizationReviewOrder__c>();
        for(Order__c od : [Select ID,Order_Type__c,Taper__r.Name,Medicine__r.Name,Client_Chart__c,
          Frequency__c from Order__c  where Client_Chart__c=:clientChartId AND (Status__c = 'Active' OR Status__c = 'Under Review')])

        {
            ListOfOrder.add( new UtlizationReviewOrder__c(Tx_and_D_C_Plans__c = txdc.ID , Order__c = od.ID , Order__r= od));
        }
        
        system.debug('test##' + ListOfOrder);
        
    }

    
 

    
    private void loadAppointments(){
        lstAppointments = new list<Appointment__c>();
        lstProgramReferral = new list<Appointment__c>();
        lstSupportMeetings = new list<Appointment__c>();
        
        lstAppointments = [select id, Tx_and_D_C_Plans__c, Address__c, Name__c, Phone_Number__c, Date_Time__c from
        Appointment__c where Tx_and_D_C_Plans__c =: txdcId and RecordType.Name='Appointment'];
        
        lstProgramReferral = [select id, Tx_and_D_C_Plans__c, Address__c, Name__c, Type_of_Program_Level_of_Care__c,
        Phone_Number__c, Contact_Person__c from Appointment__c where Tx_and_D_C_Plans__c =: txdcId and 
        RecordType.Name='Program Referral'];
        
        lstSupportMeetings = [select id, Tx_and_D_C_Plans__c, Address__c, Name__c, Meeting_Type__c, Date_Time__c from
        Appointment__c where Tx_and_D_C_Plans__c =: txdcId and RecordType.Name='Support Meeting'];
                
    }
    
    public void AddAppointment(){
        Appointment__c app = new Appointment__c();
        app.Tx_and_D_C_Plans__c = txdcId;
        app.RecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Appointment').getRecordTypeId();
        lstAppointments.add(app);
    }
    
    public void AddProgramReferral(){
        Appointment__c app = new Appointment__c();
        app.Tx_and_D_C_Plans__c = txdcId;
        app.RecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Program Referral').getRecordTypeId();
        lstProgramReferral.add(app);
    }
    
    public void AddSupportMeeting(){
        Appointment__c app = new Appointment__c();
        app.Tx_and_D_C_Plans__c = txdcId;
        app.RecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Support Meeting').getRecordTypeId();
        lstSupportMeetings.add(app);
    }
    
    public void EditFullPage(){
        EditPage = true;
        ChangeStatus();
        
    }
    
    void ChangeStatus(){
        
        if(txdc.status__c == 'Open'){
            txdc.status__c = 'In Progress';
            txdc.SignedBy__c = 'None';
            update txdc;
        }
        
    }
    
   
    
    public Pagereference submit(){
        System.debug('submit button method');
       
        // = stringCodes;//String.join(Codes, ';');
        upsert txdc ;
        
        list<Appointment__c> lstUpsert = new list<Appointment__c>();
        
        for(Appointment__c app : lstAppointments){
            if(app.Name__c!=null)
                lstUpsert.add(app);
        }
        for(Appointment__c app : lstProgramReferral){
            if(app.Name__c!=null)
                lstUpsert.add(app);
        }
        for(Appointment__c app : lstSupportMeetings){
            if(app.Name__c!=null)
                lstUpsert.add(app);
        }
        system.debug(lstUpsert);
        if(lstUpsert.size()>0)
            upsert lstUpsert;
            
        EditPage = false;
        
        ClientChart.Diagnosis_Code__c = txdc.Diagnosis__c;//String.join(Codes, ';');
        update ClientChart;
        
        return null;
    }
}