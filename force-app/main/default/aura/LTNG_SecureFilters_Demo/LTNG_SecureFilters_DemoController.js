({
    searchCreature : function(component, event, helper) {
        component.set("v.creatures", "Searching...");
        var getCreaturesAction = component.get("c.searchCreatures");
        getCreaturesAction.setParams({ creatureName : component.find("InputName").get("v.value") });
        getCreaturesAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var results = response.getReturnValue();
                var outputT = "";
                for (var i=0;i<results.length;i++) {
                    outputT += "<strong>Name: " + secureFilters.html(results[i].Name) + "</strong><br />";
                    outputT += "Id: " + results[i].Id + "<br />";
                    outputT += "Description: " + results[i].Description__c + "<br />";
                    outputT += "Region: " + results[i].Creature_Region__r.Name + "<br /><hr/>";
                }
                component.set("v.creatures", outputT);
            }
        });
        $A.enqueueAction(getCreaturesAction);
    }
})