public  inherited sharing class QueryFactory {
    

    List<Schema.SObjectField> fields;
    List<string> extraFields;
    Schema.SObjectType objectType;
    string expression;
    integer recordLimit;
    integer offSet;
    
    public QueryFactory() {

    }

    public void selectFields(List<Schema.SObjectField> fields){
        this.fields = fields;
    }
    
     public void extraFields(List<string> fields){
        this.extraFields = fields;
    }

    public void setSObjectName(Schema.SObjectType objectType){
        this.objectType = objectType;
    }

    public QueryFactory setConditions(string expression){
        this.expression = expression;
        return this;
    }

    public QueryFactory setLimit(integer recordLimit){
        this.recordLimit = recordLimit;
        return this;
    }

    public QueryFactory offSet(integer offSet){
        this.offSet = offSet;
        return this;
    }
    
    public QueryFactory orderBy(string expression){
        
        this.expression += string.format(' Order By {0} ',new List<string> { expression });
         return this;
    }

    public string toSoql(){

        string soqlQuery = 'SELECT ';
        for (Schema.SObjectField iObjectField :  fields){
            soqlQuery += string.format('{0} ,',new List<string> { string.valueOf(iObjectField) });
        }
        if(extraFields != null){
            for(string iField : extraFields){
                soqlQuery += string.format('{0} ,',new List<string> { iField });
            }
        }
        
        soqlQuery = soqlQuery.removeEnd(',');
        soqlQuery += string.format('FROM {0} ',new List<string> { string.valueOf(objectType) });

        if(string.isBlank(expression)){
            return soqlQuery;
        }
        soqlQuery += string.format('WHERE {0} ',new List<string> { string.valueOf(expression) });

        if(recordLimit != null)
            soqlQuery += string.format('LIMIT {0} ',new List<string> { string.valueOf(recordLimit) });
        
        if(offSet != null)
            soqlQuery += string.format('OFFSET {0} ',new List<string> { string.valueOf(offSet) });
        
       system.debug('$$$:' + soqlQuery);
        return soqlQuery;
        
    }
}