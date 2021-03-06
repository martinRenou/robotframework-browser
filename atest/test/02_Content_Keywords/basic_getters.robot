*** Settings ***
Resource          imports.resource
Suite Setup       New Page    ${LOGIN_URL}

*** Variables ***
${UserNameLabel}=    label[for="username_field"]
${InputUsername}=    ${UserNameLabel} >> //.. >> input

*** Test Cases ***
Get Text
    ${h1}=    Get Text    h1
    Should Be Equal    ${h1}    Login Page

Get Text and Assert ==
    Get Text    ${UserNameLabel}    ==    User Name:

Get Text and Assert !=
    Get Text    ${UserNameLabel}    !=

Get Text Assert Validate
    Get Text    h1    validate    value.startswith('Login')

Get Text With Nonmatching Selector
    [Setup]    Set Browser Timeout    50ms
    Run Keyword And Expect Error    *Timeout 50ms exceeded.*waiting for selector "notamatch"*    Get Text    notamatch
    [Teardown]    Set Browser Timeout    ${PLAYWRIGHT_TIMEOUT}

Get Property and Assert
    Get Property    h1    innerText    ==    Login Page

Get Property innerText
    ${inner_text}=    Get Property    ${UserNameLabel}    innerText
    Should Be Equal    ${inner_text}    User Name:

Get Property size
    ${size}=    Get Property    ${InputUsername}    type
    Should Be Equal    ${size}    text

Get Property and Then .. (Closure)
    ${text}=    Get Property    h1    innerText    then    value.replace('g', 'k')
    Should be equal    ${text}    Lokin Pake

Get Property With Nonmatching Selector
    [Setup]    Set Browser Timeout    50ms
    Run Keyword And Expect Error    *Timeout 50ms exceeded.*waiting for selector "notamatch"*    Get Property    notamatch    attributeName
    [Teardown]    Set Browser Timeout    ${PLAYWRIGHT_TIMEOUT}

Get Attribute
    ${type}=    Get Attribute    id=login_button    type
    Should Be Equal    ${type}    submit

Get Attribute and Fail
    Run Keyword And Expect Error    Attribute 'disabled' not found!    Get Attribute    id=login_button    disabled

Get Attribute and Verify absense
    Get Attribute    id=login_button    disabled    ==    ${None}

Get Attribute and return presents state
    ${present}=    Get Attribute    id=login_button    value    evaluate    value is not None
    Should Be True    ${present}
    ${present}=    Get Attribute    id=login_button    disabled    evaluate    value is None
    Should Be True    ${present}

Get Attribute Names
    [Setup]    New Page    ${ELEMENT_STATE_URL}
    ${attrs}=    Get Attribute Names    [name="readonly_input"]
    FOR    ${attr}    IN    @{attrs}
        ${value}=    Get Attribute    [name="readonly_input"]    ${attr}
        Log    ${attr}=${value}
    END
    [Teardown]    Close Page

Get Attribute Names and Assert single and multiple
    [Setup]    New Page    ${ELEMENT_STATE_URL}
    Get Attribute Names    [name="readonly_input"]    ==    type    name    value    readonly
    Get Attribute Names    [name="disabled_input"]    contains    disabled
    Get Attribute Names    [name="disabled_input"]    validate    value[-1] == "disabled"
    [Teardown]    Close Page

Get Classes
    ${classes}=    Get Classes    id=draggable
    Should Be Equal    ${classes}    ${{["box", "react-draggable"]}}

Get Classes and Assert
    Get Classes    id=draggable    contains    react-draggable
    Get Classes    id=draggable    ==    react-draggable    box
    Get Classes    id=draggable    validate    "react-draggable-dragged" not in value

Get Element Count
    ${count}=    Get Element Count    h1
    Should Be Equal    ${count}    ${1}
    ${count}=    Get Element Count    label
    Should Be Equal    ${count}    ${2}
    ${count}=    Get Element Count    not-existing
    Should Be Equal    ${count}    ${0}

Get Element Count and Assert
    Get Element Count    h1    ==    1
    Get Element Count    h1    ==    ${1}
    Get Element Count    label    validate    value == 2
    Get Element Count    label    >    1
    Get Element Count    not-existing    ==
    ${promise}=    Promise to    Get Element Count    label
    ${count}=    Wait for    ${promise}
    should be equal    ${count}    ${2}

Get Style and Assert
    Get Style    h1    ALL    *=    align-content
    Get Style    h1    align-content    ==    normal

Get Element Size and Assert
    ${expected}=    Evaluate    {'x': 0, 'y': 400, 'width': 40, 'height': 30}
    ${bounding_box}=    Get BoundingBox    \#progress_bar    ALL    ==    ${expected}
    Should Be Equal    ${bounding_box}    ${expected}
    Get BoundingBox    \#progress_bar    ALL    ==    ${{{'x': 0, 'y': 400, 'width': 40, 'height': 30}}}

Get Element and Assert x
    ${x}=    Get BoundingBox    \#progress_bar    x    ==    0
    Should Be Equal    ${x}    ${0}

Get Element and Assert y
    Get BoundingBox    \#progress_bar    y    validate    value - 400 == 0

Get Element width and height
    ${expected}=    Evaluate    {'w': 40, 'h': 30}
    ${wh}=    Get BoundingBox    \#progress_bar    ALL    validate    value['width'] == 40
    ${wh}=    Get BoundingBox    \#progress_bar    ALL    evaluate    {'w': value['width'], 'h': value['height']}
    Should Be Equal    ${wh}    ${expected}

Get Page Source
    Get Page Source    contains    <title>Login Page</title>
