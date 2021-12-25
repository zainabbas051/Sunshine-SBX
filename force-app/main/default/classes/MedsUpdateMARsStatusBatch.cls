/*
    batch class for updating MARs status to Missed and Refused according to time.
    author Huma Zafar
*/
//Test Class : Meds_ControllersTest
global class MedsUpdateMARsStatusBatch implements Database.Batchable<sObject>{
    
    string query;
    
    global MedsUpdateMARsStatusBatch (){
        query = 'select id, Status__c, Pending_Time__c, Missed_Time__c,Frequency__c, Discontinued__c ,StartDateTime,WhatId '+
        ' from Event where (Status__c = \'Open\' or Status__c = \'Pending\') and RecordType.Name = \'MARs\'' +
        ' and PRN__c = false';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
         
        map<id,Event> mapDiscontinuedOrders = new map<id,Event>();
        
        list<Event> lstUpdateEvent = new list<Event>();
        
        for(Event e : (list<Event>)scope){
            if(e.Frequency__c.startswith('QDaily') && Datetime.now().hour() ==0 && DateTime.now().minute()==0){
                e.Status__c = 'Missed';   lstUpdateEvent.add(e);   
            }
            else if(e.Status__c == 'Open' && e.Discontinued__c && !e.Frequency__c.startswith('QDaily')){
                mapDiscontinuedOrders.put(e.WhatId,e);
            }
            else if(e.Status__c == 'Open' && e.Missed_Time__c !=null 
            && e.Missed_Time__c <= Datetime.now()
             && !e.Frequency__c.startswith('QDaily')){
                e.Status__c = 'Missed';   
                lstUpdateEvent.add(e);             
            }
            else if(e.Status__c == 'Pending' && e.Pending_Time__c!=null && e.Pending_Time__c<= Datetime.now() && !e.Frequency__c.startswith('QDaily')){
                e.Status__c = 'Refused';lstUpdateEvent.add(e);
            }
        }
        
        map<id,Order__c> mapOrders = new map<id,Order__c>([select id, Discontinue_Date_Time__c from Order__c 
        where id in: mapDiscontinuedOrders.keyset()]);
        
        for(Event e: mapDiscontinuedOrders.values()){
            if(mapOrders.get(e.WhatId).Discontinue_Date_Time__c <= Datetime.now()){
                e.Status__c = 'Inactive';
                lstUpdateEvent.add(e);
            }
        }
        
        
        
        try{
           if(lstUpdateEvent.size()>0)
                update lstUpdateEvent;            
        }
        catch(Exception e){
            
            //Uncomment Below this line.
            /*
            list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();
            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c(); 
            
            smsObject.smagicinteract__SenderId__c = 'smsMagic';
            smsObject.smagicinteract__PhoneNumber__c = '+15863424795';//u.MobilePhone;
            smsObject.smagicinteract__Name__c = 'Naveen';//u.name;
            smsObject.smagicinteract__disableSMSOnTrigger__c =1;
            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            smsObject.smagicinteract__SMSText__c = 'MedsUpdateMARsStatusBatch Exception: '+e.getMessage();
            lstSendSMS.add(smsObject); 
            
            if(lstSendSMS.size()>0){if(!Test.isRunningTest()){String response = smagicinteract.ApexAPI.pushSMSCallout(lstSendSMS);system.debug('response ::::'+response);Database.insert(lstSendSMS,false);}}
            */
        }
    }
    
    global void finish(Database.BatchableContext BC){
    
    }
    
}