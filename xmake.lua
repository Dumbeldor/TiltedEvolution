set_xmakever("2.6.2")

-- c code will use c99,
set_languages("c99", "cxx20")

set_arch("x64")
set_warnings("all")
add_vectorexts("sse", "sse2", "sse3", "ssse3")

-- build configurations
add_rules("mode.debug", "mode.releasedbg", "mode.release")
add_rules("plugin.vsxmake.autoupdate")
add_rules("c.unity_build")

add_requires("entt", "recastnavigation")

before_build(function (target)
    import("modules.version")
    local branch, commitHash = version()
    bool_to_number={ [true]=1, [false]=0 }
    local contents = string.format([[
    #pragma once
    #define IS_MASTER %d
    #define IS_BRANCH_BETA %d
    #define IS_BRANCH_PREREL %d
    ]], 
    bool_to_number[branch == "master"], 
    bool_to_number[branch == "bluedove"], 
    bool_to_number[branch == "prerel"])
    io.writefile("build/BranchInfo.h", contents)
end)

if is_mode("debug") then
    add_cxflags("/FS")
    add_defines("DEBUG")
end

if is_mode("release") then
    add_ldflags("/LTCG", "/OPT:REF")
    add_cxflags("/Ot", "/GL", "/Ob2", "/Oi", "/GS-")
    add_defines("NDEBUG")
    set_optimize("fastest")
end

if is_plat("windows") then
    add_defines("NOMINMAX")
end

-- add projects
includes("Libraries")
includes("Code")
