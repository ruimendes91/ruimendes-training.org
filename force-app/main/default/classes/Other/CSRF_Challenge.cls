public class CSRF_Challenge {

    public List<Requisition__c > Requisitions {get;set;}
    public string approve {get; set;}
  
    public CSRF_Challenge(){
        if(Requisitions == null){
            Requisitions= new List<Requisition__c>();
            for(Requisition__c req: [SELECT Approved__c,Castle__c,Description__c,Id,Name,Quantity__c,Resource__c FROM Requisition__c]){
                Requisitions.add(req);
            }
        }
    }
    
    public void approveReq(){
        approve = ApexPages.currentPage().getParameters().get('approve');
        if(approve!=null){
            For(Requisition__c req : Requisitions){
                if(req.id==approve){
                    req.approved__c = true;
                    update req;
                    approve = null;
                }
            }
        }
    }

    public void approveReqNOCSRF(){
        if(approve!=null){
            For(Requisition__c req : Requisitions){
                if(req.id==approve){
                    req.approved__c = true;
                    update req;
                    approve = null;
                }
            }
        }    
    }


}