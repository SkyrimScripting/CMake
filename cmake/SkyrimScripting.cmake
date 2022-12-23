# Debug output
# Displayed when `set(SKYRIMSCRIPTING_DEBUG true)`
function(__skyrimScriptingDebug text)
    if(SKYRIMSCRIPTING_DEBUG)
        message(STATUS "${text}")
    endif()
endfunction()

# Provide a folder to auto-deploy your mod to after build
#
# ```
# target_skyrim_mods_folder(mytarget MODS_FOLDER "C:/path/to/mods")
# ```
#
# Defaults to the `CMAKE_SKYRIM_MODS_FOLDER` environment variable, if set.
function(target_skyrim_mods_folder TARGET)
    __skyrimScriptingDebug("target_skyrim_mods_folder(${TARGET} ${ARGV})")

    set(options NO_DEFAULT NO_SCRIPTS)
    set(oneValueArgs MODS_FOLDER SCRIPTS_FOLDER)
    set(multiValueArgs)
    cmake_parse_arguments(PARSE_ARGV 1 modsFolderArg "${options}" "${oneValueArgs}" "${multiValueArgs}")

    if(NOT TARGET "${TARGET}")
        message(FATAL_ERROR "Invalid target_skyrim_mods_folder invocation. Target is not valid target: '${TARGET}'")
    endif()

    if(DEFINED modsFolderArg_MODS_FOLDER)
        if(IS_DIRECTORY "${modsFolderArg_MODS_FOLDER}")
            set(mods_folder "${modsFolderArg_MODS_FOLDER}")
        else()
            message(FATAL_ERROR "Invalid target_skyrim_mods_folder MODS_FOLDER provided (directory does not exist) '${modsFolderArg_MODS_FOLDER}'")
        endif()
    elseif(NOT modsFolderArg_NO_DEFAULT)
        if(DEFINED ENV{CMAKE_SKYRIM_MODS_FOLDER})
            if(IS_DIRECTORY "$ENV{CMAKE_SKYRIM_MODS_FOLDER}")
                set(mods_folder "$ENV{CMAKE_SKYRIM_MODS_FOLDER}")
            else()
                message(FATAL_ERROR "Invalid target_skyrim_mods_folder invocation. CMAKE_SKYRIM_MODS_FOLDER environment variable (directory does not exist) '$ENV{CMAKE_SKYRIM_MODS_FOLDER}'")
            endif()
        else()
            message(FATAL_ERROR "Invalid target_skyrim_mods_folder invocation. No MODS_FOLDER provided and no CMAKE_SKYRIM_MODS_FOLDER environment variable defined.")
        endif()
    endif()

    set(mod_folder "${mods_folder}/${TARGET}")
    message("Skyrim mod folder: ${mod_folder}")

    # TODO - we'll separate this out when we do the next refactor of how all of this works :)
    # if(NOT modsFolderArg_NO_SCRIPTS)
    #     if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Scripts")
    #         set(scripts_folder "${CMAKE_CURRENT_SOURCE_DIR}/Scripts")
    #     endif()
    #     if(DEFINED modsFolderArg_SCRIPTS_FOLDER)
    #         if(IS_DIRECTORY "${modsFolderArg_SCRIPTS_FOLDER}")
    #             set(scripts_folder "${modsFolderArg_SCRIPTS_FOLDER}")
    #         else()
    #             message(FATAL_ERROR "Invalid target_skyrim_mods_folder SCRIPTS_FOLDER provided (directory does not exist) '${modsFolderArg_SCRIPTS_FOLDER}'")
    #         endif()
    #     endif()
    #     __skyrimScriptingDebug("SCRIPTS FOLDER: ${scripts_folder}")
    # endif()

    set(dll_folder "${mod_folder}/SKSE/Plugins")
    add_custom_command(TARGET ${TARGET} POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${dll_folder}"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:${TARGET}>" "${dll_folder}/$<TARGET_FILE_NAME:${TARGET}>"
        VERBATIM
    )

    string(TOLOWER "${CMAKE_BUILD_TYPE}" build_type)
    if(build_type STREQUAL debug)
        add_custom_command(TARGET ${TARGET} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_PDB_FILE:${TARGET}>" "${dll_folder}/$<TARGET_PDB_FILE_NAME:${TARGET}>"
            VERBATIM
        )
    endif()
endfunction()

