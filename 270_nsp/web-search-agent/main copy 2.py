import os
from agent_framework import ChatAgent
from agent_framework_azure_ai import AzureAIAgentClient

from azure.identity.aio import DefaultAzureCredential

from azure.ai.agentserver.agentframework import from_agent_framework

os.environ["AZURE_AI_PROJECT_ENDPOINT"] = "https://foundry-270-us-test.services.ai.azure.com/api/projects/project-270-us-test"
os.environ["AZURE_AI_MODEL_DEPLOYMENT_NAME"] = "gpt-4o-mini"

print("Using AZURE_AI_PROJECT_ENDPOINT:", os.environ["AZURE_AI_PROJECT_ENDPOINT"])

def create_agent() -> ChatAgent:
    assert (
        "AZURE_AI_PROJECT_ENDPOINT" in os.environ
    ), "AZURE_AI_PROJECT_ENDPOINT environment variable must be set."
    assert (
        "AZURE_AI_MODEL_DEPLOYMENT_NAME" in os.environ
    ), "AZURE_AI_MODEL_DEPLOYMENT_NAME environment variable must be set."

    credential = DefaultAzureCredential()

    chat_client = AzureAIAgentClient(
        project_endpoint=os.environ["AZURE_AI_PROJECT_ENDPOINT"],
        model_deployment_name=os.environ["AZURE_AI_MODEL_DEPLOYMENT_NAME"],
        credential=credential,
    )

    agent = ChatAgent(
        chat_client=chat_client,
        name="BingSearchAgent",
        instructions=(
            "You are a helpful assistant that can search the web for current information. "
            "Use the Bing search tool to find up-to-date information and provide accurate, "
            "well-sourced answers. Always cite your sources when possible."
        )
    )
    return agent

if __name__ == "__main__":
    from_agent_framework(lambda _: create_agent()).run()
