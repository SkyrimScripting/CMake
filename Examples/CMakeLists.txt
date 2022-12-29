set(SKYRIMSCRIPTING_DEBUG ON)
set(SKYRIMSCRIPTING_DEBUG_LEVEL STATUS)
# set(SKYRIMSCRIPTING_PCH_PATH "${CMAKE_SOURCE_DIR}/SkyrimScripting.CMake/Skyrim_SKSE_PCH.h")

include("${CMAKE_SOURCE_DIR}/cmake/SkyrimScripting.cmake")

# add_subdirectory(JustOneSKSEPlugin)
add_subdirectory(SkyrimModWithJustFiles)
add_subdirectory(CopyFilesToSkyrimModFolder)
