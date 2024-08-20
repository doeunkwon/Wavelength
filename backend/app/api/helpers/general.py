from datetime import datetime
from neo4j.time import datetime as neo4j_datetime  # Import directly from neo4j


def test_print(var: str, case=0):
    if case == 0:
        return print(f'\n\n{var}\n\n')
    else:
        return print(f'\n\nCase {case}\n{var}\n\n')


def get_neo4j_datetime_iso8601():
    """
    This function gets the current timestamp as a Neo4j datetime object
    """
    python_datetime = datetime.now()
    neo4j_dt = neo4j_datetime(python_datetime.year, python_datetime.month, python_datetime.day,
                              python_datetime.hour, python_datetime.minute, python_datetime.second,
                              python_datetime.microsecond)

    # Extract year, month, day, hour, minute, second, etc. from neo4j_timestamp
    year = neo4j_dt.year
    month = neo4j_dt.month
    day = neo4j_dt.day
    hour = neo4j_dt.hour
    minute = neo4j_dt.minute
    second = neo4j_dt.second

    # Use datetime to format the timestamp
    timestamp_obj = datetime(year, month, day, hour, minute, second)
    # Adjust format specifiers based on precision (milliseconds, microseconds)
    timestamp_iso8601 = timestamp_obj.isoformat()

    return timestamp_iso8601
