@isTest
private class clinicianAuditDashboardController_Test{
    Public static KIPU_Clinician_Audit__c kca1;
    Public static KIPU_Clinician_Audit__c kca2;
    Public static KIPU_Clinician_Audit__c kca3;
    Public static KIPU_Clinician_Audit__c kca4;
    Public static KIPU_Clinician_Audit__c kca5;
    Public static KIPU_Clinician_Audit__c kca6;
    Public static KIPU_Clinician_Audit__c kca7;
    Public static KIPU_Clinician_Audit__c kca8;
    Public static KIPU_Clinician_Audit__c kca9;
    Public static KIPU_Clinician_Audit__c kca10;
    Public static KIPU_Clinician_Audit__c kca11;
    Public static KIPU_Clinician_Audit__c kca12;
    
    
     public Static void createSampleData(){
        
        List<KIPU_Clinician_Audit__c> kcaList = new List<KIPU_Clinician_Audit__c>();
        
        kca1 = new KIPU_Clinician_Audit__c();
        kca1.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca1.Start_Date_Time__c = dateTime.Now();
        kca1.Status__c = 'Complete';
        kca1.Duration__c = 1;
        kca1.Sunshine_Center__c = 'Chapters Capistrano';
        kca1.Type_of_Session__c = 'Individual Session';
        kcaList.add(kca1);
        
        kca2 = new KIPU_Clinician_Audit__c();
        kca2.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca2.Start_Date_Time__c = dateTime.Now().addDays(-8);
        kca2.Status__c = 'Complete';
        kca2.Duration__c = 1;
        kca2.Sunshine_Center__c = 'Chapters Capistrano';
        kca2.Type_of_Session__c = 'Individual Session';
        kcaList.add(kca2);
        
        kca3 = new KIPU_Clinician_Audit__c();
        kca3.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca3.Start_Date_Time__c = dateTime.Now().addDays(-15);
        kca3.Status__c = 'Complete';
        kca3.Duration__c = 1;
        kca3.Sunshine_Center__c = 'Chapters Capistrano';
        kca3.Type_of_Session__c = 'Individual Session';
        kcaList.add(kca3);
        
        kca4 = new KIPU_Clinician_Audit__c();
        kca4.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca4.Start_Date_Time__c = dateTime.Now().addDays(-22);
        kca4.Status__c = 'Complete';
        kca4.Duration__c = 1;
        kca4.Sunshine_Center__c = 'Chapters Capistrano';
        kca4.Type_of_Session__c = 'Individual Session';
        kcaList.add(kca4);
        
        kca5 = new KIPU_Clinician_Audit__c();
        kca5.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca5.Start_Date_Time__c = dateTime.Now();
        kca5.Status__c = 'Complete';
        kca5.Duration__c = 1;
        kca5.Sunshine_Center__c = 'Chapters Capistrano';
        kca5.Type_of_Session__c = 'Group Session';
        kcaList.add(kca5);
        
        kca6 = new KIPU_Clinician_Audit__c();
        kca6.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca6.Start_Date_Time__c = dateTime.Now().addDays(-8);
        kca6.Status__c = 'Complete';
        kca6.Duration__c = 1;
        kca6.Sunshine_Center__c = 'Chapters Capistrano';
        kca6.Type_of_Session__c = 'Group Session';
        kcaList.add(kca6);
        
        kca7 = new KIPU_Clinician_Audit__c();
        kca7.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca7.Start_Date_Time__c = dateTime.Now().addDays(-15);
        kca7.Status__c = 'Complete';
        kca7.Duration__c = 1;
        kca7.Sunshine_Center__c = 'Chapters Capistrano';
        kca7.Type_of_Session__c = 'Group Session';
        kcaList.add(kca7);
        
        kca8 = new KIPU_Clinician_Audit__c();
        kca8.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca8.Start_Date_Time__c = dateTime.Now().addDays(-22);
        kca8.Status__c = 'Complete';
        kca8.Duration__c = 1;
        kca8.Sunshine_Center__c = 'Chapters Capistrano';
        kca8.Type_of_Session__c = 'Group Session';
        kcaList.add(kca8);
        
        kca9 = new KIPU_Clinician_Audit__c();
        kca9.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca9.Start_Date_Time__c = dateTime.Now();
        kca9.Status__c = 'In Progress';
        kca9.Duration__c = 1;
        kca9.Sunshine_Center__c = 'Chapters Capistrano';
        kca9.Type_of_Session__c = 'Group Session';
        kcaList.add(kca9);
        
        kca10 = new KIPU_Clinician_Audit__c();
        kca10.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca10.Start_Date_Time__c = dateTime.Now().addDays(-8);
        kca10.Status__c = 'In Progress';
        kca10.Duration__c = 1;
        kca10.Sunshine_Center__c = 'Chapters Capistrano';
        kca10.Type_of_Session__c = 'Group Session';
        kcaList.add(kca10);
        
        kca11 = new KIPU_Clinician_Audit__c();
        kca11.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca11.Start_Date_Time__c = dateTime.Now().addDays(-15);
        kca11.Status__c = 'In Progress';
        kca11.Duration__c = 1;
        kca11.Sunshine_Center__c = 'Chapters Capistrano';
        kca11.Type_of_Session__c = 'Group Session';
        kcaList.add(kca11);
        
        kca12 = new KIPU_Clinician_Audit__c();
        kca12.Facilitator_Signed_By_Name__c = 'Naveen Chugh';
        kca12.Start_Date_Time__c = dateTime.Now().addDays(-22);
        kca12.Status__c = 'In Progress';
        kca12.Duration__c = 1;
        kca12.Sunshine_Center__c = 'Chapters Capistrano';
        kca12.Type_of_Session__c = 'Group Session';
        kcaList.add(kca12);
        
        insert kcaList;
        
     } 
     
