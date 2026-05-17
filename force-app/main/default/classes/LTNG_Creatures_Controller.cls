public with sharing class LTNG_Creatures_Controller {
    @AuraEnabled
    public static List<Creature__c> searchCreatures(string creatureName) {
        if(Creature__c.SObjectType.getDescribe().isAccessible()) {
            string searchTerm = '%' + string.escapeSingleQuotes(creatureName) + '%';
            return [SELECT Name, Id, Description__c, Type__c, Creature_Region__r.Name from Creature__c WHERE Name like: searchTerm];
        }
        else {
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Creature__c> getAllCreatures(){
        if(Creature__c.SObjectType.getDescribe().IsAccessible()){ 
            return [SELECT Name, Id, Description__c, Type__c, Creature_Region__r.Name from Creature__c];
        } else {
            return null;
        }
    }
}