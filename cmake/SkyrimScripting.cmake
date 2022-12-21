# Provide a folder to auto-deploy your mod to after build
#
# ```
# target_skyrim_mods_folder(mytarget DESTINATION "C:/path/to/mods")
# ```
#
# Defaults to the `CMAKE_SKYRIM_MODS` environment variable, if set.
function(target_skyrim_mods_folder TARGET)
    set(options)
    set(oneValueArgs DESTINATION)
    set(multiValueArgs)
    cmake_parse_arguments(PARSE_ARGV 1 SKYRIM_SCRIPTING_MODS_FOLDER "${options}" "${oneValueArgs}" "${multiValueArgs}")

    if(NOT TARGET "${TARGET}")
        message(FATAL_ERROR "Invalid target_skyrim_mods_folder invocation. Target is not valid target: '${TARGET}'")
    endif()

    if(DEFINED SKYRIM_SCRIPTING_MODS_FOLDER_DESTINATION)
        message("DEST: ${SKYRIM_SCRIPTING_MODS_FOLDER_DESTINATION}")
        if(IS_DIRECTORY "${SKYRIM_SCRIPTING_MODS_FOLDER_DESTINATION}")
            set(mods_folder "${SKYRIM_SCRIPTING_MODS_FOLDER_DESTINATION}")
        else()
            message(FATAL_ERROR "Invalid target_skyrim_mods_folder DESTINATION provided (directory does not exist) '${SKYRIM_SCRIPTING_MODS_FOLDER_DESTINATION}'")
        endif()
    else()
        if(DEFINED ENV{CMAKE_SKYRIM_MODS})
            if(IS_DIRECTORY "$ENV{CMAKE_SKYRIM_MODS}")
                set(mods_folder "$ENV{CMAKE_SKYRIM_MODS}")
            else()
                message(FATAL_ERROR "Invalid target_skyrim_mods_folder invocation. CMAKE_SKYRIM_MODS environment variable (directory does not exist) '$ENV{CMAKE_SKYRIM_MODS}'")
            endif()
        else()
            message(FATAL_ERROR "Invalid target_skyrim_mods_folder invocation. No DESTINATION provided and no CMAKE_SKYRIM_MODS environment variable defined.")
        endif()
    endif()

    set(mod_folder "${mods_folder}/${TARGET}")
    message("Skyrim mod folder: ${mod_folder}")

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

# Sets `target_precompile_headers` on the target to use a provided precompile header file.
function(target_skyrim_precompile_headers TARGET)
    set(options PUBLIC PRIVATE INTERFACE)
    set(oneValueArgs)
    set(multiValueArgs)
    cmake_parse_arguments(PARSE_ARGV 1 SKYRIM_SCRIPTING_PRECOMPILE_HEADERS "${options}" "${oneValueArgs}" "${multiValueArgs}")

    if(SKYRIM_SCRIPTING_PRECOMPILE_HEADERS_PRIVATE)
        message("PRIVATE!")
    elseif(SKYRIM_SCRIPTING_PRECOMPILE_HEADERS_PUBLIC)
        message("PUBLIC!")
    elseif(SKYRIM_SCRIPTING_PRECOMPILE_HEADERS_INTERFACE)
        message("INTERFACE!")
    else()
        message("NONE!")
    endif()

    find_file(TESTING2 "Skyrim_SKSE_PCH.h")
    message("FOUND? FILE '${TESTING2}'")
endfunction()
