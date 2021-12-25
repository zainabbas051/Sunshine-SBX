//Test Class : LeadHelperBatchTest
global class LeadHelperBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    string query;
    
    global LeadHelperBatch(){
        query = 'select id, Lead_Id__c, Time_Lead_Qualified__c, Unassigned_or_ERP_Queue_Lead__c, Intake_Queue_Lead_Flag__c, Time_Lead_Assigned_To_Intake_Queue__c, Time_Unassigned_ERP_Queue_Lead_Created__c from Lead_Helper__c';
        if(Test.isRunningTest())
            query += ' limit 200';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        
        set<Id> leadId = new set<Id>();
        list<Lead> leadList = new list<Lead>();
        list<Lead> leadUpdate = new list<Lead>();
        list<Lead_Helper__c> leadHelperList = new list<Lead_Helper__c>();
        list<Lead_Helper__c> leadHelperDelete = new list<Lead_Helper__c>();
        List<Id> smsUserIdList = new List<Id>();
        list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();
        List<user> userList = new List<User>();
        
                            
        for(Lead_Helper__c lh : (list<Lead_Helper__c>) scope){
            if(lh.Unassigned_or_ERP_Queue_Lead__c == False && lh.Intake_Queue_Lead_Flag__c == False){
                Decimal nowVar = dateTime.now().getTime();
                Decimal tlqVar = lh.Time_Lead_Qualified__c.getTime();
                system.debug('nowVar :::'+nowVar);
                system.debug('tlqVar :::'+tlqVar);
                Decimal var = (nowVar - tlqVar);
                system.debug('var value :::'+var);
                Decimal varFinal = var/1000;
                system.debug('varFinal value :::'+varFinal); 
                if(varFinal > 360.0)//The minimum Time Before the lead should go back to Closers Queue is 6 Minutes
                    leadId.add(lh.Lead_Id__c);
            }else if(lh.Unassigned_or_ERP_Queue_Lead__c == True && lh.Intake_Queue_Lead_Flag__c == False){
                Decimal nowVar = dateTime.now().getTime();
                Decimal tlqVar = lh.Time_Unassigned_ERP_Queue_Lead_Created__c.getTime();
                system.debug('nowVar :::'+nowVar);
                system.debug('tlqVar :::'+tlqVar);
                Decimal var = (nowVar - tlqVar);
                system.debug('var value :::'+var);
                Decimal varFinal = var/1000;
                system.debug('varFinal value :::'+varFinal); 
                if(varFinal > 180.0)//The minimum Time Before the lead should go to Intake Queue is 3 Minutes
                    leadId.add(lh.Lead_Id__c);
            }else if(lh.Unassigned_or_ERP_Queue_Lead__c == False && lh.Intake_Queue_Lead_Flag__c == True){
                Decimal nowVar = dateTime.now().getTime();
                Decimal tlqVar = lh.Time_Lead_Assigned_To_Intake_Queue__c.getTime();
                system.debug('nowVar :::'+nowVar);
                system.debug('tlqVar :::'+tlqVar);
                Decimal var = (nowVar - tlqVar);
                system.debug('var value :::'+var);
                Decimal varFinal = var/1000;
                system.debug('varFinal value :::'+varFinal); 
                if(varFinal > 180.0)//The minimum Time Before the We should Resend SMS to Intake Number if the Lead Owner is Still Intake Queue is 3 Minutes
                    leadId.add(lh.Lead_Id__c);
            }
        }
        
        if(leadId.size()>0){
            leadList = [select id, FirstName, LastName, OwnerId, isConverted, Lead_Returned_to_Closure_Queue__c, Lead_Claimed_By_AC__c from Lead where ID IN: leadId];
        }
        
        if(leadList.size()>0){
            for(GroupMember gm : [Select UserOrGroupId, GroupId,Group.Name From GroupMember where GroupId =: Label.Closers_Queue_Id]){
                smsUserIdList.add(gm.UserOrGroupId);
            }
            
            if(smsUserIdList.size()>0){
                for(User u : [SELECT name,mobilephone from user where id IN: smsUserIdList]){
                    userList.add(u);
                }
            }
            for(Lead_Helper__c lh : (list<Lead_Helper__c>) scope){
                for(Lead l : leadList){
                    if(l.id == lh.Lead_Id__c){
                        if(lh.Unassigned_or_ERP_Queue_Lead__c == False && lh.Intake_Queue_Lead_Flag__c == False){
                            if(l.Lead_Claimed_By_AC__c == False && l.isConverted == False){
                                l.OwnerId = Label.Closers_Queue_Id;
                                l.Lead_Returned_to_Closure_Queue__c = True;
                                leadUpdate.add(l);
                                leadHelperDelete.add(lh);
                                
                                if(userList.size()>0){
                                    for(User u : userList){
                                        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c(); 
                                        smsObject.smagicinteract__SenderId__c = '13173155065';
                                        smsObject.smagicinteract__PhoneNumber__c =u.MobilePhone;
                                        smsObject.smagicinteract__Name__c =u.name;
                                        smsObject.smagicinteract__disableSMSOnTrigger__c =1;
                                        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                                        smsObject.smagicinteract__SMSText__c = 'New Lead in Closers Queue : '+l.Firstname+' '+l.LastName;
                                        lstSendSMS.add(smsObject); 
                                        
                                    }
                                }
                            }
                            else{
                                leadHelperDelete.add(lh);
                            }
                        }else if(lh.Unassigned_or_ERP_Queue_Lead__c == True && lh.Intake_Queue_Lead_Flag__c == False){
                            //check to see if the lead is still owned by Unassigned to ERP Call Queue
                            if((l.OwnerId == Label.Unassigned_Queue_ID || l.OwnerId == Label.ERP_Call_Queue_ID) && l.isConverted == False){
                                l.OwnerId = Label.Intake_Queue_ID;//change the owner to Intake Queue
                                leadUpdate.add(l);
                                leadHelperDelete.add(lh);
                                
                                set<string> setPhones = new set<string>();
                                setPhones.add('+12486021423');//Adding the number of Common Intake Mobile Phone Number
                                setPhones.add(label.Tom_Kearns_Phone);//Adding Tom Kearns Phone Number from Custom Label
                            
                                for(string p : setPhones){
                                    smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c(); 
                                    smsObject.smagicinteract__SenderId__c = '13173155065';
                                    smsObject.smagicinteract__PhoneNumber__c =p;
                                    smsObject.smagicinteract__Name__c ='Tom Kearns';
                                    smsObject.smagicinteract__disableSMSOnTrigger__c =1;
                                    smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                                    smsObject.smagicinteract__SMSText__c = 'New Lead in Intake Queue : '+l.Firstname+' '+l.LastName;
                                    lstSendSMS.add(smsObject);
                                } 
                            }
                            else{
                                leadHelperDelete.add(lh);
                            }
                        }else if(lh.Unassigned_or_ERP_Queue_Lead__c == False && lh.Intake_Queue_Lead_Flag__c == True){
                            //check to see if the lead is still owned by Intake Queue
                            if(l.OwnerId == Label.Intake_Queue_ID && l.isConverted == False){
                                leadHelperDelete.add(lh);
                                
                                set<string> setPhones = new set<string>();
                                setPhones.add('+12486021423');//Adding the number of Common Intake Mobile Phone Number
                                //setPhones.add(label.Tom_Kearns_Phone);//Removed Text to Tom, as per his request.
                            
                                for(string p : setPhones){
                                    smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c(); 
                                    smsObject.smagicinteract__SenderId__c = '13173155065';
                                    smsObject.smagicinteract__PhoneNumber__c =p;
                                    smsObject.smagicinteract__Name__c ='Tom Kearns';
                                    smsObject.smagicinteract__disableSMSOnTrigger__c =1;
                                    smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                                    smsObject.smagicinteract__SMSText__c = 'New Lead Still in Intake Queue : '+l.Firstname+' '+l.LastName;
                                    lstSendSMS.add(smsObject);
                                } 
                            }
                            else{
                                leadHelperDelete.add(lh);
                            }
                        }
                    }
                }
            }
        }
        
        if(lstSendSMS.size()>0){
            if(!Test.isRunningTest()){
                String response = smagicinteract.ApexAPI.pushSMSCallout(lstSendSMS);
                system.debug('response ::::'+response);
                Database.insert(lstSendSMS,false);
            }
        }
        
        
        if(leadHelperDelete.size()>0){
            delete leadHelperDelete;
        }
        if(leadUpdate.size()>0){
            update leadUpdate;
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC){

    }
}