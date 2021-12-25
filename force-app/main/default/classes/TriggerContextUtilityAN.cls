public class TriggerContextUtilityAN {

    private static boolean firstRun = true;

    public static boolean isFirstRun() {
        return firstRun;
    }
    public static void setFirstRunFalse(){
        firstRun = false;
    }
    
    @testvisible private static boolean run = true;
    //for stopping recursion
    public static boolean isRunOnce(){
      return run;        
    }
    
    public static void setRunOnceFalse(){
      run = false;
    }
}