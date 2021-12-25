//Test Class : ctrl_csvimport_ClientKIPUSnapshotsTest
public class ctrl_csvimport_ClientKIPUSnapshots {
    
    public String documentName {get;set;}
    public Blob csvFileBody{get;set;}
    public String[] snpashotDataLines {get;set;}
    public List <Client_KIPU_Snapshot__c> clientKIPUSnapshotsList {get;set;}
    Client_KIPU_Snapshot__c kipuSnapshotObj;
    public List <KIPU_Billable_Items_Temp__c> kipuBillableItemsList {get;set;}
    KIPU_Billable_Items_Temp__c kipuBillableItemsObj;
    public boolean readSuccess {get;set;}
    public List<String> lstFieldNames{get;set;}
    String snapshotDataAsString;
    String fieldValue;
    Double doubleFieldValue;
    dateTime dateTimeFieldValue;
    date dateFieldValue;
    Integer fieldNumber;
    Map < String, Integer > fieldNumberMap = new Map < String, Integer > ();
    public Map<String,String> metaDataFieldNameMap {get;set;}
    public Map<String,String> metaDataDatatypeMap {get;set;}
    
    String centerName = '';
    String objectName = '';
    Public Client_KIPU_Snapshot__c tempSnapshotRecord{get;set;}
    //String centerName = '';
    
