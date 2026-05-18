public class Sharing_Demo {
    
    public List<Coin_Purse__c> whereclause_records {get; set;}

    public PageReference whereclause_search(){
        if(Coin_Purse__c.sObjectType.getDescribe().isAccessible() && 
            Schema.sObjectType.Coin_Purse__c.fields.Coin_Purse_Owner__c.isAccessible() && 
            Schema.sObjectType.Coin_Purse__c.fields.Copper_Coins__c.isAccessible() && 
            Schema.sObjectType.Coin_Purse__c.fields.Gold_Coins__c.isAccessible() && 
            Schema.sObjectType.Coin_Purse__c.fields.Silver_Coins__c.isAccessible())
        {
            string query = 'SELECT Coin_Purse_Owner__r.Name,Gold_coins__c, Silver_Coins__c, Copper_Coins__c FROM Coin_Purse__c';
            whereclause_records = Database.query(query);  
            return null;
        }
        else
        {
            return null;
        }
    }
    
    public string[] getPermSets(){
        String[] permSetArray = new List<string>();
        PermSetArray.add('Simulate Farmer User'); // description of the needed permission set
        return permSetArray;
    }
}