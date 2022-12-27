include("${CMAKE_SOURCE_DIR}/cmake/SkyrimScripting.cmake")

set(SKYRIMSCRIPTING_PCH_PATH "${CMAKE_SOURCE_DIR}/SkyrimScripting.CMake/Skyrim_SKSE_PCH.h")

add_subdirectory(JustOneSKSEPlugin)