     public Static testmethod void test_auditDashboardController(){
       test.startTest();
           createSampleData();
           
           clinicianAuditDashboardController cadc = new clinicianAuditDashboardController();
           cadc.loadData();
           
           cadc.inputDate = date.Today();
           cadc.setSunshineCenterValue('Chapters Capistrano');
           
           cadc.loadData();
           
           list<clinicianAuditDashboardController.totalHours> totalHoursList = new list<clinicianAuditDashboardController.totalHours>();
           totalHoursList = cadc.totalHoursList;
           
           list<clinicianAuditDashboardController.individualSessionHours > individualHoursList = new list<clinicianAuditDashboardController.individualSessionHours >();
           individualHoursList = cadc.individualSessionHoursList;
           
           list<clinicianAuditDashboardController.groupSessionHours> groupHoursList = new list<clinicianAuditDashboardController.groupSessionHours>();
           groupHoursList = cadc.groupSessionHoursList;
           
           Double var1 = cadc.totalHoursList_fourWeeksPriorTotal;
           Double var2 = cadc.totalHoursList_threeWeeksPriorTotal;
           Double var3 = cadc.totalHoursList_twoWeeksPriorTotal;
           Double var4 = cadc.totalHoursList_oneWeeksPriorTotal;
           Double var5 = cadc.totalHoursList_allTotal;
           
           Double var6 = cadc.individualSessionHoursList_fourWeeksPriorTotal;
           Double var7 = cadc.individualSessionHoursList_threeWeeksPriorTotal;
           Double var8 = cadc.individualSessionHoursList_twoWeeksPriorTotal;
           Double var9 = cadc.individualSessionHoursList_oneWeeksPriorTotal;
           Double var10 = cadc.individualSessionHoursList_allTotal;
           
           Double var11 = cadc.grouSessionHoursList_fourWeeksPriorCompleteTotal;
           Double var12 = cadc.grouSessionHoursList_fourWeeksPriorIncompleteTotal;
           Double var13 = cadc.grouSessionHoursList_threeWeeksPriorCompleteTotal;
           Double var14 = cadc.grouSessionHoursList_threeWeeksPriorIncompleteTotal;
           Double var15 = cadc.grouSessionHoursList_twoWeeksPriorCompleteTotal;
           Double var16 = cadc.grouSessionHoursList_twoWeeksPriorIncompleteTotal;
           Double var17 = cadc.grouSessionHoursList_oneWeeksPriorCompleteTotal;
           Double var18 = cadc.grouSessionHoursList_oneWeeksPriorIncompleteTotal;
           Double var19 = cadc.groupSessionHoursList_allTotal;
           
           String var20 = cadc.priorWeekHeaderValue;
           String var21 = cadc.priorTwoWeekHeaderValue;
           String var22 = cadc.priorThreeWeekHeaderValue;
           String var23 = cadc.priorFourWeekHeaderValue;
           Boolean var24 = cadc.displayDataTables;
           
           String var25 = cadc.getSunshineCenterValue();
           
           List<SelectOption> soList = new List<SelectOption>();
           soList = cadc.getSunshineCenterItems();
           
           
       test.StopTest();
             
      }
      
     
  }