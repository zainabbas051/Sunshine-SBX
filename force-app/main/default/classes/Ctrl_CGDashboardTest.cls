@isTest(SeeAllData = True)
public class Ctrl_CGDashboardTest{

 static testMethod void testCGDashboard() {
      
        
        Test.startTest();
        Ctrl_CGDashboard cgDash= new Ctrl_CGDashboard();
        cgDash.UnscheduledDischarge_CC='123';
        cgDash.UnscheduledDischarge_MS='123';
        cgDash.UnscheduledDischarge_WS='123';
        cgDash.UnscheduledDischarge_MSR='123';
        cgDash.UnscheduledDischarge_Total='123';

        cgDash.Discharge_Buckets_CC='123';
        cgDash.Discharge_Buckets_MS='123';
        cgDash.Discharge_Buckets_WS='123';
        cgDash.Discharge_Buckets_MSR='123';
        cgDash.Discharge_Buckets_Total='123';
        //cgDash.UnscheduledDischarge_CC=cgDash.getLastUnscheduledDischarge('Cases by Origin and Open Status');
        Test.stopTest();
        }



}