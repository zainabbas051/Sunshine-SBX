/*
TestClass = ClientTicket_CtrlTest
*/
public inherited sharing class ClientTicketServices {

    static IConfigRetriever config;
    final static string DEPARTMENT_CONFIG = 'DepartmentConfigs';

    static{
        config = (IConfigRetriever) Type.forName('CustomMetaDataConfig').newInstance();
    }

    public static Map<string,string> getValuesByDepartment(string sunShineCentre,
                                        string department){

        string jsonConfig =  getConfigs(DEPARTMENT_CONFIG);
        if(string.isBlank(jsonConfig)){
            return new Map<string,string>();
        } 
        Map<string,Map<string,List<string>>> deptConfigs = convertDeptConfigs(jsonConfig);
        List<string> relatedValues = deptConfigs?.get(sunShineCentre)?.get(department);
        if(relatedValues != null){
            return bindValuesAgainstDept(relatedValues);
        }
        return null;                 
    }

    public static Map<string,string> getDepartmentPicklist(string sunShineCentre){

        string jsonConfig =  getConfigs(DEPARTMENT_CONFIG);
        if(string.isBlank(jsonConfig)){
            return new Map<string,string>();
        } 
        Map<string,Map<string,List<string>>> deptConfigs = convertDeptConfigs(jsonConfig);
        Map<string,List<string>> deptPickList = deptConfigs?.get(sunShineCentre);
        if(deptPickList != null){
            return bindDepts(deptPickList);
        }
        return null; 

    }

    private static string getConfigs(string configName){
        return (string)config.getConfiguration(configName);
    }

    private static Map<string,Map<string,List<string>>> convertDeptConfigs(string jsonStr){
        return (Map<string,Map<string,List<string>>>) JSON.deserialize(jsonStr,Map<string,Map<string,List<string>>>.class);
    }
    
    private static Map<string,string> bindValuesAgainstDept(List<string> values){
    
        Map<string,string> mapOfOptions = new Map<string,string>();
        for(string value : values){
            mapOfOptions.put(value,value);
        }
        return mapOfOptions;
    }

    private static Map<string,string> bindDepts (Map<string,List<string>> values){

        Map<string,string> mapOfOptions = new Map<string,string>();
        for(string value : values.keySet()){
            mapOfOptions.put(value,value);
        }
        return mapOfOptions;
    }

}