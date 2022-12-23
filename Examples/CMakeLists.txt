cmake_minimum_required(VERSION 3.21)

project(CMakeSKSEDemo VERSION 0.0.1 LANGUAGES CXX)

find_package(SkyrimScripting.CMake CONFIG REQUIRED)

add_skse_plugin(
    ${PROJECT_NAME}
    DATA_FOLDER "C:/GOG/Games/Skyrim Anniversary Edition/Foo"
    SOURCES plugin.cpp
)
