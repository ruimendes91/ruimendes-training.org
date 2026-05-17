public with sharing class CRUD_Demo {
    
    public List<TreasureWrapper> dereferencedTreasures {get;set;}
    public List<Treasures__c> treasures {get;set;}
     
    public CRUD_Demo()
    {
        dereferencedTreasures = new List<TreasureWrapper>();
        
        treasures = new List<Treasures__c>([select Name, Type__c, Found__c, Description__c, Castle__r.Name FROM Treasures__c where Found__c =: True limit 5]);
        
        for(Treasures__c t : treasures)
            dereferencedTreasures.add(new TreasureWrapper(t));  
    }
        
    
    
    public with sharing class TreasureWrapper {
        public Treasures__c treasure {get; private set;}
        
        public TreasureWrapper(Treasures__c treasure) {
            this.treasure = treasure;
        } 
        
        public String getName(){
            return treasure.Name;
        }
        
        public Boolean getFound(){
            return treasure.Found__c;
        }
        
        public String getDescription(){
            return treasure.Description__c;
        }
        
        public String getCastle(){
            return treasure.Castle__r.Name;
        }
    
    }
    
    public string[] getPermSets(){
        String[] permSetArray = new List<string>();
        PermSetArray.add('User with No CRUD nor FLS');
        PermSetArray.add('User with Limited Access to Treasures'); // description of the needed permission set
        return permSetArray;
    }

    
    
}