public class TriggerContext {
    
    public static Map<String, Variables> variablesByName = new Map<String, Variables>();
    
    public static void setHandlerApexClassName(String triggerContextName, String handlerApexClassName) {
        if(variablesByName.containsKey(triggerContextName)) {
            variablesByName.get(triggerContextName).setHandlerApexClassName(handlerApexClassName);
        }
        else {
            Variables variables = new Variables();
            variables.setHandlerApexClassName(handlerApexClassName);
            variablesByName.put(triggerContextName, variables);
        }
    }
    
    public static void addNewRecord(String triggerContextName, SObject record) {
        if(variablesByName.containsKey(triggerContextName)) {
            variablesByName.get(triggerContextName).addNewRecord(record);
        }
        else {
            Variables variables = new Variables();
            variables.addNewRecord(record);
            variablesByName.put(triggerContextName, variables);
        }
    }
    
    public static Variables getVariables(String triggerContextName) {
        return variablesByName.get(triggerContextName);
    }
    
    public class Variables {
        // trigger context variables
        public String handlerApexClassName;
        public List<SObject> newRecords;
        
        public Variables() {
            this.newRecords = new List<SObject>();
        }
        
        public void addNewRecord(SObject record) {
            newRecords.add(record);
        }
        
        public void setHandlerApexClassName(String handlerApexClassName) {
            this.handlerApexClassName = handlerApexClassName;
        }
        
        public void execute() {
            Type customType = Type.forName(this.handlerApexClassName);
            TriggerHandler triggerHandler = (TriggerHandler) customType.newInstance();
            triggerHandler.execute();
        }
        
    }
    
}