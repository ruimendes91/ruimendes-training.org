trigger OpportunityTrigger on Opportunity (
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {

    
    Map<String, Criteria_Setting__mdt> criteriaSettingById = new Map<String, Criteria_Setting__mdt>();    
    
    Map<String, List<Criterion__mdt>> criterionListByCriteriaId = new Map<String, List<Criterion__mdt>>();
    
    for(Criterion__mdt criterion: Criterion__mdt.getAll().values()) {
        String criteriaId = criterion.Criteria_Setting__c;
        if(!criteriaSettingById.containsKey(criteriaId)) {
            criteriaSettingById.put(criteriaId, Criteria_Setting__mdt.getInstance(criteriaId));
        }
        if(criterionListByCriteriaId.containsKey(criteriaId)) {
            criterionListByCriteriaId.get(criteriaId).add(criterion);
        }
        else {
            criterionListByCriteriaId.put(criteriaId, new List<Criterion__mdt> { criterion });
        }
    }
    
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for(SObject record: Trigger.new) {
            for(String criteriaId: criterionListByCriteriaId.keySet()) {
                Criteria_Setting__mdt criteriaSetting = criteriaSettingById.get(criteriaId);
                List<Criterion__mdt> criterionList = criterionListByCriteriaId.get(criteriaId);
                CriteriaSettingEvaluator criteriaSettingEvaluator = new CriteriaSettingEvaluator(criteriaSetting, criterionList);
                if(criteriaSettingEvaluator.evaluateCriteria(record)) {
                    TriggerContext.setHandlerApexClassName(criteriaSetting.DeveloperName, criteriaSetting.Trigger_Handler_Class_Name__c);
                    TriggerContext.addNewRecord(criteriaSetting.DeveloperName, record);
                }       
            }
        }
    }
    
    for(TriggerContext.Variables triggerContext: TriggerContext.variablesByName.values()) {
        triggerContext.execute();
    }
    
    //new MetadataTriggerHandler().run();

    
}