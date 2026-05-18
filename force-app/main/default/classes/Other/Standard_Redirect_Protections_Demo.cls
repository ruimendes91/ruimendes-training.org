public class Standard_Redirect_Protections_Demo {

    public List<Personnel__c> knights {get;set;}
  
    public Standard_Redirect_Protections_Demo(){
        knights = new List<Personnel__c>();
        for(Personnel__c knight : [SELECT Assignment__c,Castle__c,Name,Quarters__c,Title__c,Type__c FROM Personnel__c WHERE Type__r.Name = 'Knight' LIMIT 5]){
            knights.add(knight);
        } 
    }

}