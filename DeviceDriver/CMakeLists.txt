message(STATUS "Configuring DeviceDriver")

wdk_add_driver(
    DeviceDriver
    KMDF
    1.15

    DeviceDriver.cpp
)

target_compile_definitions(DeviceDriver PRIVATE DEBUG=1)
target_link_options(DeviceDriver PUBLIC /integritycheck)
target_link_libraries(DeviceDriver DriverLib)

set(CERT_CN "BlahCat Corp")
set(CERT_STORE "PrivateCertStore")
set(CERT_FILE "$<TARGET_FILE_DIR:DeviceDriver>/BlahCatTest.cer")

add_custom_command(
    TARGET DeviceDriver POST_BUILD
    # COMMAND
    # powershell -ep bypass "Get-ChildItem -Recurse Cert:\\CurrentUser | Where-Object { $_.Subject -match '${CERT_CN}' } | Remove-Item"
    COMMAND
    makecert.exe -r -pe -ss ${CERT_STORE} -n CN="${CERT_CN}" -eku 1.3.6.1.5.5.7.3.3 "${CERT_FILE}"
    COMMAND
    signtool.exe sign /v /a /fd SHA256 /s ${CERT_STORE} /n "${CERT_CN}" "$<TARGET_FILE:DeviceDriver>"
    COMMAND
    certmgr.exe -del -c -n "${CERT_CN}" -s -r currentUser ${CERT_STORE}
    COMMENT
    "Signing driver with self-signed certificate"
)

install(TARGETS DeviceDriver DESTINATION Drivers)
install(FILES $<TARGET_PDB_FILE:DeviceDriver> DESTINATION Drivers/Debug)
