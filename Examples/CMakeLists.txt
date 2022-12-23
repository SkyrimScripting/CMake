cmake_minimum_required(VERSION 3.21)

project(CMakeSKSEDemo VERSION 0.0.1 LANGUAGES CXX)

find_package(SkyrimScripting.CMake CONFIG REQUIRED)

set(CMAKE_FIND_DEBUG_MODE true)
find_file(SOME_PATH7 "SkyrimScripting.CMake/Skyrim_SKSE_PCH.h")
message("FOUND IT: ${SOME_PATH7}")

# add_skse_plugin(
#     ${PROJECT_NAME}
#     DATA_FOLDER "C:/GOG/Games/Skyrim Anniversary Edition/Data"
#     SOURCES plugin.cpp
# )
