public class LTNG_Landing {
	@AuraEnabled
    public static void readyOrg(){
		Creature__c balrog = [select Id from Creature__c where Name='Balrog' limit 1][0];
        Region__c underworld = [select Id, Name, Common_Monster__c from Region__c where Name='Underworld' limit 1][0];
        underworld.Common_Monster__c = balrog.Id;
        update underworld;
        
        Creature__c golem = [select Id from Creature__c where Name='Golem' limit 1][0];
        Region__c badlands = [select Id, Name, Common_Monster__c from Region__c where Name='Badlands' limit 1][0];
        badlands.Common_Monster__c = golem.Id;
        update badlands;
        
        Creature__c kraken = [select Id from Creature__c where Name='Kraken' limit 1][0];
        Region__c sea = [select Id, Name, Common_Monster__c from Region__c where Name='The Great Sea' limit 1][0];
        sea.Common_Monster__c = kraken.Id;
        update sea;
    }
}