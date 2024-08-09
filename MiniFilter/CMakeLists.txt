message(STATUS "Configuring MinifilterDriver")

wdk_add_driver(MinifilterDriver
    KMDF
    1.15

    MinifilterDriver.cpp
)

target_compile_definitions(MinifilterDriver PRIVATE DEBUG=1)
target_link_options(MinifilterDriver PUBLIC /integritycheck)
target_link_libraries(MinifilterDriver DriverLib WDK::FLTMGR WDK::KSECDD)

set(RC_FILE ${CMAKE_CURRENT_SOURCE_DIR}/MinifilterDriver.rc)
set(INF_FILE ${CMAKE_CURRENT_SOURCE_DIR}/MinifilterDriver.inf)
set(CERT_CN "BlahCat Corp")
set(CERT_STORE "PrivateCertStore")
set(CERT_FILE "$<TARGET_FILE_DIR:MinifilterDriver>/BlahCatTest.cer")

add_custom_command(
    TARGET MinifilterDriver POST_BUILD
    COMMAND
        powershell.exe -ExecutionPolicy Bypass -File ${CMAKE_SOURCE_DIR}/Scripts/SignDriver.ps1
        ARGS "$<TARGET_FILE:MinifilterDriver>" "${CERT_STORE}" "${CERT_CN}"
    COMMAND
        ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/MinifilterDriver.inf
        "$<TARGET_FILE_DIR:MinifilterDriver>/MinifilterDriver.inf"
    COMMENT
        "Signing driver with self-signed certificate"
)

install(TARGETS MinifilterDriver DESTINATION Drivers)
install(FILES $<TARGET_PDB_FILE:MinifilterDriver> ${RC_FILE} ${INF_FILE} DESTINATION Drivers/Debug)
