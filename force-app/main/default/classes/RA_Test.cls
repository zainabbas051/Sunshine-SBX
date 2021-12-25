@istest
public class RA_Test{
     static{
        awsBucket__c aws = new awsBucket__c();
        aws.accessKeyId__c =  'AKIAIKHBOKKMOFRNX5XQ';
        aws.secretAccessKey__c = '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';
        aws.Bucket__c = 'freepu';
        aws.Name = 'FREEPU';
        insert aws;
       
        
    }
    
    //test method for VitalSignsCompCntrl,VitalSignUtil and VitalSignsGCompCntrl  
    static testmethod void VitalSignsCompCntrl (){
        
        test.startTest();
        
        Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Recurring_Assessment__c recu = new Recurring_Assessment__c();
         recu.Client_Chart__c = cl.ID;
         recu.Time_Due__c = DateTime.Now();
         /*recu.Blood_Glucose_Assessment_Required__c = TRUE;
         recu.Blood_Glucose_Assessment_Recurring_Time__c = 'Q4 Hours';
        recu.Vital_SIgns_Required__c = true;
        recu.Vital_SIgns_Recurring_Time__c = 'Q15';*/
        recu.Status__c = 'Closed';
         recu.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
         insert recu;
        
        //VitalSignUtil.IsVitalSignExsist(cl.id);
        
         Recurring_Assessment__c recu2 = new Recurring_Assessment__c();
        recu2.Status__c = 'Open';
         recu2.Client_Chart__c = cl.ID;
         recu2.Time_Due__c = DateTime.Now();
         recu2.related_to__c = recu.Id;/*
        recu2.Vital_SIgns_Required__c = true;
        recu2.Vital_SIgns_Recurring_Time__c = 'Q15';
         recu2.Blood_Glucose_Assessment_Required__c = TRUE;
         recu2.Blood_Glucose_Assessment_Recurring_Time__c = 'Q4 Hours';*/
         recu2.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
         insert recu2;
         
         
         Test.setCurrentPageReference(Page.VitalSignsVfp);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');
         
         VitalSignsCompCntrl ra = new VitalSignsCompCntrl ();
         ra.buildData();
         try{
         ra.Add();
         }
         catch(exception e){
         }
         
        ra.lstwrapperRA[0].RA.BP_Systolic__c = 'abc';
        ra.lstwrapperRA[0].RA.BP_Diastolic__c ='abc';
            ra.lstwrapperRA[0].RA.Temperature__c ='abc';
            ra.lstwrapperRA[0].RA.Pulse__c ='abc';
                ra.lstwrapperRA[0].RA.Respirations__c ='abc';
                ra.lstwrapperRA[0].RA.X02_Saturation__c ='abc';
          integer i = ra.test1;
        i = ra.test2;
        i=ra.test3;
        i = ra.test4;
        i = ra.test5;
        i=ra.test6;
        i = ra.test7;
        i = ra.test8;
        i = ra.test9;
        i = ra.test10;
        i = ra.test11;
        i = ra.test12;
        i = ra.test14;
        i = ra.test13;
        i=ra.test15;
        i = ra.test16;
        i = ra.test17;
        i = ra.test18;
        i = ra.test19;
        i = ra.test20;
        i = ra.test21;
        i = ra.test22;
        i = ra.test23;
        i = ra.test24;
        i = ra.test25;
        i = ra.test26;
        i = ra.test27;
        i = ra.test28;
        i = ra.test29;
        i = ra.test30;
         try{
         ra.Save();
         }
         catch(exception e){}
         Recurring_Assessment__c raRecord = [select id from Recurring_Assessment__c limit 1];
         ra.vsId = raRecord.id;
         ra.UpdateFileupload();
         if(ra.lstWrapperRA.size()>0)
         ra.lstWrapperRA[0].selected = true;
         ra.generatePDF();
         
         System.currentPageReference().getParameters().put('id', cl.id);
         
         VitalSignsGCompCntrl  ra_2 = new VitalSignsGCompCntrl ();
         ra_2.pageName ='VitalSignsVfp';
         ra_2.Save();
         test.stoptest();
        
    }
    
