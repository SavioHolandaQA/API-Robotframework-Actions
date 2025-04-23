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
    Set Test Variable    ${token}    ${token}
    Log     Token gerado com sucesso: ${token}

Step 4: Criar uma reserva com o token
    ${booking_dates}=    Create Dictionary    checkin=2025-01-01    checkout=2025-01-02
    ${data}=    Create Dictionary    firstname=John    lastname=Doe    totalprice=100    depositpaid=True    bookingdates=${booking_dates}    additionalneeds=Breakfast
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${create_response}=    POST    ${BASE_URL}/booking    json=${data}    headers=${headers}
    Set Test Variable    ${create_response}    ${create_response}
    Log     Reserva criada: ${create_response.text}

Step 5: Verificar se a reserva foi criada com sucesso
    Should Be Equal As Numbers    ${create_response.status_code}    200
    ${created_booking}=    Set Variable    ${create_response.json()}
    ${booking_id}=    Get From Dictionary    ${created_booking}    bookingid
    Set Test Variable    ${booking_id}    ${booking_id}

Step 6: Buscar reserva por ID
    ${response}=    GET    ${BASE_URL}/booking/${booking_id}
    Log     Resposta GET (por ID): ${response.text}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${get_booking}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${get_booking['firstname']}    John
    Should Be Equal As Strings    ${get_booking['lastname']}     Doe
    Should Be Equal As Numbers    ${get_booking['totalprice']}   100
    Log     Reserva encontrada com sucesso: ${get_booking}

Step 7: Atualizar a reserva com o token
    ${updated_dates}=    Create Dictionary    checkin=2018-01-01    checkout=2019-01-01
    ${updated_data}=    Create Dictionary
    ...    firstname=Sávio
    ...    lastname=QA
    ...    totalprice=520
    ...    depositpaid=True
    ...    bookingdates=${updated_dates}
    ...    additionalneeds=Breakfast
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Cookie=token=${token}
    ${update_response}=    PUT    ${BASE_URL}/booking/${booking_id}    json=${updated_data}    headers=${headers}
    Set Test Variable    ${update_response}    ${update_response}
    Log     Atualização da reserva: ${update_response.text}

Step 8: Verificar se a solicitação PUT foi bem-sucedida
    Should Be Equal As Numbers    ${update_response.status_code}    200
    ${updated_response}=    Set Variable    ${update_response.json()}
    Should Be Equal As Strings    ${updated_response['firstname']}    Sávio
    Should Be Equal As Strings    ${updated_response['lastname']}     QA
    Should Be Equal As Numbers    ${updated_response['totalprice']}   520
    Log     Reserva atualizada com sucesso!

Step 9: Deletar reserva
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${delete_response}=    DELETE    ${BASE_URL}/booking/${booking_id}    headers=${headers}
    Set Test Variable    ${delete_response}    ${delete_response}
    Log     Resposta DELETE: ${delete_response.text}
    Should Be Equal As Numbers    ${delete_response.status_code}    201
    Log     Reserva deletada com sucesso!

*** Test Cases ***
Cenário: Gerar Token, Criar, Buscar, Atualizar e Excluir Reserva com Token
    Step 1: Preparar o payload de autenticação
    Step 2: Enviar a solicitação POST de autenticação
    Step 3: Verificar se o token foi gerado com sucesso
    Step 4: Criar uma reserva com o token
    Step 5: Verificar se a reserva foi criada com sucesso
    Step 6: Buscar reserva por ID
    Step 7: Atualizar a reserva com o token
    Step 8: Verificar se a solicitação PUT foi bem-sucedida
    Step 9: Deletar reserva
