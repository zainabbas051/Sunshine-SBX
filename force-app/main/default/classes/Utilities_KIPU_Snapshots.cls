//test class UtilitiesTest
public without sharing class Utilities_KIPU_Snapshots {

    public static String getCurrentURLoc(string tempURLOC){
        
        if(tempURLOC != null){
            String currentURLoc = '';
            if(tempURLOC.contains('RTC -') || tempURLOC.contains('Residential')){
                currentURLoc = 'Residential';
            }
            if(tempURLOC.contains('DTX -') || tempURLOC.contains('Detox')){
                currentURLoc = 'Detox';
            }
            if(tempURLOC.contains('PHP -') || tempURLOC == 'PHP/Day-Night' || tempURLOC == 'PHP'){
                currentURLoc = 'PHP';
            }
            if(tempURLOC.contains('OP -') || tempURLOC == 'OP'){
                currentURLoc = 'OP';
            }
            if(tempURLOC.contains('IOP -') || tempURLOC == 'IOP'){
                currentURLoc = 'IOP';
            }    
            return currentURLoc;
        }
        return null;
    }   
}