    static testmethod void CIWACompCntrl (){
        
         test.startTest();
        
        Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Recurring_Assessment__c recu = new Recurring_Assessment__c();
         recu.Client_Chart__c = cl.ID;
         recu.Time_Due__c = DateTime.Now();/*
        recu.CIWA_Assessment_Required__c = true;
        recu.CIWA_Assessment_Recurring_Time__c ='Q1 Hours';
         recu.Blood_Glucose_Assessment_Required__c = TRUE;
        recu.Status__c = 'Closed';
         recu.Blood_Glucose_Assessment_Recurring_Time__c = 'Q4 Hours';*/
         recu.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('CIWA').getRecordTypeId();
         insert recu;
        
         Recurring_Assessment__c recu2 = new Recurring_Assessment__c();
         recu2.Client_Chart__c = cl.ID;
         recu2.Time_Due__c = DateTime.Now();
         recu2.related_to__c = recu.Id;/*
        recu2.CIWA_Assessment_Required__c = true;
        recu2.CIWA_Assessment_Recurring_Time__c ='Q1 Hours';
        recu2.Status__c = 'Closed';
         recu2.Blood_Glucose_Assessment_Required__c = TRUE;
         recu2.Blood_Glucose_Assessment_Recurring_Time__c = 'Q4 Hours';*/
         recu2.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('CIWA').getRecordTypeId();
         insert recu2;
         
         Test.setCurrentPageReference(Page.CIWAVfp);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');
         
         CIWACompCntrl ra = new CIWACompCntrl ();
        integer i = ra.test1;
        i = ra.test2;
        i=ra.test3;
        i = ra.test4;
        i = ra.test5;
        i=ra.test6;
        i = ra.test7;
        i = ra.test8;
        i = ra.test9;
        i = ra.test10;
        i = ra.test11;
        i = ra.test12;
        i = ra.test14;
        i = ra.test13;
        i=ra.test15;
        i = ra.test16;
        i = ra.test17;
        i = ra.test18;
        i = ra.test19;
        i = ra.test20;
        i = ra.test21;
        i = ra.test22;
        i = ra.test23;
        i = ra.test24;
        i = ra.test25;
        i = ra.test26;
        i = ra.test27;
        i = ra.test28;
        i = ra.test29;
        i = ra.test30;
        i = ra.test31;
        i = ra.test32;
        i = ra.test33;
        i = ra.test34;
        i = ra.test35;
            
        
         ra.buildData();
         ra.Add();
        i = ra.listRASize;
        string sid = ra.vitalSignID;
        boolean r = ra.isRequired;
         ra.lstwrapperRA[0].RA.Nausea_Vomitting__c = '2:';
         ra.lstwrapperRA[0].RA.Tremors__c ='2';
         ra.lstwrapperRA[0].RA.Anxiety__c = '2';
         ra.lstwrapperRA[0].RA.Agitation__c = '2';
         ra.lstwrapperRA[0].RA.Orientation__c ='0: oriented';
         ra.lstwrapperRA[0].RA.Tactile_Disturbances__c = '0: none';
         ra.lstwrapperRA[0].RA.Auditory_Disturbance__c ='0: not present';     
         ra.lstwrapperRA[0].RA.Paroxysmal_Sweats__c = '2';  
         ra.lstwrapperRA[0].RA.Visual_Disturbances__c = '0: not present';
         ra.lstwrapperRA[0].RA.Headache__c = '0: not present';
         
         ra.recordId = [select id from Recurring_Assessment__c limit 1].id;
         System.currentPageReference().getParameters().put('param1', ra.recordID);
         ra.AddVS();
         ra.SaveVS();
         ra.Save();
         ra.ciwaid = [select id from Recurring_Assessment__c limit 1].id;
         ra.UpdateFileupload();
         if(ra.lstWrapperRA.size()>0)
         ra.lstWrapperRA[0].selected = true;

         ra.generatePDF();
         test.stoptest();
    }
    
    static testmethod void COWSCompCntrl(){
        
        test.startTest();
        
        Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Recurring_Assessment__c recu = new Recurring_Assessment__c();
         recu.Client_Chart__c = cl.ID;
         recu.Time_Due__c = DateTime.Now();/*
         recu.Blood_Glucose_Assessment_Required__c = TRUE;
         recu.Blood_Glucose_Assessment_Recurring_Time__c = 'Q4 Hours';
        recu.COWS_Assessment_Recurring_Time__c = 'Q1 Hours';
        recu.COWS_Assessment_Required__c = true;*/
        recu.Status__c = 'Closed';
            
         recu.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('COWS').getRecordTypeId();
         insert recu;
        
         Recurring_Assessment__c recu2 = new Recurring_Assessment__c();
         recu2.Client_Chart__c = cl.ID;
         recu2.Time_Due__c = DateTime.Now();
        recu2.Status__c = 'Closed';
         recu2.related_to__c = recu.Id;/*
        recu2.COWS_Assessment_Recurring_Time__c = 'Q1 Hours';
        recu2.COWS_Assessment_Required__c = true;
         recu2.Blood_Glucose_Assessment_Required__c = TRUE;
         recu2.Blood_Glucose_Assessment_Recurring_Time__c = 'Q4 Hours';*/
         recu2.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('COWS').getRecordTypeId();
         insert recu2;
         
         Test.setCurrentPageReference(Page.COWSVfp);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');
         
         COWSCompCntrl ra = new COWSCompCntrl();
         ra.buildData();
         ra.Add();
         ra.recordID = [select id from Recurring_Assessment__c limit 1].id;
         System.currentPageReference().getParameters().put('param1', ra.recordID);
          ra.AddVS();
         ra.SaveVS();
        integer i = ra.test1;
        i = ra.test2;
        i=ra.test3;
        i = ra.test4;
        i = ra.test5;
        i=ra.test6;
        i = ra.test7;
        i = ra.test8;
        i = ra.test9;
        i = ra.test10;
        i = ra.test11;
        i = ra.test12;
        i = ra.test14;
        i = ra.test13;
        i=ra.test15;
        i = ra.test16;
        i = ra.test17;
        i = ra.test18;
        i = ra.test19;
        i = ra.test20;
        i = ra.test21;
        i = ra.test22;
        i = ra.test23;
        i = ra.test24;
        i = ra.test25;
        i = ra.test26;
        i = ra.test27;
        i = ra.test28;
        i = ra.test29;
        i = ra.test30;
        i = ra.test31;
        i = ra.test32;
        i = ra.test33;
        i = ra.test34;
        i = ra.test35;
         ra.Save();
         ra.cowsId = [select id from Recurring_Assessment__c limit 1].id;
         ra.UpdateFileupload();
         if(ra.lstWrapperRA.size()>0)
         ra.lstWrapperRA[0].selected = true;
         ra.generatePDF();
         test.stoptest();
    }
    
