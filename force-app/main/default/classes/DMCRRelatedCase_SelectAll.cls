public class DMCRRelatedCase_SelectAll{
                 
                    
        public static String SelectAll(string sfo){
            
            string allfields;
            string SOQL;
            
            map<string, schema.sobjecttype> allSObjects = schema.getglobaldescribe();
            schema.sobjecttype q = allsobjects.get(sfo);
            schema.describesobjectresult d = q.getdescribe();
            map<string, schema.sobjectfield> m = d.fields.getmap();
                            set<string> s = m.keyset();
            string query = '';
            for(string f : s){
                query = query+f+', ';
            }
            query = query.substring(0,query.length()-2);
            SOQL = 'SELECT ' + query + ' FROM ' + sfo;
            return SOQL;
        }
    }