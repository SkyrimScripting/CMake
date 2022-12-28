function(skyrim_mod)
    __skyrimscripting_arg_parse(
        # VALUE NAME TARGET AUTHOR EMAIL
        # MULTI FILES
        ARGS ${ARGV}
    )

    string(REGEX REPLACE "[^a-zA-Z0-9]" "" target "${PROJECT_NAME}")

    add_custom_target("${target}" COMMAND echo "Hello from ${target}!")
    message("ADDED TARGET: ${target}")

    set_property(TARGET "${target}" PROPERTY MOD_NAME "${PROJECT_NAME}")
    set_property(TARGET "${target}" PROPERTY MOD_VERSION "${PROJECT_VERSION}")
endfunction()





    # if(DEFINED ${arg_prefix}TARGET)
    #     set(target "${arg_prefix}TARGET")
    # else()
    #     string(REGEX REPLACE "[^a-zA-Z0-9]" "" target "${MOD_NAME}")
    # endif()
    # set_property(TARGET ${target} PROPERTY MOD_FILES "${${arg_prefix}FILES}")