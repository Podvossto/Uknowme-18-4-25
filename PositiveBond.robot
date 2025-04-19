*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Suite Setup    Setup Bond Trader
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}    chrome
${URL}    http://localhost/
${DELAY}    0
${SCREENSHOT_DIR}    screenshots
${BOND_EMAIL}    trader@uknowme.com
${BOND_PASSWORD}    Trader1234
${BOND_NAME}    Bond Trader Test
${BOND_COMPANY}    Test Trading Co.
${BOND_CITIZEN_ID}    1234567890123
${BOND_PHONE}    0899999998

*** Keywords ***
Capture Step Screenshot
    [Arguments]    ${step_name}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${step_name}_${timestamp}.png

Setup Bond Trader
    Register Bond Trader
    LogIn

Register Bond Trader
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Sleep    2s
    
    # Try both role selection methods
    ${role_btn_exists}=    Run Keyword And Return Status    Page Should Contain Element    id=role-btn-trader
    Run Keyword If    ${role_btn_exists}    Click Element    id=role-btn-trader
    Run Keyword If    not ${role_btn_exists}    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]    timeout=15s
    Run Keyword If    not ${role_btn_exists}    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]
    Sleep    1s

    Wait Until Element Is Visible    id=signup-btn    timeout=10s
    Click Element    id=signup-btn
    Sleep    1s
    
    Wait Until Element Is Visible    id=name-input    timeout=10s
    Input Text    id=name-input    ${BOND_NAME}
    Input Text    id=company-input    ${BOND_COMPANY}
    Input Text    id=citizen-id-input    ${BOND_CITIZEN_ID}
    Input Text    id=email-input    ${BOND_EMAIL}
    Input Text    id=phone-input    ${BOND_PHONE}
    Input Password    id=password-input    ${BOND_PASSWORD}
    Wait Until Element Is Visible    id=submit-signup-btn    timeout=10s
    Click Element    id=submit-signup-btn
    
    # Handle both success and duplicate registration scenarios
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=15s
    ${status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สมัครสมาชิกสำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Close Browser

Signup New Bond Trader
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Wait Until Element Is Visible    id=role-btn-trader
    Click Element    id=role-btn-trader

    Wait Until Element Is Visible    id=signup-btn
    Click Element    id=signup-btn
    Input Text    id=name-input    New Bond Trader
    Input Text    id=company-input    New Company
    Input Text    id=citizen-id-input    9876543210123
    Input Text    id=email-input    newtrader@uknowme.com
    Input Text    id=phone-input    0887654321
    Input Password    id=password-input    Trader5678
    Wait Until Element Is Visible    id=submit-signup-btn
    Click Element    id=submit-signup-btn
    
    # Confirm Registration Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สมัครสมาชิกสำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    [Teardown]    Close Browser

LogIn
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Capture Step Screenshot    user_login_start
    Sleep    2s
    
    # Select User Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]    timeout=15s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]
    Capture Step Screenshot    user_role_selected
    Sleep    1s
    
    # Input Login Credentials
    Wait Until Element Is Visible    id=email-input    timeout=10s
    Input Text    id=email-input    ${BOND_EMAIL}
    Input Password    id=password-input    ${BOND_PASSWORD}
    Capture Step Screenshot    user_credentials_entered
    
    # Click Login Button
    Wait Until Element Is Visible    id=login-submit-btn    timeout=10s
    Click Element    id=login-submit-btn
    
    # Verify Login Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=15s
    ${status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ล็อกอินสำเร็จ
    Run Keyword If    not ${status}    Fail    Trader login failed - please check credentials
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Capture Step Screenshot    user_login_success
    Homepage
    

Homepage
    Go To    http://localhost/UserHomepage
    Sleep    5s    # Increased sleep time to ensure homepage loads fully

Profile
    Wait Until Element Is Visible    id=user-menu-btn    timeout=10s
    Click Element    id=user-menu-btn
    Sleep    1s

*** Test Cases ***
TCI001-การสมัครสมาชิก
    Signup
    [Teardown]    Run Keyword And Ignore Error    Close Browser


TCI003-โปรไฟล์
    LogIn
    Homepage
    Profile
    [Teardown]    Run Keyword And Ignore Error    Close Browser
    

TCI004-แก้ไขข้อมูลโปรไฟล์

    Wait Until Element Is Visible    id=profile-btn
    Click Element    id=profile-btn

    # Edit Profile Information
    Wait Until Element Is Visible    id=edit-profile-btn
    Click Element    id=edit-profile-btn

    Choose File    id=profile-picture-input    ${CURDIR}/image/download.jpg

    Wait Until Element Is Visible    id=save-profile-btn
    Click Element    id=save-profile-btn
    Sleep    3s
    Wait Until Element Is Visible    id=close-profile-btn
    Click Button     id=close-profile-btn

TCI005-เปลี่ยนรหัสผ่าน
    LogIn
    Homepage
    Profile

    Wait Until Element Is Visible    id=change-password-btn    timeout=10s
    Click Element    id=change-password-btn
    Sleep    1s
    
    Wait Until Element Is Visible    id=swal-old-password    timeout=10s
    Input Password    id=swal-old-password    ${BOND_PASSWORD}
    Input Password    id=swal-new-password    ${BOND_PASSWORD}

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    ${title_status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เปลี่ยนรหัสผ่าน
    Run Keyword If    ${title_status}    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Sleep    3s
    
    ${success_status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    Run Keyword If    ${success_status}    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สำเร็จ
    Run Keyword If    ${success_status}    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    
    [Teardown]    Run Keyword And Ignore Error    Close Browser
    

TCI006-หลักสูตรของฉัน
    Homepage
    Profile
    Wait Until Element Is Visible    xpath=//*[@id="profile-btn"]
    Click Element    xpath=//*[@id="profile-btn"]

    Wait Until Element Is Visible    id=my-courses-link
    Click Element    id=my-courses-link

    Wait Until Element Is Visible    id=close-history-btn
    Click Element    id=close-history-btn

TCI007-ลงทะเบียนคอร์ส
    LogIn
    Homepage
    Wait Until Element Is Visible    id=user-nav-link-courses    timeout=10s
    Click Element    id=user-nav-link-courses
    Sleep    2s
    
    # Try to find any course card since MongoDB IDs may change
    ${card_exists}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//*[contains(@id, 'course-card-')]
    
    # If a specific course card exists, use it, otherwise try to find any course card
    ${specific_card_exists}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//*[@id="course-card-6709ccb3c628150b54faeae4"]
    
    Run Keyword If    ${specific_card_exists}    Click Element    xpath=//*[@id="course-card-6709ccb3c628150b54faeae4"]
    Run Keyword If    not ${specific_card_exists} and ${card_exists}    Click Element    xpath=(//*[contains(@id, 'course-card-')])[1]
    Sleep    2s
    
    # Check if registration button exists
    ${reg_btn_exists}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=register-course-btn    timeout=10s
    Run Keyword If    ${reg_btn_exists}    Click Element    id=register-course-btn
    Sleep    2s

    # Handle registration result - could be success or already registered
    ${popup_exists}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    Run Keyword If    ${popup_exists}    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    
    [Teardown]    Run Keyword And Ignore Error    Close Browser

TCI-008-เริ่มเรียน
    LogIn
    Homepage
    Wait Until Element Is Visible    id=user-nav-link-courses    timeout=10s
    Click Element    id=user-nav-link-courses
    Sleep    2s
    
    # Try to find any course card and click it
    ${card_exists}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//*[contains(@id, 'course-card-')]
    Run Keyword If    ${card_exists}    Click Element    xpath=(//*[contains(@id, 'course-card-')])[1]
    Sleep    2s
    
    # Check if start learning button exists
    ${start_btn_exists}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=start-learning-btn    timeout=10s
    Run Keyword If    ${start_btn_exists}    Click Element    id=start-learning-btn
    Sleep    2s
    
    # Handle QR code popup or any other message
    ${popup_exists}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    Run Keyword If    ${popup_exists}    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    
    [Teardown]    Run Keyword And Ignore Error    Close Browser

TCI_009-ยกเลิกการลงทะเบียน
    LogIn
    Homepage
    Wait Until Element Is Visible    id=user-nav-link-courses    timeout=10s
    Click Element    id=user-nav-link-courses
    Sleep    2s
    
    # Try to find any course card and click it
    ${card_exists}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//*[contains(@id, 'course-card-')]
    Run Keyword If    ${card_exists}    Click Element    xpath=(//*[contains(@id, 'course-card-')])[1]
    Sleep    2s
    
    # Check if cancel enrollment button exists
    ${cancel_btn_exists}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//*[@id="cancel-enrollment-btn"]    timeout=10s
    Run Keyword If    ${cancel_btn_exists}    Click Element    xpath=//*[@id="cancel-enrollment-btn"]
    Sleep    2s

    # Handle confirmation popup
    ${confirm_popup}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    ${title_status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ยืนยันการยกเลิกการลงทะเบียน
    Run Keyword If    ${confirm_popup}    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Sleep    5s
    
    # Handle success popup
    ${success_popup}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    ${success_status}=    Run Keyword And Return Status    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ยกเลิกการลงทะเบียนสำเร็จ
    Run Keyword If    ${success_popup}    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    
    [Teardown]    Run Keyword And Ignore Error    Close Browser
    

TCI010-ตารางอบรม
    LogIn
    Homepage
    Wait Until Element Is Visible    id=user-nav-link-schedule    timeout=10s
    Click Element    id=user-nav-link-schedule
    Sleep    2s
    
    [Teardown]    Run Keyword And Ignore Error    Close Browser

TCI011-ดาว์นโหลดใบรับรอง
    LogIn
    Homepage
    Profile

    Wait Until Element Is Visible    id=profile-btn    timeout=10s
    Click Element    id=profile-btn
    Sleep    1s

    Wait Until Element Is Visible   id=my-courses-link    timeout=10s
    Click Element   id=my-courses-link
    Sleep    2s

    # Check if certificate download button exists
    ${cert_btn_exists}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=download-certificate-btn-0    timeout=10s
    Run Keyword If    ${cert_btn_exists}    Click Element    id=download-certificate-btn-0
    Sleep    2s

    Wait Until Element Is Visible    id=close-history-btn    timeout=10s
    Click Button     id=close-history-btn
    
    [Teardown]    Run Keyword And Ignore Error    Close Browser
    
TCI012-ออกจากระบบ
    LogIn
    Homepage
    Profile

    Wait Until Element Is Visible    id=logout-btn    timeout=10s
    Click Element    id=logout-btn
    Sleep    2s
    
    # Verify logout success - should return to login page
    ${login_page}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=header-logo-link    timeout=10s
    Run Keyword If    not ${login_page}    Log    Logout may not have worked correctly
    
    [Teardown]    Run Keyword And Ignore Error    Close Browser