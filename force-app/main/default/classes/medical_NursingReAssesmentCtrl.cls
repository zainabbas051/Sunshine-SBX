//Test Class : medical_NursingReAssesmentCtrlTest
public class medical_NursingReAssesmentCtrl {
    
         public Medical__c meds {get;set;}
     //   public boolean IsEdit {get;set;}
        public Recurring_Assessment__c VitalSign {get; set;}
          public Recurring_Assessment__c glucose {get; set;}
         //AWS
        public string accessKeyId {get; set;}
        public string secretAccessKey {get; set;}
        public string OrgName {get; set;}
        final string AWSURL;
        public string BodyChartUrl{get;set;}
        public List<Recurring_Assessment__c> lstGlucoseHistory {get;set;}
        
        public boolean IsEdit {get;set;}
        
        ID medicalID;
        public medical_NursingReAssesmentCtrl(){
            
            //IsEdit = true;
            accessKeyId = Constants.accessKeyId;
            OrgName = Constants.OrgName;
            AWSURL = 'http://freepu.s3.amazonaws.com/';
            secretAccessKey = Constants.secretAccessKey;
            if(apexPages.currentPage().getParameters().get('edit') != null){
                 IsEdit = true;
            }
        }
            
        
        
        public PageReference SaveMeds(){
            
            
            meds.Previous_Treatment_Image__c = AWSURL + BodyChartUrl;
            upsert meds;
            
              PageReference pr = new PageReference('/apex/MedicalHomeEditPage');
         pr.getParameters().put('ID',meds.Client_Chart__c);
         pr.getParameters().put('mcid',meds.ID);
         pr.getParameters().put('rt',apexPages.currentPage().getParameters().get('rt'));
         pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
         return pr;
            
            
        }
    
        public void QuickSaveMeds(){
            meds.Previous_Treatment_Image__c = AWSURL + BodyChartUrl;
            upsert meds;
        }
        
        public boolean ProcessGlusoseSign {
            
            get{
                
                boolean glucoseSign = false;
                if(meds.Status__c != 'Closed'){
                    
                   List<Recurring_Assessment__c> GlucoseList = [SELECT Id, Name, Note__c, Reading__c, Intervention__c,Type_Of_Check__c,Client_Chart__c,Time_Due__c, CreatedDate, Owner.Name,LastModifiedDate, Related_To__c, Related_To__r.Name ,Status__c
                                                            FROM Recurring_Assessment__c
                                                            WHERE RecordType.DeveloperName = 'Blood_Glucose' AND Status__c = 'Closed'  and Client_Chart__c=:  meds.Client_Chart__c  order by LastModifiedDate desc];
                    
                   
                  if(GlucoseList.isEmpty()) return false;
                  
                  lstGlucoseHistory = GlucoseList;
                  
                   glucose = GlucoseList[0];
                   List<UtlizationReviewOrder__c> toDelRecord = [Select Id from UtlizationReviewOrder__c where Medical__c =: meds.Id];
                   if(toDelRecord.size()>0)
                    {
                        Delete toDelRecord[0];
                    }
                    UtlizationReviewOrder__c toCreatedRecord = new UtlizationReviewOrder__c();
                    toCreatedRecord.Glucose__c = glucose.Id;
                    toCreatedRecord.Medical__c = meds.Id;
                    insert toCreatedRecord;
                    
                    glucoseSign = true;
                    
                        
                   
                }
                else{
                    List<UtlizationReviewOrder__c> junctionRecord = [Select Id,Glucose__c from UtlizationReviewOrder__c where Medical__c =: meds.Id];
                if(junctionRecord.size() > 0)
                {
                     List<Recurring_Assessment__c> RecAssList = [SELECT Id, Name, Note__c, Reading__c, Intervention__c,Type_Of_Check__c,Client_Chart__c,Time_Due__c, CreatedDate, Owner.Name,LastModifiedDate, Related_To__c, Related_To__r.Name ,Status__c
                                                                FROM Recurring_Assessment__c
                                                                WHERE RecordType.DeveloperName = 'Blood_Glucose' AND Status__c = 'Closed' 
                                                                and Id =: junctionRecord[0].Glucose__c];
                    if(RecAssList.size() >0)
                    {
                        glucoseSign = true;
                        glucose = RecAssList[0];
                    }
                }
                }
                    return glucoseSign;    
            }
        }
        
          public boolean ProcessVitalSign{
        get{
            boolean showVitalSign = false;
            if(meds.Status__c != 'Closed')
            {
                List<Recurring_Assessment__c> RecAssList = [Select Id, Name, Status__c, X02_Saturation__c, BP_Diastolic__c, BP_Systolic__c,
                                                            Temperature__c, Respirations__c, Pulse__c, LastModifiedDate from Recurring_Assessment__c
                                                            where Status__c = 'Closed' and Client_Chart__c =: meds.Client_Chart__c and Recordtype.name = 'Vital Signs' order by LastModifiedDate desc limit 1]; 
               
                  if(RecAssList.size()>0)
                {
                    try
                    {
                        VitalSign = RecAssList[0];
                        List<UtlizationReviewOrder__c> toDelRecord = [Select Id from UtlizationReviewOrder__c where Medical__c =: meds.Id];
                        if(toDelRecord.size()>0)
                        {
                            Delete toDelRecord[0];
                        }
                        UtlizationReviewOrder__c toCreatedRecord = new UtlizationReviewOrder__c();
                        toCreatedRecord.Vital_Sign__c = VitalSign.Id;
                        toCreatedRecord.Medical__c = meds.Id;
                        insert toCreatedRecord;
                        
                        System.debug('Vital Sings: ' + toCreatedRecord);
                        
                        showVitalSign = true;
                    }
                    catch(Exception ex)
                    {
                        string ExMessgae = 'Exception occured: '+ ex.getMessage() + ', on line: '+ ex.getLineNumber();
                        System.debug(ExMessgae);
                    }
                }
            }else{
                
                List<UtlizationReviewOrder__c> junctionRecord = [Select Id,Vital_Sign__c from UtlizationReviewOrder__c where Medical__c =: meds.Id];
                if(junctionRecord.size() > 0)
                {
                     List<Recurring_Assessment__c> RecAssList = [Select Id, Name, Status__c, X02_Saturation__c, BP_Diastolic__c, BP_Systolic__c,
                                                            Temperature__c, Respirations__c, Pulse__c, LastModifiedDate from Recurring_Assessment__c
                                                            where Status__c = 'Closed' and Client_Chart__c =:meds.Client_Chart__c and Recordtype.name = 'Vital Signs' and Id =: junctionRecord[0].Vital_Sign__c];
                    if(RecAssList.size() >0)
                    {
                        showVitalSign = true;
                        VitalSign = RecAssList[0];
                    }
                }
            }
            return showVitalSign;    
        }
        
    }
           
        
   
        
       
        
        
        
}