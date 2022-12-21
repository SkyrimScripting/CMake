# Provide a folder to auto-deploy your mod to after build
#
# ```
# target_deploy_skyrim_mod(mytarget DESTINATION "C:/path/to/mods")
# ```
#
# Defaults to the `CMAKE_SKYRIM_MODS` environment variable, if set.
function(target_deploy_skyrim_mod TARGET)
    set(options)
    set(oneValueArgs DESTINATION)
    set(multiValueArgs)
    cmake_parse_arguments(PARSE_ARGV 1 SKYRIM_SCRIPTING_DEPLOY_MOD "${options}" "${oneValueArgs}" "${multiValueArgs}")

    if(NOT TARGET "${TARGET}")
        message(FATAL_ERROR "Invalid target_deploy_skyrim_mod invocation. Target is not valid target: '${TARGET}'")
    endif()

    if(DEFINED SKYRIM_SCRIPTING_DEPLOY_MOD_DESTINATION)
        message("DEST: ${SKYRIM_SCRIPTING_DEPLOY_MOD_DESTINATION}")
        if(IS_DIRECTORY "${SKYRIM_SCRIPTING_DEPLOY_MOD_DESTINATION}")
            set(mods_folder "${SKYRIM_SCRIPTING_DEPLOY_MOD_DESTINATION}")
        else()
            message(FATAL_ERROR "Invalid target_deploy_skyrim_mod DESTINATION provided (directory does not exist) '${SKYRIM_SCRIPTING_DEPLOY_MOD_DESTINATION}'")
        endif()
    else()
        if(DEFINED ENV{CMAKE_SKYRIM_MODS})
            if(IS_DIRECTORY "$ENV{CMAKE_SKYRIM_MODS}")
                set(mods_folder "$ENV{CMAKE_SKYRIM_MODS}")
            else()
                message(FATAL_ERROR "Invalid target_deploy_skyrim_mod invocation. CMAKE_SKYRIM_MODS environment variable (directory does not exist) '$ENV{CMAKE_SKYRIM_MODS}'")
            endif()
        else()
            message(FATAL_ERROR "Invalid target_deploy_skyrim_mod invocation. No DESTINATION provided and no CMAKE_SKYRIM_MODS environment variable defined.")
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
