@isTest
private class AccountsTest {

    @isTest
    static void onAfterUpdate_createsContactForAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        acc = [SELECT Id, Name FROM Account WHERE Id = :acc.Id];

        Accounts handler = new Accounts(new List<Account>{ acc });

        Test.startTest();
        handler.onAfterUpdate();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id, LastName, AccountId FROM Contact WHERE AccountId = :acc.Id];
        Assert.areEqual(1, contacts.size(), 'Expected one contact to be created');
        Assert.areEqual('Child of ' + acc.Name, contacts[0].LastName, 'Contact LastName should be Child of <Account Name>');
    }

    @isTest
    static void onAfterUpdate_onlyCreatesOneContactAcrossMultipleAccounts() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Account One'),
            new Account(Name = 'Account Two')
        };
        insert accounts;
        accounts = [SELECT Id, Name FROM Account WHERE Id IN :new Map<Id, Account>(accounts).keySet()];

        Accounts handler = new Accounts(accounts);

        Test.startTest();
        handler.onAfterUpdate();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId IN :new Map<Id, Account>(accounts).keySet()];
        Assert.areEqual(1, contacts.size(), 'isToRun flag should limit creation to one contact per transaction');
    }

    @isTest
    static void onAfterUpdate_withEmptyList_createsNoContacts() {
        Accounts handler = new Accounts(new List<Account>());

        Test.startTest();
        handler.onAfterUpdate();
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact];
        Assert.areEqual(0, contacts.size(), 'No contacts should be created for an empty account list');
    }
}
