/*
test class : clientChartTabsPageTest
*/
public class clientChartTabsPage {
    public Client_Chart__c client{get;set;}
    public String dob {get;set;}
    public String admitDate{get;set;}
    public String dischargeDate{get;set;}
    public string allergies{get;set;}
    public Integer age {get; set;}
    Public Recurring_Assessment__c ra{get;set;}
    Public Boolean raMain{get;set;}
    Public Boolean flagCIWA{get;set;}
    public string Diagnosis {get; set;}
    public string AvailableTabs { get;set;}
   
    //Public boolean showRAMain{get;set;}
    public boolean showURMain {get;set;}
    public boolean showPHIMain{get;set;}
    public boolean showAIRMain {get;set;}
    public boolean showCNMain{get;set;}
    public boolean showFaceChrt { get;set;}
  
    
    public clientChartTabsPage(ApexPages.StandardController stdController) {
       
            try{
                 GetClients();
                dob = client.DOB__c != null? (DateTime.newInstance(client.DOB__c.year(),client.DOB__c.month(),client.DOB__c.day()).format('d-MMM-YYYY')) : '';
                admitDate = client.Admit_Date_Time__c != null?  (DateTime.newInstance(client.Admit_Date_Time__c.year(),client.Admit_Date_Time__c.month(),client.Admit_Date_Time__c.day()).format('d-MMM-YYYY')) : '';
                dischargeDate = client.Discharge_Date_Time__c != null? (DateTime.newInstance(client.Discharge_Date_Time__c.year(),client.Discharge_Date_Time__c.month(),client.Discharge_Date_Time__c.day()).format('d-MMM-YYYY')) : '';
                Integer days = client.DOB__c != null? (client.DOB__c.daysBetween(Date.Today())) : null;
                age = days != null? (Integer.valueOf(days/365)) : null;
               
                Diagnosis = '';
                if(client.Diagnosis_Code__c!=null)
                {
                    for(string code: client.Diagnosis_Code__c.split(';'))
                        if(code!= null && !string.isBlank(code))
                            Diagnosis +=code + '<br/>';
                }
                Diagnosis = Diagnosis.removeEnd('<br/>');
              
                
                //Recurring Assessment
                //showRAMain = false;
                showURMain = false;
                showPHIMain = false;
                showAIRMain  = false;
                showCNMain = false;
                //System.debug('inside cons:: ' + showRAMain);
                //RecurringAssessments();
            }
            catch(Exception e){
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,e.getMessage()+' '+e.getLineNumber());
                ApexPages.addMessage(errMsg);
            }
            
        
    }
    
    
    public clientChartTabsPage() {
        
            try{
                
                User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
                
                AvailableTabs = 'none';
        
                if(string.isNotBlank(u.Acess_Type__c)){
                    AvailableTabs = '';
            
                    Map<String,TabViews__c> allTabs = TabViews__c.getAll();
                    
                    for(string key : allTabs.keySet()){
                        
                        TabViews__c tabValue = allTabs.get(key);
                        
                        for(string access : u.Acess_Type__c.split(';')){
                            
                            if(tabValue.Tabs_Access_Type__c.contains(access) && !tabValue.Is_Main_Tab__c)
                                AvailableTabs += key;
                        }
                        
                    }
                }
                
                GetClients();
                dob = client.DOB__c != null? ( DateTime.newInstance(client.DOB__c.year(),client.DOB__c.month(),client.DOB__c.day()).format('d-MMM-YYYY')) : '';
                admitDate = client.Admit_Date_Time__c != null?  (DateTime.newInstance(client.Admit_Date_Time__c.year(),client.Admit_Date_Time__c.month(),client.Admit_Date_Time__c.day()).format('d-MMM-YYYY')) : '';
                dischargeDate = client.Discharge_Date_Time__c != null? ( DateTime.newInstance(client.Discharge_Date_Time__c.year(),client.Discharge_Date_Time__c.month(),client.Discharge_Date_Time__c.day()).format('d-MMM-YYYY')) : '';
                Integer days = client.DOB__c != null?  (client.DOB__c.daysBetween(Date.Today())) : null;
                age = days != null? (Integer.valueOf(days/365)) : null;
               
                allergies = '';   
                for(Allergies__c iArr : [Select id ,Allergen__c from Allergies__c where Client_Chart__c =: client.Id ]){
                    allergies += iArr.Allergen__c +','; 
                }
                
                allergies = allergies.removeEnd(',');
                Diagnosis = '';
                if(client.Diagnosis_Code__c!=null)
                {
                    for(string code: client.Diagnosis_Code__c.split(';'))
                        if(code!= null && !string.isBlank(code))
                            Diagnosis +=code + '<br/>';
                }
                Diagnosis = Diagnosis.removeEnd('<br/>');
                //Recurring Assessment
                //showRAMain = false;
                showURMain = false;
                showPHIMain = false;
                showAIRMain  = false;
                showCNMain = false;
                //System.debug('inside cons:: ' + showRAMain);
                //RecurringAssessments();
                
            }
            catch(Exception e){
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,e.getMessage()+' '+e.getLineNumber());
                ApexPages.addMessage(errMsg);
            }
       
    }
    
    public void GetClients(){
         Id clientId = ApexPages.CurrentPage().getParameters().get('id');
         if(clientId == null) return; 
         
        client = [SELECT id,Name,DOB__c, Age__c, Admit_Date_Time__c, Building__c, Room__c, Bed__c, Total_Age__c,
                  Discharge_Date_Time__c, Latest_Concurrent_Review__c, Latest_Concurrent_Review__r.Level_Of_Care__c, 
                  Latest_Concurrent_Review__r.Next_review_date__c, U_R_Location__c, Medical_Record_Number__c, Primary_Counsellor__r.Name, 
                  Primary_Therapist__r.Name, Special_Diet__c, Diagnosis_Code__c, Diet__c , Admissions_Coordinator__r.Phone
                  FROM Client_Chart__c WHERE id = :clientId limit 1];
    }
    
    
   
    
  /*  private void RecurringAssessments(){
        
        List<Recurring_Assessment__c> listConfigRA = [SELECT Id, CIWA_Assessment_Required__c, CIWA_Assessment_Recurring_Time__c ,
                                                     COWS_Assessment_Required__c, COWS_Assessment_Recurring_Time__c ,
                                                     Vital_SIgns_Required__c , Vital_SIgns_Recurring_Time__c FROM Recurring_Assessment__c
                                                      WHERE Name='Config'];
        if(listConfigRA.size() == 0)
            ra = new Recurring_Assessment__c();
        else
            ra = listConfigRA[0];
        
        //variables
        raMain = true;
        flagCIWA = false;
    }*/
    
    public PageReference RACIWA(){
        System.debug('inside:: ');
        
        raMain = false;
        flagCIWA = true;
        
        return null;
        
    }   
    
    Public PageReference RAMain(){
        
        //showRAMain = true;
        //System.debug('inside method:: ' + showRAMain);
        //
  
            return new PageReference('/apex/RAHome?id='+client.id);
    
    }
    
    
    
    
    
    Public PageReference PHIMain(){
        
        showPHIMain = true;
        System.debug('inside method:: ' + showPHIMain );
        return new PageReference('/apex/PHILogHomePage?id='+client.id);
        
    }
    
    public PageReference AIRMain(){
        showAIRMain = true;
        return new PageReference('/apex/AssessmentHomePage?id='+client.id);
        
    }
    
    public PageReference CNMain(){
        showCNMain = true;
        return new PageReference('/apex/ClinicalNotesHomePage?id='+client.id);
    }
    
    public PageReference TxDcMain(){
        return new PageReference('/apex/TxDcHomePage?id='+client.id);
    }
    
    public PageReference CEMain(){
        return new PageReference('/apex/ClinicalEvaluationHomePage?id='+client.id);
    }
    
    public PageReference IntakeMain(){
        return new PageReference('/apex/IntakeHomePage?id='+client.id);
    }
    
    public PageReference FSMain(){
        return new PageReference('/apex/FaceSheetHomePage?id='+client.id);
    }
    
    
    Public PageReference URMain(){
        
        //showURMain = true;
        
        return new PageReference('/apex/UtilizationReviewHomePage?id='+client.id);
        
    }
    
    public PageReference MedsMain(){
        return new PageReference('/apex/MedsHomePage?id='+client.id);
    }
    
    public PageReference MedicalMain(){
        return new PageReference('/apex/MedicalHomePage?id='+client.id);
    }
    public PageReference IRMain(){
        return new PageReference('/apex/IncidentReportsHomePage?id='+client.id);
    }
  
   
    
   
   
    
    public void updateRAConfig(){
        try{
            upsert ra;
        }
        catch(Exception ex){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));

        }
    }
    
}