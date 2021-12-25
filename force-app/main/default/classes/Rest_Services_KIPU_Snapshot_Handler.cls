//Test Class : Rest_Services_KIPU_Snapshot_HandlerTest
public  class Rest_Services_KIPU_Snapshot_Handler {
    
    public static Object kipuSnapshotService(String data){
        
        System.debug(data);
        
        
       
        try{
            
            String tempJSON = getFormatedJSONValue(data);
            
            
             KIPU_Snapshot_Wrapper   requestDataJSON = (KIPU_Snapshot_Wrapper)JSON.deserializeStrict(tempJSON, KIPU_Snapshot_Wrapper.class);
           
            
            String tempString = requestDataJSON.Sunshine_Center+' for snapshot date ::::'+requestDataJSON.Snapshot_Date+'::::::';
            
            if(requestDataJSON.Care_Team_Data.size()>0)
                tempString = tempString+insertCareTeamRecords(requestDataJSON.Care_Team_Data,requestDataJSON.Snapshot_Date);
            else
                tempString = tempString+' No Care Team Data Found';
            if(requestDataJSON.Billable_Items_Labs.size()>0)
                tempString = tempString+':::::'+insertBillableLabRecords(requestDataJSON.Billable_Items_Labs);
            else
                tempString = tempString+'::::: No Labs Data Found';
            if(requestDataJSON.Billable_Items_Sessions.size()>0)    
                tempString = tempString+':::::'+insertBillableSessionRecords(requestDataJSON.Billable_Items_Sessions);
            else
                tempString = tempString+'::::: No Sessions Data Found'; 
            if(requestDataJSON.Billable_Items_Evaluations.size()>0)   
                tempString = tempString+':::::'+insertBillableEvaluationRecords(requestDataJSON.Billable_Items_Evaluations); 
            else
                tempString = tempString+'::::: No Evaluations Data Found';  
            
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { 'chugh.naveen@gmail.com'};
            message.subject = 'Insert Successfull for'+requestDataJSON.Sunshine_Center+', For Snapshot Date : '+requestDataJSON.Snapshot_Date;
            message.plainTextBody =tempString;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }catch(exception e){
            String tempJSON = getFormatedJSONValue(data);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { 'chugh.naveen@gmail.com'};
            message.subject = 'Insert Failed';
            message.plainTextBody = e.getMessage()+'::::::::'+tempJSON;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
        
        return New ResponseClass('success',JSON.deserializeUntyped(data),'Services are working!','Services are working!');
    }
    
    public static DateTime getDateTimeValue(String dateTimeString){
        
        if(dateTimeString!=''){
            
            String[] dateTimeBreakdown = dateTimeString.trim().split(' ');//Breaking the field on the basis of Date and Time
            if(dateTimeBreakdown.size()>0){
                if(dateTimeBreakdown[0].contains('/')){
                    String[] dateBreakDown = dateTimeBreakdown[0].split('/');//Breakte the Date into Month, Day and Year
                    String[] timeBreakDown = dateTimeBreakdown[1].split(':');//Breaking the Time in Hour and Minutes
                    system.debug('dateBreakdown :::'+dateBreakdown);
                    system.debug('date month :::'+dateBreakdown[0]);
                    system.debug('date day :::'+dateBreakdown[1]);
                    system.debug('date year :::'+dateBreakdown[2]);
                    
                    system.debug('timeBreakdown :::'+timeBreakDown);
                    system.debug('time hour :::'+timeBreakDown[0]);
                    system.debug('time minute :::'+timeBreakDown[1]);
                    
                    dateTime dateTimeFieldValue = DateTime.newInstance(integer.valueOf(dateBreakdown[2].trim()),integer.valueOf(dateBreakdown[0].trim()),integer.valueOf(dateBreakdown[1].trim()),integer.valueOf(timeBreakDown[0].trim()),integer.valueOf(timeBreakDown[1].trim()),0);
                    system.debug('dateTimeFieldValue ::::'+dateTimeFieldValue);
                    
                    return dateTimeFieldValue;
                }
                else if(dateTimeBreakdown[0].contains('-')){
                    String[] dateBreakDown = dateTimeBreakdown[0].split('-');//Breakte the Date into Month, Day and Year
                    String[] timeBreakDown = dateTimeBreakdown[1].split(':');//Breaking the Time in Hour and Minutes
                    system.debug('dateBreakdown :::'+dateBreakdown);
                    system.debug('date year :::'+dateBreakdown[0]);
                    system.debug('date month :::'+dateBreakdown[1]);
                    system.debug('date day :::'+dateBreakdown[2]);
                    
                    system.debug('timeBreakdown :::'+timeBreakDown);
                    system.debug('time hour :::'+timeBreakDown[0]);
                    system.debug('time minute :::'+timeBreakDown[1]);
                    
                    dateTime dateTimeFieldValue = DateTime.newInstance(integer.valueOf(dateBreakdown[0].trim()),integer.valueOf(dateBreakdown[1].trim()),integer.valueOf(dateBreakdown[2].trim()),integer.valueOf(timeBreakDown[0].trim()),integer.valueOf(timeBreakDown[1].trim()),0);
                    system.debug('dateTimeFieldValue ::::'+dateTimeFieldValue);
                    
                    return dateTimeFieldValue;
                }
            }
        }
        
        return null;
    }
    
    public static Date getDateValue(String dateString){
        
        if(dateString!=''){
            
            String[] dateBreakdown = dateString.split('/');//Breakte the Date into Month, Day and Year
            if(dateBreakdown.size()>0){
                system.debug('dateBreakdown :::'+dateBreakdown);
                system.debug('date month :::'+dateBreakdown[0]);
                system.debug('date day :::'+dateBreakdown[1]);
                system.debug('date year :::'+dateBreakdown[2]);
                
                Date dateFieldValue = Date.newInstance(integer.valueOf(dateBreakdown[2].trim()),integer.valueOf(dateBreakdown[0].trim()),integer.valueOf(dateBreakdown[1].trim()));
                system.debug('dateFieldValue ::::'+dateFieldValue);
                return dateFieldValue;
            }
        }
        
        return null;
    }
    
    public static Date getSnapshotDateValue(String snapshotDateString){
        
        if(snapshotDateString!=''){
            
            String[] snapshotDateBreakdown = snapshotDateString.trim().split('_');//Breaking the field on the basis of Date and Time
            if(snapshotDateBreakdown.size()>0){
                system.debug('date month :::'+snapshotDateBreakdown[0]);
                system.debug('date day :::'+snapshotDateBreakdown[1]);
                system.debug('date year :::'+snapshotDateBreakdown[2]);
                
                Map<String,Integer> monthNumberMap = new Map<String,Integer>();
                monthNumberMap.put('JAN',1);
                monthNumberMap.put('FEB',2);
                monthNumberMap.put('MAR',3);
                monthNumberMap.put('APR',4);
                monthNumberMap.put('MAY',5);
                monthNumberMap.put('JUN',6);
                monthNumberMap.put('JUL',7);
                monthNumberMap.put('AUG',8);
                monthNumberMap.put('SEP',9);
                monthNumberMap.put('OCT',10);
                monthNumberMap.put('NOV',11);
                monthNumberMap.put('DEC',12);
                
                date snapshotDateFieldValue = Date.newInstance(integer.valueOf(snapshotDateBreakdown[2].trim()),monthNumberMap.get(snapshotDateBreakdown[0].trim()),integer.valueOf(snapshotDateBreakdown[1].trim())).addDays(-1);
                system.debug('dateTimeFieldValue ::::'+snapshotDateFieldValue);
                
                return snapshotDateFieldValue;
            }
        }
        
        return null;
    }
    
    public static String getFormatedJSONValue(String data){
        
        if(data!=''){
            
            String modified_data = data.replace('1_case_manager', 'case_manager').replace('1_primary_therapist','primary_therapist');
            Map<String,String> requestData = (Map<String,String>)JSON.deserialize(modified_data,Type.forName('Map<String,String>'));
            String careTeamData_temp = requestData.get('Care_Team_Data').replace(':full_name=>','"full_name":').replace(':mr=>','"mr":').replace(':current_ur_loc=>','"current_ur_loc":').replace(':discharge_date=>','"discharge_date":').replace(':"case_manager"=>','"case_manager":').replace(':"primary_therapist"=>','"primary_therapist":').replace(':bed=>','"bed":').replace(':program=>','"program":').replace(':current_clinical_loc=>','"current_clinical_loc":').replace('[[{','[{').replace('}]]','}]');
            String careTeamData = '';
            if(requestData.get('Sunshine_Center') == 'Chapters Capistrano')
                careTeamData = careTeamData_temp.replace(', {"full_name":nil, "mr":nil, "current_ur_loc":nil, "discharge_date":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil}','');
            if(requestData.get('Sunshine_Center') == 'Willow Springs')
                careTeamData = careTeamData_temp.replace(', {"full_name":nil, "mr":nil, "discharge_date":nil, "current_ur_loc":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil}','');
            if(requestData.get('Sunshine_Center') == 'Monarch Shores')
                careTeamData = careTeamData_temp.replace(', {"full_name":nil, "mr":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil, "discharge_date":nil, "current_ur_loc":nil}','').replace(', {"full_name":nil, "mr":nil, "current_ur_loc":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil, "discharge_date":nil}','');
            if(requestData.get('Sunshine_Center') == 'Mountain Springs Recovery')
                careTeamData = careTeamData_temp.replace(', {"full_name":nil, "mr":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil, "discharge_date":nil, "current_ur_loc":nil}','').replace(', {"full_name":nil, "mr":nil, "current_ur_loc":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil, "discharge_date":nil}','');
            
            if(careTeamData.containsOnly('nil'))
                careTeamData = careTeamData.replace('nil','""');
            
            String billingItemsLab = '';
            if(requestData.get('Billable_Items_Labs').contains('[[]]')){
                billingItemsLab = requestData.get('Billable_Items_Labs').replace('[[]]','[]');
            }else{
                billingItemsLab = requestData.get('Billable_Items_Labs').replace(':full_name=>','"full_name":').replace(':mr=>','"mr":').replace(':specimen_id=>','"specimen_id":').replace(':vendor=>','"vendor":').replace(':specimen_source=>','"specimen_source":').replace(':collected=>','"collected":').replace(':current_ur_loc=>','"current_ur_loc":').replace('[[{','[{').replace('}]]','}]');
            }
            if(billingItemsLab.containsOnly('nil'))
                billingItemsLab = billingItemsLab.replace('nil','""');
            
            String billingItemsEvaluations = '';
            if(requestData.get('Billable_Items_Evaluations').contains('[[]]')){
                billingItemsEvaluations = requestData.get('Billable_Items_Evaluations').replace('[[]]','[]');
            }else{
                billingItemsEvaluations = requestData.get('Billable_Items_Evaluations').replace(':full_name=>','"full_name":').replace(':mr=>','"mr":').replace(':evaluation=>','"evaluation":').replace(':signed_by=>','"signed_by":').replace(':started=>','"started":').replace(':ended=>','"ended":').replace(':duration=>','"duration":').replace(':authorizations=>','"authorizations":').replace(':status=>','"status":').replace(':completed_at=>','"completed_at":').replace(':evaluation_id=>','"evaluation_id":').replace(':template_id=>','"template_id":').replace(':current_ur_loc=>','"current_ur_loc":').replace('[[{','[{').replace('}]]','}]');
            }
            if(billingItemsEvaluations.containsOnly('nil'))
                billingItemsEvaluations = billingItemsEvaluations.replace('nil','""');
            
            string billingItemsSessions = '';
            if(requestData.get('Billable_Items_Sessions').contains('[[]]')){
                billingItemsSessions = requestData.get('Billable_Items_Sessions').replace('[[]]','[]');
            }else{
                billingItemsSessions = requestData.get('Billable_Items_Sessions').replace(':full_name=>','"full_name":').replace(':mr=>','"mr":').replace(':session=>','"session":').replace(':topic=>','"topic":').replace(':provider=>','"provider":').replace(':started=>','"started":').replace(':ended=>','"ended":').replace(':duration=>','"duration":').replace(':attended=>','"attended":').replace(':absent=>','"absent":').replace(':authorizations=>','"authorizations":').replace(':status=>','"status":').replace(':completed_at=>','"completed_at":').replace(':session_id=>','"session_id":').replace(':template_id=>','"template_id":').replace(':current_ur_loc=>','"current_ur_loc":').replace('[[{','[{').replace('}]]','}]');
            }
            if(billingItemsSessions.containsOnly('nil'))
                billingItemsSessions = billingItemsSessions.replace('nil','""');
            
            String tempJSON = '{"Sunshine_Center":"'+requestData.get('Sunshine_Center')+'","Snapshot_Date":"'+requestData.get('Snapshot_Date')+'","Care_Team_Data":'+careTeamData+',"Billable_Items_Labs":'+billingItemsLab+',"Billable_Items_Evaluations":'+billingItemsEvaluations+',"Billable_Items_Sessions":'+billingItemsSessions+'}';
            
            return tempJSON;
        }
        
        return null;
    }
    
    public static String insertCareTeamRecords(List<KIPU_Snapshot_Wrapper.Care_Team_Data> careTeamDataList, String snapshotDate){
        string returnString = '';
        if(careTeamDataList.size()>0 && snapshotDate != null){
            
            List<Client_KIPU_Snapshot__c> ccSnapshotsList = new List<Client_KIPU_Snapshot__c>();
            
            for(KIPU_Snapshot_Wrapper.Care_Team_Data ctd : careTeamDataList){
                Client_KIPU_Snapshot__c tempSnapshot = new Client_KIPU_Snapshot__c();
                tempSnapshot.Client_Name__c = ctd.full_name;
                tempSnapshot.KIPU_MRN__c = ctd.mr;
                tempSnapshot.UR_Level_of_Care_Temp__c = ctd.current_ur_loc;
                if(ctd.discharge_date != ''){
                    tempSnapshot.Discharge_Date_Time__c = getDateTimeValue(ctd.discharge_date);
                }
                tempSnapshot.Case_Manager__c = ctd.case_manager;
                tempSnapshot.Primary_Therapist__c = ctd.primary_therapist;
                tempSnapshot.Bed__c = ctd.bed;
                if(snapshotDate != '')
                    tempSnapshot.Snapshot_Date__c = getSnapshotDateValue(snapshotDate);
                else
                    tempSnapshot.Snapshot_Date__c = date.Today();
                
                ccSnapshotsList.add(tempSnapshot);
            }
            
            if(ccSnapshotsList.size()>0){
                try{
                    
                    insert ccSnapshotsList;
                    returnString = 'Care Team Records Inserted Successfully, #'+ccSnapshotsList.size();
                    return returnString;
                }Catch(exception e){
                    returnString = 'Care Team Records Insert Failed due to :::'+e.getMessage();
                    return returnString;
                }
            }
        }
        
        return null;
    }
    
    public static String insertBillableLabRecords(List<KIPU_Snapshot_Wrapper.Billable_Items_Labs > billableItemsLabsDataList){
        string returnString = '';
        if(billableItemsLabsDataList.size()>0){
            List<KIPU_Billable_Items_Temp__c> ccLabItemsList = new List<KIPU_Billable_Items_Temp__c>();
            for(KIPU_Snapshot_Wrapper.Billable_Items_Labs ctd : billableItemsLabsDataList){
                
                KIPU_Billable_Items_Temp__c tempBillableItem = new KIPU_Billable_Items_Temp__c();
                tempBillableItem.KIPU_MRN__c = ctd.mr;
                tempBillableItem.Speciment_ID__c= ctd.specimen_id;
                tempBillableItem.Vendor__c= ctd.vendor;
                tempBillableItem.Specimen_Source__c= ctd.specimen_source;
                if(ctd.collected != ''){
                    tempBillableItem.Collected__c = getDateValue(ctd.collected);
                }
                ccLabItemsList.add(tempBillableItem);
            }
            
            if(ccLabItemsList.size()>0){
                try{
                    insert ccLabItemsList;
                    returnString = 'Billable Items - Labs Records Inserted Successfully, #'+ccLabItemsList.size();
                    return returnString;
                }Catch(exception e){
                    returnString = 'Billable Items - Labs Insert Failed due to :::'+e.getMessage();
                    return returnString;
                }
            }
        }
        
        return null;
    }
    
    public static String insertBillableSessionRecords(List<KIPU_Snapshot_Wrapper.Billable_Items_Sessions > billableItemsSessionDataList){
        string returnString = '';
        if(billableItemsSessionDataList.size()>0){
            List<KIPU_Billable_Items_Temp__c> ccSessionItemsList = new List<KIPU_Billable_Items_Temp__c>();
            for(KIPU_Snapshot_Wrapper.Billable_Items_Sessions ctd : billableItemsSessionDataList){
                
                KIPU_Billable_Items_Temp__c tempBillableItem = new KIPU_Billable_Items_Temp__c();
                tempBillableItem.KIPU_MRN__c = ctd.mr;
                tempBillableItem.Session__c= ctd.session;
                tempBillableItem.Topic__c= ctd.topic;
                tempBillableItem.Provider__c= ctd.provider;
                if(ctd.started != '')
                    tempBillableItem.Start_Date__c = getDateTimeValue(ctd.started);
                if(ctd.ended != '')
                    tempBillableItem.End_Date__c= getDateTimeValue(ctd.ended);
                tempBillableItem.Duration__c= ctd.duration;
                tempBillableItem.Authorizations__c= ctd.authorizations;
                tempBillableItem.Status__c= ctd.status;
                if(ctd.completed_at != '')
                    tempBillableItem.Completed_At__c= getDateTimeValue(ctd.completed_at);
                
                ccSessionItemsList.add(tempBillableItem);
            }
            
            if(ccSessionItemsList.size()>0){
                try{
                    insert ccSessionItemsList;
                    returnString = 'Billable Items - Sessions Records Inserted Successfully, #'+ccSessionItemsList.size();
                    return returnString;
                }Catch(exception e){
                    returnString = 'Billable Items - Sessions Insert Failed due to :::'+e.getMessage();
                    return returnString;
                }
            }
        }
        
        return null;
    }
    
    public static String insertBillableEvaluationRecords(List<KIPU_Snapshot_Wrapper.Billable_Items_Evaluations > billableItemsEvaluationDataList){
        string returnString = '';
        if(billableItemsEvaluationDataList.size()>0){
            List<KIPU_Billable_Items_Temp__c> ccEvaluationsItemsList = new List<KIPU_Billable_Items_Temp__c>();
            for(KIPU_Snapshot_Wrapper.Billable_Items_Evaluations ctd : billableItemsEvaluationDataList){
                
                KIPU_Billable_Items_Temp__c tempBillableItem = new KIPU_Billable_Items_Temp__c();
                
                tempBillableItem.KIPU_MRN__c = ctd.mr;
                tempBillableItem.Evaluation__c= ctd.evaluation;
                tempBillableItem.Signed_By__c= ctd.signed_by;
                if(ctd.started != '')
                    tempBillableItem.Start_Date__c = getDateTimeValue(ctd.started);
                if(ctd.ended != '')
                    tempBillableItem.End_Date__c= getDateTimeValue(ctd.ended);
                tempBillableItem.Duration__c= ctd.duration;
                tempBillableItem.Authorizations__c= ctd.authorizations;
                tempBillableItem.Status__c= ctd.status;
                if(ctd.completed_at != '')
                    tempBillableItem.Completed_At__c= getDateTimeValue(ctd.completed_at);
                tempBillableItem.Evaluation_Template_ID__c= string.valueOf(ctd.template_id);
                
                ccEvaluationsItemsList.add(tempBillableItem);
            }
            
            if(ccEvaluationsItemsList.size()>0){
                try{
                    insert ccEvaluationsItemsList;
                    returnString = 'Billable Items - Evaluations Records Inserted Successfully, #'+ccEvaluationsItemsList.size();
                    return returnString;
                }Catch(exception e){
                    returnString = 'Billable Items - Evaluations Insert Failed due to :::'+e.getMessage();
                    return returnString;
                }
            }
        }
        
        return null;
    }
    
}