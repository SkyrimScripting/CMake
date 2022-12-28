include("${CMAKE_CURRENT_LIST_DIR}/SpecHelper.cmake")

function(test_defaults_without_arguments)
    set(PROJECT_NAME "Some Project")
    set(PROJECT_VERSION 1.2.3)

    skyrim_mod()

    expect("SomeProject" to be target)
    expect("Some Project" to be property MOD_NAME of TARGET SomeProject)
    expect(1.2.3 to be property MOD_VERSION of TARGET SomeProject)

    set(parent_var 123)
    create_project(project_path [=[
        project("Cool Project" VERSION 69.420)
        skyrim_mod()
    ]=])

    message("THE PROJECT PATH IS ${project_path}")

    build_spec_target(
        PATH "${project_path}"
        PROJECT "Cool Project"
        TARGET "CoolProject"
        RESULT result
        OUTPUT output
    )

    message("---> ${result} OUTPUT: [${output}]")
    message("${output}")
endfunction()