    public ctrl_csvimport_ClientKIPUSnapshots() {
        documentName = '';
        readSuccess = FALSE;
        snpashotDataLines = new String[] {};
        
        metaDataFieldNameMap = new Map<String,String>();
        metaDataDatatypeMap = new Map<String,String>();
        lstFieldNames = new List<String>();
        tempSnapshotRecord = new Client_KIPU_Snapshot__c();
    }
    public void readFromFile(){
        try{
            if(centerName != '--None--' && objectName != '--None--'){
                if((objectName == 'Client_KIPU_Snapshot__c' && tempSnapshotRecord.Snapshot_Date__c != null) || (objectName == 'KIPU_Billable_Items_Temp__c')){
                    system.debug('objectName :::'+objectName);
                    system.debug('centerName :::'+centerName);
                    snapshotDataAsString = csvFileBody.toString();
                    readCSVFile();
                }else{
                    readSuccess = FALSE;
                    ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select a Value for Snapshot Date');
                    ApexPages.addMessage(errorMessage);    
                }
                
            }else{
                readSuccess = FALSE;
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select a Value for Center Name and Object Name Before Uploading CSV');
                ApexPages.addMessage(errorMessage);
            }
        }catch(exception e){
            readSuccess = FALSE;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Error reading CSV file :::'+e.getmessage());
            ApexPages.addMessage(errorMessage);
        }
    }    
    public void readCSVFile() {
        clientKIPUSnapshotsList = new List<Client_KIPU_Snapshot__c> ();
        kipuBillableItemsList = new List<KIPU_Billable_Items_Temp__c>();
        if(objectName == 'Client_KIPU_Snapshot__c'){
            clientKIPUSnapshotsList.clear();
        }else if(objectName == 'KIPU_Billable_Items_Temp__c'){
            kipuBillableItemsList.clear();
        }
        
        for(KIPU_Snapshot_CSV_Field_Mappings__mdt fieldMapping : [Select MasterLabel, Field_API_Name__c, Field_Datatype__c from KIPU_Snapshot_CSV_Field_Mappings__mdt where Sunshine_Center__c =: centerName AND Custom_Object__c =: objectName]){
            metaDataFieldNameMap.put(fieldMapping.MasterLabel,fieldMapping.Field_API_Name__c);
            metaDataDatatypeMap.put(fieldMapping.Field_API_Name__c,fieldMapping.Field_Datatype__c);
        }
        
        system.debug('metaDataDatatypeMap :::'+metaDataDatatypeMap);
        system.debug('metaDataFieldNameMap :::'+metaDataFieldNameMap);
        
        snpashotDataLines = snapshotDataAsString.split('\n');
        List<string> csvFieldNames = new List<String>(); 
        for(String fieldName : snpashotDataLines[0].split(',')){
            system.debug('fieldName ::::'+fieldName.trim());
            system.debug('metaDataNameMap Key Set ::::'+metaDataFieldNameMap.keySet());
            system.debug('metaDataFieldNameMap ContainsKey :::'+metaDataFieldNameMap.containsKey(fieldName.trim()));
            if(metaDataFieldNameMap.containsKey(fieldName.trim())){//If the Column Name from the CSV Exists in metadataFieldMap, then add the Corresponding Custom Object Field API Name into the list
                
                csvFieldNames.add(metaDataFieldNameMap.get(fieldName.trim()));
            }
        }
        system.debug('csvFieldNames :::'+csvFieldNames);
        for (Integer i = 0; i < csvFieldNames.size(); i++) {
            fieldNumberMap.put(csvFieldNames[i], i);
            lstFieldNames.add(csvFieldNames[i].trim());
        }
        for (Integer i = 1; i < snpashotDataLines.size(); i++) {
            if(objectName == 'Client_KIPU_Snapshot__c'){
                kipuSnapshotObj = new Client_KIPU_Snapshot__c();
            }else if(objectName == 'KIPU_Billable_Items_Temp__c'){
                kipuBillableItemsObj = new KIPU_Billable_Items_Temp__c();
            }
            string[] csvRecordData = snpashotDataLines[i].split(',');
            for (String fieldName: csvFieldNames) {
                if(metaDataDatatypeMap.containsKey(fieldName) && metaDataDatatypeMap.get(fieldName) == 'DateTime'){//If the Data Type of the Field is DateTime
                    fieldNumber = fieldNumberMap.get(fieldName);
                    system.debug('csvRecordData[fieldNumber] :::'+csvRecordData[fieldNumber]);
                    if(csvRecordData[fieldNumber].trim() != null && csvRecordData[fieldNumber].trim() != ''){
                        String[] dateTimeBreakdown = csvRecordData[fieldNumber].trim().split(' ');//Breaking the field on the basis of Date and Time
                        if(dateTimeBreakdown.size()>0){
                            String[] dateBreakDown = dateTimeBreakdown[0].split('/');//Breakte the Date into Month, Day and Year
                            String[] timeBreakDown = dateTimeBreakdown[1].split(':');//Breaking the Time in Hour and Minutes
                            system.debug('dateBreakdown :::'+dateBreakdown);
                            system.debug('date month :::'+dateBreakdown[0]);
                            system.debug('date day :::'+dateBreakdown[1]);
                            system.debug('date year :::'+dateBreakdown[2]);
                            
                            system.debug('timeBreakdown :::'+timeBreakDown);
                            system.debug('time hour :::'+timeBreakDown[0]);
                            system.debug('time minute :::'+timeBreakDown[1]);
                            
                            dateTimeFieldValue = DateTime.newInstance(integer.valueOf(('20'+dateBreakdown[2]).trim()),integer.valueOf(dateBreakdown[0].trim()),integer.valueOf(dateBreakdown[1].trim()),integer.valueOf(timeBreakDown[0].trim()),integer.valueOf(timeBreakDown[1].trim()),0);
                            system.debug('dateTimeFieldValue ::::'+dateTimeFieldValue);
                            
                            if(objectName == 'Client_KIPU_Snapshot__c'){
                                kipuSnapshotObj.put(fieldName.trim(), dateTimeFieldValue);
                            }else if(objectName == 'KIPU_Billable_Items_Temp__c'){
                                kipuBillableItemsObj.put(fieldName.trim(), dateTimeFieldValue);
                            }
                        }
                        
                        
                    }
                    
                }else if(metaDataDatatypeMap.containsKey(fieldName) && metaDataDatatypeMap.get(fieldName) == 'Date'){//If the Data Type of the Field is Date
                    fieldNumber = fieldNumberMap.get(fieldName);
                    system.debug('csvRecordData[fieldNumber] :::'+csvRecordData[fieldNumber]);
                    if(csvRecordData[fieldNumber].trim() != ''){
                        String[] dateBreakdown = csvRecordData[fieldNumber].split('/');//Breakte the Date into Month, Day and Year
                        system.debug('dateBreakdown :::'+dateBreakdown);
                        system.debug('date month :::'+dateBreakdown[0]);
                        system.debug('date day :::'+dateBreakdown[1]);
                        system.debug('date year :::'+dateBreakdown[2]);
                        
                        dateFieldValue = Date.newInstance(integer.valueOf(('20'+dateBreakdown[2]).trim()),integer.valueOf(dateBreakdown[0].trim()),integer.valueOf(dateBreakdown[1].trim()));
                        system.debug('dateFieldValue ::::'+dateFieldValue);
                        
                        if(objectName == 'Client_KIPU_Snapshot__c'){
                            kipuSnapshotObj.put(fieldName.trim(), dateFieldValue);
                        }else if(objectName == 'KIPU_Billable_Items_Temp__c'){
                            kipuBillableItemsObj.put(fieldName.trim(), dateFieldValue);
                        }
                    }
                    
                }else if(metaDataDatatypeMap.containsKey(fieldName) && metaDataDatatypeMap.get(fieldName) == 'Double'){//If the Data Type of the Field is String
                    fieldNumber = fieldNumberMap.get(fieldName);
                    doubleFieldValue = double.valueOf(csvRecordData[fieldNumber].trim());
                    
                    if(objectName == 'Client_KIPU_Snapshot__c'){
                        kipuSnapshotObj.put(fieldName.trim(), doubleFieldValue);
                    }else if(objectName == 'KIPU_Billable_Items_Temp__c'){
                        kipuBillableItemsObj.put(fieldName.trim(), doubleFieldValue);
                    }
                }else if(metaDataDatatypeMap.containsKey(fieldName) && metaDataDatatypeMap.get(fieldName) == 'String'){//If the Data Type of the Field is String
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];
                    
                    if(objectName == 'Client_KIPU_Snapshot__c'){
                        kipuSnapshotObj.put(fieldName.trim(), fieldValue.trim());
                    }else if(objectName == 'KIPU_Billable_Items_Temp__c'){
                        kipuBillableItemsObj.put(fieldName.trim(), fieldValue.trim());
                    }
                }
            }
            if(objectName == 'Client_KIPU_Snapshot__c' && tempSnapshotRecord.Snapshot_Date__c != null){
                kipuSnapshotObj.put('Snapshot_Date__c', tempSnapshotRecord.Snapshot_Date__c);
            }
            if(objectName == 'Client_KIPU_Snapshot__c'){
                clientKIPUSnapshotsList.add(kipuSnapshotObj); 
            }else if(objectName == 'KIPU_Billable_Items_Temp__c'){
                kipuBillableItemsList.add(kipuBillableItemsObj); 
            }
                           
        }
        if(clientKIPUSnapshotsList.size() > 0 || kipuBillableItemsList.size()>0){
            readSuccess = TRUE;
        }            
    }
    public void saveData(){
        try {
            
            if(objectName == 'Client_KIPU_Snapshot__c'){
                INSERT clientKIPUSnapshotsList; 
            }else if(objectName == 'KIPU_Billable_Items_Temp__c'){
                INSERT kipuBillableItemsList; 
            }
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.INFO, 'Records inserted successfully');
            ApexPages.addMessage(errorMessage);
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured while saving data');
            ApexPages.addMessage(errorMessage);
        }
    }
    
    
    
    public List<SelectOption> getCenterNames() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption('Chapters Capistrano','Chapters Capistrano'));
        options.add(new SelectOption('Willowsprings Recovery','Willowsprings Recovery'));
        options.add(new SelectOption('Monarch Shores + Mountain Springs','Monarch Shores + Mountain Springs'));
        return options;
    }
    public String getcenterName() {
        return centerName;
    }
    public void setcenterName(String centerName) {
        this.centerName = centerName;
    }
    
    public List<SelectOption> getObjectNames() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption('Client_KIPU_Snapshot__c','Client KIPU Snapshot'));
        options.add(new SelectOption('KIPU_Billable_Items_Temp__c','KIPU Billable Items Temp'));
        return options;
    }
    public String getobjectName() {
        return objectName;
    }
    public void setobjectName(String objectName) {
        this.objectName = objectName;
    }

    
}