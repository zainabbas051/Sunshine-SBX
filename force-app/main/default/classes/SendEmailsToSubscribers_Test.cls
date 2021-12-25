@isTest(seeAlldata = true)
public with sharing class SendEmailsToSubscribers_Test {
    static testMethod void unitTest1()  {

        Test.StartTest();
        /*SchedulableContext sc = null;
        SendEmailToSubscribersSchd tsc = new SendEmailToSubscribersSchd();
        tsc.execute(sc);*/

        SendEmailToSubscribersBatch b = new SendEmailToSubscribersBatch(true);
        Database.executeBatch(b);
		Test.stopTest();

    }

    static testMethod void unitTest2()  {

        Test.StartTest();
        sendEmailToSubscribers.createEmailBody('00O4P000004GF81', 'report', new list<string>{'zainabbas051@gmail.com'});
        sendEmailToSubscribers.createEmailBody('01Z4P000000eA0T', 'dashboard', new list<string>{'zainabbas051@gmail.com'});
		Test.stopTest();

    }

    /*static testMethod void unitTest3()  {

        Test.StartTest();
        string did = [select id from dashboard limit 1].id;
        ApexPages.currentPage().getParameters().put('dashid', '01Z4P000000zB4z');
		SendEmailToSubscribersCntrl  testAccPlan = new SendEmailToSubscribersCntrl();
        Test.stopTest();

    }*/

    static testMethod void unitTest4()  {

        Test.StartTest();
        SendEmailToSubscribersSchd testsche = new SendEmailToSubscribersSchd();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
        Test.stopTest();

    }
}