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
    [Documentation]    Login and verify fetching a specific user
    Login With Credentials    /api/login/    admin    111111@A
    ${user_response}=    Get Response Request   /api/users/1/
    Validate A User Response   ${user_response}

Get All Users With Validation
    [Tags]    003
    [Documentation]    Login and verify fetching all users
    Login With Credentials    /api/login/    admin    111111@A
    ${user_response}=    Get Response Request   /api/users/ 
    Validate All Users Response    ${user_response}    1    100

Create A User
    [Tags]    004
    [Documentation]    Login and create a new user
    Login With Credentials    /api/login/    admin    111111@A
    ${post_data}=    Post User Data    test029    User    test029@gmail.com    test029    Normal    111111@A
    Send POST Request   /api/users/    ${post_data}
