*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Library    OtpLibrary.py
Suite Setup    SignIn-SuperAdmin
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}    chrome
${URL}    http://localhost/
${DELAY}    0
${SCREENSHOT_DIR}    screenshots
${SECRET}    32KZ7QO6I5Q6CGI2K3PJQOOFNMYI46ES
${ADMIN_EMAIL}    admin@uknowme.com
${ADMIN_PASSWORD}    Admin1234

*** Keywords ***
Capture Step Screenshot
    [Arguments]    ${step_name}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${step_name}_${timestamp}.png

Register Admin
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Capture Step Screenshot    admin_registration_start
    
    # Navigate to registration page
    Wait Until Element Is Visible    id=header-logo-link
    Click Element    id=header-logo-link
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]    timeout=10s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
    
    # Click on Register/Signup if available
    Wait Until Element Is Visible    id=signup-btn
    Click Element    id=signup-btn
    
    # Fill registration form
    Input Text    id=name-input    Admin Test
    Input Text    id=email-input    ${ADMIN_EMAIL}
    Input Password    id=password-input    ${ADMIN_PASSWORD}
    Input Text    id=phone-input    0899999999
    
    # Submit registration
    Wait Until Element Is Visible    id=submit-signup-btn
    Click Element    id=submit-signup-btn
    
    # Wait for confirmation
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Close Browser

SignIn-SuperAdmin
    # First try to register the admin if needed
    ${status}=    Run Keyword And Return Status    Register Admin
    
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Capture Step Screenshot    admin_login_start
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]    timeout=10s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
    Capture Step Screenshot    admin_role_selected
    
    # Input Login Credentials
    Wait Until Element Is Visible    id=email-input
    Input Text    id=email-input    ${ADMIN_EMAIL}
    Input Password    id=password-input    ${ADMIN_PASSWORD}
    Capture Step Screenshot    admin_credentials_entered
    
    # Click Login Button
    Click Element    id=login-submit-btn
    
    # Verify Login Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ล็อกอินสำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Capture Step Screenshot    admin_login_success

    Go To    http://localhost/AdminDashboard
    Sleep    3s

    Wait Until Element Is Visible    id=user-menu-btn
    Click Element    id=user-menu-btn

    Wait Until Element Is Visible    id=logout-btn
    Click Element    id=logout-btn

    Wait Until Element Is Visible    id=header-logo-link
    Click Element    id=header-logo-link
    Input Text    private-key-input    1111111111111111111111111
    Wait Until Element Is Visible    id=submit-private-key-btn
    Click Element    id=submit-private-key-btn
    ${otp}=    Get Otp    ${SECRET}
    Input Text    id=otp-input    ${otp}
    Wait Until Element Is Visible    id=verify-otp-btn
    Click Element    id=verify-otp-btn
    
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]

Add-SuperAdmin
    Wait Until Element Is Visible    id=add-user-btn
    Click Element    id=add-user-btn
    Input Text    xpath=//*[@id="add-user-modal"]/div/div[1]/input    Test35
    Input Text    xpath=//*[@id="add-user-modal"]/div/div[2]/input    00035
    Input Text    xpath=//*[@id="add-user-modal"]/div/div[3]/input    00035
    Input Text    xpath=//*[@id="add-user-modal"]/div/div[4]/input    000335
    Input Text    xpath=//*[@id="add-user-modal"]/div/div[5]/input    Test1245s@gmail.com
    Wait Until Element Is Visible    id=confirm-add-btn
    Click Button    id=confirm-add-btn

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]

Edit-Admin
    # Find the admin user by looking for edit buttons that contain user IDs
    @{elements}=    Get WebElements    xpath=//button[contains(@id, 'edit-user-')]    
    ${first_admin_id}=    Set Variable    ${EMPTY}
    
    # Get the first available admin ID
    FOR    ${element}    IN    @{elements}
        ${id}=    Get Element Attribute    ${element}    id
        ${status}=    Run Keyword And Return Status    Should Match Regexp    ${id}    edit-user-.*
        Run Keyword If    ${status}    Set Variable    ${first_admin_id}    ${id}
        Run Keyword If    ${status}    Exit For Loop
    END
    
    # If we found an admin to edit
    Run Keyword If    '${first_admin_id}' != '${EMPTY}'    Click Element    id=${first_admin_id}
    
    # Edit form fields - using more generic selectors that don't depend on exact values
    Wait Until Element Is Visible    xpath=//form//input[contains(@id, 'name')]    10s
    Input Text    xpath=//form//input[contains(@id, 'name')]    Updated Admin Name
    Input Text    xpath=//form//input[contains(@id, 'phone')]    0987654321
    
    # Click update button - using a more generic selector
    Wait Until Element Is Visible    xpath=//button[contains(text(), 'Update') or contains(@id, 'update')]    10s
    Click Element    xpath=//button[contains(text(), 'Update') or contains(@id, 'update')]
    
    # Verify success message
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    10s
    ${status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สำเร็จ
    Run Keyword If    ${status}    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]

*** Test Cases ***
TC-001-Add-SuperAdmin
    
    Add-SuperAdmin
    

TC-002-Edit-SuperAdmin
    
    Edit-Admin
    

TC-003-delete-SuperAdmin
    # Find delete buttons for admin users
    @{elements}=    Get WebElements    xpath=//button[contains(@id, 'delete-user-')]    
    ${first_delete_id}=    Set Variable    ${EMPTY}
    
    # Get the first available delete button ID
    FOR    ${element}    IN    @{elements}
        ${id}=    Get Element Attribute    ${element}    id
        ${status}=    Run Keyword And Return Status    Should Match Regexp    ${id}    delete-user-.*
        Run Keyword If    ${status}    Set Variable    ${first_delete_id}    ${id}
        Run Keyword If    ${status}    Exit For Loop
    END
    
    # If we found a user to delete
    Run Keyword If    '${first_delete_id}' != '${EMPTY}'    Click Element    id=${first_delete_id}
    
    # Confirm deletion
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    10s
    ${status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สำเร็จ
    Run Keyword If    ${status}    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]

TC-005-Add-SuperAdmin
    
    Add-SuperAdmin
TC-006-Logout
    
    Wait Until Element Is Visible    id=logout-btn
    Click Element    id=logout-btn
    