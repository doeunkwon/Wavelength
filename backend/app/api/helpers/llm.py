from langchain import FewShotPromptTemplate, PromptTemplate
from langchain.chains import GraphCypherQAChain
from langchain_google_genai import ChatGoogleGenerativeAI
from app.api.helpers.users import get_user
from app.api.helpers.friends import get_friend
from helper import get_env_variable
from database.neo4j import graph
from app.api.helpers.relationships import get_memory_relationships
from typing import List, Tuple
from dotenv import load_dotenv

load_dotenv()

# Load environment variables once at startup
gemini_api_key = get_env_variable("GEMINI_API_KEY")

# Initialize LLM clients outside of request handlers
gemini = ChatGoogleGenerativeAI(
    model="gemini-pro", google_api_key=gemini_api_key, temperature=1.0)

# Define the format for how each example will be presented in the prompt
example_prompt_template = PromptTemplate(
    input_variables=["input", "output", "explanation"],
    template="""
    Input: {input}
    Output: {output}
    Explanation: {explanation}
    """
)

# Define examples for few-shot prompting
examples = [
    {
        "input": '''
            Individual 1:
            - Name: Alice Smith
            - Goals: Become a successful entrepreneur, travel the world, and start a family.
            - Interests: ["Hiking", "Reading", "Cooking"]
            - Values: ["Honesty", "Kindness", "Loyalty"]
            Individual 2:
            - Name: Bob Johnson
            - Goals: Find a stable job, buy a house, and spend more time with loved ones.
            - Interests: ["Video games", "Movies", "Outdoors"].
            - Values: ["Family", "Friendship", "Hard work"]
            Shared Memories:
            - [('Hiking trip to Yosemite National Park', 4), ('Dinner party with friends', 3), ('Weekend getaway to the beach', 5)]
        ''',
        "output": "goal:mid,value:high,interest:low,memory:high",
        "explanation": '''
            Goal Compatibility (mid): Their goals differ but aren't entirely incompatible.
            Value Compatibility (high): Strong alignment in core values.
            Interest Compatibility (low): Limited overlap in interests.
            Memory Compatibility (high): Positive shared memories contribute to a strong connection.
        '''
    },
    {
        "input": '''
            Individual 1:
            - Name: Charlie Brown
            - Goals: Become a famous artist, live a peaceful life, and help others.
            - Interests: ["Painting", "Music", "Volunteering"]
            - Values: ["Creativity", "Compassion", "Freedom"]
            Individual 2:
            - Name: Lucy Pelt
            - Goals: Become a doctor, have a successful career, and find a loving partner.
            - Interests: ["Science", "Reading", "Socializing"]
            - Values: ["Intelligence", "Ambition", "Loyalty"]
            Shared Memories:
            - [('Childhood friends', 5), ('Summer camp adventures', 4), ('Shared dreams', 3)]
        ''',
        "output": "goal:mid,value:mid,interest:low,memory:high",
        "explanation": '''
            Goal Compatibility (mid): Ambitious but different goals.
            Value Compatibility (mid): Some alignment, but also significant differences.
            Interest Compatibility (low): Limited shared interests.
            Memory Compatibility (high): Strong bond from shared memories.
        '''
    },
    {
        "input": '''
            Individual 1:
            - Name: David Kim
            - Goals: Start a successful business, travel the world, and make a positive impact on society.
            - Interests: ["Entrepreneurship", "Technology", "Social justice"]
            - Values: ["Innovation", "Leadership", "Equality"]
            Individual 2:
            - Name: Emily Peterson
            - Goals: Find a stable job, start a family, and enjoy a comfortable life.
            - Interests: ["Cooking", "Gardening", "Spending time with loved ones"]
            - Values: ["Family", "Tradition", "Security"]
            Shared Memories:
            - [('High school sweethearts', 5), ('Shared dreams', 4), ('Overcoming challenges together', 3)]
        ''',
        "output": "goal:low,value:mid,interest:low,memory:high",
        "explanation": '''
            Goal Compatibility (low): Significant differences in goals.
            Value Compatibility (mid): Some common ground, but differing values.
            Interest Compatibility (low): Very limited shared interests.
            Memory Compatibility (high): Deep connection from shared memories.
        '''
    },
    {
        "input": '''
            Individual 1:
            - Name: Eva Green
            - Goals: Lead a sustainable lifestyle, write a book, and raise a family.
            - Interests: ["Environmental activism", "Writing", "Yoga"]
            - Values: ["Sustainability", "Creativity", "Family"]
            Individual 2:
            - Name: Frank Harris
            - Goals: Build a successful eco-friendly business, travel the world, and start a family.
            - Interests: ["Entrepreneurship", "Travel", "Cooking"]
            - Values: ["Innovation", "Sustainability", "Family"]
            Shared Memories:
            - [('Volunteering for a tree-planting campaign', 5), ('Weekend writing retreats', 4), ('Planning future travel', 3)]
        ''',
        "output": "goal:high,value:high,interest:mid,memory:high",
        "explanation": '''
            Goal Compatibility (high): Eva and Frank share strong alignment in their goals, particularly around sustainability and family life. Their shared ambition to make a positive impact on the world further enhances their compatibility.
            Value Compatibility (high): Both individuals deeply value sustainability and family, with Eva's creativity complementing Frank's innovation, making their value alignment nearly perfect.
            Interest Compatibility (mid): While they share some interests like sustainability, they also have unique pursuits (Eva's focus on writing and yoga, Frank's on entrepreneurship and cooking) that may not always overlap.
            Memory Compatibility (high): Positive shared experiences, particularly in volunteering and planning for the future, provide a solid foundation for their relationship.
        '''
    },
    {
        "input": '''
            Individual 1:
            - Name: George Clark
            - Goals: Become a top corporate lawyer, accumulate wealth, and live a luxurious life.
            - Interests: ["Corporate law", "Luxury cars", "Golf"]
            - Values: ["Ambition", "Wealth", "Power"]
            Individual 2:
            - Name: Hannah Lee
            - Goals: Pursue a career in social work, help underprivileged communities, and live a simple, meaningful life.
            - Interests: ["Community service", "Minimalism", "Nature walks"]
            - Values: ["Compassion", "Humility", "Equality"]
            Shared Memories:
            - [('Charity fundraiser event', 2), ('Debates on social issues', 1), ('Divergent lifestyle choices', 1)]
        ''',
        "output": "goal:low,value:low,interest:low,memory:low",
        "explanation": '''
            Goal Compatibility (low): George's pursuit of wealth and power contrasts sharply with Hannah's dedication to social work and simple living, leading to significant goal misalignment.
            Value Compatibility (low): Their core values are fundamentally opposed, with George valuing ambition and wealth, while Hannah prioritizes compassion and equality. This creates a strong potential for conflict.
            Interest Compatibility (low): There is minimal overlap in interests, as George's focus on luxury and career contrasts with Hannah's passion for community service and minimalism.
            Memory Compatibility (low): Their few shared memories are marked by disagreement and divergence, indicating a weak connection.
        '''
    }
]

