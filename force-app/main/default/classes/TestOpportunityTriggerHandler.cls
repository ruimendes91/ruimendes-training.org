public with sharing class TestOpportunityTriggerHandler implements TriggerAction.BeforeInsert {
    
    public void beforeInsert(List<Opportunity> opportunities) {
        system.debug('TestOpportunity');
    }

}