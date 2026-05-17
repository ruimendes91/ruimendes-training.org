public with sharing class FLS_Demo {

 public List<TreasureWrapper> dereferencedTreasures {get;set;}
  public List<Treasures__c> treasures {get;set;}
   
  public FLS_Demo()
  {
    dereferencedTreasures = new List<TreasureWrapper>();
    
    treasures = new List<Treasures__c>([select Name, Type__c, Found__c, Description__c, Castle__r.Name, Storage_Location__r.Name FROM Treasures__c where Found__c=true limit 5]);
    
    for(Treasures__c t : treasures)
      dereferencedTreasures.add(new TreasureWrapper(t));  
  }
  
     public with sharing class TreasureWrapper {
      public string TreasureName {get; private set;}
      public string TreasureType {get; private set;}
      public boolean TreasureFound {get; private set;}
      public string TreasureDescription {get; private set;}
      public string TreasureCastleName {get; private set;}
      public string TreasureCastleLocation {get; private set;}
      
      public TreasureWrapper(Treasures__c treasure) {
          this.TreasureName = treasure.Name;
          this.TreasureType = treasure.Type__c;
          this.TreasureFound = treasure.Found__c;
          this.TreasureDescription = treasure.Description__c;
          this.TreasureCastleName = treasure.Castle__r.Name;
          this.TreasureCastleLocation = treasure.Storage_Location__r.Name;
      } 
      
  }

 public string[] getPermSets(){
        String[] permSetArray = new List<string>();
        PermSetArray.add('User with CRUD but no FLS'); // description of the needed permission set
        return permSetArray;
    }
    
    
}