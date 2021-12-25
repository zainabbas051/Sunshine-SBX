@isTest
public class TriggerContextUtility2_Test {

      static testMethod void TriggerContextTest(){
          
          TriggerContextUtility2.isFirstRun();
          TriggerContextUtility2.setFirstRunFalse();
          
          TriggerContextUtility.isFirstRun();
          TriggerContextUtility.setFirstRunFalse();
          
          TriggerContextUtility3.isFirstRun();
          TriggerContextUtility3.setFirstRunFalse();
          
          TriggerContextUtilityAN.isRunOnce();
          TriggerContextUtilityAN.setRunOnceFalse();
          
          TriggerContextUtilityAN.isFirstRun();
          TriggerContextUtilityAN.setFirstRunFalse();
          
          
          TriggerContextUtilityMSOpp.runOnce();
          
          TriggerContextUtilityOpp.isFirstRun();
          TriggerContextUtilityOpp.setFirstRunFalse();
          
      }

}