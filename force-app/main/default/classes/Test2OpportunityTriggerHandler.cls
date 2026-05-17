public with sharing class Test2OpportunityTriggerHandler implements TriggerAction.BeforeInsert {
    
    public void beforeInsert(List<Opportunity> opportunities) {
        system.debug('Test2Opportunity');
    }

}