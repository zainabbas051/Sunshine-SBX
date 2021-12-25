@isTest(seeAlldata = true)
public class LeadInsuranceKeywordUtilTest {

    static testMethod void unitTest1()  {
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
        Lead l = new lead();
        l.FirstName = 'test';
        l.LastName = '1';
        l.Company = 'test company';
        l.Insurance_Providors__c = 'Venom 1';
        l.recordtypeId = recordTypeId;
        test.startTest();
        insert l;

        l.Insurance_Providors__c = 'tommy 1';
        update l;
        test.stopTest();

    }

    static testMethod void unitTest2()  {
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
        Lead l = new lead();
        l.FirstName = 'test';
        l.LastName = '1';
        l.Company = 'test company';
        l.Insurance_Providors__c = 'No keyword';
        l.recordtypeId = recordTypeId;
        test.startTest();
        insert l;
        test.stopTest();

    }

    static testMethod void unitTest3()  {
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
        Lead l = new lead();
        l.FirstName = 'test';
        l.LastName = '1';
        l.Company = 'test company';
        l.Insurance_Providors__c = 'No keyword';
        l.recordtypeId = recordTypeId;
        l.LeadSource = 'Biz Dev';
        test.startTest();
        insert l;
        test.stopTest();

    }
}