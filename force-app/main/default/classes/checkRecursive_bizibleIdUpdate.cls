//Test Class : bizibleIdUpdateFromInvocaCallLogTest
public Class checkRecursive_bizibleIdUpdate{
    public static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}