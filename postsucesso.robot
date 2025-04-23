*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://restful-booker.herokuapp.com

*** Test Cases ***
Cadastrando Uma Reserva
    # Criar sessão com o servidor
    Create Session    restful    ${BASE_URL}

    # Montar o corpo da requisição
    ${bookingdates}=    Create Dictionary    checkin=2018-01-01    checkout=2019-01-01
    ${data}=    Create Dictionary
    ...    firstname=Sávio
    ...    lastname=QA
    ...    totalprice=520
    ...    depositpaid=True
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Breakfast
       
    Log    ${data}

    # Enviar a requisição POST
    ${response}=    Post Request    restful    /booking    json=${data}

    # Logs de resposta
    Log    ${response.text}
    Log    ${response.status_code}
    Log    ${response.reason}

    # Validações principais
    Should Be True    ${response.ok}
    Should Be Equal As Numbers    ${response.status_code}    200

    # Validação dos dados retornados
    ${booking}=    Evaluate    ${response.json()}    json
    Log Dictionary    ${booking}

    # Extraindo o objeto "booking" do JSON de resposta
    ${booking_info}=    Get From Dictionary    ${booking}    booking

    # Validações dos campos principais
    Should Be Equal As Strings    ${booking_info['firstname']}    Sávio
    Should Be Equal As Strings    ${booking_info['lastname']}     QA
    Should Be Equal As Numbers    ${booking_info['totalprice']}   520
    Should Be Equal As Strings    ${booking_info['additionalneeds']}   Breakfast

    # Acessando e validando os campos do objeto aninhado "bookingdates"
    ${bookingdates_info}=    Get From Dictionary    ${booking_info}    bookingdates
    Should Be Equal As Strings    ${bookingdates_info['checkin']}     2018-01-01
    Should Be Equal As Strings    ${bookingdates_info['checkout']}    2019-01-01
