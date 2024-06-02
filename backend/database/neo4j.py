from langchain_community.graphs import Neo4jGraph
from dotenv import load_dotenv
from helper import get_env_variable

load_dotenv()

uri = get_env_variable("NEO4J_URI")
username = get_env_variable("NEO4J_USERNAME")
password = get_env_variable("NEO4J_PASSWORD")

graph = Neo4jGraph(url=uri, username=username, password=password)
