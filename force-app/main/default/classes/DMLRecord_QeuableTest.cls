@isTest
private class DMLRecord_QeuableTest{


      Static testmethod void ProcessTest(){
          
          Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;
        
         System.enqueueJob(new DMLRecord_Qeuable(new List<sObject> { a },'Update'));
      }

}