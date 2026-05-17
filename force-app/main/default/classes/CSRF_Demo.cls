public class CSRF_Demo {

public List<Personnel__c> getPersonList() {
          List<Personnel__c> perList;
          perList = [SELECT Id, Name,Type__r.Name FROM Personnel__c where Type__r.Name='Squire' LIMIT 10];
          return perList;
        }   
public List<Personnel__c> getKnightList() {
          List<Personnel__c> perList;
          perList = [SELECT Id, Name,Type__r.Name FROM Personnel__c where Type__r.Name='Knight'];
          return perList;
        }
     private String message; 
      public void performInitAction() {
        
        try
        {
            String id = ApexPages.currentPage().getParameters().get('UserID');
            if(id==null)
            {
                setMessage('Provide an Squire user ID as a query parameter id to update the corresponding Person. Alternatively, clicking on a Update link on this page reloads the page with that Person ID.');   
                return;
            }
            Personnel__c obj = [select id, Name FROM Personnel__c WHERE id = :id];
            Resource_Type__c rt= [select id from Resource_Type__c where Name='Knight'][0];
            if (Personnel__c.sObjectType.getDescribe().isUpdateable())
            {
                obj.Type__c=rt.id;
                update obj;
            }
          }
            catch(Exception e){
                setMessage('Could not update the provided user ID');
                System.debug(e.getMessage());
                return;
        }
        setMessage('The Squire is now a Knight'); 
        return ;    
        
}
      
      public String getMessage()
    {
        return message;
    }
    
    public void setMessage(String msg)
    {
        message = msg;
    }
}