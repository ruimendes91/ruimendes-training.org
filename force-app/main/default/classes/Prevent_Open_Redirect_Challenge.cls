public class Prevent_Open_Redirect_Challenge {

	public Resource_Type__c rtype {get;set;}

	public Prevent_Open_Redirect_Challenge(){
		if(rtype==null){
			string rtid = [select id from recordType where sObjectType = 'Resource_Type__c' and DeveloperName = 'Personnel' limit 1].id; 
		    rtype = new Resource_Type__c(recordtypeid=rtid);
		}
	}

    public PageReference save(){
        PageReference savePage;
        if (Schema.SObjectType.Resource_Type__c.isCreateable()){
            try{


                insert rtype;

                String finishURL = ApexPages.currentPage().getParameters().get('finishURL');
                
                savePage = new PageReference(finishURL);
                
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

    public pageReference seedURL(){
        pageReference p = page.Prevent_Open_Redirect_Challenge;
        String keyPrefix = Resource_Type__c.sObjectType.getDescribe().getKeyPrefix();

        String finishURL = ApexPages.currentPage().getParameters().get('finishURL');
        if(string.isBlank(finishURL)){      
            p.getParameters().put('finishURL', '/'+keyPrefix);
            p.setRedirect(true);
        } else {
        	p.getParameters().put('finishURL',finishURL);
        }

        if(p.getRedirect()==true){
        	return p;
        } else {
        	return null; 
        }
    }

}