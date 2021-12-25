/*
Test class : MedcialHomePageCtrlTest
*/
public class MedcialHomePageCtrl {

    public string ccRecordId{get;set;}
    public string ccRecordType{get;set;}
    public boolean ShowMedicalRecPage{get;set;}
    public boolean ShowMedicalFormRecTypes {get;set;}
    public boolean ShowMedicalConsultForm {get;set;}
    public boolean ShowMedicalDetoxForm {get;set;}
    public boolean ShowMedicalLabAttachmentForm{get;set;}
    public boolean showAdmitOrderForm{get;set;}
    public boolean ShowOustidereferalnoteform {get;set;}
    public boolean ShowDrugScreenForm {get;set;}
    public Boolean ShowUrinePregnacyTestForm {get;set;}
    public string SelectedOption {get; set;}
    public medical__c MecicalIns {get;set;}
    public string selectedId { get;set;}
    public List<RecordType> MedicalList {get;set;}
    public List<RecordType> LabList {get;set;}
    public List<Medical__c> MedicalListForm {get;set;}
    public List<Medical__c> LabListForm {get;set;}
    boolean IsFemale;
    public list<Clinical_Evaluation__c> cePsychEvList {get; set;}
    public list<Clinical_Evaluation_3__c> ceHistoryPhyList {get; set;}
    public Sunshine_Center_Id__c scID {get; set;}
    
    User userObj;
    
