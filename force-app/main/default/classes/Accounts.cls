// test PR open
public with sharing class Accounts {
    
    private static Boolean isToRun = true;
    
    private List<Account> accounts;
    
    public Accounts(List<Account> accounts){
        this.accounts = accounts;
        
        System.debug('# isToRun: ' + isToRun);
    }
    
    public void onAfterUpdate() {
                
        List<Contact> contactsToCreate = new List<Contact>();
        
        for(Account acc: this.accounts) {
            System.debug('Account: ' + acc);
            System.debug(' - isToRun: ' + isToRun);
            if(isToRun) {
                isToRun = false;
                contactsToCreate.add(new Contact(AccountId = acc.Id, LastName='Child of ' + acc.Name));
            }
                    
        }
        
        if (!contactsToCreate.isEmpty()) {
            if (!Schema.sObjectType.Contact.isCreateable() ||
                !Schema.sObjectType.Contact.fields.AccountId.isCreateable() ||
                !Schema.sObjectType.Contact.fields.LastName.isCreateable()) {
                return;
            }
            try {
                insert contactsToCreate;
            } catch (DmlException e) {
                System.debug('Error inserting Contacts: ' + e.getDmlMessage(0));
            }
        }
        
    }
    
}