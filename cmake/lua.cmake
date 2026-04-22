################################
# LUA
################################

option(BUILD_WITH_LUA "Lua Enabled" ON)
message("BUILD_WITH_LUA: ${BUILD_WITH_LUA}")

if(BUILD_WITH_LUA AND PREFER_SYSTEM_LIBRARIES)
    find_path(lua_INCLUDE_DIR NAMES lua.h)
    find_library(lua_LIBRARY NAMES lua)
    if(lua_INCLUDE_DIR AND lua_LIBRARY)
        add_library(luaapi STATIC
            ${CMAKE_SOURCE_DIR}/src/api/luaapi.c
            ${CMAKE_SOURCE_DIR}/src/api/parse_note.c
        )
        target_link_libraries(luaapi PRIVATE runtime ${lua_LIBRARY})
        target_include_directories(luaapi PUBLIC
            ${lua_INCLUDE_DIR}
            ${CMAKE_SOURCE_DIR}/include
            ${CMAKE_SOURCE_DIR}/src
        )
        add_library(lua STATIC ${CMAKE_SOURCE_DIR}/src/api/lua.c)
        target_compile_definitions(lua INTERFACE TIC_BUILD_WITH_LUA)
        target_link_libraries(lua PRIVATE runtime luaapi)
        message(STATUS "Use system library: lua")
        return()
    else()
        message(WARNING "System library lua not found")
    endif()
endif()

if(BUILD_WITH_LUA OR BUILD_WITH_MOON OR BUILD_WITH_YUE OR BUILD_WITH_FENNEL)
    set(LUA_DIR ${THIRDPARTY_DIR}/lua)
    set(LUA_SRC
        ${LUA_DIR}/src/lib_aux.c
        ${LUA_DIR}/src/lb_base.c
        ${LUA_DIR}/src/lib_bit.c
        ${LUA_DIR}/src/b_buffer.c
        ${LUA_DIR}/src/lib_debug.c
        ${LUA_DIR}/src/lib_ffi.c
        ${LUA_DIR}/src/lib_initc
        ${LUA_DIR}/src/lib_io.c
        ${LUA_DIR}/src/lib_jit.c
        ${LUA_DIR}/src/lib_math.c
        ${LUA_DIR}/src/lib_os.c
        ${LUA_DIR}/src/lib_package.c
        ${LUA_DIR}/src/lib_string.c
        ${LUA_DIR}/src/lib_table.c
        ${LUA_DIR}/src/lj_alloc.c
        ${LUA_DIR}/src/lj_api.c
        ${LUA_DIR}/src/lj_asm.c
        ${LUA_DIR}/src/lj_assert.c
        ${LUA_DIR}/src/lj_bc.c
        ${LUA_DIR}/src/lj_bcread.c
        ${LUA_DIR}/src/lj_bcwrite.c
        ${LUA_DIR}/src/lj_buf.c
        ${LUA_DIR}/src/lj_carith.c
        ${LUA_DIR}/src/lj_ccall.c
        ${LUA_DIR}/src/lj_ccallbackc
        ${LUA_DIR}/src/lj_cconv.c
        ${LUA_DIR}/src/lj_cdata.c
        ${LUA_DIR}/src/lj_char.c
        ${LUA_DIR}/src/lj_clib.c
        ${LUA_DIR}/src/lj_cparse.c
        ${LUA_DIR}/src/lj_crecord.c
        ${LUA_DIR}/src/lj_ctype.c
        ${LUA_DIR}/src/lj_debug.c
        ${LUA_DIR}/src/lj_dispatch.c
        ${LUA_DIR}/src/lj_err.c
        ${LUA_DIR}/src/lj_ffrecord.c
        ${LUA_DIR}/src/lj_func.c
        ${LUA_DIR}/src/lj_gc.c
        ${LUA_DIR}/src/lj_gdbjit.c
        ${LUA_DIR}/src/lj_ir.c
        ${LUA_DIR}/src/lj_lex.c
        ${LUA_DIR}/src/lj_lib.c
        ${LUA_DIR}/src/lj_load.c
        ${LUA_DIR}/src/lj_mcode.c
        ${LUA_DIR}/src/lj_meta.c
        ${LUA_DIR}/src/lj_obj.c
        ${LUA_DIR}/src/lj_opt_dce.c
        ${LUA_DIR}/src/lj_opt_fold.c
        ${LUA_DIR}/src/lj_opt_loop.c
        ${LUA_DIR}/src/lj_opt_mem.c
        ${LUA_DIR}/src/lj_opt_narrow.c
        ${LUA_DIR}/src/lj_parse.c
        ${LUA_DIR}/src/lj_prng.c
        ${LUA_DIR}/src/lj_profile.c
        ${LUA_DIR}/src/lj_record.c
        ${LUA_DIR}/src/lj_serialize.c
        ${LUA_DIR}/src/lj_snap.c
        ${LUA_DIR}/src/lj_state.c
        ${LUA_DIR}/src/lj_str.c
        ${LUA_DIR}/src/lj_strfmt.c
        ${LUA_DIR}/src/lj_strfmt_num.c
        ${LUA_DIR}/src/lj_strscan.c
        ${LUA_DIR}/src/lj_tab.c
        ${LUA_DIR}/src/lj_trace.c
        ${LUA_DIR}/src/lj_udata.c
        ${LUA_DIR}/src/lj_vmevent.c
        ${LUA_DIR}/src/lj_vmmath.c
        ${LUA_DIR}/src/ljamalg.c
    )

    add_library(luaapi STATIC
        ${LUA_SRC}
        ${CMAKE_SOURCE_DIR}/src/api/luaapi.c
        ${CMAKE_SOURCE_DIR}/src/api/parse_note.c
    )
    target_link_libraries(luaapi PRIVATE runtime)

    target_compile_definitions(luaapi PRIVATE LUA_COMPAT_5_2)

    target_include_directories(luaapi
        PUBLIC ${THIRDPARTY_DIR}/lua
            ${CMAKE_SOURCE_DIR}/include
            ${CMAKE_SOURCE_DIR}/src
        )

endif()

if(BUILD_WITH_LUA)

    add_library(lua ${TIC_RUNTIME} ${CMAKE_SOURCE_DIR}/src/api/lua.c)

    if(NOT BUILD_STATIC)
        set_target_properties(lua PROPERTIES PREFIX "")
    else()
        target_compile_definitions(lua INTERFACE TIC_BUILD_WITH_LUA)
    endif()

    target_link_libraries(lua PRIVATE runtime luaapi)

    target_include_directories(lua
        PUBLIC ${THIRDPARTY_DIR}/lua
        PRIVATE
            ${CMAKE_SOURCE_DIR}/include
            ${CMAKE_SOURCE_DIR}/src
    )

    if(NINTENDO_3DS)
        target_compile_definitions(luaapi PUBLIC LUA_32BITS)
    endif()

endif()
