public with sharing class OpportunityExampleTriggerAction implements TriggerAction.BeforeInsert {
    
    public void beforeInsert(List<Opportunity> opportunities) {
        system.debug('OpportunityExampleTriggerAction');
    }

}