@isTest
private class CleanlinessChecklist_Test{

    
        
 Public Static Profile adminProfile;
     @testSetup static void setup() {
        // Create common test accounts
       
           Account a;
        
       House__c house;  
       House_Line_Items__c hli;
        House_Line_Items__c hli2;
        Task_Line_Items__c tli;
        Cleanliness_Checklist_House_Mapping__mdt houseMapping;
        Cleanliness_Checklist_Task_Mapping__mdt taskMapping;
        
        a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
    
        
        house= new House__c();
        house.Name='House test schedule';
        house.Sunshine_Center__c= a.id;
        insert house;
        
        FINAL STRING DAILY_REC_TYPE = Schema.getGlobalDescribe().get('House_Line_Items__c').getDescribe().getRecordTypeInfosByDeveloperName().get('Daily_Line_Item').getRecordTypeId();
        hli= new House_Line_Items__c();
        hli.Bedroom_Number__c='bed123';
        hli.Status__c='Incomplete';
        hli.Line_Item_Type__c='Bedroom';
        hli.Due_Date__c=date.TODAY();
        hli.RecordtypeId = DAILY_REC_TYPE;
        hli.Related_House__c=house.id;
        insert hli;
        
        hli2= new House_Line_Items__c();
        hli2.Bedroom_Number__c='bed123';
        hli2.Status__c='Incomplete';
        hli2.Line_Item_Type__c='Bedroom';
        hli2.Due_Date__c=date.TODAY()-1;
        hli2.RecordtypeId = DAILY_REC_TYPE;
        hli2.Related_House__c=house.id;
        insert hli2;
        
        
        tli= new Task_Line_Items__c();
        tli.Task_Name__c='testTask';
        tli.BHT_Status__c=false;
        tli.Supervisor_Status_chkb__c=false;
        tli.Related_House_Line_Item__c=hli.id;
        insert tli;
        
      Application_Password__c app = new Application_Password__c();
      app.Name = 'house 2';
      app.password__c = 'abcd';
      app.Sunshine_Center__c = 'Chapters Capistrano';
      app.Application_Name__c = 'Cleanliness Checklist';
      insert app;
      
        
        
    }

      Static testmethod void ProcessTest(){


        Test.startTest();
          
          ID houseId = [SELECT ID FROM house__c limit 1].ID;
          ID houseLineItemId = [SELECT ID FROM House_Line_Items__c LIMIT 1].ID;
          ID taskLineItemId = [SELECT ID FROM Task_Line_Items__c LIMIT 1].ID;
          string jsonString='[{"Task_Name__c":"Clean Floor","Task_Completed__c":false,"BHT_Status__c":true,"Supervisor_Status_chkb__c":false,"Related_House_Line_Item__c":"'+houseLineItemId+'","Id":"'+taskLineItemId+'","Related_House_Line_Item__r":{"Status__c":"Incomplete","Id":"'+houseId+'"}}]';
          CleanessChecklistCtrl.saveActivityListRecord(jsonString);
          CleanessChecklistCtrl.completeHouselineItem(houseLineItemId,jsonString,'abc','abc','BHT');
          CleanessChecklistCtrl.completeHouselineItem(houseLineItemId,jsonString,'abc','abc','Supervisor');
          CleanessChecklistCtrl.completeHouselineItem(houseLineItemId,jsonString,'abc','abc','Director');
          CleanessChecklistCtrl.getHouseLineItemsList(houseId ,'Bedroom','Daily_Line_Item');
          CleanessChecklistCtrl.getTasksByHouseLineItem(houseLineItemId );
          CleanessChecklistCtrl.getLineItemsAgainstHouse(houseId ,'Daily_Line_Item','BHT'); 
          CleanessChecklistCtrl.getTasksByHouse(houseId ,'Bedroom','Daily_Line_Item');
          CleanessChecklistCtrl.getLineItemsAgainstHouse(houseId ,'Daily_Line_Item','BHT');
          CleanessChecklistCtrl.getPasswordFromCustomSetting('Director');
          CleanessChecklistCtrl.getHouseList();
           String CRON_EXP = '0 0 0 3 9 ? 2022';
          system.schedule('Test Territory Check',CRON_EXP,new CleanlinessCheckListDataCreation_Schd());

        
        Test.stopTest();
     }
}