# Provide a folder to auto-deploy your mod to after build
#
# ```
# target_skyrim_data_folder(mytarget SKYRIM_FOLDER "C:/Program Files (x86)/Steam/steamapps/common/Skyrim Special Edition")
# target_skyrim_data_folder(mytarget DATA_FOLDER "C:/Program Files (x86)/Steam/steamapps/common/Skyrim Special Edition/Data")
# ```
#
# Defaults to using the `CMAKE_SKYRIM_FOLDER` environment variable, if set. Deploys to `$ENV{CMAKE_SKYRIM_FOLDER}/Data`
# function(target_skyrim_data_folder TARGET)
#     __skyrimScriptingDebug("target_skyrim_data_folder(${TARGET} ${ARGV})")

#     set(options NO_DEFAULT)
#     set(oneValueArgs SKYRIM_FOLDER DATA_FOLDER)
#     set(multiValueArgs)
#     cmake_parse_arguments(PARSE_ARGV 1 SKYRIM_SCRIPTING_DATA_FOLDER "${options}" "${oneValueArgs}" "${multiValueArgs}")

#     if(NOT TARGET "${TARGET}")
#         message(FATAL_ERROR "Invalid target_skyrim_data_folder invocation. Target is not valid target: '${TARGET}'")
#     endif()

#     if(DEFINED SKYRIM_SCRIPTING_DATA_FOLDER_SKYRIM_FOLDER)
#         if(IS_DIRECTORY "${SKYRIM_SCRIPTING_DATA_FOLDER_SKYRIM_FOLDER}/Data")
#             set(data_folder "${SKYRIM_SCRIPTING_DATA_FOLDER_SKYRIM_FOLDER}/Data")
#         else()
#             message(FATAL_ERROR "Invalid target_skyrim_data_folder SKYRIM_FOLDER provided (Data directory does not exist) '${SKYRIM_SCRIPTING_DATA_FOLDER_SKYRIM_FOLDER}/Data'")
#         endif()
#     elseif(DEFINED SKYRIM_SCRIPTING_DATA_FOLDER_DATA_FOLDER)
#         if(IS_DIRECTORY "${SKYRIM_SCRIPTING_DATA_FOLDER_DATA_FOLDER}")
#             set(data_folder "${SKYRIM_SCRIPTING_DATA_FOLDER_DATA_FOLDER}")
#         else()
#             message(FATAL_ERROR "Invalid target_skyrim_data_folder DATA_FOLDER provided (directory does not exist) '${SKYRIM_SCRIPTING_DATA_FOLDER_DATA_FOLDER}'")
#         endif()
#     elseif(NOT SKYRIM_SCRIPTING_DATA_FOLDER_NO_DEFAULT)
#         if(DEFINED ENV{CMAKE_SKYRIM_FOLDER})
#             if(IS_DIRECTORY "$ENV{CMAKE_SKYRIM_FOLDER}/Data")
#                 set(data_folder "$ENV{CMAKE_SKYRIM_FOLDER}/Data")
#             else()
#                 message(FATAL_ERROR "Invalid target_skyrim_data_folder invocation. CMAKE_SKYRIM_FOLDER environment variable (Data directory does not exist) '$ENV{CMAKE_SKYRIM_FOLDER}/Data'")
#             endif()
#         else()
#             message(FATAL_ERROR "Invalid target_skyrim_data_folder invocation. No SKYRIM_FOLDER or DATA_FOLDER provided and no CMAKE_SKYRIM_FOLDER environment variable defined.")
#         endif()
#     endif()

#     message("Skyrim Data folder: ${data_folder}")

#     set(dll_folder "${data_folder}/SKSE/Plugins")
#     add_custom_command(TARGET ${TARGET} POST_BUILD
#         COMMAND "${CMAKE_COMMAND}" -E make_directory "${dll_folder}"
#         COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:${TARGET}>" "${dll_folder}/$<TARGET_FILE_NAME:${TARGET}>"
#         VERBATIM
#     )

#     string(TOLOWER "${CMAKE_BUILD_TYPE}" build_type)
#     if(build_type STREQUAL debug)
#         add_custom_command(TARGET ${TARGET} POST_BUILD
#             COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_PDB_FILE:${TARGET}>" "${dll_folder}/$<TARGET_PDB_FILE_NAME:${TARGET}>"
#             VERBATIM
#         )
#     endif()
# endfunction()

