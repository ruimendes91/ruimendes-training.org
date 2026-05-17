({
    createRecords : function(cmp, event, helper) {

        var totalToCreate = cmp.get("v.recordsToCreate");
        var action = cmp.get("c.createRecords");
        action.setParams({
            total: totalToCreate,
        });

        action.setCallback(this, function (response) {

            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set('v.statusOfCreation', result );
                cmp.set("v.isloading",false);
                

            } else {
                console.log("Error on try to Create Records.");
                cmp.set("v.isloading",false);

            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();

    },
})