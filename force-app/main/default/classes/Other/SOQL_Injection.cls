public class SOQL_Injection {

    public List<Personnel__c> whereclause_records {get; set;}
    public String textualTitle {get; set;}
    public String textualAge {get; set;}

    public PageReference whereclause_search(){
        String query = 'select Name, Role__c, Title__c, Age__c from Personnel__c';
        String whereClause = '';
        if(textualTitle != null && textualTitle!='')
        {
            whereClause += 'Title__c like  \'%'+textualTitle+'%\' ';
            whereclause_records = database.query(query+' where '+whereClause);

        }
        else 
        {
            if(textualAge != null && textualAge!='')
            {
                 whereClause+='Age__c >'+textualAge+'';
                 whereclause_records = database.query(query+' where '+whereClause);
            }
        }
        
        return null;
}
}