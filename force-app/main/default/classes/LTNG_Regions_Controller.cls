public with sharing class LTNG_Regions_Controller {
    @AuraEnabled
    public static Region__c getRegionByName(String regionName){
        if(Region__c.SObjectType.getDescribe().isAccessible()) {
            String searchTerm = '%' + string.escapeSingleQuotes(regionName) + '%';
            return [SELECT Id, Name, Description__c, Common_Monster__c FROM Region__c WHERE Name like :searchTerm LIMIT 1];
        } else {
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Creature__c> getCreaturesForRegion(Id regionId) {
        List<Creature__c> creatures = new List<Creature__c>();
        return [SELECT Name, Id, Description__c, Type__c from Creature__c WHERE Creature_Region__c =: regionId];
    }
}