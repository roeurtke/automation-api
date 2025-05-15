*** Settings ***
Library    RequestsLibrary
Resource    ../resources/auth.resource
Resource    ../resources/user.resource

*** Test Cases ***
Post Login And Get Response
    [Tags]    001
    [Documentation]    Login and verify fetching user information
    ${login_response}=    Login With Credentials    /api/login/    admin    111111@A
    Validate Successful Login Response    ${login_response}

Get A User With Validation
    [Tags]    002
    [Documentation]    Verify fetching a specific user
    ${user_response}=    Get Response Request   /api/users/1/
    Validate A User Response   ${user_response}

Get All Users With Validation
    [Tags]    003
    [Documentation]    Verify fetching all users
    ${user_response}=    Get Response Request   /api/users/ 
    Validate All Users Response    ${user_response}    1    100

Create A User
    [Tags]    004
    [Documentation]    Create a new user
    ${post_data}=    Post User Data    test031    User    test031@gmail.com    test031    Normal    111111@A
    Send POST Request   /api/users/    ${post_data}
