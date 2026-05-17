({
    searchCreaturesAction : function(component, event, helper) {
        component.set("v.creatures", "Searching...");
        var getCreaturesAction = component.get("c.searchCreatures");
        getCreaturesAction.setParams({ creatureName : component.find("InputName").get("v.value") });
        getCreaturesAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var results = response.getReturnValue();
                var outputT = '<table class="slds-table--bordered slds-table--cell-buffer"><tr><th>Name</th><th>Type</th><th>Description</th><th>Region</th></tr>';
                for (var i=0;i<results.length;i++) {
                    outputT += "<tr><td><strong><a href=\"/"+results[i].Id+"\">" + results[i].Name + "</a></strong></td>";
                    outputT += "<td>" + results[i].Type__c + "</td>";
                    outputT += "<td><div>"+results[i].Description__c+"</div></td>";
                    if(results[i].Creature_Region__r  === undefined){
                        outputT += "<td>Unknown</td>";
                    } else {
						outputT += "<td>" + results[i].Creature_Region__r.Name + "</td></tr>";
                    }
                }
                outputT += "</table>";
                component.set("v.creatures", outputT);
            }
        });
        $A.enqueueAction(getCreaturesAction);
    }
})