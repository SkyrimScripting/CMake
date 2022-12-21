cmake_minimum_required(VERSION 3.21)

project(SkyrimScripting.CMake)

install(DIRECTORY include DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/..")

configure_file(cmake/Config.cmake.in ${PROJECT_NAME}Config.cmake @ONLY)

install(
    FILES
    cmake/SkyrimScripting.cmake
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake"
)
