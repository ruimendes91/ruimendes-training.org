public class SOQL_Injection_Whitelist_Fix {

    public String objectName {get;set;}
    public List<sobject> sObjectList {get;set;}
    String QueryString;
    public List<string> fieldList{get;set;}
    
    public SOQL_Injection_Whitelist_Fix(){
        objectclause_search();
    }
    
    public PageReference objectclause_search(){
        string obj = ApexPages.currentPage().getParameters().get('object');
        if(obj != null){ 
            string query = 'select id, name from '+obj+' limit 10';
            fieldList = New List<string>();
            fieldList.add('id');
            fieldList.add('name');
            sObjectList = Database.Query(query);
        }
        return null;
    }
    
    
    public PageReference add_urlParam(){  
        Pagereference P = Page.SOQL_Injection_Whitelist_Fix;
        P.getParameters().put('object', objectName+'__c');
        P.setRedirect(true);
        return P;
    }
}