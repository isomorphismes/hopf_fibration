cmake_minimum_required(VERSION 3.22.1)
project(hopf C)

set(NATIVE_GLUE_DIR "${CMAKE_ANDROID_NDK}/sources/android/native_app_glue")

get_filename_component(HOPF_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../../.." ABSOLUTE)
set(HOPF_AICI_ROOT "${HOPF_ROOT}/.ai-ci-ick" CACHE PATH
    "Exact ai-ci source providing the qualified ICK Android stages")
include("${HOPF_AICI_ROOT}/ick-android/OwnedC.cmake")
if(NOT ICK_COMPILER)
    ick_android_stage(ROOT "${HOPF_ROOT}/build/ick/${ANDROID_ABI}" FORTIFY_SOURCE 2)
endif()

ick_android_objects(HOPF_OBJECTS NAME hopf
    SOURCES hopf_android.c hopf_math.c
    INCLUDES "${NATIVE_GLUE_DIR}"
    OPTIONS -Wall -Wextra -Wpedantic
    STANDARD 11
)

add_library(native_app_glue STATIC
    "${NATIVE_GLUE_DIR}/android_native_app_glue.c"
)
target_include_directories(native_app_glue PUBLIC "${NATIVE_GLUE_DIR}")

add_library(hopf SHARED
    ${HOPF_OBJECTS}
)
set_target_properties(hopf PROPERTIES LINKER_LANGUAGE C)
target_link_options(hopf PRIVATE -u ANativeActivity_onCreate)
target_link_libraries(hopf
    native_app_glue
    android
    log
    EGL
    GLESv3
    m
)
