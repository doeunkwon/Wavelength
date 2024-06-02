examples = [
    {
        "question": '''As the user with uid=db668224-6d8a-4d51-a44e-b7f4875ece20, I wonder:
        List all memories I have created.''',
        "query": '''MATCH (u:User {{uid: "db668224-6d8a-4d51-a44e-b7f4875ece20"}})-[:HAS]->(m:Memory) RETURN m.content''',
    },
    {
        "question": '''As the user with uid=db668224-6d8a-4d51-a44e-b7f4875ece20, I wonder:
        Who are all my friends?''',
        "query": '''MATCH (u:User {{uid: "db668224-6d8a-4d51-a44e-b7f4875ece20"}})-[:FRIENDS_WITH]->(f:User) RETURN f.firstName''',
    },
    {
        "question": '''As the user with uid=db668224-6d8a-4d51-a44e-b7f4875ece20, I wonder:
        What should I get Andrea for her birthday?''',
        "query": '''MATCH (u:User {{uid: "db668224-6d8a-4d51-a44e-b7f4875ece20"}})-[:FRIENDS_WITH]->(f:User {{firstName: "Andrea"}}) RETURN f.interests'''
    },
    {
        "question": '''As the user with uid=db668224-6d8a-4d51-a44e-b7f4875ece20, I wonder:
        What kind of books do you think Austin would like?''',
        "query": '''MATCH (u:User {{uid: "db668224-6d8a-4d51-a44e-b7f4875ece20"}})-[:FRIENDS_WITH]->(f:User {{firstName: "Austin"}}) RETURN f.interests'''
    }
]

example_prompt = "User input: {question}\nCypher query: {query}"

prompt_prefix = "You are a Neo4j expert. Given an input question, create a syntactically correct Cypher query to run.\n\nHere is the schema information\n{schema}.\n\nBelow are a number of examples of questions and their corresponding Cypher queries."

prompt_suffix = "User input: {question}\nCypher query: "


def uid_modified_prompt(uid, promptContent): return f'''As the user with uid={
    uid}, I wonder: {promptContent}'''


def rag_response_prompt(context, promptContent): return f'''The answer to the question "{promptContent}" is based on "{context}".
            Don't mention the fact that the answer is in JSON object.
            Elaborate on the answer in natural language.'''


def gen_response_prompt(
    promptContent): return f'In under 5 sentences, answer the question: {promptContent}'
