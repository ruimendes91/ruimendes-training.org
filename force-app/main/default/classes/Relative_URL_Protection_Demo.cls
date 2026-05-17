public class Relative_URL_Protection_Demo {

    public List<Personnel__c > unassigned {get;set;}

    public Relative_URL_Protection_Demo(){
        unassigned = new List<Personnel__c >();
        for(Personnel__c per : [SELECT name, Assignment__c, Castle__c,Role__c FROM Personnel__c WHERE Assignment__c = null LIMIT 5]){
            unassigned.add(per);
        } 
    }

    public pageReference seedURL(){
        pageReference p = page.Relative_URL_Protection_Demo;
        String onSave = ApexPages.currentPage().getParameters().get('onSave');
        String onCancel = ApexPages.currentPage().getParameters().get('onCancel'); 
        if(string.isBlank(onCancel)){      
            p.getParameters().put('onCancel', 'https://en.wikipedia.org/wiki/Knights_who_say_Ni');
            p.setRedirect(true);
        } else {
            p.getParameters().put('onCancel',onCancel);
        }
        if(string.isBlank(onSave)){      
            p.getParameters().put('onSave', '/apex/relative_url_protection_demo');
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
    if (Schema.SObjectType.Personnel__c.isUpdateable()){
    try{
        update unassigned;
        String completion = ApexPages.currentPage().getParameters().get('onSave');

        if(completion.startsWith('/')){
            completion = completion.replaceFirst('/','');
        }
        savePage = new PageReference('/'+completion);

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
/*
    public PageReference cancel(){
        PageReference cancelPage;
        String completion = ApexPages.currentPage().getParameters().get('onCancel');
        //completion = (completion == NULL) ? '/home/home.jsp' : completion;
        cancelPage = new PageReference(completion);
        cancelPage.setRedirect(true);
        validate(cancelPage);
        return cancelPage;
    }
*/
}