    //test method for BMICntrl
    static testmethod void BMICntrl(){
    
        test.startTest();
        
        Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Test.setCurrentPageReference(Page.BMIVFP);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');
         
         BMICntrl ra = new BMICntrl();
         ra.buildData();
         ra.Add();
         ra.recordID = [select id from Recurring_Assessment__c limit 1].id;
         ra.AddVitalSigns();
         ra.Save();
         ra.bmiId = [select id from Recurring_Assessment__c limit 1].id;
         ra.UpdateFileupload();
         if(ra.lstWrapperRA.size()>0)
         ra.lstWrapperRA[0].selected = true;
         ra.generatePDF();
         test.stoptest();
         
    }
    
    //test method for GlucoseCntrl
    static testmethod void GlucoseCntrl(){
        
        test.startTest();
        
        Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Test.setCurrentPageReference(Page.BloodGlucoseVfp);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');
         
         GlucoseCntrl ra = new GlucoseCntrl();
         ra.buildData();
         ra.Add();
         ra.recordID = [select id from Recurring_Assessment__c limit 1].id;
         ra.AddVitalSigns();
         ra.Save();
         ra.glucoseId = [select id from Recurring_Assessment__c limit 1].id;
         ra.UpdateFileupload();
         if(ra.lstWrapperRA.size()>0)
         ra.lstWrapperRA[0].selected = true;
         ra.generatePDF();
         test.stoptest();
         
    }
    
    //test method for DetoxCompCntrl
    static testmethod void DetoxCntrl(){
        
        test.startTest();
        
        Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Recurring_Assessment__c recu = new Recurring_Assessment__c();
         recu.Client_Chart__c = cl.ID;
         recu.Time_Due__c = DateTime.Now();/*
         recu.Detox_Required__c = TRUE;
         recu.Detox_Recurring_Time__c = 'Q15';
        recu.Status__c = 'Closed';*/        recu.Observation_Location__c = 'Other';
         recu.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Detox Check').getRecordTypeId();
         insert recu;
        
         Recurring_Assessment__c recu2 = new Recurring_Assessment__c();
         recu2.Client_Chart__c = cl.ID;
         recu2.Time_Due__c = DateTime.Now();
         recu2.related_to__c = recu.Id;/*
        recu2.Detox_Required__c = TRUE;
        recu2.Observation_Location__c = 'Other';
        recu2.Status__c = 'Closed';
         recu2.Detox_Recurring_Time__c = 'Q15';*/
         recu2.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Detox Check').getRecordTypeId();
         insert recu2;
         
         Test.setCurrentPageReference(Page.DetoxCheck);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');
         
         DetoxCompCntrl ra = new DetoxCompCntrl();
         ra.buildData();
         ra.Add();
        integer ir = ra.listRASize;
        string vsid = ra.vitalSignID;
        boolean r = ra.isRequired;
            
            integer i = ra.test1;
        i = ra.test2;
        i=ra.test3;
        i = ra.test4;
        i = ra.test5;
        i=ra.test6;
        i = ra.test7;
        i = ra.test8;
        i = ra.test9;
        i = ra.test10;
        i = ra.test11;
        i = ra.test12;
        i = ra.test14;
        i = ra.test13;
        i=ra.test15;
        i = ra.test16;
        i = ra.test17;
        i = ra.test18;
        i = ra.test19;
        i = ra.test20;
        i = ra.test21;
        i = ra.test22;
        i = ra.test23;
        i = ra.test24;
        i = ra.test25;
        i = ra.test26;
        i = ra.test27;
        i = ra.test28;
        i = ra.test29;
        i = ra.test30;
        i = ra.test31;
        i = ra.test32;
        i = ra.test33;
        i = ra.test34;
        i = ra.test35;
         ra.recordID = [select id from Recurring_Assessment__c limit 1].id;
         ra.listRA[0].Observation_Location__c = 'Other';
         ra.Save();
         ra.ciwaId= [select id from Recurring_Assessment__c limit 1].id;
         ra.UpdateFileupload();
         if(ra.lstWrapperRA.size()>0)
         ra.lstWrapperRA[0].selected = true;
         ra.generatePDF();
         test.stoptest();
         
    }
    
