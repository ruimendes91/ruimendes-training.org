public class XSS_Visualforce_Mitigations_Demo {

    public string hello {get; set;}
    public string title {get;set;}
    public string name {get;set;}
    public string color {get;set;}
    public string animal {get;set;}
    public Personnel__c person;

    public pageReference seedURL(){
        pageReference p = page.XSS_Visualforce_Mitigations_Demo;
        String user = ApexPages.currentPage().getParameters().get('user');
        if(string.isBlank(user)){      
            p.getParameters().put('user',userinfo.getName());
            p.setRedirect(true);
        } else {
            p.getParameters().put('user',user);
        }

        if(p.getRedirect()==true){
            return p;
        } else {
            return null; 
        }
        
    }   

    public XSS_Visualforce_Mitigations_Demo(){
        person = [SELECT Favorite_Animal__c,Favorite_Color__c,Id,Name,Title__c FROM Personnel__c where Favorite_Animal__c!=null and Favorite_Color__c!=null limit 1];
        title = person.title__c;
        // adding to fix demo steps...          
        title = 'THEME VIOLATION!!!!\';var newHTML = document.createElement(\'div\');newHTML.innerHTML = \'<img src="https://developer.salesforce.com/resource/images/astro.png" />\';document.body.appendChild (newHTML);var x =\'x';
        name = person.name;
        color = person.favorite_color__c;
        animal = person.favorite_animal__c;
        hello = ApexPages.currentPage().getParameters().get('user');
    }

    public pageReference HTMLXSS(){
        pageReference p = page.XSS_Visualforce_Mitigations_Demo;
        p.getParameters().put('user','THEME VIOLATION!!!! <img src="https://developer.salesforce.com/resource/images/astro.png"/>');
        p.setRedirect(true);
        return p;
    }

    public pageReference JSXSS(){
        title = 'THEME VIOLATION!!!!\';var newHTML = document.createElement(\'div\');newHTML.innerHTML = \'<img src="https://developer.salesforce.com/resource/images/astro.png" />\';document.body.appendChild (newHTML);var x =\'x';
        return null;
    }

    public pageReference JSINHTMLXSS(){
        color = 'THEME VIOLATION!!!! <img src="https://developer.salesforce.com/resource/images/astro.png"/>';
        return null;
    }
    
    public pageReference REMOVEXSS(){
        pageReference p = page.XSS_Visualforce_Mitigations_Demo;
        p.getParameters().put('user',userinfo.getName());              
        title = person.title__c;
        color = person.Favorite_Color__c;
        p.setRedirect(true);
        return p;
    }    

}