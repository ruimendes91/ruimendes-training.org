({
    getAllCreaturesAction : function(component, event, helper) {
        var getAccountsAction = component.get("c.getAllCreatures");
        getAccountsAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var results = response.getReturnValue();
                
                // Let's create a beautiful table with results:
                var outputT = "<table class=\"slds-table slds-table--bordered slds-table--cell-buffer \">";
                outputT += "<thead><tr class=\"slds-text-title--caps\">";
                outputT += "<th scope=\"col\"><div class=\"slds-truncate\" title=\"Id\">Id</div></th>";
                outputT += "<th scope=\"col\"><div class=\"slds-truncate\" title=\"Name\">Name</div></th>";
                outputT += "<th scope=\"col\"><div class=\"slds-truncate\" title=\"Description\">Description</div></th>";
                outputT += "<th scope=\"col\"><div class=\"slds-truncate\" title=\"Region\">Region</div></th>";
                outputT += "</tr></thead><tbody>";
                for (var i=0;i<results.length;i++) {
                    outputT += "<tr><th scope=\"row\" data-label=\"Id\"><div class=\"slds-truncate\" title=\"Id\">" + results[i].Id + "</div></th>";
                    outputT += "<td data-label=\"Name\"><div class=\"slds-truncate\" title=\"Name\">" + results[i].Name + "</div></td>";
                    outputT += "<td data-label=\"Name\"><div class=\"slds-truncate\" title=\"Description\">" + results[i].Description__c + "</div></td>";
                    outputT += "<td data-label=\"Company\"><div class=\"slds-truncate\" title=\"Region\">" + results[i].Creature_Region__r.Name + "</div></td></tr>";
                }
                outputT += "</tbody></table>";
                component.set("v.creatures", outputT);
            }
        });
        $A.enqueueAction(getAccountsAction);
	}
})