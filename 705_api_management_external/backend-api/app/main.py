from typing import Optional

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods="GET",
    allow_headers=["*"]
)

class AzureService():
    def __init__(self, id, name):
         self.id = id
         self.name = name

albums = [ 
    AzureService(1, "Azure Function"),
    AzureService(2, "Azure App Service"),
    AzureService(3, "Azure Container Apps"),
    AzureService(4, "Azure Kubernetes Service"),
    AzureService(5, "Azure API Management")
]

@app.get("/")
def read_root():
    return {"Sample REST API with GET operation. Try navigate to /api"}


@app.get("/api")
def get_albums():
    return albums
