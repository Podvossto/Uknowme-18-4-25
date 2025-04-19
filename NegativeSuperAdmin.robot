*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Library    OtpLibrary.py

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
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
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
    [Teardown]    Close Browser

SignIn-Privatekey
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Capture Step Screenshot    admin_login_start
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
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
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
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
    Wait Until Element Is Visible    id=submit-private-key-btn    timeout=10s
    Click Element    id=submit-private-key-btn
    Sleep    3s
    Input Text    id=private-key-input    1111111111111111111111111
    Wait Until Element Is Visible    id=submit-private-key-btn    timeout=10s
    Click Element    id=submit-private-key-btn
    Wait Until Element Is Visible    id=verify-otp-btn
    Click Element    id=verify-otp-btn

*** Test Cases ***
TCI00-สร้างผู้ดูแลระบบ
    Register Admin

TCI01-เข้าสู่ระบบผู้ดูแลระบบขั้นสูงกรณีไม่กรอก Privatekay
    SignIn-Privatekey
    [Teardown]    Close Browser
