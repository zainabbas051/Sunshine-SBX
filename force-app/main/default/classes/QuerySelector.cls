public abstract inherited sharing class QuerySelector {
    public QuerySelector() {

    }

    private Set<Schema.SObjectField> setOfNewFields = new Set<Schema.SObjectField>();
    /**
     * Implement this method to inform the base class of 
     * the SObject (custom or standard) to be queried
     **/
    abstract Schema.SObjectType getSObjectType();
    /**
     * Implement this method to inform the base class of 
     * the common fields to be queried or listed by the base class methods
     **/
    abstract List<Schema.SObjectField> getSObjectFieldList();

    /**
     * Performs a SOQL query, 
     *   - Selecting the fields described via getSObjectFieldsList and getSObjectFieldSetList (if included) 
     *   - From the SObject described by getSObjectType
     *   - Where the Id's match those provided in the set
     *   - Ordered by the fields returned via getOrderBy
     * @returns A list of SObject's
     **/
    public virtual List<SObject> selectSObjectsById(Set<Id> idSet)
    {  
       return Database.query(configureQueryFactory(idSet));
    }


    private string configureQueryFactory(Set<Id> idSet){

        return newQueryFactory().setConditions('Id in :idSet').toSoql();
    }

    /**
     * Returns a QueryFactory configured with the Selectors object, fields, fieldsets and default order by
    **/
    public QueryFactory newQueryFactory()
    {    
        // Construct QueryFactory around the given SObject
        return configureQueryFactory(
            new QueryFactory(),null);
    }
    
     public QueryFactory newQueryFactory(string lstOfFields)
    {    
        // Construct QueryFactory around the given SObject
        return configureQueryFactory(
            new QueryFactory(),lstOfFields.split(','));
    }

    private QueryFactory configureQueryFactory(QueryFactory queryFactory,List<string> lstOfFields){

        queryFactory.setSObjectName(getSObjectType());
        queryFactory.selectFields(getSObjectFieldList());
        queryFactory.extraFields(lstOfFields);
        return queryFactory;
        
    }

}