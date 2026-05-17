public class URL_Validation_Protection_Demo {


  public List<Requisition__c> requisitions {get;set;}


  public URL_Validation_Protection_Demo(){
      requisitions = new List<Requisition__c>();
      for(Requisition__c requisition : [SELECT name, Castle__c, Resource__c, Quantity__c, Description__c FROM Requisition__c LIMIT 5]){
          requisitions.add(requisition);
      } 
  }


    public pageReference seedURL(){
        pageReference p = page.URL_Validation_Protection_Demo;
        String onSave = ApexPages.currentPage().getParameters().get('onSave');
        String onCancel = ApexPages.currentPage().getParameters().get('onCancel'); 
        if(string.isBlank(onCancel)){      
            p.getParameters().put('onCancel', 'https://en.wikipedia.org/wiki/Knights_who_say_Ni');
            p.setRedirect(true);
        } else {
          p.getParameters().put('onCancel',onCancel);
        }
        if(string.isBlank(onSave)){      
            p.getParameters().put('onSave', 'https://developer.salesforce.com/page/Secure_Coding_Arbitrary_Redirect');
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