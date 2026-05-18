public with sharing class FLS_Update_Demo {

    public List<Jouster__c> jousters {get;set;}

    public FLS_Update_Demo()
    {
       init();
    }
    
    public void init(){
        jousters = [select Id, Participant_Name__r.Name, Castle__r.Name, Rank__c, Score__c, Color__c from Jouster__c order by Rank__c ASC];
    }
    
    public PageReference updateRequest(){      
        try{ 
            update jousters;
            
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        init();
        return null;
    }
    
    public string[] getPermSets(){
        String[] permSetArray = new List<string>();
        PermSetArray.add('User with Read ONLY Access to the Jousters object'); // description of the needed permission set
        return permSetArray;
    }
}