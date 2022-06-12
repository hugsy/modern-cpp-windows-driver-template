message(STATUS "Configuring MinifilterDrivery")

wdk_add_driver(MinifilterDriver
    KMDF
        1.15

    MinifilterDriver.cpp
)

target_compile_definitions(MinifilterDriver PRIVATE DEBUG=1)
target_link_options(MinifilterDriver PUBLIC /integritycheck)
target_link_libraries(MinifilterDriver DriverLib WDK::FLTMGR WDK::KSECDD)
