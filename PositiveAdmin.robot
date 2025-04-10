*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime

*** Variables ***
${BROWSER}    chrome
${URL}    http://localhost:5173/
${DELAY}    0
${SCREENSHOT_DIR}    screenshots

*** Keywords ***
Capture Step Screenshot
    [Arguments]    ${step_name}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${step_name}_${timestamp}.png

Login Admin
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
    Input Text    id=email-input    AtitayaAdmin@gmail.com
    Input Password    id=password-input    1234
    Capture Step Screenshot    admin_credentials_entered
    
    # Click Login Button
    Click Element    id=login-submit-btn
    
    # Verify Login Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เข้าสู่ระบบสำเร็จ!
    Capture Step Screenshot    admin_login_success

DashboardAdmin
    Go To    http://localhost:5173/AdminDashboard
    Sleep    3s

Profile
    Wait Until Element Is Visible    id=user-menu-btn
    Click Element    id=user-menu-btn

    Wait Until Element Is Visible    id=profile-btn
    Click Element    id=profile-btn 

*** Test Cases ***
TCI001-Login Admin
    Login Admin
    [Teardown]    Close Browser

TCI002-Dashboard Admin
    Login Admin
    DashboardAdmin
    [Teardown]    Close Browser

TCI003-Profile Admin
    Login Admin
    DashboardAdmin
    Profile
    [Teardown]    Close Browser

TCI004-Edir-Profile
    Login Admin
    DashboardAdmin
    Profile

    Wait Until Element Is Visible    id=edit-btn
    Click Element    id=edit-btn
    Input Text    xpath=//*[@id="profile-fields"]/div[1]/input    อทิตยา ชัยศิริวัฒนาศัย
    Input Text    xpath=//*[@id="profile-fields"]/div[3]/input    0838911917

    Wait Until Element Is Visible    id=save-btn
    Click Element    id=save-btn
    [Teardown]    Close Browser

TCI005-Status-Active
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=view-all-btn-จำนวนผู้ค้าที่ได้รับสถานะ
    Click Element    id=view-all-btn-จำนวนผู้ค้าที่ได้รับสถานะ

    Wait Until Element Is Visible    id=active-filter
    Click Element    id=active-filter
    [Teardown]    Close Browser

TCI006-Status-InActive
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=view-all-btn-จำนวนผู้ค้าที่ยังไม่ได้รับสถานะ
    Click Element    id=view-all-btn-จำนวนผู้ค้าที่ยังไม่ได้รับสถานะ

    Wait Until Element Is Visible    id=inactive-filter
    Click Element    id=inactive-filter
    [Teardown]    Close Browser

TCI007-Status-All
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=view-all-btn-จำนวนผู้ค้าที่หมดอายุ
    Click Element    id=view-all-btn-จำนวนผู้ค้าที่หมดอายุ
    [Teardown]    Close Browser

TCI008-Search-User
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=search-input
    Input Text    id=search-input    Athitiya Chaisiriwatthanachai
    Sleep    3s
    [Teardown]    Close Browser

TCI009-Detall-User
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=view-details-btn-670a2da745a3113da061b371
    Click Element    id=view-details-btn-670a2da745a3113da061b371
    Sleep    3s
    [Teardown]    Close Browser

TCI010-Show-User
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=traders-link
    Click Element    id=traders-link
    [Teardown]    Close Browser

TCI011-Edit-User
    Login Admin
    DashboardAdmin

    #Go bond
    Wait Until Element Is Visible    id=traders-link
    Click Element    id=traders-link

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
    Sleep    5s
    [Teardown]    Close Browser

TCI012-Course
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link

TCI013-Add-Course
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link

    Wait Until Element Is Visible    id=add-course-btn
    Click Element    id=add-course-btn

    Input Text    id=title-upload-popup    Financials
    Input Text    id=description-upload-popup    Financials
    Input Text    id=details-upload-popup    test
    Input Text    id=trainingLocation-upload-popup    test
    Input Text    id=duration_hours-upload-popup    1
    Input Text    id=max_seats-upload-popup    20
    Input Text    id=start_date-upload-popup    10102025
    Choose File    id=thumbnail-upload-popup    ${CURDIR}/image/download.jpg
    Choose File    id=video-upload-popup        ${CURDIR}/image/12607801_1920_1080_30fps.mp4
    Choose File    id=qr_code-upload-popup      ${CURDIR}/image/download.jpg

    Wait Until Element Is Visible    id=upload-btn-upload-popup
    Click Element    id=upload-btn-upload-popup

TCI014-Filter-Course
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link

    Wait Until Element Is Visible    id=filter-toggle
    Click Element    id=filter-toggle

    Wait Until Element Is Visible    id=duration-select
    Click Element    xpath=//*[@id="duration-select"]/option[2]

    Wait Until Element Is Visible    id=start-date-select
    Click Element    xpath=//*[@id="start-date-select"]/option[2]
    Sleep    3s
    [Teardown]    Close Browser

TCI015-Latest-Course
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link

    [Teardown]    Close Browser

TCI016-Popular-Course
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link
    Wait Until Element Is Visible    id=tab-popular
    Click Element    id=tab-popular
    [Teardown]    Close Browser

TCI017-Upcoming-Course
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link
    Wait Until Element Is Visible    id=tab-upcoming
    Click Element    id=tab-upcoming
    [Teardown]    Close Browser

TCI018-Delete-Course
    Login Admin
    DashboardAdmin
    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link

    Wait Until Element Is Visible    id=delete-btn-6709c39ac628150b54faeaa3
    Click Element    id=delete-btn-6709c39ac628150b54faeaa3
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ยืนยันการลบคอร์ส
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    [Teardown]    Close Browser

TCI019-Search-Course
    Login Admin
    DashboardAdmin
    Wait Until Element Is Visible    id=courses-link
    Click Element    id=courses-link

    Wait Until Element Is Visible    id=search-input
    Input Text    id=search-input    Financial
    Sleep    3s
    [Teardown]    Close Browser

TCI020-schedule
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=schedule-link
    Click Element    id=schedule-link
    [Teardown]    Close Browser

TCI021-Search-schedule
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=schedule-link
    Click Element    id=schedule-link
    Wait Until Element Is Visible    id=course-search
    Input Text    id=course-search    Financial
    Sleep    3s
    [Teardown]    Close Browser

TCI022-User-schedule
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=schedule-link
    Click Element    id=schedule-link

    Wait Until Element Is Visible    id=view-participants-6709c570c628150b54faeab8
    Click Element    id=view-participants-6709c570c628150b54faeab8
    Sleep    3s
    [Teardown]    Close Browser

TCI023-Check-User-schedule
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=schedule-link
    Click Element    id=schedule-link

    Wait Until Element Is Visible    id=view-participants-6709c570c628150b54faeab8
    Click Element    id=view-participants-6709c570c628150b54faeab8

    Wait Until Element Is Visible    xpath=//*[@id="check-participant-670a2f1445a3113da061f5cd"]/i
    Click Element    xpath=//*[@id="check-participant-670a2f1445a3113da061f5cd"]/i
    
    Wait Until Element Is Visible    id=save-participants
    Click Element    id=save-participants
    Sleep    3s
    [Teardown]    Close Browser

TCI024-Logout
    Login Admin
    DashboardAdmin

    Wait Until Element Is Visible    id=user-menu-btn
    Click Element    id=user-menu-btn

    Wait Until Element Is Visible    id=logout-btn
    Click Element    id=logout-btn

    [Teardown]    Close Browser