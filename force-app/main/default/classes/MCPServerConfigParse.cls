/*
 Author :Diptabhanu Bhattacharya
 Version:v1.0
 Description:  This is an invocable class which will return exactly what agent to be called for 
              the user query.
*/

public with sharing class MCPServerConfigParse {
   
    public static String getAgentName(String MCPContext) {
      Map<String, String> result = new Map<String, String>();   
      String response ;
      String finalResponse;
      list <MCP_Server_Config__c> mcpServerConfigList = [select id from MCP_Server_Config__c];
     //Loop through the agent configurations
     for (MCP_Server_Config__c mcpConfig : mcpServerConfigList)
     {
       //Get the response to decide what is the right agent. 
       response = MCP_ServerControllerApex.generateResponse (MCPContext,mcpConfig.id);
       //Replace all newline with a nothing
       response=response.Replace('\n','');
       result=extractKeyValuePairs(response); //Call to extract the key value
       if (result.get('"Agent API Name"')!='"none"')
       {
        finalResponse =result.get('"Agent API Name"');
        return finalResponse; //return the agent API name
       }
     }    
     //system.debug ('Logging :'+result.get('"Agent API Name"'));  
     return 'none'; 
    }

    public static Map<String, String> extractKeyValuePairs(String input) {
            // The map to hold the extracted key-value pairs
            Map<String, String> keyValueMap = new Map<String, String>(); 
            Integer agentFoundFlg=0 ;
            // Split the input string into pairs (assuming they are separated by "&")
            String[] pairs = input.split(',');
            // Loop through each pair
            for (String pair : pairs) {
                // Split the pair into key and value (assuming they are separated by "=")
                String[] keyValue = pair.split(':');
                // Ensure we have both key and value
                if (keyValue.size() == 2) 
                { 
                        //Agent with skillset found , return from here.
                        String Key =keyValue[0].Replace('{','').Replace('}','').Trim();
                        String Value=keyValue[1].Replace('{','').Replace('}','').Trim();
                        keyValueMap.put(Key, Value); 
                        system.debug ('Key='+Key);
                }
            }
            return keyValueMap;
        }
}