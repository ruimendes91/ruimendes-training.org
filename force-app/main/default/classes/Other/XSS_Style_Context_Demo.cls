public with sharing class XSS_Style_Context_Demo {
	public String color {get; set;}
    public List<Personnel__c> personnel {get;set;}
    
    public XSS_Style_Context_Demo()
    {
    	if(ApexPages.currentPage().getParameters().get('color') != null) {
    		color = ApexPages.currentPage().getParameters().get('color');
    	}
    	else
    	{
    		color = 'red';  
    	}
    	
    	personnel = getPersonnel();
    }
    
    public pageReference seedURL()
    {
    	pageReference p = page.XSS_in_Style_Context; 
        String color= ApexPages.currentPage().getParameters().get('color');
        if(string.isBlank(color)){       
            p.getParameters().put('color', 'red');
            p.setRedirect(true);
        } else {
            p.getParameters().put('color',color);
        }

        if(p.getRedirect()==true){
            return p;
        } else {
            return null; 
        }
    }
    
    public List<Personnel__c> getPersonnel()
    {
    	return [select name, age__c, favorite_color__c, favorite_animal__c from Personnel__c where favorite_color__c != null limit 10];
    }
    
    public PageReference save(){
        PageReference savePage;
        if (Schema.SObjectType.Personnel__c.isUpdateable()){
            try{
                savePage = page.XSS_in_Style_Context;
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

    public PageReference cancel(){
    	PageReference cancelPage = page.XSS_in_Style_Context;
        cancelPage.setRedirect(true);
        return page.XSS_in_Style_Context;
    }
    
    
}