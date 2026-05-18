public class ApexEncryptionDemo {
    /* Author: Salesforce Product Security team */
     public String paramValue{get;set;}
     public String pitemId{get;set;}    
     public String pitemName{get;set;}
     public Id recordId{get;set;}
     
     String testing;
     public List<EnCrypt_Decrypt__c> deals;
     public EnCrypt_Decrypt__c encrypt{get;set;}
     public List<EnCrypt_Decrypt__c> Messages {get;set;}
    
    // Use cryptokey as the encryption key. cryptokey is stored in custom metadata settings. 
    Blob cryptoKey = Blob.valueOf([SELECT keys__c FROM secretkey__mdt].keys__c);
  
     
     
     public ApexEncryptionDemo(ApexPages.StandardController controller) {
         if (Schema.sObjectType.EnCrypt_Decrypt__c.fields.Name.isAccessible()){
        getMessages();
       

        recordId = Apexpages.CurrentPage().getParameters().get('id');
        if(recordId !=null){
            encrypt = [SELECT Name From EnCrypt_Decrypt__c 
                    WHERE id=:recordId];
        }
        else{
            encrypt = new EnCrypt_Decrypt__c();
        }
         }
    }
     
     public PageReference DeleteMe(){
         if (!EnCrypt_Decrypt__c.sObjectType.getDescribe().isDeletable()){

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,

                                                    'Insufficient access'));

        return null;
      }

         
        if(pitemId != ''){
            deals  = [select Id, Name from EnCrypt_Decrypt__c where id =:pitemId];
        }
  
     if(deals.size() > 0 ){ delete deals; }
       getMessages();
       return null; 
     }
    
    
       public PageReference DecryptMe(){
         
       
          
           if(pitemName != NULL && pitemName != ''){
         
         
         paramValue = pitemName;
          }
          else{
              System.debug('PitemName was NULL NULL NULL NULL');
          }
         //update encrypt;
         return null; 
    }
    
    
    
    public List<EnCrypt_Decrypt__c> getMessages() {
         if (!Schema.sObjectType.EnCrypt_Decrypt__c.fields.Name.isAccessible()){

                    return NULL;

        }
        Messages =  [select Id, Name from EnCrypt_Decrypt__c ORDER BY LastModifiedDate DESC NULLS FIRST];
        return Messages;
    }
    
    
    
    
     public PageReference Save(){
         if (!Schema.sObjectType.EnCrypt_Decrypt__c.fields.Name.isCreateable()){

                    return NULL;

        }
         try{
                 if(pitemName != NULL && pitemName != ''){
                     if(encrypt.Name.length() < 80) {
                        
                        // Add code here 
                        
                         insert encrypt;
                         encrypt.id = null;
                          getMessages();
                         }
         }
          
       
                } catch (Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'String empty or handling an error!');
                    ApexPages.addMessage(myMsg);
                }
         return null; 
     }
    


}