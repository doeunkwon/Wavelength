import os


def get_env_variable(var: str):
    value = os.getenv(var)
    if value is None:
        raise ValueError(f"Environment variable '{var}' not found.")
    return value
