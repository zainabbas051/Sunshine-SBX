@isTest
private class MaintenanceCheckListCtrl_Test {
         
     Public Static Profile adminProfile;
     @testSetup static void setup() {
        // Create common test accounts
       
      Account a;
        
       House__c house;  
     
        Cleanliness_Checklist_House_Mapping__mdt houseMapping;
        Cleanliness_Checklist_Task_Mapping__mdt taskMapping;
        
        a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Account mountainSpring = new Account();
        mountainSpring.Name = 'Mountain Springs Recovery';
        mountainSpring.Type = 'Internal Center';
        insert mountainSpring;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
    
        
        house= new House__c();
        house.Name='House test schedule';
        house.Sunshine_Center__c= a.id;
        insert house;

        house= new House__c();
        house.Name='House test schedule Mountain';
        house.Sunshine_Center__c= mountainSpring.id;
        insert house;
        
        Maintenance_Tasks_LineItem__c m = new Maintenance_Tasks_LineItem__c();
        m.Task_Name__c='testTask';
        m.BHT_Status__c=true;
        m.Supervisor_Status__c = true;
        m.Supervisor_Status__c=false;
        m.Related_House__c=house.id;
        m.Due_Date__c = Date.Today();
        insert m;
        
      Application_Password__c app = new Application_Password__c();
      app.Name = 'house 2';
      app.password__c = 'abcd';
      app.Sunshine_Center__c = 'Chapters Capistrano';
      app.Application_Name__c = 'Maintenance Checklist';
      insert app;
      
        
        
    }

      Static testmethod void ProcessTest(){


        Test.startTest();
          
          ID houseId = [SELECT ID FROM house__c limit 1].ID;
          List<Maintenance_Tasks_LineItem__c> lstMObj = [Select ID,Task_Name__c,BHT_Status__c,
                                                Supervisor_Status__c,Related_House__c FROM Maintenance_Tasks_LineItem__c];
          string jsonString=  JSON.serialize(lstMObj);
          MaintenanceCheckListCtrl.getMaintenanceTaskByHouseId(houseId,'Monthly',string.valueOf(Date.Today().Month()),string.valueOf(Date.Today().Year()));
          MaintenanceCheckListCtrl.getMaintenanceTaskByHouseId(houseId,'Quarterly',string.valueOf(Date.Today().Month()),string.valueOf(Date.Today().Year()));
          MaintenanceCheckListCtrl.getMaintenanceTaskByHouseId(houseId,'Yearly',string.valueOf(Date.Today().Month()),string.valueOf(Date.Today().Year()));
          MaintenanceCheckListCtrl.getHouseList();
          MaintenanceCheckListCtrl.completeHouselineItem(jsonString,'abc','abc','BHT');
          MaintenanceCheckListCtrl.completeHouselineItem(jsonString,'abc','abc','Supervisor');
          MaintenanceCheckListCtrl.getPasswordFromCustomSetting('Supervisor');
          String CRON_EXP = '0 0 0 3 9 ? 2022';
          system.schedule('Test Territory Check',CRON_EXP,new MaintenanceCheckListDataCreation_Schd());   
        Test.stopTest();
    }
}