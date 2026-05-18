public class CriteriaSettingEvaluator {
    
    private Map<String, CriterionEvaluator> criterionEvaluatorByOperator;
    
    private Criteria_Setting__mdt criteriaSetting;
    private List<Criterion__mdt> criterionList;
    
    public CriteriaSettingEvaluator(
        Criteria_Setting__mdt criteriaSetting, 
        List<Criterion__mdt> criterionList
    ) {
        this.criterionEvaluatorByOperator = new Map<String, CriterionEvaluator> {
        	'equals' => new EqualsCriterionEvaluator()
        };
        this.criteriaSetting = criteriaSetting;
        this.criterionList = criterionList;
    }
    
    public Boolean evaluateCriteria(SObject record) {
        for(Criterion__mdt criterion: criterionList) {
            CriterionEvaluator criterionEvaluator = this.criterionEvaluatorByOperator.get(criterion.Operator__c);
            switch on criterion.Comparison_Type__c {
                when 'field' {
                    Boolean result = criterionEvaluator.evaluateCriterion(criterion.Field_Name_1__c, criterion.Field_Name_2__c, record);
                    if(result == false) {
                        return false;
                    }
                }
                when 'value' {
                    Boolean result = criterionEvaluator.evaluateCriterion(criterion.Field_Name_1__c, criterion.Field_Value__c, record);
                    if(result == false) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
    
}