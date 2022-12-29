include("${CMAKE_CURRENT_LIST_DIR}/SpecHelper.cmake")

# skyrim_mod() specs

function(it_takes_default_values_from_project)
    expect(SomeProject not to be target)
    set(PROJECT_NAME "Some Project")
    set(PROJECT_VERSION 1.2.3)

    skyrim_mod()

    expect(SomeProject to be target)
    expect("Some Project" to be property MOD_NAME of TARGET SomeProject)
    expect(1.2.3 to be property MOD_VERSION of TARGET SomeProject)
endfunction()

function(it_accepts_project_values_via_arguments)
    expect(ThisIsTheTarget not to be target)
    set(PROJECT_NAME "Some Project")
    set(PROJECT_VERSION 1.2.3)

    skyrim_mod(
        NAME "Awesome Mod"
        TARGET ThisIsTheTarget
        VERSION 69.420
    )

    expect(ThisIsTheTarget to be target)
    expect("Awesome Mod" to be property MOD_NAME of TARGET ThisIsTheTarget)
    expect(69.420 to be property MOD_VERSION of TARGET ThisIsTheTarget)
endfunction()

function(xit_can_deploy_provided_files_to_a_provided_folder_path)
endfunction()
