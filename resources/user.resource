*** Settings ***
Library    RequestsLibrary
Library    custom_keywords.py
Library    Collections

*** Keywords ***
Validate A User Response
    [Documentation]    Validate the user response and extract user information
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${user}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${user["id"]}    1
    Should Be Equal    ${user["username"]}    admin
    Should Be Equal    ${user["email"]}    admin@gmail.com

Validate All Users Response
    [Documentation]    Validate the response for all users
    [Arguments]    ${response}    ${min_count}=1    ${max_count}=100
    Should Be Equal As Numbers    ${response.status_code}    200
    ${users}=    Set Variable    ${response.json()}
    Should Be True    ${users}    !=[]
    Validate User List    ${users}    ${min_count}    ${max_count}
    # ${length}=    Get Length    ${users}
    # Should Be True    ${length} >= ${min_count}    List should have at least ${min_count} users
    # Should Be True    ${length} <= ${max_count}    List should not exceed ${max_count} users

    # FOR    ${user}    IN    @{users}
    #     Should Contain    ${user}    id
    #     Should Contain    ${user}    username
    #     Should Contain    ${user}    email
    #     Should Contain    ${user}    role
    #     Should Be True    ${user["id"]} > 0
    #     Should Not Be Empty    ${user["username"]}
    #     Should Match Regexp    ${user["email"]}    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$    Invalid email format
    #     Should Not Be Empty    ${user["role"]["name"]}
    # END

Post User Data
    [Documentation]    Create a new user via POST request and validate the response
    [Arguments]    ${first_name}    ${last_name}    ${email}    ${username}    ${role_name}    ${password}=${None}
    ${role_ids}=    Create Dictionary
    ...    Admin=1
    ...    Normal=2
    ...    Test=3
    ${role_id}=    Get From Dictionary    ${role_ids}    ${role_name}    default=${None}
    Run Keyword If    '${role_id}' == '${None}'    Fail    Invalid role_name: ${role_name}
    ${user_data}=    Create Dictionary
    ...    first_name=${first_name}
    ...    last_name=${last_name}
    ...    email=${email}
    ...    username=${username}
    ...    role=${role_id}
    Run Keyword If    '${password}' != '${None}'    Set To Dictionary    ${user_data}    password    ${password}
    RETURN    ${user_data}

Validate Response Of User Created
    [Documentation]    Validate the response of the user created
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    201
    ${user}=    Set Variable    ${response.json()}
    Should Be True    ${user["id"]} > 0   
    Should Be Equal    ${user["username"]}    Normal
    Should Be Equal    ${user["username"]}    test029
    Should Match Regexp    ${user["email"]}    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$    Invalid email format