//Author : DANISH FAROOQ
//test class : COWS_popupCtrlTest
public  virtual class RA_Handler {
    
    
  
    
    public void CreateOpenCOWS(string aClientChart){
        
         List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, COWS_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                         COWS_Assessment_Required__c = TRUE and Client_Chart__c=:aClientChart];
            
            if(listConfigRA.size() > 0){
                Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='COWS-' + Crypto.getRandomInteger(),
                                                                           Time_Due__c = Datetime.now().addHours(Integer.valueOf(listConfigRA[0].COWS_Assessment_Recurring_Time__c.replace('Q','').replace(' Hours',''))),
                                                                           RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                            get('COWS').getRecordTypeId(),
                                                                           Client_Chart__c=aClientChart,
                                                                           Status__c='Open');
                
                insert raNew;
            }
    }
    
    public void CreateOpenBMI(string aClientChart){
        
         List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, BMI_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      BMI_Assessment_Required__c = TRUE  and Client_Chart__c =: aClientChart];
        
        if(listConfigRA.size() > 0){
            list<string> rtime = listConfigRA[0].BMI_Assessment_Recurring_Time__c.split(' ');
            integer Hours = 0;
            if(listConfigRA[0].BMI_Assessment_Recurring_Time__c.contains('Days'))
                Hours = 24 * integer.valueof(rtime[1]);
            else
                Hours = integer.valueof(rtime[0]);
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='BMI-' + Crypto.getRandomInteger(),
                                                                        Time_Due__c = Datetime.now().addHours(Hours ),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('BMI').getRecordTypeId(),
                                                                        Client_Chart__c=aClientChart,
                                                                        Status__c='Open');
            
          IF(!test.isRunningTest())
            insert raNew;
        }
    }
    
     public void CreateOpenCIWA(string aClientChart){
        
        List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, CIWA_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      CIWA_Assessment_Required__c = TRUE and Client_Chart__c =: aClientChart];
        
        if(listConfigRA.size() > 0){
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='CIWA-' + Crypto.getRandomInteger(),
                                                                        Time_Due__c = Datetime.now().addHours(Integer.valueOf(listConfigRA[0].CIWA_Assessment_Recurring_Time__c.replace('Q','').replace(' Hours',''))),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('CIWA').getRecordTypeId(),
                                                                        Client_Chart__c = aClientChart,
                                                                        Status__c='Open');
            
            insert raNew;
        }
    }
    
    public void CreateOpenVS(string aClientChart ,string aVitalSignID){
        
         List < Recurring_Assessment__c > lstRAVT = [SELECT Id, Vital_SIgns_Recurring_Time__c  FROM Recurring_Assessment__c WHERE 
                                                        Vital_SIgns_Required__c = TRUE and Client_Chart__c =: aClientChart and RecordType.Name = 'Configurations'];
            
            if(!lstRAVT.isEmpty()){
                  string rtime = lstRAVT[0].Vital_SIgns_Recurring_Time__c.replace('Q','').replace(' Hours','');
                 if (rtime == 'BID')
                    rtime = '12';
             // CREATE NEW VITAL RECORD        
                Recurring_Assessment__c raNewVitalSign = new Recurring_Assessment__c(Name='VS-' + Crypto.getRandomInteger(),
                                                                       Time_Due__c = Datetime.now().addHours(Integer.valueOf(rtime)),
                                                                       RecordTypeId = aVitalSignID,
                                                                       Client_Chart__c = aClientChart,
                                                                       Status__c='Open');
               insert raNewVitalSign;
        }
    }
    
      public void CreateOpenGlucose(string aClientChart){
          
           List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, Blood_Glucose_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Blood_Glucose_Assessment_Required__c = TRUE  and Client_Chart__c =: aClientChart];
        
        if(listConfigRA.size() > 0){
            string RTime = listConfigRA[0].Blood_Glucose_Assessment_Recurring_Time__c;//.replace('Q','').replace(' Hours','');
            if(RTime == 'BID')
                RTime = '12';
            else if(RTime == 'TID')
                RTime = '8';
            else if(Rtime == 'QID')
                RTime = '6';
            else if(RTime == 'QDaily')
                RTime = '24';
            else if(RTime.contains('Hours'))
                RTime = RTime.replace('Q','').replace(' Hours','');
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='Blood Glucose-' + Crypto.getRandomInteger(),
                                                                        Time_Due__c = Datetime.now().addHours(Integer.valueOf(RTime)),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('Blood Glucose').getRecordTypeId(),
                                                                        Client_Chart__c = aClientChart,
                                                                        Status__c='Open');
            
               if(!test.isRunningTest())
                insert raNew;
        }
      }
      
      public void CreateOpenWellNess(string aClientChart){
          
         List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, Wellness_Recurring_Time__c  FROM Recurring_Assessment__c WHERE 
                                                      Wellness_Check_Required__c= TRUE  and Client_Chart__c =: aClientChart];
        
        if(listConfigRA.size() > 0){
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='Wellness-' + Crypto.getRandomInteger(),
                                                                        Time_Due__c = Datetime.now().addMinutes(Integer.valueOf(listConfigRA[0].Wellness_Recurring_Time__c.replace('Q','').replace(' Hours',''))),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('Wellness Check').getRecordTypeId(),
                                                                        Client_Chart__c=aClientChart,
                                                                        Status__c='Open');
            
            insert raNew;
        }
      }
      
        public void CreateOpenDetox(string aClientChart){
          
           List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, Detox_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                          Detox_Required__c = TRUE  and Client_Chart__c =: aClientChart];
            
            if(listConfigRA.size() > 0){
                Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='Detox-' + Crypto.getRandomInteger(),
                                                                            Time_Due__c = Datetime.now().addMinutes(Integer.valueOf(listConfigRA[0].Detox_Recurring_Time__c.replace('Q','').replace(' Hours',''))),
                                                                            RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                            get('Detox Check').getRecordTypeId(),
                                                                            Client_Chart__c=aClientChart,
                                                                            Status__c='Open');
                
                insert raNew;
            }
      }
        
}