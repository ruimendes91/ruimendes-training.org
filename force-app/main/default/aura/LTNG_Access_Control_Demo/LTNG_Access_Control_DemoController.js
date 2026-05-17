({
	withdrawMoney : function(component, event, helper) {
		var money = component.get("v.cofferSize");
        var isLimited = component.get("v.loanLimit");
        money -= 5000;
        if(money > 10000 || isLimited) { // we have money or unlimited spending
            component.set("v.cofferSize", money);
        } else {
    		var toastEvent = $A.get("e.force:showToast");
    		toastEvent.setParams({
        		"title": "Sorry!",
        		"message": "The bank is closed for the moment and no unlimited loans have been allowed"
    		});
   		 	toastEvent.fire();
        } 
	}
})