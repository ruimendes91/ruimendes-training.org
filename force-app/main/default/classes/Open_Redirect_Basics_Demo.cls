public class Open_Redirect_Basics_Demo {


    public List<Requisition__c> requisitions {get;set;}


    public Open_Redirect_Basics_Demo(){
        requisitions = new List<Requisition__c>();
        for(Requisition__c requisition : [SELECT name, Castle__c, Resource__c, Quantity__c, Description__c FROM Requisition__c LIMIT 5]){
            requisitions.add(requisition);
        } 
    }


    public pageReference seedURL(){
        pageReference p = page.Open_Redirect_Basics_Demo;
        String keyPrefix = Requisition__c.sObjectType.getDescribe().getKeyPrefix();
        String onSave = ApexPages.currentPage().getParameters().get('onSave');
        String onCancel = ApexPages.currentPage().getParameters().get('onCancel'); 
        if(string.isBlank(onCancel)){      
            p.getParameters().put('onCancel', '/home/home.jsp');
            p.setRedirect(true);
        } else {
            p.getParameters().put('onCancel',onCancel);
        }
        if(string.isBlank(onSave)){      
            p.getParameters().put('onSave', '/home/home.jsp');
            p.setRedirect(true);
        } else {
            p.getParameters().put('onSave',onSave);
        }

        if(p.getRedirect()==true){
            return p;
        } else {
            return null; 
        }
    }


    public PageReference save(){
        PageReference savePage;
        if (Schema.SObjectType.Requisition__c.isUpdateable()){
            try{
                update requisitions;
                String onsave = ApexPages.currentPage().getParameters().get('onSave');
                onSave = (onSave == NULL) ? '/home/home.jsp' : onSave;
                savePage = new PageReference(onSave);
                savePage.setRedirect(true);
                return savePage;
            }catch (exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Unable to update requisitions.  Exception: ' + e.getMessage()));
                return null;
            } 
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'You do not have permission to update requisitions'));
            return null;
        }
    }
    

}