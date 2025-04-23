*** Settings ***
Library    RequestsLibrary

*** Keywords ***

Step 1: Fazer a request GET
    ${response}=    GET    https://restful-booker.herokuapp.com/booking
    Log    ${response.text}
    Set Test Variable    ${response}

Step 2: Verificar se o get foi feito com sucesso
    Should Be True    ${response.ok}

Step 3: Verificar o status code é igual a 200
    Should Be Equal As Strings    ${response.status_code}   200

*** Test Cases ***
Cenário 1: Validando get 
    Step 1: Fazer a request GET
    Step 2: Verificar se o get foi feito com sucesso
    Step 3: Verificar o status code é igual a 200
