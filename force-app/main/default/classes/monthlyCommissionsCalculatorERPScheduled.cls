//Test Class : monthlyCommissionsCalculatorERPTest
global class monthlyCommissionsCalculatorERPScheduled implements Schedulable {
   global void execute(SchedulableContext SC) {
      monthlyCommissionsCalculatorERP.commissionCalculator();
   }
}