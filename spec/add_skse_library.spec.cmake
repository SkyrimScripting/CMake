include("${CMAKE_CURRENT_LIST_DIR}/SpecHelper.cmake")

# add_skse_library() specs

function(it_can_compile_an_SKSE_plugin)
    message("${CMAKE_SOURCE_DIR}")

    create_project(path [=[
        project("My Project")
        add_skse_library(
            NAME MyCoolLibrary
            SOURCES @basic_plugin_cpp@
        )
    ]=])

    build_spec_target(
        PATH "${path}"
        PROJECT "My Project"
        TARGET "MyCoolLibrary"
        RESULT result
        SAFE_OUTPUT output
    )

    expect("${output}" to contain text "????")
endfunction()

function(xit_takes_default_values_from_project)
    # ...
endfunction()
