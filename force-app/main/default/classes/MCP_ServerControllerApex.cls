/*
 Author :Diptabhanu Bhattacharya
 Version:v1.0
 Description: This class is used to call the MCP Server Template to return which agent to 
              call based on the user query.
*/

public with sharing class MCP_ServerControllerApex 
{  
public static String generateResponse(String MCPContext, String MCPContextId)
{
        //create input 
        ConnectApi.EinsteinPromptTemplateGenerationsInput promptGeneration = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        promptGeneration.isPreview=false;
       
        //Build input map 
         Map<String, ConnectApi.WrappedValue> valueMap = new Map<String, ConnectApi.WrappedValue>();
       
         //Build the input map for userinput
       ConnectApi.WrappedValue mcpContextValue = new ConnectApi.WrappedValue();
       mcpContextValue.value=MCPContext;
       valueMap.put('Input:MCP_Context', mcpContextValue);
       
       //Build the map for Agents Configurations
       Map<String,String> mcConfig = new Map<String,String>();
       mcConfig.put('id',MCPContextId);
       ConnectApi.WrappedValue mcpConfigValue = new ConnectApi.WrappedValue();
       mcpConfigValue.value=mcConfig;
       valueMap.put('Input:MCP_Server_Config', mcpConfigValue);

       //Get additional params

        promptGeneration.inputParams = valueMap;
        promptGeneration.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        promptGeneration.additionalConfig.applicationName ='PromptTemplateGenerationsInvocable';

        connectApi.EinsteinPromptTemplateGenerationsRepresentation responseOutput = connectApi.Einsteinllm.generateMessagesForPromptTemplate('0hfdL00000CrmsPQAR',promptGeneration);
        connectApi.EinsteinLLMGenerationItemOutput response= responseOutput.generations[0];
        //Return Response
       //system.debug ('Prompt Ouput Response'+ response.text);
     return response.text;
}

}