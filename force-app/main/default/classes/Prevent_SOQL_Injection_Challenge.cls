public class Prevent_SOQL_Injection_Challenge {

    public string textOne {get; set;}
    public string textTwo {get; set;}
    public string comparator {get; set;}
    public string numberOne {get; set;}

    public List<Supply__c> whereclause_records {get; set;}


    public PageReference stringSearchOne(){
        string query = 'SELECT Id,Name,Quantity__c,Storage_Location__c,Storage_Location__r.Castle__c,Type__c FROM Supply__c';
        string whereClause = '';

        if(textOne != null && textOne!=''){
                whereClause += 'name like  \'%'+textOne+'%\' ';
        }

        if(whereClause != ''){
            whereclause_records = database.query(query+' where '+whereClause+' Limit 10');
        }

        return null;
    }


    public PageReference stringSearchTwo(){
        string query = 'SELECT Id,Name,Quantity__c,Storage_Location__c,Storage_Location__r.Castle__c,Type__c FROM Supply__c';
        string whereClause = '';

        if(textTwo != null && textTwo!=''){
                whereClause += 'Storage_Location__r.name like  \'%'+textTwo+'%\' ';
        }

        if(whereClause != ''){
            whereclause_records = database.query(query+' where '+whereClause+' Limit 10');
        }

        return null;
    }


    public PageReference numberSearchOne(){
        string query = 'SELECT Id,Name,Quantity__c,Storage_Location__c,Storage_Location__r.Castle__c,Type__c FROM Supply__c';
        string whereClause = '';

        if(numberOne != null && comparator != null && (comparator == '<' || comparator == '>' || comparator == '=')){
            whereClause += 'Quantity__c '+comparator+' '+numberOne+' ';
        }

        if(whereClause != ''){
            whereclause_records = database.query(query+' where '+whereClause+' Limit 10');
        }

        return null;
    }

}