# Sets `target_precompile_headers` on the target to use a provided precompile header file.
function(target_skyrim_precompile_headers TARGET)
    __skyrimScriptingDebug("target_skyrim_precompile_headers(${TARGET} ${ARGV})")

    set(options PUBLIC PRIVATE INTERFACE)
    set(oneValueArgs)
    set(multiValueArgs)
    cmake_parse_arguments(PARSE_ARGV 1 SKYRIM_SCRIPTING_PRECOMPILE_HEADERS "${options}" "${oneValueArgs}" "${multiValueArgs}")

    find_file(pch_header "SkyrimScripting.CMake/Skyrim_SKSE_PCH.h")
    if(NOT EXISTS "${pch_header}")
        message(FATAL_ERROR "target_skyrim_precompile_headers error: Skyrim_SKSE_PCH.h not found via find_file")
    endif()

    if(SKYRIM_SCRIPTING_PRECOMPILE_HEADERS_PRIVATE)
        target_precompile_headers(${TARGET} PRIVATE "${pch_header}")
    elseif(SKYRIM_SCRIPTING_PRECOMPILE_HEADERS_PUBLIC)
        target_precompile_headers(${TARGET} PUBLIC "${pch_header}")
    elseif(SKYRIM_SCRIPTING_PRECOMPILE_HEADERS_INTERFACE)
        target_precompile_headers(${TARGET} INTERFACE "${pch_header}")
    else()
        target_precompile_headers(${TARGET} PRIVATE "${pch_header}")
    endif()
endfunction()

# `add_skse_plugin` wraps calls to `add_commonlibsse_plugin` and find_package, compile features, precompile headers
function(add_skse_plugin TARGET)
    __skyrimScriptingDebug("add_skse_plugin(${TARGET} ${ARGV})")

    set(options NO_PCH)
    set(oneValueArgs)
    set(multiValueArgs)
    cmake_parse_arguments(PARSE_ARGV 1 SKYRIM_SCRIPTING_SKSE_PLUGIN "${options}" "${oneValueArgs}" "${multiValueArgs}")

    # Gotta find CommonLibSSE (NG) !
    find_package(CommonLibSSE CONFIG REQUIRED)

    # This is the main thing which creates a SHARED library linked to CommonLibSSE with necessary generated NG files
    add_commonlibsse_plugin(${TARGET} ${SKYRIM_SCRIPTING_SKSE_PLUGIN_UNPARSED_ARGUMENTS})

    # Required for CommonLibSSE NG
    target_compile_features(${TARGET} PRIVATE cxx_std_23)

    if(NOT SKYRIM_SCRIPTING_SKSE_PLUGIN_NO_PCH)
        target_skyrim_precompile_headers(${TARGET})
    endif()
endfunction()

# # `setup_skse_plugin` is `add_skse_plugin` plus: deployment to mods folder, packaging for release, and more! (TODO!)
# function(setup_skse_plugin TARGET)
#     __skyrimScriptingDebug("setup_skse_plugin(${TARGET} ${ARGV})")

#     set(options)
#     set(oneValueArgs MODS_FOLDER DATA_FOLDER SKYRIM_FOLDER)
#     set(multiValueArgs)
#     cmake_parse_arguments(PARSE_ARGV 1 SKYRIM_SCRIPTING_SETUP_PLUGIN "${options}" "${oneValueArgs}" "${multiValueArgs}")

#     function(add_skse_plugin ${TARGET} ${SKYRIM_SCRIPTING_SETUP_PLUGIN_UNPARSED_ARGUMENTS})

#     if(NOT NO_DEPLOY)
#         __skyrimScriptingDebug("Setup SKSE plugin deployment")
#         if(DEFINED SKYRIM_SCRIPTING_SETUP_PLUGIN_MODS_FOLDER)
#             target_skyrim_mods_folder(${TARGET} MODS_FOLDER "${SKYRIM_SCRIPTING_SETUP_PLUGIN_MODS_FOLDER}")
#         elseif(DEFINED SKYRIM_SCRIPTING_SETUP_PLUGIN_DATA_FOLDER)
#             target_skyrim_data_folder(${TARGET} DATA_FOLDER "${SKYRIM_SCRIPTING_SETUP_PLUGIN_DATA_FOLDER}")
#         elseif(DEFINED SKYRIM_SCRIPTING_SETUP_PLUGIN_SKYRIM_FOLDER)
#             target_skyrim_data_folder(${TARGET} SKYRIM_FOLDER "${SKYRIM_SCRIPTING_SETUP_PLUGIN_SKYRIM_FOLDER}")
#         elseif(DEFINED ENV{CMAKE_SKYRIM_MODS_FOLDER})
#             target_skyrim_mods_folder(${TARGET})
#         elseif(DEFINED ENV{CMAKE_SKYRIM_FOLDER})
#             target_skyrim_data_folder(${TARGET})
#         endif()
#     else()
#         __skyrimScriptingDebug("No Deploy set for SKSE plugin")
#     endif()
# endfunction()
