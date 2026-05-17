public with sharing class XSS_Automatic_HTML_Encoding_Demo {
	public String name {get; set;}
    
    public XSS_Automatic_HTML_Encoding_Demo()
    {
    	if(ApexPages.currentPage().getParameters().get('name') != null) {
    		name = ApexPages.currentPage().getParameters().get('name');
    	}
    	else
    	{
    		name = UserInfo.getFirstName();
    	}
    }
    
    public pageReference seedURL()
    {
    	pageReference p = page.XSS_Automatic_HTML_Encoding_Demo;
        String completion = ApexPages.currentPage().getParameters().get('name');
        if(string.isBlank(completion)){      
            p.getParameters().put('name', UserInfo.getFirstName());
            p.setRedirect(true);
        } else {
            p.getParameters().put('name',completion);
        }

        if(p.getRedirect()==true){
            return p;
        } else {
            return null;  
        }
    }
    
    public pageReference seedDisableURL()
    {
    	pageReference p = page.XSS_Disabling_HTML_Encoding;
        String completion = ApexPages.currentPage().getParameters().get('name');
        if(string.isBlank(completion)){      
            p.getParameters().put('name', UserInfo.getFirstName());
            p.setRedirect(true);
        } else {
            p.getParameters().put('name',completion);
        }

        if(p.getRedirect()==true){
            return p;
        } else {
            return null; 
        }
    }
}