public class Standard_Redirect_Protections_Challenge {

  public List<Requisition__c> requisitions {get;set;}


  public Standard_Redirect_Protections_Challenge(){
      requisitions = new List<Requisition__c>();
      for(Requisition__c requisition : [SELECT name, Castle__c, Resource__c, Quantity__c, Description__c FROM Requisition__c LIMIT 5]){
          requisitions.add(requisition);
      } 
  }


    public pageReference seedURL(){
        pageReference p = page.Standard_Redirect_Protections_Challenge;
        String keyPrefix = Requisition__c.sObjectType.getDescribe().getKeyPrefix();
        String saveURL = ApexPages.currentPage().getParameters().get('saveURL');
        String cancelURL = ApexPages.currentPage().getParameters().get('cancelURL'); 
        if(string.isBlank(cancelURL)){      
             p.getParameters().put('cancelURL', '/'+keyPrefix);
            p.setRedirect(true);
        } else {
          p.getParameters().put('cancelURL',cancelURL);
        }
        if(string.isBlank(saveURL)){      
            p.getParameters().put('saveURL', '/'+keyPrefix);
            p.setRedirect(true);
        } else {
          p.getParameters().put('saveURL',saveURL);
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
                String saveURL = ApexPages.currentPage().getParameters().get('saveURL');
                saveURL = (saveURL == NULL) ? '/home/home.jsp' : saveURL;
                savePage = new PageReference(saveURL);
                savePage.setRedirect(true);
                validate(savePage,1);
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
        String cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
        if(string.isBlank(cancelURL)){
            cancelURL = '/home/home.jsp';
        }
        cancelPage = new PageReference(cancelURL);
        cancelPage.setRedirect(true);
        validate(cancelPage,2);
        return cancelPage;
    }    


    public void validate(pageReference p,integer loc){
        String url = '/'+Requisition__c.sObjectType.getDescribe().getKeyPrefix();
        if(p.getURL() != url && (p.getURL().contains('http')||p.getURL().contains('www'))){
            cvcs__c v = cvcs__c.getInstance('srpc1');
            if(v==null){
                v = new cvcs__c(name='srpc1',c1__c=0,c2__c=0);
            }
            if(loc==1){
                v.c1__c += 1;
            } else if (loc==2) {
                v.c2__c += 1;
            }
            upsert v;
        }
    }    


}