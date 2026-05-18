public interface CriterionEvaluator {
    Boolean evaluateCriterion(String fieldName, String fieldValue, SObject record);
}