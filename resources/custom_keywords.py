from robot.api import logger
import re

def validate_user_list(users, min_count=1, max_count=100):
    if not isinstance(users, list):
        raise AssertionError("Response is not a list")
    length = len(users)
    if length < min_count:
        raise AssertionError(f"List has {length} users, expected at least {min_count}")
    if length > max_count:
        raise AssertionError(f"List has {length} users, expected at most {max_count}")
    
    for user in users:
        required_fields = ["id", "username", "email", "role"]
        for field in required_fields:
            if field not in user:
                raise AssertionError(f"Field '{field}' missing in user: {user}")
        
        if not isinstance(user["id"], int) or user["id"] <= 0:
            raise AssertionError(f"Invalid ID: {user['id']}")
        if not user["username"]:
            raise AssertionError(f"Username is empty for user: {user}")
        if not re.match(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", user["email"]):
            raise AssertionError(f"Invalid email format: {user['email']}")
        if not isinstance(user["role"], dict) or "name" not in user["role"] or not user["role"]["name"]:
            raise AssertionError(f"Invalid or missing role name: {user['role']}")
        
        logger.info(f"Validated user: {user['username']}")