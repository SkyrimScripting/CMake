include("${CMAKE_CURRENT_LIST_DIR}/SpecHelper.cmake")

function(setup)
    message("SETUP")
endfunction()

function(teardown)
    message("TEARDOWN")
endfunction()

function(test_defaults_without_arguments)
    set(PROJECT_NAME "Some Project")
    set(PROJECT_VERSION 1.2.3)

    skyrim_mod()

    expect(SomeProject to be target)
    expect("Some Project" to be property MOD_NAME of TARGET SomeProject)
endfunction()

# function(it_has_a_mod_name)

#     get_property(TARGET MyMod PROPERTY MOD_NAME)

# endfunction()

# function(it_adds_target)
#     expect(MyCoolMod not to be target)

#     skyrim_mod(MyCoolMod)

#     expect(MyCoolMod to be target)
# endfunction()
