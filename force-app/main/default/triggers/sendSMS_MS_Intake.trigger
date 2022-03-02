//Test Class : sendSMS_MS_Intake_Test
trigger sendSMS_MS_Intake on Lead (after update){
    Public Boolean textRequired = False;//Flag to see if a TEXT is needed to be sent
    Public Boolean testClassCheckbox = False;//Flag to make sure Test Class works
     
    list<Id> leadId = new list<Id>();
    list<lead> leadUpd = new list<Lead>();
    
    system.debug('isFirstRun is:'+TriggerContextUtility.isFirstRun());
    
    Id msRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
       
                
    for(Lead ld : Trigger.New){
        if(ld.RecordTypeId == msRecTypeId && ld.isConverted==False && ld.OwnerId == label.Intake_Queue_ID && 
            (ld.Text_Sent_Queues__c==null || !ld.Text_Sent_Queues__c.contains(ld.OwnerId)) ){
            leadId.add(ld.Id);
            textRequired = True;
        }
    }
        
    if(textRequired == True){
            
        if(TriggerContextUtility.isFirstRun() == True){  
         
        List<smagicinteract__smsMagic__c> smsObjects = new List<smagicinteract__smsMagic__c>();
        String tplText = null;
        
        set<string> setPhones = new set<string>();
        setPhones.add('+12486021423');//Adding the number of Common Intake Mobile Phone Number
        setPhones.add(label.Tom_Kearns_Phone);//Adding Tom Kearns Phone Number from Custom Label
                    
        
        //Getting a list of all the leads to which texts need to be sent
        for(Lead l : [select id, OwnerId, Text_Sent_Queues__c, Name, Test_Class_Checkbox__c from Lead where Id IN: leadId]){
            
                for(string p : setPhones){
                    tplText = 'New Lead in Intake Queue : '+ l.Name;//body of the text
                    smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
                    smsObj.smagicinteract__PhoneNumber__c = p;//Phone Number to which text is sent
                    smsObj.smagicinteract__SMSText__c = tplText;
                    //smsObj.smagicinteract__senderId__c = 'smsMagic';
                    smsObj.smagicinteract__senderId__c = '13173155065';
                    smsObj.smagicinteract__Name__c = 'Tom Kearns';
                    
                    smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                    smsObjects.add(smsObj);
                }
                l.Text_Sent_Queues__c = l.Text_Sent_Queues__c +';'+l.OwnerId;
                leadUpd.add(l);
                continue;
           
                testClassCheckbox = l.Test_Class_Checkbox__c;//Used as a dummy boolean flag for Test Class to avoid WEB SERVICE CALL
            }
            if(testClassCheckbox == False){//Used as a dummy boolean flag for Test Class to avoid WEB SERVICE CALL  
                if(!Test.isRunningTest()){
                    try{
                        insert smsObjects;//a list of all Texts that need to be sent
                    }Catch(exception e){
                        
                    }
                }
            }
        }                        
        
        if(leadUpd.size()>0){
            try{
                update leadUpd;//Updating the leads with text sent flags
            }catch(exception e){
                
            }
            
        }         
        TriggerContextUtility.setFirstRunFalse();   
    } 
}