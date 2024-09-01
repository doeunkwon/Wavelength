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
    input_variables=["input", "output"],
    template="""
    Input: {input}
    Output: {output}
    """
)

# Define examples for few-shot prompting with compatibility scores from 0 to 100
examples = [
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Become a successful entrepreneur, travel the world, start a family.
            - Interests: ["Hiking", "Reading", "Cooking", "Photography"]
            - Values: ["Honesty", "Kindness", "Loyalty", "Independence"]
            Individual 2:
            - Name: Jane Smith
            - Goals: Find a stable job, buy a house, spend more time with loved ones.
            - Interests: ["Video games", "Movies", "Outdoors"]
            - Values: ["Family", "Friendship", "Hard work"]
        ''',
        "output": "goal:::50,,,value:::85,,,interest:::30,,,explanation:::Although you and Jane's ambitions differ—focusing on entrepreneurship versus stability—you both aim to build a fulfilling life, particularly with the goal of starting a family. Despite some differences, both value strong interpersonal relationships, such as loyalty and family, which indicates high compatibility in what you both prioritize. Your interests show minimal overlap; while both of you enjoy outdoor activities, your interests in reading and photography differ significantly from Jane's interest in video games and movies."
    },
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Become a famous artist, live peacefully, help others.
            - Interests: ["Painting", "Music", "Volunteering"]
            - Values: ["Creativity", "Compassion", "Freedom", "Self-expression", "Community"]
            Individual 2:
            - Name: Emily Lee
            - Goals: Become a doctor, have a successful career, find a loving partner.
            - Interests: ["Science", "Reading", "Socializing", "Fitness"]
            - Values: ["Intelligence", "Ambition", "Loyalty"]
        ''',
        "output": "goal:::55,,,value:::60,,,interest:::25,,,explanation:::Both you and Emily have ambitious goals, though in very different fields—art and medicine—which suggests some alignment but with significant differences. There is some overlap in your values, such as compassion and loyalty, but differences like freedom versus ambition lower your overall compatibility. Your interests are quite distinct, with one focused on the arts and volunteering and the other on science and fitness, leading to low interest compatibility."
    },
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Start a successful business, travel, impact society.
            - Interests: ["Entrepreneurship", "Technology", "Social justice", "Networking", "Traveling"]
            - Values: ["Innovation", "Leadership", "Equality", "Progress", "Success"]
            Individual 2:
            - Name: Sarah Patel
            - Goals: Find a stable job, start a family, enjoy comfort.
            - Interests: ["Cooking", "Gardening", "Spending time with loved ones"]
            - Values: ["Family", "Tradition", "Security", "Simplicity"]
        ''',
        "output": "goal:::25,,,value:::50,,,interest:::20,,,explanation:::Your goals and Sarah's are quite different, with you focusing on business and societal impact, and Sarah focusing on personal and family stability, indicating significant misalignment. There is some overlap in your values, such as a concern for others and a focus on family, but differing priorities—such as innovation versus tradition—reduce overall compatibility. Your interests are in different domains—entrepreneurship and technology versus home-centered activities—resulting in low interest compatibility."
    },
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Become a professional athlete, achieve fame, live a luxurious lifestyle.
            - Interests: ["Sports", "Gaming", "Socializing", "Traveling"]
            - Values: ["Success", "Competition", "Excitement", "Materialism"]
            Individual 2:
            - Name: Olivia Johnson
            - Goals: Find a stable job, start a family, build a comfortable home.
            - Interests: ["Reading", "Cooking", "Gardening", "Spending time with loved ones"]
            - Values: ["Family", "Stability", "Security", "Simplicity"]
        ''',
        "output": "goal:::15,,,value:::30,,,interest:::10,,,explanation:::Your goals and Olivia's are vastly different, with you focused on fame and luxury, while Olivia is focused on stability and family. Your values also clash, with you prioritizing success and materialism, while Olivia values family and security. Your interests show minimal overlap, with your interests centered around sports and socializing, while Olivia's interests are more home-centered. Overall, your compatibility is very low."
    },
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Pursue a career in environmental science, protect the planet, make a positive impact.
            - Interests: ["Nature", "Science", "Environmental activism", "Traveling"]
            - Values: ["Sustainability", "Compassion", "Community", "Purpose"]
            Individual 2:
            - Name: Maya Patel
            - Goals: Start a successful business, become financially independent, enjoy a comfortable lifestyle.
            - Interests: ["Business", "Finance", "Fashion", "Traveling"]
            - Values: ["Success", "Ambition", "Independence", "Materialism"]
        ''',
        "output": "goal:::40,,,value:::45,,,interest:::25,,,explanation:::Your goals and Maya's are somewhat aligned, as you both value personal success and fulfillment. However, your approaches to achieving these goals differ significantly, with you prioritizing environmental impact and Maya focusing on financial independence. Your values show some overlap, such as independence, but differing priorities—sustainability versus materialism—reduce your overall compatibility. Your interests are in different domains, with you focused on environmental issues and Maya focused on business and fashion, resulting in low interest compatibility."
    }
]

# Create the FewShotPromptTemplate
few_shot_prompt = FewShotPromptTemplate(
    examples=examples,
    example_prompt=example_prompt_template,
    prefix="Task: Provide separate compatibility scores for goals, values, and interests between two individuals. Also provide a concise explanation for these scores.",
    suffix="""
    Individual 1 (Me):
    - Name: {user_firstname} {user_lastname}
    - Goals: {user_goals}
    - Interests: {user_interests}
    - Values: {user_values}
    Individual 2:
    - Name: {friend_firstname} {friend_lastname}
    - Goals: {friend_goals}
    - Interests: {friend_interests}
    - Values: {friend_values}

    Provide the scores and explanation in the following strict format: goal:::<goal_score>,,,value:::<value_score>,,,interest:::<interest_score>,,,explanation:::<explanation>.

    **Important:** Adhere strictly to the format above. In the explanation, refer to Individual 1 as "You". Do not include any additional text, commentary, or extraneous details.
    """,
    input_variables=["user_firstname", "user_lastname", "user_goals", "user_interests", "user_values",
                     "friend_firstname", "friend_lastname", "friend_goals", "friend_interests", "friend_values"],
)


def score(uid: str, fid: str):
    # Fetch user info
    user = get_user(uid)
    # Fetch friend info
    friend = get_friend(uid, fid)

    # Prepare the input for the FewShotPromptTemplate
    inputs = {
        "user_firstname": user["firstName"],
        "user_lastname": user["lastName"],
        "user_goals": user["goals"],
        "user_interests": user["interests"],
        "user_values": user["values"],
        "friend_firstname": friend["firstName"],
        "friend_lastname": friend["lastName"],
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
    compatibility_results = dict(item.split(":::")
                                 for item in output.split(",,,"))

    print("CHECKPOINT 1")

    # Expected keys and their order
    expected_keys = ['goal', 'value', 'interest', 'explanation']

    # Check if all expected keys are present and correctly ordered
    if all(key in compatibility_results for key in expected_keys) and list(compatibility_results.keys()) == expected_keys:

        compatibility_scores = {
            k: v for k, v in compatibility_results.items() if k != 'explanation'}
        try:

            # Ensure all scores are valid integers within the range 0 to 100
            compatibility_scores = {k: int(v)
                                    for k, v in compatibility_scores.items()}
            if all(0 <= score <= 100 for score in compatibility_scores.values()):

                # Fetch all user memories with friend
                memory_tokens = get_memory_tokens(uid, fid)

                token_sum = sum(memory_tokens)
                memory_count = len(memory_tokens)

                memory_score = 0

                if memory_count != 0:

                    max_token_per_memory = 5

                    # multiply by 2 since user can enter from to -5 tokens to 5 tokens, meaning 10 numbers to choose from, which is DOUBLE max_token_per_memory
                    total_denominator = (
                        max_token_per_memory * 2) * memory_count
                    total_numerator = (max_token_per_memory *
                                       memory_count) + token_sum

                    memory_score = int(
                        (total_numerator / total_denominator) * 100)

                else:

                    memory_score = 50

                compatibility_scores["memory"] = memory_score
                compatibility_scores["analysis"] = compatibility_results["explanation"]

                return compatibility_scores
            else:
                return f"Error: Scores out of valid range (0-100): {compatibility_results}"
        except ValueError:
            return f"Error: Non-integer score found in output: {compatibility_results}"
    else:
        return f"Error: Output format is incorrect or keys are missing: {compatibility_results}"
