function(copy_files_to_skyrim_mod_folder target)
    add_custom_target(
        ${target}
        COMMAND echo hello
        COMMAND echo whatever
    )
endfunction()
