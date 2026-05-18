public with sharing class XSS_Script_Context_Demo {

    public PageReference seedURL() {
        pageReference p = page.XSS_in_Script_Context;
        String input= ApexPages.currentPage().getParameters().get('userInput');
        if(string.isBlank(input)){       
            p.getParameters().put('userInput', 'test');
            p.setRedirect(true);
        } else {
            p.getParameters().put('userInput',input);
        }

        if(p.getRedirect()==true){
            return p;
        } else {
            return null; 
        }
    }

}