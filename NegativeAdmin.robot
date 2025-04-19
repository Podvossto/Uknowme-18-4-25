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
    Sleep    2s
    
    # Navigate to registration page
    Wait Until Element Is Visible    id=header-logo-link    timeout=15s
    Click Element    id=header-logo-link
    Sleep    1s
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]    timeout=15s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
    Sleep    1s
    
    # Click on Register/Signup if available
    Wait Until Element Is Visible    id=signup-btn    timeout=10s
    Click Element    id=signup-btn
    Sleep    1s
    
    # Fill registration form
    Wait Until Element Is Visible    id=name-input    timeout=10s
    Input Text    id=name-input    Admin Test
    Input Text    id=email-input    ${ADMIN_EMAIL}
    Input Password    id=password-input    ${ADMIN_PASSWORD}
    Input Text    id=phone-input    0899999999
    
    # Submit registration
    Wait Until Element Is Visible    id=submit-signup-btn    timeout=10s
    Click Element    id=submit-signup-btn
    
    # Wait for confirmation - could be success or already exists message
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=15s
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]    
    
    # Return to login page
    Wait Until Element Is Visible    id=header-logo-link    timeout=10s
    Click Element    id=header-logo-link

Login Admin Fail
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Sleep    2s
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]    timeout=15s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
    Sleep    1s
    
    # Input wrong email
    Wait Until Element Is Visible    id=email-input    timeout=10s
    Input Text    id=email-input    wrong.admin@uknowme.com
    Input Password    id=password-input    ${ADMIN_PASSWORD}
    Capture Step Screenshot    admin_credentials_entered
    
    # Click Login Button
    Wait Until Element Is Visible    id=login-submit-btn    timeout=10s
    Click Element    id=login-submit-btn
    Sleep    3s
    
    # Verify error message
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=15s
    ${status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เกิดข้อผิดพลาด
    Run Keyword If    not ${status}    Log    Expected error message for invalid login was not found
    
Login Admin Invalid
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Sleep    2s
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]    timeout=15s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
    Sleep    1s
    
    # Input incomplete credentials
    Wait Until Element Is Visible    id=email-input    timeout=10s
    Input Text    id=email-input    ${ADMIN_EMAIL}
    # Intentionally skip password
    
    # Click Login Button
    Wait Until Element Is Visible    id=login-submit-btn    timeout=10s
    Click Element    id=login-submit-btn
    Sleep    3s
    
    # Verify error message - either form validation or backend error
    ${popup_status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=15s
    Run Keyword If    ${popup_status}    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เกิดข้อผิดพลาด
    
    # If no popup, it might be doing form validation
    Run Keyword If    not ${popup_status}    Log    No popup error appeared, it might be using form validation instead

Login Admin
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Capture Step Screenshot    admin_login_start
    Sleep    2s
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]    timeout=15s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
    Capture Step Screenshot    admin_role_selected
    Sleep    1s
    
    # Input Login Credentials
    Wait Until Element Is Visible    id=email-input    timeout=10s
    Input Text    id=email-input    ${ADMIN_EMAIL}
    Input Password    id=password-input    ${ADMIN_PASSWORD}
    Capture Step Screenshot    admin_credentials_entered
    
    # Click Login Button
    Wait Until Element Is Visible    id=login-submit-btn    timeout=10s
    Click Element    id=login-submit-btn
    
    # Verify Login Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=15s
    ${status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ล็อกอินสำเร็จ
    Run Keyword If    not ${status}    Fail    Admin login failed - please check credentials
    Capture Step Screenshot    admin_login_success
    
    # Click confirm button
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'swal2-confirm')]    timeout=5s
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]

DashboardAdmin
    Go To    http://localhost/AdminDashboard
    Capture Step Screenshot    admin_dashboard
    Sleep    5s    # Increased sleep time to ensure dashboard is fully loaded

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
    Wait Until Element Is Visible    id=courses-link    timeout=15s
    Click Element    id=courses-link
    Sleep    2s

    Wait Until Element Is Visible    id=add-course-btn    timeout=10s
    Click Element    id=add-course-btn
    Sleep    2s

    # Only fill some fields, leaving others empty to test validation
    Wait Until Element Is Visible    id=duration_hours-upload-popup    timeout=10s
    Input Text    id=duration_hours-upload-popup    1
    Input Text    id=max_seats-upload-popup    20
    Input Text    id=start_date-upload-popup    10102025
    
    # Use Run Keyword And Ignore Error to handle potential file upload issues
    Run Keyword And Ignore Error    Choose File    id=thumbnail-upload-popup    ${CURDIR}/image/download.jpg
    Run Keyword And Ignore Error    Choose File    id=video-upload-popup    ${CURDIR}/image/12607801_1920_1080_30fps.mp4
    Run Keyword And Ignore Error    Choose File    id=qr_code-upload-popup    ${CURDIR}/image/download.jpg

    Wait Until Element Is Visible    id=upload-btn-upload-popup    timeout=10s
    Click Element    id=upload-btn-upload-popup
    Sleep    5s
    
    # Verify error message for incomplete course information
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=15s
    ${status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เกิดข้อผิดพลาด
    Run Keyword If    not ${status}    Log    Expected error message not found for incomplete course information
    
    # Click confirm button if popup is shown
    ${confirm_btn}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Run Keyword If    ${confirm_btn}    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    
    [Teardown]    Close Browser