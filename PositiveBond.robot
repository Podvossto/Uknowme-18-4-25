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
    Wait Until Element Is Visible    id=role-btn-trader
    Click Element    id=role-btn-trader

    Wait Until Element Is Visible    id=signup-btn
    Click Element    id=signup-btn
    Input Text    id=name-input    ${BOND_NAME}
    Input Text    id=company-input    ${BOND_COMPANY}
    Input Text    id=citizen-id-input    ${BOND_CITIZEN_ID}
    Input Text    id=email-input    ${BOND_EMAIL}
    Input Text    id=phone-input    ${BOND_PHONE}
    Input Password    id=password-input    ${BOND_PASSWORD}
    Wait Until Element Is Visible    id=submit-signup-btn
    Click Element    id=submit-signup-btn
    
    # Handle both success and duplicate registration scenarios
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
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
    
    # Select User Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]    timeout=10s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]
    Capture Step Screenshot    user_role_selected
    
    # Input Login Credentials
    Wait Until Element Is Visible    id=email-input
    Input Text    id=email-input    ${BOND_EMAIL}
    Input Password    id=password-input    ${BOND_PASSWORD}
    Capture Step Screenshot    user_credentials_entered
    
    # Click Login Button
    Click Element    id=login-submit-btn
    
    # Verify Login Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]    timeout=10s
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ล็อกอินสำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Capture Step Screenshot    user_login_success
    Homepage
    

Homepage
    Go To    http://localhost/UserHomepage
    Sleep    5s 

Profile
    Wait Until Element Is Visible    id=user-menu-btn
    Click Element    id=user-menu-btn

*** Test Cases ***
TCI001-การสมัครสมาชิก
    Signup


TCI003-โปรไฟล์
    LogIn
    Homepage
    Profile
    

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

    Profile

    Wait Until Element Is Visible    id=change-password-btn
    Click Element    id=change-password-btn
    Input Password    id=swal-old-password    12345
    Input Password    id=swal-new-password    12345

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เปลี่ยนรหัสผ่าน
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Sleep    3s
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    

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
    Wait Until Element Is Visible    id=user-nav-link-courses
    Click Element    id=user-nav-link-courses
    Wait Until Element Is Visible    xpath=//*[@id="course-card-6709ccb3c628150b54faeae4"]
    Click Element    xpath=//*[@id="course-card-6709ccb3c628150b54faeae4"]
    Wait Until Element Is Visible    id=register-course-btn
    Click Element    id=register-course-btn

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ลงทะเบียนสำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]

TCI-008-เริ่มเรียน
    
    Wait Until Element Is Visible    id=start-learning-btn
    Click Element    id=start-learning-btn
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    Scan QR Code to Start Learning
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]

TCI_009-ยกเลิกการลงทะเบียน
    
    Wait Until Element Is Visible    xpath=//*[@id="cancel-enrollment-btn"]
    Click Element    xpath=//*[@id="cancel-enrollment-btn"]

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ยืนยันการยกเลิกการลงทะเบียน
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Sleep    5s
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ยกเลิกการลงทะเบียนสำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    

TCI010-ตารางอบรม

    Click Element    id=user-nav-link-schedule

TCI011-ดาว์นโหลดใบรับรอง

    Profile

    Wait Until Element Is Visible    id=profile-btn
    Click Element    id=profile-btn

    Wait Until Element Is Visible   id=my-courses-link
    Click Element   id=my-courses-link

    Wait Until Element Is Visible    id=download-certificate-btn-0
    Click Element    id=download-certificate-btn-0

    Wait Until Element Is Visible    id=close-history-btn
    Click Button     id=close-history-btn
    
TCI012-ออกจากระบบ
    Homepage
    Profile

    Wait Until Element Is Visible    id=logout-btn
    Click Element    id=logout-btn

    