({
    getRegionInfoFunction : function(component, event, helper) {
        var getRegionAction = component.get("c.getRegionInfo");
        getRegionAction.setParams({ regionName : component.find("InputName").get("v.value") });
        getRegionAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var results = response.getReturnValue();
                component.set("v.region",results[0]);
                var region = results[0];
                
                //Check if Common_Monster__c is Id compliant
                var letterNumber = /^[0-9a-zA-Z]+$/;
                if(results[0].Common_Monster__c.match(letterNumber)) {
                    component.set('v.safeCommonMonster',results[0].Common_Monster__c); 
                }
            }
        });
        $A.enqueueAction(getRegionAction);
	}
})