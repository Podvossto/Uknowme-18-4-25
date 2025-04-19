*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Suite Setup    Setup Admin Account
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}    chrome
${URL}    http://localhost/
${DELAY}    0
${SCREENSHOT_DIR}    screenshots
${ADMIN_EMAIL}    admin@uknowme.com
${ADMIN_PASSWORD}    Admin1234
${ADMIN_NAME}    Admin Tester

*** Keywords ***
Capture Step Screenshot
    [Arguments]    ${step_name}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${step_name}_${timestamp}.png

Setup Admin Account
    # This keyword will register an admin account if it doesn't exist
    # and then log in with that account
    Register Admin
    Login Admin

Register Admin
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Capture Step Screenshot    admin_registration_start
    
    # Navigate to registration page if needed
    Wait Until Element Is Visible    id=header-logo-link
    Click Element    id=header-logo-link
    
    # Select Admin Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]    timeout=10s
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ดูแลระบบ']]
    
    # Click on Register/Signup if available
    Wait Until Element Is Visible    id=signup-btn
    Click Element    id=signup-btn
    
    # Fill registration form
    Input Text    id=name-input    ${ADMIN_NAME}
    Input Text    id=email-input    ${ADMIN_EMAIL}
    Input Password    id=password-input    ${ADMIN_PASSWORD}
    Input Text    id=phone-input    0899999999
    
    # Submit registration
    Wait Until Element Is Visible    id=submit-signup-btn
    Click Element    id=submit-signup-btn
    
    # Wait for confirmation and close it
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    
    # Return to login page
    Wait Until Element Is Visible    id=header-logo-link
    Click Element    id=header-logo-link
    Close Browser

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
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Capture Step Screenshot    admin_login_success

DashboardAdmin
    Go To    http://localhost/AdminDashboard
    Sleep    3s

Profile
    Wait Until Element Is Visible    id=user-menu-btn
    Click Element    id=user-menu-btn

    Wait Until Element Is Visible    id=profile-btn
    Click Element    id=profile-btn 

*** Test Cases ***
TCI002-ดูหน้าแดชบอร์ด
    DashboardAdmin
    

TCI003-ดูข้อมูลส่วนตัวบัญชีผู้ดูแล
    Profile
    

TCI004-แก้ไขข้อมูลส่วนตัวของผู้ดูแลระบบ
    
    Wait Until Element Is Visible    id=edit-btn
    Click Element    id=edit-btn
    Input Text    xpath=//*[@id="profile-fields"]/div[1]/input    อทิตยา ชัยศิริวัฒนาศัย
    Input Text    xpath=//*[@id="profile-fields"]/div[3]/input    0838911917

    Wait Until Element Is Visible    id=save-btn
    Click Element    id=save-btn
    

TCI005-ดูจำนวนผู้ค้าที่ได้รับสถานะ
    DashboardAdmin

    Wait Until Element Is Visible    id=view-all-btn-จำนวนผู้ค้าที่ได้รับสถานะ
    Click Element    id=view-all-btn-จำนวนผู้ค้าที่ได้รับสถานะ

    Wait Until Element Is Visible    id=active-filter
    Click Element    id=active-filter
    

TCI006-ดูจำนวนผู้ค้าที่ยังไม่ได้รับสถานะ
    Wait Until Element Is Visible    id=inactive-filter
    Click Element    id=inactive-filter
    

TCI007-ดูจำนวนผู้ค้าที่หมดอายุ
    Wait Until Element Is Visible    id=deactive-filter
    Click Element    id=deactive-filter
    

TCI008-ค้นหารายชื่อผู้ค้าตราสารหนี้ที่หน้าแดชบอร์ด
    DashboardAdmin
    Wait Until Element Is Visible    id=search-input
    Input Text    id=search-input    Athitiya Chaisiriwatthanachai
    

TCI009-ดูรายละเอียดข้อมูลของผู้ค้าตราสารหนี้

    Wait Until Element Is Visible    id=view-details-btn-670a2fe245a3113da061f5e3
    Click Element    id=view-details-btn-670a2fe245a3113da061f5e3
    Wait Until Element Is Visible    id=close-profile-btn
    Click Element    id=close-profile-btn
    

TCI010-ดูหน้าผู้ค้าตราสารหนี้

    Wait Until Element Is Visible    id=traders-link
    Click Element    id=traders-link
    

