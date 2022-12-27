function(skyrim_mod)
    __skyrimscripting_arg_parse(
        # VALUE NAME TARGET AUTHOR EMAIL
        # MULTI FILES
        ARGS ${ARGV}
    )

    add_custom_target(SomeProject)
    set_property(TARGET SomeProject PROPERTY MOD_NAME "... Some Project")
    # add_custom_target(${target})
endfunction()





    # if(DEFINED ${arg_prefix}TARGET)
    #     set(target "${arg_prefix}TARGET")
    # else()
    #     string(REGEX REPLACE "[^a-zA-Z0-9]" "" target "${MOD_NAME}")
    # endif()
    # set_property(TARGET ${target} PROPERTY MOD_FILES "${${arg_prefix}FILES}")