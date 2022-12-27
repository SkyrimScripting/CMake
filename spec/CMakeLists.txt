set(CSPEC_OUTPUT_TYPE BOTH)
set(CSPEC_OUTPUT_LOG "${CMAKE_CURRENT_SOURCE_DIR}/Specs.log")
set(CSPEC_VERBOSE true)
# set(CSPEC_EXTRA_VERBOSE true)
include("$ENV{MROWRPURR_PROJECTS}/CSpec/cmake/CSpec.cmake")

add_cspec_suite(FILES skyrim_mod.spec.cmake)
