({
	attemptEntry : function(component, event, helper) {
		var currentPeople = component.get("v.currentPeople");
        var guardAsleep = component.get("v.guardAsleep");
        currentPeople += 5;
        if(currentPeople <= 25 || guardAsleep) {
            component.set("v.currentPeople", currentPeople);
        } 
        else {
    		var toastEvent = $A.get("e.force:showToast");
    		toastEvent.setParams({
        		"title": "Guard Says",
        		"message": "No more people allowed in...!!"
    		});
   		 	toastEvent.fire();
        } 
	}
})