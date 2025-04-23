*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://restful-booker.herokuapp.com

*** Keywords ***
Step 1: Preparar o payload de autenticação
    ${payload}=    Create Dictionary    username=admin    password=password123
    Set Test Variable    ${auth_payload}    ${payload}

Step 2: Enviar a solicitação POST de autenticação
    ${response}=    POST    ${BASE_URL}/auth    json=${auth_payload}
    Log     Resposta: ${response.text}
    Set Test Variable    ${auth_response}    ${response}

Step 3: Verificar se o token foi gerado com sucesso
    Should Be True    ${auth_response.ok}
    Should Be Equal As Numbers    ${auth_response.status_code}    200
    ${json}=    Set Variable    ${auth_response.json()}
    ${token}=    Get From Dictionary    ${json}    token
    Should Not Be Empty    ${token}
    Log     Token gerado com sucesso: ${token}

*** Test Cases ***
Cenário: Validar geração de token com sucesso
    Step 1: Preparar o payload de autenticação
    Step 2: Enviar a solicitação POST de autenticação
    Step 3: Verificar se o token foi gerado com sucesso
