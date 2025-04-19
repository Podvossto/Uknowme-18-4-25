*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime

*** Variables ***
${BROWSER}    chrome
${URL}    http://localhost/
${DELAY}    0
${SCREENSHOT_DIR}    screenshots
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
    
    # Return to login page
    Wait Until Element Is Visible    id=header-logo-link
    Click Element    id=header-logo-link

Login Admin Fail
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]    timeout=10s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
    
    # Input wrong email
    Input Text    id=email-input    wrong.admin@uknowme.com
    Input Password    id=password-input    ${ADMIN_PASSWORD}
    Capture Step Screenshot    admin_credentials_entered
    
    # Click Login Button
    Click Element    id=login-submit-btn
    Sleep    3s
    
    # Verify error message
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เกิดข้อผิดพลาด
    
Login Admin Invalid
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]    timeout=10s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
    
    # Input incomplete credentials
    Input Text    id=email-input    ${ADMIN_EMAIL}
    # Intentionally skip password
    
    # Click Login Button
    Click Element    id=login-submit-btn
    Sleep    3s
    
    # Verify error message
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เกิดข้อผิดพลาด

Login Admin
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
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ล็อกอินสำเร็จ
    Capture Step Screenshot    admin_login_success

DashboardAdmin
    Go To    http://localhost/AdminDashboard
    Capture Step Screenshot    admin_dashboard
    Sleep    3s

*** Test Cases ***
TCI000-สร้างผู้ดูแลระบบใหม่
    Register Admin
    [Teardown]    Close Browser

TCI001-เข้าสู่ระบบผู้ดูแลระบบกรณีใช้ email ผิด
    Login Admin Fail
    [Teardown]    Close Browser

TCI002-เข้าสู่ระบบผู้ดูแลระบบกรณีกรอกข้อมูลไม่ครบ
    Login Admin Invalid
    [Teardown]    Close Browser

TCI003-เพิ่มคอร์สกรณีที่ใส่ข้อมูลคอร์สไม่ครบ
    Login Admin
    DashboardAdmin
    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link

    Wait Until Element Is Visible    id=add-course-btn
    Click Element    id=add-course-btn

    # Only fill some fields, leaving others empty to test validation
    Input Text    id=duration_hours-upload-popup    1
    Input Text    id=max_seats-upload-popup    20
    Input Text    id=start_date-upload-popup    10102025
    Choose File    id=thumbnail-upload-popup    ${CURDIR}/image/download.jpg
    Choose File    id=video-upload-popup        ${CURDIR}/image/12607801_1920_1080_30fps.mp4
    Choose File    id=qr_code-upload-popup      ${CURDIR}/image/download.jpg

    Wait Until Element Is Visible    id=upload-btn-upload-popup
    Click Element    id=upload-btn-upload-popup
    Sleep    5s
    
    # Verify error message for incomplete course information
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เกิดข้อผิดพลาด
    [Teardown]    Close Browser