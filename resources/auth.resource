*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    global_variable.resource

*** Keywords ***
Login With Credentials
    [Documentation]    Log in to the application and store the access token
    [Arguments]    ${endpoint}    ${username}    ${password}
    Create Session    ${loginSession}    ${apiBaseUrl}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST On Session    ${loginSession}    ${endpoint}    json=${data}    headers=${headers}
    RETURN    ${response}
    
Validate Successful Login Response
    [Documentation]    Validate the login response and extract the access token
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${body}=    Set Variable    ${response.json()}
    Should Contain    ${body}    refresh
    Should Contain    ${body}    access
    Should Not Be Empty    ${body["refresh"]}
    Should Not Be Empty    ${body["access"]}
    Should Be Equal    ${body["username"]}    admin
    Should Be Equal    ${body["message"]}    Login successfully
    Set Suite Variable    ${ACCESS_TOKEN}    ${body["access"]}

Get Data With Response Token
    [Documentation]    Use the stored access token to fetch user information
    [Arguments]    ${endpoint}
    Create Session    ${userSession}    ${apiBaseUrl}
    ${auth_headers}=    Create Dictionary    Authorization=Bearer ${ACCESS_TOKEN}
    ${response}=    GET On Session    ${userSession}     ${endpoint}    headers=${auth_headers}
    RETURN    ${response}

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
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${users}=    Set Variable    ${response.json()}
    Should Be True    ${users}    !=[]

    FOR    ${user}    IN    @{users}
        Should Contain    ${user}    id
        Should Contain    ${user}    username
        Should Contain    ${user}    email
        Should Contain    ${user}    role
        Should Be True    ${user["id"]} > 0
        Should Not Be Empty    ${user["username"]}
        Should Match Regexp    ${user["email"]}    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$    Invalid email format
        Should Not Be Empty    ${user["role"]["name"]}
    END
