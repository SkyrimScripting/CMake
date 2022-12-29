include("${CMAKE_CURRENT_LIST_DIR}/SpecHelper.cmake")

# copy_files_to_skyrim_mod_folder() specs

# set(NO_PROJECT_CLEANUP true)

function(it_is_just_a_simple_target_which_copies_files_but_at_runtime)
    # Setup a place to deploy the mod's files to
    create_temp_directory(temp_dir)

    create_project(path [=[
        copy_files_to_skyrim_mod_folder(
            CopyFilesTarget
            FILES foo.txt bar.txt
            PATH "@temp_dir@"
        )
    ]=])
    touch("./foo.txt")
    touch("./bar.txt")

    expect("${temp_dir}/foo.txt" not to be a file)
    expect("${temp_dir}/bar.txt" not to be a file)

    build_spec_target(
        PATH "${path}"
        TARGET CopyFilesTarget
        RESULT result
        SAFE_OUTPUT output
    )

    # expect result to be successful
    # expect output something?
    message("OUTPUT: ${output}")

    expect("${temp_dir}/foo.txt" to be a file)
    expect("${temp_dir}/bar.txt" to be a file)
endfunction()
