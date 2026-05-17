public with sharing class CodeLinkController {
    
    public final Map<String,String> allowedTypes = new Map<String,String> {'VISUALFORCE'=>'ApexPage', 'APEX'=>'ApexClass', 'COMPONENT'=>'ApexComponent'};
    
    public string codeType {get;set;}
    public string codeNamespace {get;set;}
    public string codeName {get;set;}
    private string codeId = NULL;
    
    public string getCodeId(){
        
        if(codeId == NULL){
            codeId = '';
            
            codeType = codeType.toUpperCase().trim();
            if (!allowedTypes.containsKey(codeType)){   
                return codeId;
            } 
            
            codeName =  string.EscapeSingleQuotes(codeName);
            
            if (codeNamespace == null) codeNamespace = '';
            codeNamespace = string.EscapeSingleQuotes(codeNamespace);
                
            string query = 'SELECT id FROM ' + allowedTypes.get(codeType) + ' WHERE name = \'' + codeName + '\' LIMIT 1';       
            List<Sobject> code = Database.query(query);
            
            if(code.size() == 1){
                
                codeId = (String) code[0].get('id');
                
            }
        }
        
        return codeId;  
        
    }

}