*** Settings ***
Library    RequestsLibrary
Resource    ../resources/auth.resource

*** Test Cases ***
Post Login And Get Response
    [Tags]    001
    [Documentation]    Login and verify fetching user information
    ${login_response}=    Login With Credentials    /api/login/    admin    111111@A
    Validate Successful Login Response    ${login_response}

# Get A User With Validation
#     [Tags]    002
#     [Documentation]    Login and verify fetching a specific user
#     ${login_response}=    Login With Credentials    /api/login/    admin    111111@A
#     ${user_response}=    Get Data With Response Token   /api/users/1/
#     Validate A User Response   ${user_response}

Get All Users With Validation
    [Tags]    003
    [Documentation]    Login and verify fetching all users
    ${login_response}=    Login With Credentials    /api/login/    admin    111111@A
    ${user_response}=    Get Data With Response Token   /api/users/ 
    Validate All Users Response    ${user_response}