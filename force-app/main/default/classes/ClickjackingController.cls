public with sharing class ClickjackingController {
    
    public String sendId {get;set;}
    public boolean reload {get;set;}
    public List<Personnel__c> accused { get;set;}
    public List<Personnel__c> toweracc {get;set;}
    public Integer numBanished {get;set;}
    
    public ClickjackingController()
    {
        accused = getAccused();
        toweracc = getTowerInhabitants();
    }


    public List<Personnel__c> getAccused() {
          List<Personnel__c> perList;
          perList = [SELECT Id, Name, Type__r.Name, Castle__r.Name, Assignment__r.Name, Disloyal_Subject__c FROM Personnel__c where Disloyal_Subject__c=True AND Assignment__r.Name != 'High Tower'];
          return perList;
        }
        
    public List<Personnel__c> getTowerInhabitants() {
          List<Personnel__c> PerList;
          PerList = [SELECT Id, Name, Castle__r.Name, Assignment__r.Name, Disloyal_Subject__c, Type__r.Name FROM Personnel__c where Assignment__r.Name ='High Tower']; 
          return PerList;
        } 
  
    private String message='';
      
    public void sendToTower() {
        try
        {  
            String id = sendId;
            
           if(id==null)
            {
                setMessage('Error: No more persons to banish');   
                return;
            }
            
            Personnel__c obj = [select id, Name, Castle__r.Name, Assignment__c FROM Personnel__c WHERE id = :id];
            Property__c loc = [select id FROM Property__c where Castle__r.Name =: obj.Castle__r.Name AND Name = 'High Tower'];
            obj.Assignment__c = loc.id;
                        
            if (Personnel__c.sObjectType.getDescribe().isUpdateable())
            {
                update obj;
            }
            reload=true;
         }
            catch(Exception e){
                setMessage('Could not update the provided user');
                System.debug(e.getMessage());    
                return;        
        } 
        setMessage('User sent to the High Tower!'); 
        accused = getAccused();
        toweracc = getTowerInhabitants();
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