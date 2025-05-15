*** Settings ***
Library    RequestsLibrary
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

Get Response Request
    [Documentation]    Use the stored access token to fetch user information
    [Arguments]    ${endpoint}
    Create Session    ${userSession}    ${apiBaseUrl}
    ${auth_headers}=    Create Dictionary    Authorization=Bearer ${ACCESS_TOKEN}
    ${response}=    GET On Session    ${userSession}     ${endpoint}    headers=${auth_headers}
    RETURN    ${response}

Send POST Request
    [Documentation]    Send a POST request with the access token
    [Arguments]    ${endpoint}    ${data}
    Create Session    ${userSession}    ${apiBaseUrl}
    ${auth_headers}=    Create Dictionary    Authorization=Bearer ${ACCESS_TOKEN}
    ${response}=    POST On Session    ${userSession}     ${endpoint}    json=${data}    headers=${auth_headers}
    RETURN    ${response}