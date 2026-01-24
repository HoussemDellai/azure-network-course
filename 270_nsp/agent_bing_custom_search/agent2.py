from random import randint
from typing import Annotated

from agent_framework.azure import AzureOpenAIChatClient
from azure.identity import DefaultAzureCredential

from azure.ai.agentserver.agentframework import from_agent_framework

# from azure.ai.projects.models import (
#     BingCustomSearchAgentTool,
#     BingCustomSearchToolParameters,
#     BingCustomSearchConfiguration,
# )
import os
from dotenv import load_dotenv

load_dotenv()


# bing_custom_search_tool = BingCustomSearchAgentTool(
#     bing_custom_search_preview=BingCustomSearchToolParameters(
#         search_configurations=[
#             BingCustomSearchConfiguration(
#                 project_connection_id=os.environ[
#                     "BING_CUSTOM_SEARCH_PROJECT_CONNECTION_ID"
#                 ],
#                 instance_name=os.environ["BING_CUSTOM_SEARCH_INSTANCE_NAME"],
#             )
#         ]
#     )
# )


def main() -> None:
    agent = AzureOpenAIChatClient(credential=DefaultAzureCredential()).create_agent(
        instructions="You are a helpful assistant that can search the web for current information. "
        "Use the Bing search tool to find up-to-date information and provide accurate, "
        "well-sourced answers. Always cite your sources when possible.",
        # tools=bing_custom_search_tool,
    )

    from_agent_framework(agent).run()


if __name__ == "__main__":
    main()
