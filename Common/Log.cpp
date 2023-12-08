#include "Log.hpp"


namespace Log
{

void
Log(_In_ const wchar_t* FormatString, ...)
{
    va_list args;
    wchar_t buffer[1024] {};
    va_start(args, FormatString);
    ::vswprintf_s(buffer, sizeof(buffer) / sizeof(wchar_t), FormatString, args);
    va_end(args);
    Log("%S", buffer);
}

void
Log(_In_ const char* FormatString, ...)
{
    va_list args;
    va_start(args, FormatString);
    char buffer[1024] {};
    ::vDbgPrintEx(DPFLTR_IHVDRIVER_ID, DPFLTR_INFO_LEVEL, FormatString, args);
    va_end(args);
}

} // namespace Log