    //test method for WellnessCheck
    static testmethod void WellnessCheck(){
        
        test.startTest();
        
        Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Recurring_Assessment__c recu = new Recurring_Assessment__c();
         recu.Client_Chart__c = cl.ID;
         recu.Time_Due__c = DateTime.Now();/*
         recu.Detox_Required__c = TRUE;
         recu.Detox_Recurring_Time__c = 'Q15';
        recu.Status__c = 'Closed';*/        recu.Observation_Location__c = 'Other';
         recu.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Wellness Check').getRecordTypeId();
         insert recu;
        
         Recurring_Assessment__c recu2 = new Recurring_Assessment__c();
         recu2.Client_Chart__c = cl.ID;
         recu2.Time_Due__c = DateTime.Now();
         recu2.related_to__c = recu.Id;/*
        recu2.Detox_Required__c = TRUE;
        recu2.Observation_Location__c = 'Other';
        recu2.Status__c = 'Closed';
         recu2.Detox_Recurring_Time__c = 'Q15';*/
         recu2.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Wellness Check').getRecordTypeId();
         insert recu2;
         
         Test.setCurrentPageReference(Page.DetoxCheck);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');
         
         WellnessCheckCtrl ra = new WellnessCheckCtrl();
         ra.buildData();
         ra.Add();
        integer i = ra.listRASize;
        string vsid = ra.vitalSignID;
        boolean r = ra.isRequired;
            
           
         ra.recordID = [select id from Recurring_Assessment__c limit 1].id;
         ra.listRA[0].Observation_Location__c = 'Other';
         ra.Save();
         ra.ciwaId= [select id from Recurring_Assessment__c limit 1].id;
         ra.UpdateFileupload();
         if(ra.lstWrapperRA.size()>0)
         ra.lstWrapperRA[0].selected = true;
         ra.generatePDF();
         test.stoptest();
         
    }
    
    static testmethod void TrgRA(){
        
        test.starttest();
            
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Recurring_Assessment__c ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Name = 'Config';
         ra.Vital_SIgns_Required__c = true;
         ra.Vital_SIgns_Recurring_Time__c = 'Q1 Hours';
         ra.CIWA_Assessment_Required__c = true;
         ra.CIWA_Assessment_Recurring_Time__c = 'Q2 Hours';
         ra.COWS_Assessment_Required__c = true;
         ra.COWS_Assessment_Recurring_Time__c = 'Q2 Hours';
         ra.BMI_Assessment_Required__c = true;
         ra.BMI_Assessment_Recurring_Time__c='Every 7 Days';
         ra.Blood_Glucose_Assessment_Required__c = true;
         ra.Blood_Glucose_Assessment_Recurring_Time__c = 'Q4 Hours';
         ra.Detox_Required__c = true;
         ra.Detox_Recurring_Time__c = 'Q15';
         ra.RecordTypeId =  Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         insert ra;
         
         Recurring_Assessment__c ra2 = new Recurring_Assessment__c();
         ra2.Client_Chart__c = cl.ID;
         ra2.Name = 'Config';
         
         ra2.RecordTypeId =  Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         
         insert ra2;
         ra2.Vital_SIgns_Required__c = true;
         ra2.Vital_SIgns_Recurring_Time__c = 'Q1 Hours';
         ra2.CIWA_Assessment_Required__c = true;
         ra2.CIWA_Assessment_Recurring_Time__c = 'Q2 Hours';
         ra2.COWS_Assessment_Required__c = true;
         ra2.COWS_Assessment_Recurring_Time__c = 'Q2 Hours';
         ra2.BMI_Assessment_Required__c = true;
         ra2.BMI_Assessment_Recurring_Time__c = 'Every 7 Days';
         ra2.Blood_Glucose_Assessment_Required__c = true;
         ra2.Blood_Glucose_Assessment_Recurring_Time__c = 'Q4 Hours';
         ra2.Detox_Required__c = true;
         ra2.Detox_Recurring_Time__c = 'Q15';
         
         update ra2;
         
         test.stoptest();
    }
}