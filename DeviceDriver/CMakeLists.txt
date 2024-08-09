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
    COMMAND
        powershell.exe -ExecutionPolicy Bypass -File ${CMAKE_SOURCE_DIR}/Scripts/SignDriver.ps1
        ARGS "$<TARGET_FILE:DeviceDriver>" "${CERT_STORE}" "${CERT_CN}"
    COMMENT
        "Signing driver with self-signed certificate"
)

install(TARGETS DeviceDriver DESTINATION Drivers)
install(FILES $<TARGET_PDB_FILE:DeviceDriver> DESTINATION Drivers/Debug)
