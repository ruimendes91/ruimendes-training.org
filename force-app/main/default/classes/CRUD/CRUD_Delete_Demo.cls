public with sharing class CRUD_Delete_Demo {
    public List<Requisition__c> req {
        get{
            return [ select Id, Resource__r.Name, Castle__r.Name, Description__c, Quantity__c from Requisition__c ];
        }
        set;
    }
    
    public Id id {get;set;}
   
    public PageReference deleteRequest(){
        Requisition__c delr = [select id from Requisition__c where id =: id limit 1];
        
        if(delr != null)
        {
            try{
                delete delr;
            }
            catch(DmlException ex){
                ApexPages.addMessages(ex);
            }
        }
        
        return null;
    }
    
    public string[] getPermSets(){
        String[] permSetArray = new List<string>();
        PermSetArray.add('User with Read ONLY access'); // description of the needed permission set
        return permSetArray;
    }
}