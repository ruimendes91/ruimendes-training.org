public class EqualsCriterionEvaluator implements CriterionEvaluator {
    public Boolean evaluateCriterion(String fieldName, String fieldValue, SObject record) {
        String actualFieldValue = String.valueOf(record.get(fieldName));
        return actualFieldValue == fieldValue;
    }
}