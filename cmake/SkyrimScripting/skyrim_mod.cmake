function(skyrim_mod)
    __skyrimscripting_arg_parse(
        VALUE NAME VERSION TARGET
        # MULTI FILES
        ARGS ${ARGV}
    )

    if(DEFINED ${arg_prefix}NAME)
        set(mod_name "${${arg_prefix}NAME}")
    endif()

    if(DEFINED ${arg_prefix}VERSION)
        set(mod_version "${${arg_prefix}VERSION}")
    endif()

    if(DEFINED ${arg_prefix}TARGET)
        set(target "${${arg_prefix}TARGET}")
    endif()

    if(NOT DEFINED mod_name)
        if(DEFINED target)
            set(mod_name target) # TEST ME
        elseif(DEFINED PROJECT_NAME)
            set(mod_name "${PROJECT_NAME}")
        endif()
    endif()

    if(NOT DEFINED mod_version)
        if(DEFINED PROJECT_VERSION)
            set(mod_version "${PROJECT_VERSION}")
        endif()
    endif()

    if(NOT DEFINED target)
        string(REGEX REPLACE "[^a-zA-Z0-9]" "" target "${mod_name}")
    endif()

    add_custom_target("${target}" COMMAND echo "Hello from ${target}!")

    set_property(TARGET "${target}" PROPERTY MOD_NAME "${mod_name}")
    set_property(TARGET "${target}" PROPERTY MOD_VERSION "${mod_version}")
endfunction()





    # if(DEFINED ${arg_prefix}TARGET)
    #     set(target "${arg_prefix}TARGET")
    # else()
    #     string(REGEX REPLACE "[^a-zA-Z0-9]" "" target "${MOD_NAME}")
    # endif()
    # set_property(TARGET ${target} PROPERTY MOD_FILES "${${arg_prefix}FILES}")