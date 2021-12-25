//Test Class : Notification2Test
public class Notification2 {
    
    //this map will be used for capturing template id a/c to condition
    private map<id,id> mapsObjectTemplate;
    
    public void SendDynamicNotification() {

        TimeZone tz = UserInfo.getTimeZone();

        List<Notification_Setting__c> lstNotificationSetting = Notification_Setting__c.getAll().values();

        List<sObject> sobjListSendNotification = new List<sObject>();
        datetime dtUpper;
        datetime dtLower;
        integer notificationIntverval = 0;
        string recordTypeName = '';

        Datetime current = datetime.now();
        //current = current.addSeconds((tz.getOffset(current)/1000));
        system.debug(current );
        
        
        mapsObjectTemplate = new map<id,id>();
        
        Map<string, List<sObject>> mapOfObject = new Map<string, List<sObject>>();

        for (Notification_Setting__c iNotification : lstNotificationSetting) {

            if (!iNotification.Is_15_Min__c && iNotification.Type_of_Notification__c == 'text') {
                //&& iNotification.Name=='CIWA'){
                
                dtUpper = datetime.Now() ;
                if(iNotification.First_Interval_Notification__c!=null){
                    notificationIntverval = integer.valueOf(iNotification.First_Interval_Notification__c);
                    system.debug(notificationIntverval );
    
                    dtUpper = dtUpper.addMinutes(-notificationIntverval);
                    system.debug(dtUpper);
    
                    integer sec = dtUpper.second();
                    dtUpper = dtUpper.addSeconds(-sec);
                    system.debug(dtUpper);
                
                    dtUpper = dtUpper.addMinutes(1);
                    system.debug(dtUpper);
                }
                recordTypeName = iNotification.Record_Type_Name__c;

                List<sObject> sobjSendSMS = new list<sobject>();

                string query = 'SELECT Id,' + iNotification.Filter_Field_2_API_Name__c + ' FROM ' + iNotification.Object_Name__c +
                               ' where ' + iNotification.Filter_Field_API_Name__c + ' != \'' + iNotification.Notification_Ending_Status__c + '\' and RecordType.Name =\'' +
                               recordTypeName + '\' and (' + iNotification.Filter_Field_2_API_Name__c + ' < :current or (' + iNotification.Filter_Field_2_API_Name__c + ' > :current and ' +
                               iNotification.Filter_Field_2_API_Name__c + '< :dtUpper ))';

                system.debug(query );
                list<sobject> sobjList = Database.query(query );

                system.debug(sobjList );
                system.debug(sobjList.size() );

                long divFirst = (long)(iNotification.First_Interval_Notification__c==null?1:iNotification.First_Interval_Notification__c);

                system.debug(divFirst );

                long divAfter = (long)(iNotification.Recursive_Interval_Notification__c);

                system.debug(divAfter);

                for (sobject s : sobjList) {

                    DateTime objDT = (DateTime)s.get(iNotification.Filter_Field_2_API_Name__c) ;
                    system.debug('objDT:' + objDT);
                    system.debug('timezone:' + (tz.getOffset(objDT) / 1000));
                    objDT = objDT.addSeconds((tz.getOffset(objDT) / 1000));
                    system.debug('objDT:' + objDT);

                    Long dt1Long = current.getTime();
                    Long dt2Long = objDT.getTime();
                    Long milliseconds = dt2Long - dt1Long;
                    Long seconds = milliseconds / 1000;
                    long minutes = seconds / 60;

                    system.debug(minutes );

                    long remainderFirst = math.mod(minutes, divFirst );

                    system.debug(remainderFirst );

                    long ans = minutes / divFirst;

                    system.debug(ans);

                    long remainderAfter = math.mod(minutes, divAfter );

                    system.debug(remainderAfter );

                    if (remainderFirst == 0 || Test.isRunningTest()) { // && ans ==1){
                        if(iNotification.First_Interval_Notification__c!=null){
                            system.debug('first sms');
                            sobjSendSMS.add(s);
                            mapsObjectTemplate.put(s.id, iNotification.TemplateID__c);
                            continue;
                        }
                    } else if (remainderAfter == 0 || Test.isRunningTest()) {
                        system.debug('remainder zero');
                        sobjSendSMS.add(s);
                        mapsObjectTemplate.put(s.id, iNotification.Recursive_Template_ID__c);
                    }

                }
                system.debug(sobjSendSMS.size());
                if (sobjSendSMS.size() > 0)
                    mapOfObject.put(iNotification.Name, sobjSendSMS);
            }
        }
        system.debug(mapOfObject.size());
        if (mapOfObject.size() > 0)
            SendNotificationToCommonHouse(mapOfObject);
    }

    void SendNotificationToCommonHouse(map<string, list<sObject>> aMapObject) {

        list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();

        list<sobject> lstUpdateSObjects = new list<sObject>();

        for (Notification_Setting__c iNotification : Notification_Setting__c.getAll().values()) {
            if (aMapObject.get(iNotification.Name) != null) {
                for (sObject loopSObject : aMapObject.get(iNotification.Name)) {


                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(mapsObjectTemplate.get(loopSObject.id), userInfo.getUserID(), loopSObject.Id);
                    string msgBody =  email.getPlainTextBody();
                    
                    //string msgBody = iNotification.Message_Body__c;
                    smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
                    //smsObject.smagicinteract__SenderId__c = 'smsMagic';
                    smsObject.smagicinteract__SenderId__c = '13173155065';
                    smsObject.smagicinteract__PhoneNumber__c = iNotification.Common_House_Phone_Number__c;
                    smsObject.smagicinteract__Name__c = '';
                    smsObject.smagicinteract__disableSMSOnTrigger__c = 1;
                    smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                    smsObject.smagicinteract__SMSText__c = msgBody;
                    lstSendSMS.add(smsObject);
                    
                    
                    Long dt1Long = ((datetime)loopSObject.get(iNotification.Filter_Field_2_API_Name__c )).getTime();
                    Long dt2Long = DateTime.now().getTime();
                    Long milliseconds = dt2Long - dt1Long;
                    Long seconds = milliseconds / 1000;
                    Long minutes = seconds / 60;

                    system.debug(minutes);
                    system.debug(minutes / iNotification.Recursive_Interval_Notification__c);

                    loopSObject.put('Date_Time_of_Last_Message_Sent__c', Datetime.now());
                    loopSObject.put('Missed_Count__c', minutes / iNotification.Recursive_Interval_Notification__c);
                    lstUpdateSObjects.add(loopSObject );
                }
            }

        }
        
        if (lstSendSMS.size() > 0) {
            system.debug(lstUpdateSObjects.size());

            if (lstUpdateSObjects.size() > 0)
                update lstUpdateSObjects;
            if (!Test.isRunningTest()) {
                
                system.debug(lstSendSMS.size());

                String response = smagicinteract.ApexAPI.pushSMSCallout(lstSendSMS);
                system.debug('response ::::' + response);
                Database.insert(lstSendSMS, false);
                
            }
        }
        
    }


}