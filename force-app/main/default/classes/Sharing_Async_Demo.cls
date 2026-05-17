// Add with sharing to this class
public class Sharing_Async_Demo  implements Queueable {
/*
public List<Gold_store__c> whereclause_records {get; set;}
    
        public PageReference whereclause_search(){
            ID jobID = System.enqueueJob(new Sharing_Async_Demo());  
              if(Gold_store__c.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.Gold_store__c.fields.Name.isAccessible() && Schema.sObjectType.Gold_store__c.fields.Gold_coins__c.isAccessible() && Schema.sObjectType.Gold_store__c.fields.Job__c.isAccessible() && Schema.sObjectType.Gold_store__c.fields.Ownerid.isAccessible())
        {
            string query = 'SELECT Name,Gold_coins__c,Job__c,Owner.Name FROM Gold_store__c';
             whereclause_records = Database.query(query);  
                return null;
            return null;
            }else{
            return null;}
    }        */
        public void execute(QueueableContext context){
            System.debug('==========>>>>>>>>Async sharing Violation example<<<<============');
  
        }
   /* public string[] getPermSets(){
        String[] permSetArray = new List<string>();
        PermSetArray.add('Farmer Sharing Demo'); // description of the needed permission set
        return permSetArray;
    }*/
}