   public boolean buttonAccessType{
        
        get {
                
        User u = userObj;
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('Medical');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    


public boolean displayPopup {
  get;
  set;
 }
    public MedcialHomePageCtrl (){
        
        ccRecordId = apexPages.currentPage().getParameters().get('id');
        ccRecordType = apexPages.currentPage().getParameters().get('rt');
        System.debug('ccRecordType ::AH:: '+ccRecordType);
        userObj = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        SelectedOption ='';
        CheckGender();
        MedicalList = new List<RecordType>();
        LabList = new List<RecordType>();
        cePsychEvList = new list<Clinical_Evaluation__c>();
        ceHistoryPhyList = new list<Clinical_Evaluation_3__c>();
        scID = Sunshine_Center_Id__c.getInstance(ApexPages.CurrentPage().getParameters().get('rt'))!=null ? Sunshine_Center_Id__c.getInstance(ApexPages.CurrentPage().getParameters().get('rt')) : new Sunshine_Center_Id__c();
        
        GetMedicalRecordType();
        GetMedicalList();
        ShowMedicalRecPage= true;
        ShowMedicalFormRecTypes = false;
        ShowMedicalConsultForm = false;
        ShowMedicalDetoxForm = false;
        ShowMedicalLabAttachmentForm = false;
        showAdmitOrderForm = false;
        ShowOustidereferalnoteform = false;
        ShowDrugScreenForm  = false;
        ShowUrinePregnacyTestForm = false;
        

    }
    
     //Bilal 
    public void AddFormMedical(){
        ShowMedicalFormRecTypes = true;
        ShowMedicalRecPage= false;
        displayPopup = true;
    }
    
    void CheckGender(){
        
        IsFemale = false;
        string Gender = [Select Gender__c from Client_Chart__c where ID =: ccRecordId limit 1 ].Gender__c;
        if(Gender == 'Female')
            IsFemale = true;
    }
    
   /* public List<RecordType > MedicalRecordOption {
        get{
            List<RecordType > MedicalRecordType = new List<RecordType >();
          
            for (RecordType rc :  [SELECT Id, Name  FROM RecordType where SobjectType='Medical__c' ])
                MedicalRecordType.add(rc);
                return MedicalRecordType ;
        }
        private set;
    }*/
    
    void GetMedicalRecordType(){
        Set<string> SetOfRecordType = new Set<string>();
          
        SetOfRecordType.add('Provider Consultation');
        SetOfRecordType.add('Oustide referal note');
        SetOfRecordType.add('Admit Order');
        SetOfRecordType.add('Doctors Note');
        SetOfRecordType.add('Evaluation Addendum');
        if(userObj.Acess_Type__c != 'Operations'){
             SetOfRecordType.add('Nursing Reassessment');
             SetOfRecordType.add('Nursing Assessment');
        }
       
        SetOfRecordType.add('Psychiatric Progress Notes');
        SetOfRecordType.add('Medical Attachment');
        SetOfRecordType.add('Refusal Of Medical Treatment');
        
        Set<string> SetOfLabAttachmentRec = new Set<string>();
          
        SetOfLabAttachmentRec.add('BAC and Drug Screen');
        SetOfLabAttachmentRec.add('Lab Attachment');
       
    
        
        for(RecordType rc : [Select Id,Name from RecordType where SObjectType = 'Medical__c' 
                            AND NAME NOT IN('Medical Consultation','Medical Detox Follow-up','Admit Order') ]){
            
            if(SetOfRecordType.contains(rc.Name)) {
                
                  if(ccRecordType != null && ccRecordType != '' && ccRecordType == 'Willowsprings Recovery')
                  {
                      if(rc.Name != 'Psychiatric Progress Notes')
                           MedicalList.add(rc);
                  }else{
                      if(rc.Name != 'PROVIDER CONSULTATION')
                           MedicalList.add(rc);
                  }
            }
            else{
                if(IsFemale && rc.Name == 'Urine Pregnancy Test')  
                    LabList.add(rc);
                else if(SetOfLabAttachmentRec.contains(rc.Name))
                     LabList.add(rc);
            }
        }
    }
    //Bilal
    
    void GetMedicalList(){
        
        MedicalListForm = new List<Medical__c>();
        LabListForm = new List<Medical__c>();
       
        Set<string> SetOfRecordType = new Set<string>();
        
        cePsychEvList = new list<Clinical_Evaluation__c>();
        ceHistoryPhyList = new list<Clinical_Evaluation_3__c>();
        SetOfRecordType.add('PROVIDER CONSULTATION');
        SetOfRecordType.add('Oustide referal note');
        SetOfRecordType.add('Admit Order');
        SetOfRecordType.add('Doctors Note');
        SetOfRecordType.add('Evaluation Addendum');
        if(userObj.Acess_Type__c != 'Operations'){
             SetOfRecordType.add('Nursing Reassessment');
             SetOfRecordType.add('Nursing Assessment');
        }
        SetOfRecordType.add('Psychiatric Progress Notes');
        SetOfRecordType.add('Medical Attachment');
        SetOfRecordType.add('Refusal Of Medical Treatment');
        
        Set<string> SetOfLabAttachmentRec = new Set<string>();
          
        SetOfLabAttachmentRec.add('BAC and Drug Screen');
        SetOfLabAttachmentRec.add('Lab Attachment');
        SetOfLabAttachmentRec.add('Urine Pregnancy Test');
       
    
        //MedicalListForm
        for(Medical__c iMed : [SELECT id,name,RecordType.Id,RecordType.Name,Recordtype.DeveloperName,status__c,LA_Title__c,Client_Chart__r.Name,Signed_User__c, Closed_Date__c, Due_Date_Time__c,
                               MC_Evaluation_Date__c FROM Medical__c WHERE Client_Chart__c =:ccRecordId order by ID]){
        
       
          
          if(SetOfRecordType.contains(iMed.RecordType.Name)){
              
               if(ccRecordType != null && ccRecordType != '' && ccRecordType == 'Willowsprings Recovery')
                {
                    if(iMed.RecordType.Name != 'Psychiatric Progress Notes')
                        MedicalListForm.add(iMed);
                }else{
                    if(iMed.RecordType.Name != 'PROVIDER CONSULTATION')
                        MedicalListForm.add(iMed);
                }
              
          }
           else if(SetOfLabAttachmentRec.contains(iMed.RecordType.Name)){
        
            LabListForm.add(iMed);
          }
          
           //Commented By Safia Osman - 8-April-2018
        /*
          if(iMed.RecordType.Name == 'PROVIDER CONSULTATION' || iMed.RecordType.Name == 'Oustide referal note' || iMed.RecordType.Name == 'Admit Order' || iMed.RecordType.Name == 'Doctors Note' ||
                iMed.RecordType.Name == 'Evaluation Addendum' ||
                iMed.RecordType.Name == 'Nursing Assessment' || iMed.RecordType.Name == 'Nursing Reassessment' ||
                iMed.RecordType.Name == 'Psychiatric Progress Notes'|| iMed.RecordType.Name == 'Medical Attachment' ){
                
                if(ccRecordType != null && ccRecordType != '' && ccRecordType == 'Willowsprings Recovery')
                {
                    if(iMed.RecordType.Name != 'Psychiatric Progress Notes')
                        MedicalListForm.add(iMed);
                }else{
                    if(iMed.RecordType.Name != 'PROVIDER CONSULTATION')
                        MedicalListForm.add(iMed);
                }
              
          }
          else{
        
            LabListForm.add(iMed);
          }*/
                               
       }
       /*
       Modified by Zain to add Clinical Evaluation's History & Physical and Psych Evaluation forms
       */
       for(Clinical_Evaluation__c ce: [select id, name, RecordType.Name, Status__c, Client_Chart__r.Name, Client_Chart__c,FFE_Evaluation_Start_Time__c,
                                       Due_Date_time__c, (select id, SignedBy__c, HP_Status__c, Staff_Closed_Date__c, Staff_Signature_URL_Closed__c ,Client_Image_Url_Closed__c, Staff_Signed_User_Closed__c from Clinical_Evaluations_3__r) from Clinical_Evaluation__c
                                        where Client_Chart__c =:ccRecordId AND recordtype.Name = 'Phsych Evaluation' order by ID ])
        {
            cePsychEvList.add(ce);                              
        }
        
        for(Clinical_Evaluation_3__c ce3: [select id, name, RecordType.Name, Client_Chart__c, Client_Chart__r.Name,HP_Status__c, SignedBy__c, Due_Date_time__c,Staff_Signature_URL_Closed__c ,
                                            HP_Evaluation_Date__c, Staff_Closed_Date__c, Client_Image_Url_Closed__c, Staff_Signed_User_Closed__c from Clinical_Evaluation_3__c where Client_Chart__c =:ccRecordId AND 
                                            (recordtype.Name = 'History And Physical' OR recordtype.Name = 'Phsych Evaluation') order by ID  ])
        {
            ceHistoryPhyList.add(ce3);                                      
        }
    }
    public List<Medical__c> getMedicalLst(){
        List<Medical__c> medicalLst = new List<Medical__c>();
        if(ccRecordId!= null){
            medicalLst = [SELECT id,name,RecordType.Id,
                               RecordType.Name,
                               status__c,Client_Chart__r.Name,Signed_User__c,
                               MC_Evaluation_Date__c 
                           FROM Medical__c 
                           WHERE Client_Chart__c =:ccRecordId limit 50];
         }
         return medicalLst;
         
    }
    
    
  
    
    public void BacktoMedicalHome(){
        ShowMedicalRecPage= true;
        ShowMedicalFormRecTypes = false;
        ShowMedicalConsultForm = false;
        ShowMedicalDetoxForm = false;
        ShowMedicalLabAttachmentForm= false;
        showAdmitOrderForm = false;
        ShowOustidereferalnoteform = false;
        ShowDrugScreenForm  = false;
        ShowUrinePregnacyTestForm = false;


    }
    
    public void AddNewForm(){
    
        SelectedOption = SelectedOption.subString(0,SelectedOption.length() - 1);
        List<medical__c> lstOfNewMedicalForm = new List<medical__c>();
        
     
      
        //string MedicalDetoxRtId= Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Medical Detox Follow-up').getRecordTypeId();*/
       

        
        for(string value : SelectedOption.split(',')){
            MecicalIns = new medical__c();
            MecicalIns.Client_Chart__c = ccRecordId ;
            MecicalIns.RecordTypeID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get(value).getRecordTypeId();
            MecicalIns.Status__c = 'Open';
            lstOfNewMedicalForm .add(MecicalIns);
        }
        insert  lstOfNewMedicalForm ;
                    system.debug('Testrecordss1'+lstOfNewMedicalForm );

        ID newVSIns = null;
        List<Recurring_Assessment__c> newVSInsList = [Select Id from Recurring_Assessment__c 
                         WHERE RecordType.DeveloperName='Vital_Signs' and Client_Chart__c=:ccRecordId  
                        and Status__c='Closed' order by LastModifiedDate desc limit 1];
        if(newVSInsList.size()>0)
            newVSIns = newVSInsList[0].Id;
        
        Medical__c DrugScreenIns = new Medical__c(); 
 
        List<Medical__c> lstMedical =[SELECT Id  FROM Medical__c WHERE RecordType.DeveloperName='Drug_Screen' and Client_Chart__c=:ccRecordId  
                                    and Status__c='Closed'  order by Medical_Closed_Date__c desc limit 1];
       
       ID DrugID;                
       if(!lstMedical.isEmpty())
            DrugID = lstMedical[0].ID;
        
        system.debug('**************************   ' +DrugID );
        AddJunctionRecords(DrugID , lstOfNewMedicalForm ,newVSIns);
        
        
        
       
        //bind the list again to get the latest records;
        GetMedicalList();
        SelectedOption ='';
    }
    
    void AddJunctionRecords(ID aDrugScreenID, List<medical__c> aLstMedicalForm ,ID aRecurringAss ){
        
          string ProviderConsultation_RTID = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Provider Consultation').getRecordTypeId();
          list<UtlizationReviewOrder__c> LstNewJunc = new list<UtlizationReviewOrder__c>();
          UtlizationReviewOrder__c NewJuncIns ;
           for(medical__c MedIns : aLstMedicalForm ){
                    system.debug('%%%%%%');       
                if(MedIns.RecordTypeID == ProviderConsultation_RTID){
                         system.debug('%%%*****');  
                    NewJuncIns = new  UtlizationReviewOrder__c ();
                    NewJuncIns.Medical__c=MedIns.id;
                    NewJuncIns.Vital_Sign__c=aRecurringAss; 
                    LstNewJunc.add(NewJuncIns); 
               }
            
                if(MedIns.RecordTypeID == ProviderConsultation_RTID && aDrugScreenID != NULL ){
                    NewJuncIns = new  UtlizationReviewOrder__c ();
                    NewJuncIns.Medical__c = MedIns.id;
                    newJuncIns.DrugScreen__c = aDrugScreenID;
                    LstNewJunc.add(NewJuncIns); 

                
                }
            
        
        }
         if(!LstNewJunc.isEmpty())
            Insert LstNewJunc;
        
    }
    
   
    
    public void closePopup() {
        displayPopup = false;
    }

    public void showPopup() {
        displayPopup = true;
     }
     

    
}