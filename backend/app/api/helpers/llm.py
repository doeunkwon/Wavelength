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
            - Goals: Travel the world, explore different cultures, document experiences.
            - Interests: ["Photography", "Traveling", "Culinary arts", "Blogging"]
            - Values: ["Curiosity", "Adventure", "Creativity", "Authenticity"]
            Individual 2:
            - Name: Emily White
            - Goals: Become a travel journalist, publish travel guides, experience new cultures.
            - Interests: ["Traveling", "Photography", "Writing", "Exploring cuisines"]
            - Values: ["Curiosity", "Adventure", "Creativity", "Open-mindedness"]
        ''',
        "output": "goal>>88||value>>92||interest>>95||explanation>>You and Emily have very similar goals centered around travel and cultural exploration, leading to high compatibility. Your values are nearly identical, emphasizing curiosity, adventure, and creativity. Your interests also align closely, particularly in travel and photography, resulting in a high interest compatibility score."
    },
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Become a well-known writer, publish a novel, live in a quiet town.
            - Interests: ["Literature", "Travel", "History", "Coffee culture"]
            - Values: ["Creativity", "Solitude", "Authenticity", "Reflection"]
            Individual 2:
            - Name: Alex Thompson
            - Goals: Climb the corporate ladder, earn a high income, enjoy city life.
            - Interests: ["Finance", "Networking", "Fine dining", "Sports"]
            - Values: ["Ambition", "Wealth", "Success", "Networking"]
        ''',
        "output": "goal>>28||value>>42||interest>>22||explanation>>Your goals and Alex's differ significantly, with you focusing on creative pursuits and a quiet lifestyle, while Alex aims for career success and city living. Your values also diverge, with you valuing creativity and solitude, and Alex prioritizing ambition and success. There is minimal overlap in your interests, leading to low interest compatibility."
    },
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Master several musical instruments, perform in a band, create original music.
            - Interests: ["Music", "Live performances", "Songwriting", "Music festivals"]
            - Values: ["Creativity", "Passion", "Expression", "Collaboration"]
            Individual 2:
            - Name: Jake Rogers
            - Goals: Play guitar professionally, tour with a band, produce music.
            - Interests: ["Music", "Guitar", "Concerts", "Music production"]
            - Values: ["Creativity", "Dedication", "Artistry", "Teamwork"]
        ''',
        "output": "goal>>82||value>>89||interest>>98||explanation>>Your goals and Jake's are closely aligned around a deep commitment to music, indicating high compatibility. Your values, centered on creativity and collaboration, are also highly compatible. Your shared passion for music leads to an almost perfect interest compatibility score."
    },
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Advance in academic research, publish in top journals, mentor students.
            - Interests: ["Research", "Reading", "Debating", "Philosophy"]
            - Values: ["Knowledge", "Integrity", "Critical thinking", "Curiosity"]
            Individual 2:
            - Name: Laura Evans
            - Goals: Start a family, build a home, volunteer in the community.
            - Interests: ["Gardening", "Cooking", "Crafting", "Community service"]
            - Values: ["Family", "Generosity", "Stability", "Empathy"]
        ''',
        "output": "goal>>36||value>>54||interest>>17||explanation>>Your goals and Laura's are quite different, with you focused on academic achievements and Laura on family and community. While there is some overlap in values like integrity and generosity, the overall compatibility is moderate. Your interests have minimal overlap, leading to low interest compatibility."
    },
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Retire early, travel extensively, live off the grid.
            - Interests: ["Sustainable living", "Travel", "Minimalism", "Hiking"]
            - Values: ["Freedom", "Simplicity", "Self-reliance", "Environmentalism"]
            Individual 2:
            - Name: Mark Johnson
            - Goals: Become a CEO, accumulate wealth, live in luxury.
            - Interests: ["Investing", "Luxury goods", "Networking", "Golf"]
            - Values: ["Wealth", "Power", "Status", "Influence"]
        ''',
        "output": "goal>>19||value>>27||interest>>11||explanation>>Your goals and Mark's are almost entirely opposed, with you seeking a simple, off-grid lifestyle, and Mark aiming for wealth and luxury. Your values clash significantly, with your emphasis on freedom and simplicity contrasting sharply with Mark's focus on power and status. Your interests are also largely incompatible, resulting in very low overall compatibility."
    },
    {
        "input": '''
            Individual 1 (Me):
            - Name: You
            - Goals: Start a tech company, innovate in AI, create impactful products.
            - Interests: ["Technology", "Startups", "AI research", "Gaming"]
            - Values: ["Innovation", "Creativity", "Ambition", "Disruption"]
            Individual 2:
            - Name: Rachel Green
            - Goals: Work in healthcare, improve patient outcomes, live a balanced life.
            - Interests: ["Healthcare", "Yoga", "Meditation", "Travel"]
            - Values: ["Compassion", "Health", "Work-life balance", "Care"]
        ''',
        "output": "goal>>48||value>>57||interest>>33||explanation>>Your goals and Rachel's share some common ground in wanting to create positive change, but in very different domains—tech versus healthcare. There is some alignment in values, like ambition and care, though they manifest differently. Your interests overlap slightly in areas like technology and wellness, but overall interest compatibility remains low."
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
        "output": "goal>>56||value>>62||interest>>27||explanation>>Both you and Emily have ambitious goals, though in very different fields—art and medicine—which suggests some alignment but with significant differences. There is some overlap in your values, such as compassion and loyalty, but differences like freedom versus ambition lower your overall compatibility. Your interests are quite distinct, with one focused on the arts and volunteering and the other on science and fitness, leading to low interest compatibility."
    }
]


# Create the FewShotPromptTemplate
few_shot_prompt = FewShotPromptTemplate(
    examples=examples,
    example_prompt=example_prompt_template,
    prefix="Task: Provide separate compatibility scores for goals, values, and interests between two individuals. Accompany each score with a concise explanation. In the explanation, refer to Individual 1 using second-person pronouns.",
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

    Provide the scores and explanation in the following strict format: goal>><goal_score>||value>><value_score>||interest>><interest_score>||explanation>><explanation>
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
    compatibility_results = dict(item.split(">>")
                                 for item in output.split("||"))

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
