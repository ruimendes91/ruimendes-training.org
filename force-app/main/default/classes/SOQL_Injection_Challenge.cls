public class SOQL_Injection_Challenge {

    public string textual {get; set;}
    public List<Supply__c> whereclause_records {get; set;}



//SELECT Id,Name,Quantity__c,Storage_Location__c,Type__c FROM Supply__c
    public PageReference whereclause_search(){
        string query = 'SELECT Id,Name,Quantity__c,Storage_Location__c,Storage_Location__r.Castle__c,Type__c FROM Supply__c';
        string whereClause = '';

        if(textual != null && textual!=''){
                whereClause += 'name like  \'%'+textual+'%\' ';
        }

        if(whereClause != ''){
            whereclause_records = database.query(query+' where '+whereClause+' Limit 10');
            validate(whereClause,whereclause_records.size());
        }

        return null;
    }


    public void validate(string s, integer i){
      if(s.contains('\'%') && s.containsIgnoreCase('Nobles_Only__c') && s.contains('%\'') && i<10){
        cvcs__c  v = cvcs__c.getInstance('sic1');
        if(v==null){
          v = new  cvcs__c(name='sic1',c1__c = 1);
        } else {
            v.c1__c += 1;
        }
        upsert v;
      }
    } 

}