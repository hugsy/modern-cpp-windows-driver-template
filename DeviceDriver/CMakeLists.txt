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
