@isTest
private class PickListCheckBoxCtrlTest{
     
    
     public Static testmethod void testCase1(){
       test.startTest();
           PickListCheckBoxCtrl pcbc = new PickListCheckBoxCtrl();
           pcbc.objectName = 'Tx_and_D_C_Plans__c';    
           pcbc.Assessment_FieldName = 'Services_Provided__c';
           
           List<SelectOption> MPOptions = pcbc.MPOptions;
           
           pcbc.Assessment_FieldValue= 'Psychiatric Assessment;Recreational Therapy';
           
           String[] var = pcbc.MPItems;
           
           //pcbc.s_object = 'Tx_and_D_C_Plans__c';
           pcbc.MPItems=var;
       test.StopTest();
             
      }
       
}