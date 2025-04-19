*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Suite Setup    Setup Suite
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}    chrome
${URL}    http://localhost/
${DELAY}    0
${SCREENSHOT_DIR}    screenshots
${USER_NAME}    Phattarapong Uknowme
${USER_COMPANY}    Uknowme Asset
${USER_CITIZEN_ID}    1429900959467
${USER_EMAIL}    phattarapong34467@gmail.com
${USER_PHONE}    0966566467
${USER_PASSWORD}    1429900959467

*** Keywords ***
Setup Suite
    Create Directory    ${SCREENSHOT_DIR}
    Signup

Capture Step Screenshot
    [Arguments]    ${step_name}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${step_name}_${timestamp}.png

Signup
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Wait Until Element Is Visible    id=role-btn-trader
    Click Element    id=role-btn-trader

    Wait Until Element Is Visible    id=signup-btn
    Click Element    id=signup-btn
    Input Text    id=name-input    ${USER_NAME}
    Input Text    id=company-input    ${USER_COMPANY}
    Input Text    id=citizen-id-input    ${USER_CITIZEN_ID}
    Input Text    id=email-input    ${USER_EMAIL}
    Input Text    id=phone-input    ${USER_PHONE}
    Wait Until Element Is Visible    id=submit-signup-btn
    Click Element    id=submit-signup-btn
    
    # Confirm Registration Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สมัครสมาชิกสำเร็จ!
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    [Teardown]    Close Browser

LogIn
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Capture Step Screenshot    user_login_start
    
    # Select User Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]
    Capture Step Screenshot    user_role_selected
    
    # Input Login Credentials
    Wait Until Element Is Visible    id=email-input
    Input Text    id=email-input    ${USER_EMAIL}
    Input Password    id=password-input    ${USER_PASSWORD}
    Capture Step Screenshot    user_credentials_entered
    
    # Click Login Button
    Click Element    id=login-submit-btn
    
    # Verify Login Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เข้าสู่ระบบสำเร็จ!
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

    Wait Until Element Is Visible    xpath=//*[@id="user-menu-btn"]
    Click Element    xpath=//*[@id="user-menu-btn"]

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
    Wait Until Element Is Visible    xpath=//*[@id="course-card-6709c473c628150b54faeaad"]
    Click Element    xpath=//*[@id="course-card-6709c473c628150b54faeaad"]
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

    