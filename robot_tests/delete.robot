*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://restful-booker.herokuapp.com

*** Test Cases ***
Cenário: Gerar Token, Criar e Deletar Reserva com Token
    Step 1: Preparar o payload de autenticação
    Step 2: Enviar a solicitação POST de autenticação
    Step 3: Verificar se o token foi gerado com sucesso
    Step 4: Criar uma reserva com o token
    Step 5: Verificar se a reserva foi criada com sucesso
    Step 6: Deletar a reserva com o token
    Step 7: Verificar se a solicitação DELETE foi bem-sucedida

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
    Log     Resposta JSON de autenticação: ${json}
    ${token}=    Get From Dictionary    ${json}    token
    Should Not Be Empty    ${token}
    Set Suite Variable    ${token}    ${token}
    Log     Token gerado com sucesso: ${token}

Step 4: Criar uma reserva com o token
    ${booking_dates}=    Create Dictionary    checkin=2025-01-01    checkout=2025-01-02
    ${data}=    Create Dictionary    firstname=John    lastname=Doe    totalprice=100    depositpaid=True    bookingdates=${booking_dates}    additionalneeds=Breakfast
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${create_response}=    POST    ${BASE_URL}/booking    json=${data}    headers=${headers}
    Log     Resposta Criar Reserva: ${create_response.text}
    Set Test Variable    ${create_response}    ${create_response}

Step 5: Verificar se a reserva foi criada com sucesso
    Should Be True    ${create_response.ok}
    Should Be Equal As Numbers    ${create_response.status_code}    200
    ${created_booking}=    Set Variable    ${create_response.json()}
    Log     Reserva criada: ${created_booking}
    ${booking_id}=    Get From Dictionary    ${created_booking}    bookingid
    Set Suite Variable    ${booking_id}    ${booking_id}

Step 6: Deletar a reserva com o token
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${delete_response}=    DELETE    ${BASE_URL}/booking/${booking_id}    headers=${headers}
    Log     Resposta DELETE: ${delete_response.text}
    Set Test Variable    ${delete_response}    ${delete_response}

Step 7: Verificar se a solicitação DELETE foi bem-sucedida
    Should Be True    ${delete_response.ok}
    Should Be Equal As Numbers    ${delete_response.status_code}    201
    Log     Reserva deletada com sucesso!