TCI011-แก้ไขสถานะของผู้ค้าตราสารหนี้

    #Active
    Wait Until Element Is Visible    id=edit-user-670a2da745a3113da061b371
    Click Element    id=edit-user-670a2da745a3113da061b371
    
    #Edit
    Wait Until Element Is Visible    id=edit-btn
    Click Element    id=edit-btn
    #Action
    Wait Until Element Is Visible    id=bond-status-select
    Click Element    id=bond-status-select
    Click Element    xpath=//*[@id="bond-status-select"]/option[2]

    Wait Until Element Is Visible    id=save-btn
    Click Element    id=save-btn
    

TCI012-ดูหน้าจัดการคอร์ส
    DashboardAdmin
    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link

TCI013-เพิ่มคอร์ส

    Wait Until Element Is Visible    id=add-course-btn
    Click Element    id=add-course-btn

    Input Text    id=title-upload-popup    Financi
    Input Text    id=description-upload-popup    Financia
    Input Text    id=details-upload-popup    test5
    Input Text    id=trainingLocation-upload-popup    test5
    Input Text    id=duration_hours-upload-popup    1
    Input Text    id=max_seats-upload-popup    20
    Input Text    id=start_date-upload-popup    10102025
    Choose File    id=thumbnail-upload-popup    ${CURDIR}/image/download.jpg
    Choose File    id=video-upload-popup        ${CURDIR}/image/12607801_1920_1080_30fps.mp4
    Choose File    id=qr_code-upload-popup      ${CURDIR}/image/download.jpg

    Wait Until Element Is Visible    id=upload-btn-upload-popup
    Click Element    id=upload-btn-upload-popup

    Wait Until Element Is Visible    id=cancel-btn-upload-popup
    Click Element    id=cancel-btn-upload-popup

TCI014-ดูตัวกรองการจัดการคอร์ส

    Wait Until Element Is Visible    id=filter-toggle
    Click Element    id=filter-toggle

    Select From List By Index    id=duration-select    2
    Select From List By Index    id=start-date-select    2

    

TCI015-ดูคอร์สที่เพิ่มมาล่าสุด
    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link

TCI016-ดูคอร์สที่ยอดนิยม
    Wait Until Element Is Visible    id=tab-popular
    Click Element    id=tab-popular
    

TCI017-ดูคอร์สที่กำลังจะเริ่มต้นการสอน

    Wait Until Element Is Visible    id=tab-upcoming
    Click Element    id=tab-upcoming
    

TCI018-ลบคอร์ส

    Wait Until Element Is Visible    id=tab-latest
    Click Element    id=tab-latest

    Wait Until Element Is Visible    id=delete-btn-6709c5e9c628150b54faeabd
    Click Element    id=delete-btn-6709c5e9c628150b54faeabd
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ยืนยันการลบคอร์ส
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    

TCI019-ค้นหาคอร์ส

    Wait Until Element Is Visible    id=search-input
    Input Text    id=search-input    Cost Accounting
    

TCI020-ดูหน้าตารางอบรม

    Wait Until Element Is Visible    id=schedule-link
    Click Element    id=schedule-link
    

TCI021-ค้นหาหลักเพื่อดูตารางอบรม

    Wait Until Element Is Visible    id=course-search
    Input Text    id=course-search    เป็นหนี้แล้วจัดการยังไง

    

TCI022-ดูรายชื่อผู้สมัครของคอร์ส
    Wait Until Element Is Visible    id=schedule-link
    Click Element    id=schedule-link
    Wait Until Element Is Visible    id=view-participants-6709ccb3c628150b54faeae4
    Click Element    id=view-participants-6709ccb3c628150b54faeae4

    

TCI023-เช็คชื่อตรวจสอบการเข้าอบรม

    Wait Until Element Is Visible    xpath=//*[@id="check-participant-670a2ecc45a3113da061f5c7"]/i
    Click Element    xpath=//*[@id="check-participant-670a2ecc45a3113da061f5c7"]/i
    
    Wait Until Element Is Visible    id=save-participants
    Click Element    id=save-participants
 
    Wait Until Element Is Visible    id=close-check-name
    Click Element    id=close-check-name

TCI024-ออกจากระบบ

    Wait Until Element Is Visible    id=user-menu-btn
    Click Element    id=user-menu-btn

    Wait Until Element Is Visible    id=logout-btn
    Click Element    id=logout-btn

    