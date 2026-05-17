public with sharing class CRUD_FLS_Challenge {
    
    public List<Treasures__c> treasures {get;set;}
    public String chestContents {get;set;}
     
    public CRUD_FLS_Challenge()
    {        
        treasures = new List<Treasures__c>([select Name, Type__c, Found__c, Description__c, Castle__r.Name FROM Treasures__c where Found__c =: True limit 5]);  
    }
        
    public void getRandomTreasure() {
    
        // Check if the user has read access on the Contact.Name field
        if (!Schema.sObjectType.Contact.fields.Name.isAccessible()){
          return;
        }
        
        Treasures__c [] myList = [SELECT Name FROM Treasures__c LIMIT 1000];
        // Pick a list entry at random
        Integer index = Math.mod(Math.abs(Crypto.getRandomInteger()),myList.size());
        Treasures__c selected = myList.get(index);
        chestContents = selected.Name;
    }

    public string[] getPermSets(){
        String[] permSetArray = new List<string>();
        PermSetArray.add('User with No CRUD nor FLS');
        return permSetArray;
    }

    
    
}