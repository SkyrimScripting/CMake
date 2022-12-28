set(CSPEC_OUTPUT_TYPE BOTH)
set(CSPEC_OUTPUT_LOG "${CMAKE_CURRENT_SOURCE_DIR}/Specs.log")
set(CSPEC_VERBOSE true)

include("$ENV{MROWRPURR_PROJECTS}/CSpec/cmake/CSpec.cmake")

add_cspec_suite(
    skyrim_mod.spec.cmake
    add_skse_library.spec.cmake
)
