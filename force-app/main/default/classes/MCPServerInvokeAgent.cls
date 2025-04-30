public with sharing class MCPServerInvokeAgent {
    @InvocableMethod(label='Invoke Agent' description='Invokes the Agent')
    public static List<String> invokeAgent(List<InputParams> inputs) {
        List<String> outputResponse = new List<String>();
        for (InputParams input : inputs) {
            String userQuery = input.userQuery;
            String AgentResponse;
            String agentName=MCPServerConfigParse.getAgentName(userQuery);
                   agentName=agentName.Replace('"','');
            //system.debug ('Agent Name from core='+agentName);      
            //Check for agent downtime , if agent is down revert with downtime message 
            list <MCP_Server_Config__c> mcpServerConfigList = [select id ,MCP_Downtime_Message__c from MCP_Server_Config__c where MCP_Agent_API_Name__c=:agentName and MCP_Status__c=false];
            if (mcpServerConfigList.size()>0)
            {
                //Agent is down, Send the custom error message to Agent       
            //system.debug ('Final agent name'+agentName);
             AgentResponse =  mcpServerConfigList[0].MCP_Downtime_Message__c; 
             outputResponse.add(AgentResponse);
            }
            else 
            {
             Invocable.Action action =Invocable.Action.createCustomAction ('generateAiAgentResponse',agentName);
            action.setInvocationParameter('userMessage',userQuery);
            List<Invocable.Action.Result> results=action.invoke();
            Invocable.Action.Result result=results[0];
            if(result.isSuccess())
            {
                AgentResponse= (String) result.getOutputParameters().get('agentResponse');
            }
            outputResponse.add(AgentResponse);
            }
        }
        return outputResponse;
    }
    public class InputParams {
        @InvocableVariable
        public String userQuery;

    }
}