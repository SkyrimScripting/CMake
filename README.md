<img src="https://github.com/SkyrimScripting/CMake/blob/main/Images/480px-Cmake.svg.png?raw=true" height=100px align=right />

# CMake modules for Skyrim

> Official CMake modules for Skyrim Scripting tutorials

- [CMake modules for Skyrim](#cmake-modules-for-skyrim)
  - [Features](#features)
  - [Why?](#why)
  - [Getting Started](#getting-started)
  - [Installation](#installation)
    - [`vcpkg.json`](#vcpkgjson)
    - [`vcpkg-configuration.json`](#vcpkg-configurationjson)
    - [`vcpkg` Support](#vcpkg-support)
      - [`CMakePresets.json`](#cmakepresetsjson)
  - [Usage](#usage)
    - [Plugin Output Locations](#plugin-output-locations)
  - [CMake Learning Resources](#cmake-learning-resources)

## Features

- [x] `add_skse_plugin` automatically sets up precompile headers (includes its own `PCH.h`)
- [x] `add_skse_plugin` can automatically deploy to your MO2/Vortex mods folder
- [x] `add_skse_plugin` can automatically deploy to your Skyrim `Data/` folder
- [ ] Support for Papyrus scripts
- [ ] Support for `.esp`/`.bsa` files or other assets
- [ ] Support for packaging mod for release

## Why?

I actually enjoy [CMake][].

[CMake]: https://cmake.org/

But, when your goal is: **_Create a fun Skyrim SKSE plugin_**  
then you should not _also_ be forced to learn this wicked language.

The `SkyrimScripting.CMake` module provides `CMake` functions which make it **easy** to _ignore CMake_ and just _**write Skyrim plugins!**_

## Getting Started

The easiest way to get started is by using this **template**:

**https://github.com/SkyrimScripting/SKSE_Template_StarterKit**

1. Set an environment variable to configure where generated SKSE plugins are output:
  > `CMAKE_SKYRIM_MODS_FOLDER`: _set to your MO2 or Vortex mods folder_  
  > or `CMAKE_SKYRIM_FOLDER`: _plugin will output to your `Data\` directory_
2. Clone that repository ([or download as a .zip file](https://github.com/SkyrimScripting/SKSE_Template_StarterKit/archive/refs/heads/main.zip))
3. Open the folder in any C++ editor program (_e.g. CLion, Visual Studio, VS Code_)
4. Choose other the `Debug` or `Release` build, if prompted (_CLion/VS Code_)
5. **Build the project!**
  > _SKSE plugin automatically copied into your mods or Data folder, per config above_
6. Enable the mod (_if using a mod manager_) and run Skyrim 🐉

## Installation

In your own projects, add `SkyrimScripting.CMake` by adding the following 2x files to the root of your project:

### `vcpkg.json`

<details>
    <summary>View Content</summary>

```json
{
    "$schema": "https://raw.githubusercontent.com/microsoft/vcpkg/master/scripts/vcpkg.schema.json",
    "name": "my-project",
    "version-string": "0.0.1",
    "dependencies": [
        "commonlibsse-ng",
        { "name": "skyrimscripting-cmake", "version>=": "0.0.1" }
    ]
}
```

</details>

> Please **always** specify an explicit `version<=` (_view content for example_).  
> Development of `SkyrimScripting.CMake` is currently active and the interface/functions **will change**.

### `vcpkg-configuration.json`

<details>
    <summary>View Content</summary>

```json
{
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/microsoft/vcpkg.git",
    "baseline": "cc288af760054fa489574bd8e22d05aa8fa01e5c"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://gitlab.com/colorglass/vcpkg-colorglass",
      "baseline": "ef8d43afe4d26e842de3d034bff1081cb7990f07",
      "packages": [
        "commonlibsse-ng"
      ]
    },
    {
      "kind": "git",
      "repository": "https://github.com/SkyrimScripting/vcpkg.git",
      "baseline": "< INSERT THE LATEST COMMIT SHA >",
      "packages": [
        "skyrimscripting-cmake"
      ]
    }
  ]
}
```

</details>

### `vcpkg` Support

And make sure that your project is configured to use `vcpkg`!
> e.g. via setting your `CMAKE_TOOLCHAIN_FILE` to `$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake`.

If you want, you can add this `CMakePresets.json` into the root of your project (_if you don't already have your own preferred `CMakePresets.json`_)

#### `CMakePresets.json`

<details>
    <summary>View Content</summary>

```json
{
    "version": 3,
    "configurePresets": [
        {
            "name": "base",
            "hidden": true,
            "generator": "Ninja",
            "binaryDir": "${sourceDir}/build/${presetName}",
            "installDir": "${sourceDir}/install/${presetName}",
            "architecture": { "value": "x64", "strategy": "external" },
            "cacheVariables": {
                "CMAKE_CXX_COMPILER": "cl.exe",
                "CMAKE_CXX_FLAGS": "/permissive- /Zc:preprocessor /EHsc /MP /W4 -DWIN32_LEAN_AND_MEAN -DNOMINMAX -DUNICODE -D_UNICODE",
                "CMAKE_TOOLCHAIN_FILE": "$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake",
                "VCPKG_TARGET_TRIPLET": "x64-windows-static-md",
                "VCPKG_OVERLAY_TRIPLETS": "${sourceDir}/cmake",
                "CMAKE_MSVC_RUNTIME_LIBRARY": "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL",
                "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
            }
        },
        {
            "name": "debug",
            "inherits": ["base"],
            "displayName": "Debug",
            "cacheVariables": { "CMAKE_BUILD_TYPE": "Debug" }
        },
        {
            "name": "release",
            "inherits": ["base"],
            "displayName": "Release",
            "cacheVariables": { "CMAKE_BUILD_TYPE": "Release" }
        }
    ]
}
```

</details>

## Usage

Example `CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.21)

project(MyCoolSksePlugin VERSION 0.0.1 LANGUAGES CXX)

find_package(SkyrimScripting.CMake CONFIG REQUIRED)

add_skse_plugin(${PROJECT_NAME} SOURCES plugin.cpp)
```

That's it.

### Plugin Output Locations

If you configured either `CMAKE_SKYRIM_MODS_FOLDER` or `CMAKE_SKYRIM_FOLDER` [as described above](#getting-started), then just build the project and your SKSE plugin will go into your MO2/Vortex mods folder (_or directly into your `Data/` folder_).

Alternatively, you can specify these locations manually:

```cmake
# Provide a path to your mods folder
add_skse_plugin(
    ${PROJECT_NAME}
    MODS_FOLDER "C:/path/to/my/mods/folder"
    SOURCES plugin.cpp
)
```

```cmake
# Provide a path to your Data/ folder
add_skse_plugin(
    ${PROJECT_NAME}
    DATA_FOLDER "C:/Program Files (x86)/Steam/steamapps/common/Skyrim Special Edition/Data"
    SOURCES plugin.cpp
)
```

That's all I'm going to share for now.

The usage **will** change over time, so let's keep it simple for now.

## CMake Learning Resources

> _There will be a Skyrim Scripting video covering CMake in detail in the future._

- [`cmake-language(7)`](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html)
- [`cmake-commands(7)`](https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html)

