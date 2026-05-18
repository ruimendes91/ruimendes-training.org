public class Visualforce_Anti_Protections_Demo {


	public List<Requisition__c> requisitions {get;set;}


	public Visualforce_Anti_Protections_Demo(){
	    requisitions = new List<Requisition__c>();
	    for(Requisition__c requisition : [SELECT name, Castle__c, Resource__c, Quantity__c, Description__c FROM Requisition__c LIMIT 5]){
	        requisitions.add(requisition);
	    } 
	}


    public pageReference seedURL(){
        pageReference p = page.Visualforce_Anti_Protections_Demo;
        String urlParam = ApexPages.currentPage().getParameters().get('retURL');
        if(string.isBlank(urlParam)){      
            p.getParameters().put('retURL', '/home/home.jsp');
            p.setRedirect(true);
            return p;
        }
        return null;      
    }


    public PageReference save(){
        PageReference savePage;
        if (Schema.SObjectType.Requisition__c.isUpdateable()){
            try{
                update requisitions;
                String onsave = ApexPages.currentPage().getParameters().get('retURL');
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


    public PageReference cancel() {
        PageReference cancelPage;
        String onCancel = ApexPages.currentPage().getParameters().get('retURL');
        if(string.isBlank(onCancel)){
            onCancel = '/home/home.jsp';
        }
        cancelPage = new PageReference(onCancel);
        cancelPage.setRedirect(true);
        return cancelPage;
    }    


}