({
	onInit : function(component, event, helper) {
		var readyOrg = component.get("c.readyOrg");
        $A.enqueueAction(readyOrg);
	}
})