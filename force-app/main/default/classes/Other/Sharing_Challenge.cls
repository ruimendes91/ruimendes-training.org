public class Sharing_Challenge {

    public List<Coin_Purse__c> gold_normal_record {get; set;}
    public List<Coin_Purse__c> gold_async_record {get; set;}

    public void Sharing_Challenge() {
    
        Share_Challenge s_norm = new Share_Challenge(this);
        AsyncExecutionExample a_async = new AsyncExecutionExample(this);
        
        s_norm.s_chal_func();
        a_async.a_gold_search();
    }        
  
    
    public class AsyncExecutionExample implements Queueable {
        Sharing_Challenge s_chal;

        public AsyncExecutionExample(Sharing_Challenge s_chal) {
            this.s_chal = s_chal;
        }
        public PageReference a_gold_search(){ 
            if(Coin_Purse__c.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.Coin_Purse__c.fields.Name.isAccessible() 
               														&& Schema.sObjectType.Coin_Purse__c.fields.Coin_location__c.isAccessible() 
               														)
            {
                string query = 'SELECT Id,Name, Coin_location__c,Coin_Purse_Owner__r.Name FROM Coin_Purse__c';
                s_chal.gold_async_record = Database.query(query);
                return null;
            }
            else{
                return null;
            }
        }        
        public void execute(QueueableContext context){
            System.debug('==========>>>>>>>>Async sharing Violation example<<<<============');
   
        }
    }    
    
    public class Share_Challenge {
      Sharing_Challenge s_chal;
        public Share_Challenge(Sharing_Challenge s_chal) {
            this.s_chal = s_chal;
        }    
    
        public PageReference s_chal_func(){
            if(Coin_Purse__c.sObjectType.getDescribe().isAccessible() && Schema.sObjectType.Coin_Purse__c.fields.Name.isAccessible()  
               															&& Schema.sObjectType.Coin_Purse__c.fields.Coin_location__c.isAccessible() 
               															)
            {
                string query = 'SELECT Id,Name,Gold_coins__c, Coin_location__c, Coin_Purse_Owner__r.Name FROM Coin_Purse__c';
                s_chal.gold_normal_record = Database.query(query);    
                return null;
            }else {
                return null;
            }
        }

    }

    public string[] getPermSets(){
            String[] permSetArray = new List<string>();
            PermSetArray.add('Simulate Farmer User'); // description of the needed permission set
            return permSetArray;
    }   
}