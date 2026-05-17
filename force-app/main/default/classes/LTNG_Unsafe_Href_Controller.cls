public class LTNG_Unsafe_Href_Controller {
    @AuraEnabled
    public static List<Region__c> getRegionInfo(string regionName) {
        if(Region__c.SObjectType.getDescribe().isAccessible()) {
            string searchTerm = '%' + string.escapeSingleQuotes(regionName) + '%';
            List<Region__c> regions = [SELECT Name, Id, Common_Monster__c from Region__c WHERE Name like: searchTerm];
			return regions;
        }
        else {
            return null;
        }
    }
}