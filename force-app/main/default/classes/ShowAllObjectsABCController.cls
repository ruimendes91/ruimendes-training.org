public with sharing class ShowAllObjectsABCController {
   

    @AuraEnabled
    public static list<SObject> getObjectData(string obj){
        
        String query = 'SELECT Name FROM '+ obj +' ORDER BY Name';
       
        list<SObject> lstRecords = database.query(query);
        lstRecords.sort();
        
        return lstRecords;

    }

}