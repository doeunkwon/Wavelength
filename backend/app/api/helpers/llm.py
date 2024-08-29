from langchain_core.prompts import FewShotPromptTemplate, PromptTemplate
from langchain_google_genai import ChatGoogleGenerativeAI
from app.api.helpers.users import get_user
from app.api.helpers.friends import get_friend
from helper import get_env_variable
from app.api.helpers.relationships import get_memory_tokens
from dotenv import load_dotenv

load_dotenv()

# Load environment variables once at startup
gemini_api_key = get_env_variable("GEMINI_API_KEY")

# Initialize LLM clients outside of request handlers
gemini = ChatGoogleGenerativeAI(
    model="gemini-1.5-flash", google_api_key=gemini_api_key, temperature=1.0)

# Define the format for how each example will be presented in the prompt
example_prompt_template = PromptTemplate(
    input_variables=["input", "output", "explanation"],
    template="""
    Input: {input}
    Output: {output}
    Explanation: {explanation}
    """
)

# Define examples for few-shot prompting with compatibility scores from 0 to 100
examples = [
    {
        "input": '''
            Individual 1:
            - Goals: Become a successful entrepreneur, travel the world, start a family.
            - Interests: ["Hiking", "Reading", "Cooking", "Photography"]
            - Values: ["Honesty", "Kindness", "Loyalty", "Independence"]
            Individual 2:
            - Goals: Find a stable job, buy a house, spend more time with loved ones.
            - Interests: ["Video games", "Movies", "Outdoors"]
            - Values: ["Family", "Friendship", "Hard work"]
        ''',
        "output": "goal:50,value:85,interest:30",
        "explanation": '''
            Goal: 50 (Although their ambitions differ—one focuses on entrepreneurship, the other on stability—they both aim to build a fulfilling life, particularly with the goal of starting a family).
            Value: 85 (Despite some differences, both value strong interpersonal relationships, such as loyalty and family, which indicates high compatibility in what they prioritize).
            Interest: 30 (Their interests show minimal overlap; while both enjoy outdoor activities, Individual 1’s interests in reading and photography differ significantly from Individual 2’s interest in video games and movies).
        '''
    },
    {
        "input": '''
            Individual 1:
            - Goals: Become a famous artist, live peacefully, help others.
            - Interests: ["Painting", "Music", "Volunteering"]
            - Values: ["Creativity", "Compassion", "Freedom", "Self-expression", "Community"]
            Individual 2:
            - Goals: Become a doctor, have a successful career, find a loving partner.
            - Interests: ["Science", "Reading", "Socializing", "Fitness"]
            - Values: ["Intelligence", "Ambition", "Loyalty"]
        ''',
        "output": "goal:55,value:60,interest:25",
        "explanation": '''
            Goal: 55 (Both have ambitious goals, though in very different fields—art and medicine—which suggests some alignment but with significant differences).
            Value: 60 (There is some overlap in values, such as compassion and loyalty, but differences like freedom versus ambition lower their overall compatibility).
            Interest: 25 (Their interests are quite distinct, with one focused on the arts and volunteering and the other on science and fitness, leading to low interest compatibility).
        '''
    },
    {
        "input": '''
            Individual 1:
            - Goals: Start a successful business, travel, impact society.
            - Interests: ["Entrepreneurship", "Technology", "Social justice", "Networking", "Traveling"]
            - Values: ["Innovation", "Leadership", "Equality", "Progress", "Success"]
            Individual 2:
            - Goals: Find a stable job, start a family, enjoy comfort.
            - Interests: ["Cooking", "Gardening", "Spending time with loved ones"]
            - Values: ["Family", "Tradition", "Security", "Simplicity"]
        ''',
        "output": "goal:25,value:50,interest:20",
        "explanation": '''
            Goal: 25 (The goals are quite different, with one focused on business and societal impact, and the other on personal and family stability, indicating significant misalignment).
            Value: 50 (There is some overlap in their values, such as a concern for others and a focus on family, but differing priorities—such as innovation versus tradition—reduce overall compatibility).
            Interest: 20 (Their interests are in different domains—entrepreneurship and technology versus home-centered activities—resulting in low interest compatibility).
        '''
    }
    # Additional examples can be added here as needed.
]

# Create the FewShotPromptTemplate
few_shot_prompt = FewShotPromptTemplate(
    examples=examples,
    example_prompt=example_prompt_template,
    prefix="Task: Provide separate compatibility scores for goals, values, and interests between two individuals.",
    suffix="""
    Individual 1:
    - Goals: {user_goals}
    - Interests: {user_interests}
    - Values: {user_values}
    Individual 2:
    - Goals: {friend_goals}
    - Interests: {friend_interests}
    - Values: {friend_values}

    Provide the scores in the following strict format: goal:<goal_score>,value:<value_score>,interest:<interest_score>.

    **Important:** Only provide the scores in the exact format above without any additional text, explanation, or commentary.
    """,
    input_variables=["user_goals", "user_interests", "user_values",
                     "friend_goals", "friend_interests", "friend_values"],
)


def score(uid: str, fid: str):
    # Fetch user info
    user = get_user(uid)
    # Fetch friend info
    friend = get_friend(uid, fid)

    # Prepare the input for the FewShotPromptTemplate
    inputs = {
        "user_goals": user["goals"],
        "user_interests": user["interests"],
        "user_values": user["values"],
        "friend_goals": friend["goals"],
        "friend_interests": friend["interests"],
        "friend_values": friend["values"]
    }

    # Generate the final prompt using the FewShotPromptTemplate
    prompt = few_shot_prompt.format(**inputs)

    # Send the prompt to the LLM
    response = gemini.invoke(prompt)
    output = response.content

    print(output)

    # Post-process the output to ensure it's in the correct format
    compatibility_scores = dict(item.split(":") for item in output.split(","))

    # Expected keys and their order
    expected_keys = ['goal', 'value', 'interest']

    # Check if all expected keys are present and correctly ordered
    if all(key in compatibility_scores for key in expected_keys) and list(compatibility_scores.keys()) == expected_keys:
        try:
            # Ensure all scores are valid integers within the range 0 to 100
            compatibility_scores = {k: int(v)
                                    for k, v in compatibility_scores.items()}
            if all(0 <= score <= 100 for score in compatibility_scores.values()):

                # Fetch all user memories with friend
                memory_tokens = get_memory_tokens(uid, fid)

                token_sum = sum(memory_tokens)
                memory_count = len(memory_tokens)

                max_token_per_memory = 5

                # multiply by 2 since user can enter from to -5 tokens to 5 tokens, meaning 10 numbers to choose from, which is DOUBLE max_token_per_memory
                total_denominator = (max_token_per_memory * 2) * memory_count
                total_numerator = (max_token_per_memory *
                                   memory_count) + token_sum

                memory_score = int((total_numerator / total_denominator) * 100)

                compatibility_scores["memory"] = memory_score

                return compatibility_scores
            else:
                return f"Error: Scores out of valid range (0-100): {compatibility_scores}"
        except ValueError:
            return f"Error: Non-integer score found in output: {compatibility_scores}"
    else:
        return f"Error: Output format is incorrect or keys are missing: {compatibility_scores}"