# Create the FewShotPromptTemplate
few_shot_prompt = FewShotPromptTemplate(
    examples=examples,
    example_prompt=example_prompt_template,
    prefix="Task: Provide separate compatibility scores for goals, values, interests, and shared memories between two individuals.",
    suffix="""
    Individual 1:
    - Name: {user_first_name} {user_last_name}
    - Goals: {user_goals}
    - Interests: {user_interests}
    - Values: {user_values}
    Individual 2:
    - Name: {friend_first_name} {friend_last_name}
    - Goals: {friend_goals}
    - Interests: {friend_interests}
    - Values: {friend_values}
    Shared Memories:
    - {memories} (Each memory has an associated sentiment value.)

    Provide the scores in the following strict format: goal:<goal_score>,value:<value_score>,interest:<interest_score>,memory:<memory_score>.
    """,
    input_variables=["user_first_name", "user_last_name", "user_goals", "user_interests", "user_values",
                     "friend_first_name", "friend_last_name", "friend_goals", "friend_interests", "friend_values", "memories"],
)


def score(uid: str, fid: str):
    # Fetch user info
    user = get_user(uid)
    # Fetch friend info
    friend = get_friend(uid, fid)
    # Fetch all user memories with friend
    memories = get_memory_relationships(uid, fid)

    # Prepare the input for the FewShotPromptTemplate
    inputs = {
        "user_first_name": user["firstName"],
        "user_last_name": user["lastName"],
        "user_goals": user["goals"],
        "user_interests": user["interests"],
        "user_values": user["values"],
        "friend_first_name": friend["firstName"],
        "friend_last_name": friend["lastName"],
        "friend_goals": friend["goals"],
        "friend_interests": friend["interests"],
        "friend_values": friend["values"],
        "memories": memories
    }

    # Generate the final prompt using the FewShotPromptTemplate
    prompt = few_shot_prompt.format(**inputs)

    # Send the prompt to the LLM
    response = gemini.invoke(prompt)
    output = response.content

    # Post-process the output to ensure it's in the correct format
    compatibility_scores = dict(item.split(":") for item in output.split(","))
    if list(compatibility_scores.keys()) != ['goal', 'value', 'interest', 'memory']:
        return f"Error, could not parse the output: {compatibility_scores}"

    return compatibility_scores
