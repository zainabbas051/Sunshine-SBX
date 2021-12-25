@isTest
private class Rest_Services_KIPU_Snapshot_HandlerTest{
     
     public Static testmethod void test_handler(){
        test.startTest();
           
           
        /*String data = '{"Sunshine_Center":"Willow Springs","Snapshot_Date":"DEC_16_2019"'+
                     +',"Care_Team_Data":"[[{:full_name=\u003e\"Aaron Eger\", :mr=\u003e\"WS2019-174\", :discharge_date=\u003e\"01/13/2020 12:00 AM\", :current_ur_loc=\u003e\"Residential\", :\"1_case_manager\"=\u003e\"Amelia Forman, LCDC\", :\"1_primary_therapist\"=\u003e\"Amelia Forman, LCDC\", :bed=\u003e\"Men Room 18 Bed 36\"}]]"'+
                     +',"Billable_Items_Appointments":"[[]]","Billable_Items_Sessions":"[[{:full_name=\u003e\"Aaron Eger\", :mr=\u003e\"WS2019-174\", :session=\u003e\"Aftercare Planning, Blue\", :topic=\u003e\"\", :provider=\u003e\"Anne Rhodes, MS Intern\", :started=\u003e\"12/16/2019 03:00 PM\", :ended=\u003e\"12/16/2019 04:00 PM\", :duration=\u003e1.0, :attended=\u003e15, :absent=\u003e0'+
                     +', :authorizations=\u003e\"UM19348AWVC, Start: 12/13/2019, End: 12/16/2019, Freq: daily, LOC: Residential\", :status=\u003e\"In Progress\", :completed_at=\u003e\"\", :session_id=\u003e13605, :template_id=\u003e\"88d3b0a4-38d4-4b8c-aeb6-bc5e32b65668\"}]]"'+
                     +',"Billable_Items_Labs":"[[{:full_name=\u003e\"Anthony Paramo\", :mr=\u003e\"WS2019-82\", :specimen_id=\u003e\"K7N3ACAK\", :vendor=\u003e\"Sunshine Behavioral Health Partners\", :specimen_source=\u003e\"Urine\", :collected=\u003e\"12/16/2019\"}]]"'+
                     +',"Billable_Items_Evaluations":"[[{:full_name=\u003e\"Aaron Eger\",:mr=\u003e\"WS2019-174\",:evaluation=\u003e\"Initial Psych Eval - 90833\",:signed_by=\u003e\"\",:started=\u003e\"2019-12-15 19:04:31 -0600\",:ended=\u003e\"\",:duration=\u003e0.0,:authorizations=\u003e\"\",:status=\u003e\"No Signature Requirement\",:completed_at=\u003e\"\",:evaluation_id=\u003e840,:template_id=\u003e956107}]]"}';
        
        */
        
        KIPU_Snapshot_Wrapper.Care_Team_Data ctd = new KIPU_Snapshot_Wrapper.Care_Team_Data();
        ctd.full_name = 'Naveen Chugh';
        ctd.mr = 'CC2019-20';
        ctd.current_ur_loc = 'Detox';
        ctd.discharge_date = '12/16/2019 07:08 AM';
        ctd.case_manager = 'Naveen Chugh';
        ctd.primary_therapist = 'Naveen Chugh';
        ctd.bed = '10';
        
        KIPU_Snapshot_Wrapper.Billable_Items_Sessions bis = new KIPU_Snapshot_Wrapper.Billable_Items_Sessions();
        bis.full_name = 'Naven Chugh';
        bis.mr = 'CC2019-20';
        bis.session = 'Sessions';
        bis.topic='Topic';
        bis.provider = 'Provider';
        bis.started = '12/16/2019 07:00 AM';
        bis.ended = '12/16/2019 08:00 AM';
        bis.duration = 1.0;
        bis.attended = 10;
        bis.absent = 0;
        bis.authorizations ='Authorizations';
        bis.status = 'Status';
        bis.completed_at = '12/16/2019 08:08 AM';
        bis.session_id = 1234;
        bis.template_id = 'Template ID';
        
        KIPU_Snapshot_Wrapper.Billable_Items_Labs bil = new KIPU_Snapshot_Wrapper.Billable_Items_Labs();
        bil.full_name = 'Naveen Chugh';
        bil.mr = 'CC2019-20';
        bil.specimen_id = '12345';
        bil.vendor = 'Sunshine BH';
        bil.specimen_source = 'Urine';
        bil.collected = '12/16/2019';
        
        KIPU_Snapshot_Wrapper.Billable_Items_Evaluations bie = new KIPU_Snapshot_Wrapper.Billable_Items_Evaluations();
        bie.full_name = 'Naveen Chugh';
        bie.mr = 'CC2019-20';
        bie.evaluation = 'Evaluation';
        bie.signed_by = 'Signed By';
        bie.started = '12/16/2019 07:00 AM';
        bie.ended = '12/16/2019 08:00 AM';
        bie.duration = 1.0;
        bie.authorizations = 'Authorizations';
        bie.status = 'Status';
        bie.completed_at = 'Completed At';
        bie.evaluation_id = 123456;
        bie.template_id = 1234567890;
        
        List<KIPU_Snapshot_Wrapper.Care_Team_Data> ctdList = new List<KIPU_Snapshot_Wrapper.Care_Team_Data>();
        ctdList.add(ctd);
        
        List<KIPU_Snapshot_Wrapper.Billable_Items_Labs> bilList = new List<KIPU_Snapshot_Wrapper.Billable_Items_Labs>();
        bilList.add(bil);
        
        List<KIPU_Snapshot_Wrapper.Billable_Items_Evaluations> bieList = new List<KIPU_Snapshot_Wrapper.Billable_Items_Evaluations>();
        bieList.add(bie);
        
        List<KIPU_Snapshot_Wrapper.Billable_Items_Sessions> bisList = new List<KIPU_Snapshot_Wrapper.Billable_Items_Sessions>();
        bisList.add(bis);
        
        KIPU_Snapshot_Wrapper ksw = new KIPU_Snapshot_Wrapper();
        ksw.Sunshine_Center = 'Chapters Capistrano';
        ksw.Snapshot_Date = 'JAN_01_2020';
        ksw.Care_Team_Data = ctdList; 
        ksw.Billable_Items_Labs = bilList;
        ksw.Billable_Items_Evaluations = bieList;
        ksw.Billable_Items_Sessions = bisList;
        
        KIPU_Snapshot_Wrapper ksw2 = KIPU_Snapshot_Wrapper.parse(string.valueOf(JSON.serialize(ksw)));
        
        
        DateTime dateTimeVariable =  Rest_Services_KIPU_Snapshot_Handler.getDateTimeValue('12/16/2019 08:08 AM');
        DateTime dateTimeVariable2 =  Rest_Services_KIPU_Snapshot_Handler.getDateTimeValue('2019-12-16 07:31:00 -0800');
        
        Date dateVariable = Rest_Services_KIPU_Snapshot_Handler.getDateValue('12/16/2019');
        Date snapshotDate = Rest_Services_KIPU_Snapshot_Handler.getSnapshotDateValue('DEC_09_2019');
        
        String careTeamRecords =  Rest_Services_KIPU_Snapshot_Handler.insertCareTeamRecords(ctdList, 'DEC_09_2019');
        
        String bilRecords =  Rest_Services_KIPU_Snapshot_Handler.insertBillableLabRecords(bilList);
        
        String bisRecords =  Rest_Services_KIPU_Snapshot_Handler.insertBillableSessionRecords(bisList);
        
        String bieRecords =  Rest_Services_KIPU_Snapshot_Handler.insertBillableEvaluationRecords(bieList);
        
        string dataString = string.valueOf(JSON.serialize(ksw));
        
        
        
        string data = '{"Sunshine_Center":"Willow Springs","Snapshot_Date":"DEC_16_2019","Care_Team_Data":"","Billable_Items_Appointments":"[[]]","Billable_Items_Sessions":"[[]]","Billable_Items_Labs":"[[]]","Billable_Items_Evaluations":"[[]]"}';
        
        String formatedJSON = Rest_Services_KIPU_Snapshot_Handler.getFormatedJSONValue(data);
        Object result = Rest_Services_KIPU_Snapshot_Handler.kipuSnapshotService(data);
        
        //Object result = 
           
        test.StopTest();
             
      }
      
    
      
}