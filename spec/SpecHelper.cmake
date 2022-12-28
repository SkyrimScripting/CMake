set(SpecFolder "${CMAKE_CURRENT_LIST_DIR}")

include("${CMAKE_CURRENT_LIST_DIR}/../cmake/SkyrimScripting.cmake")

macro(build_example_target target)
    list(APPEND __build_target_args ${ARGN})
    if(${ARGC} EQUAL 3)
        list(POP_FRONT __build_target_args __build_target_output_varname)
        list(POP_FRONT __build_target_args __build_target_result_varname)
    elseif(${ARGC} EQUAL 2)
        list(POP_FRONT __build_target_args __build_target_output_varname)
        set(__build_target_result_varname __build_target_result)
    else()
        set(__build_target_output_varname __build_target_output)
        set(__build_target_result_varname __build_target_result)
    endif()
    unset(__build_target_args)
    try_compile(
        ${__build_target_result_varname}
        PROJECT "SkyrimScripting.CMake"
        SOURCE_DIR "${SpecFolder}/.."
        TARGET "${target}"
        CMAKE_FLAGS -DDISABLE_CSPEC=ON
        OUTPUT_VARIABLE ${__build_target_output_varname}
    )
    unset(__build_target_output_varname)
    unset(__build_target_result_varname)
endmacro()

function(build_spec_target)
    set(options)
    set(oneValueArgs PROJECT TARGET PATH RESULT OUTPUT)
    set(multiValueArgs CMAKE_FLAGS)
    cmake_parse_arguments(PARSE_ARGV 0 build_spec_target_ARG "${options}" "${oneValueArgs}" "${multiValueArgs}")
    set(arg_prefix build_spec_target_ARG_)
    if(NOT DEFINED ${arg_prefix}PROJECT)
        set(${arg_prefix}PROJECT "Test Project") # default from create_project()
    endif()
    if(DEFINED ${arg_prefix}CMAKE_FLAGS)
        list(PREPEND ${arg_prefix}CMAKE_FLAGS "CMAKE_FLAGS")
    else()
        set(${arg_prefix}CMAKE_FLAGS "")
    endif()
    try_compile(
        try_compile_result
        PROJECT "${${arg_prefix}PROJECT}"
        SOURCE_DIR "${${arg_prefix}PATH}"
        TARGET "${${arg_prefix}TARGET}"
        ${${arg_prefix}CMAKE_FLAGS}
        OUTPUT_VARIABLE try_compile_output
    )
    if(DEFINED ${arg_prefix}RESULT)
        set(${${arg_prefix}RESULT} "${try_compile_result}" PARENT_SCOPE)
    endif()
    if(DEFINED ${arg_prefix}OUTPUT)
        set(${${arg_prefix}OUTPUT} "${try_compile_output}" PARENT_SCOPE)
    endif()
endfunction()

function(create_project out_folder_path content)
    string(PREPEND content "include(\"${SpecFolder}/../cmake/SkyrimScripting.cmake\")\n")
    if(NOT content MATCHES "project\\(")
        string(PREPEND content "project(\"Test Project\" VERSION 1.2.3)\n")
    endif()
    if(NOT content MATCHES "cmake_minimum_required\\(")
        string(PREPEND content "cmake_minimum_required(VERSION 3.21)\n")
    endif()
    string(SHA1 file_id "${CSPEC_FILE}")
    set(project_folder "$ENV{TEMP}/SkyrimScripting.CMake/Specs/${file_id}/${CSPEC_TEST_FUNCTION}")
    if(NOT IS_DIRECTORY "${project_folder}")
        file(MAKE_DIRECTORY "${project_folder}")
    endif()
    string(CONFIGURE "${content}" cmakelists_txt_content @ONLY)
    file(WRITE "${project_folder}/CMakeLists.txt" "${cmakelists_txt_content}")
    set(${out_folder_path} "${project_folder}" PARENT_SCOPE)
endfunction()
