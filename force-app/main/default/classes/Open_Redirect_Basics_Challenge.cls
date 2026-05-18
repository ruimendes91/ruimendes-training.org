public class Open_Redirect_Basics_Challenge {


    public List<Personnel__c > unassigned {get;set;}

    public Open_Redirect_Basics_Challenge(){
        unassigned = new List<Personnel__c >();
        for(Personnel__c per : [SELECT name, Assignment__c, Castle__c,Role__c FROM Personnel__c WHERE Assignment__c = null LIMIT 5]){
            unassigned.add(per);
        } 
    }

    public pageReference seedURL(){
        pageReference p = page.Open_Redirect_Basics_Challenge;
        String keyPrefix = Personnel__c.sObjectType.getDescribe().getKeyPrefix();

        String completion = ApexPages.currentPage().getParameters().get('completion');
        if(string.isBlank(completion)){      
            p.getParameters().put('completion', '/'+keyPrefix);
            p.setRedirect(true);
        } else {
            p.getParameters().put('completion',completion);
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
                String completion = ApexPages.currentPage().getParameters().get('completion');
                //completion = (completion == NULL) ? '/home/home.jsp' : completion;
                savePage = new PageReference(completion);
                savePage.setRedirect(true);
                validate(savePage);
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
        PageReference cancelPage;
        String completion = ApexPages.currentPage().getParameters().get('completion');
        //completion = (completion == NULL) ? '/home/home.jsp' : completion;
        cancelPage = new PageReference(completion);
        cancelPage.setRedirect(true);
        validate(cancelPage);
        return cancelPage;
    }


    public void validate(pageReference p){
        String url = '/'+Personnel__c.sObjectType.getDescribe().getKeyPrefix();
        if(p.getURL() != url && (p.getURL().contains('http')||p.getURL().contains('www'))){
            cvcs__c v = cvcs__c.getInstance('orbc1');
            if(v==null){
                v = new  cvcs__c(name='orbc1',c1__c = 1);
            } else {
                v.c1__c += 1;
            }
            upsert v;
        }
    }

}