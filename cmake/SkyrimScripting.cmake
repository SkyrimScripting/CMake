function(target_deploy_skyrim_mod TARGET)
    set(options)
    set(oneValueArgs DESTINATION)
    set(multiValueArgs)
    cmake_parse_arguments(PARSE_ARGV 1 SKYRIM_SCRIPTING_DEPLOY_MOD "${options}" "${oneValueArgs}" "${multiValueArgs}")

    if(DEFINED SKYRIM_SCRIPTING_DEPLOY_MOD_DESTINATION)
        message("DEST: ${SKYRIM_SCRIPTING_DEPLOY_MOD_DESTINATION}")
    else()
        message("NO DESTINATION PROVIDED")
    endif()

endfunction()
