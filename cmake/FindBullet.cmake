SET(BULLET3_DIR ${BUILD_DIR}
    CACHE PATH "bullet3 root directory")
message(STATUS "searching bullet in ${BULLET3_DIR} ...")

find_package(Bullet REQUIRED PATHS ${BULLET3_DIR} NO_DEFAULT_PATH)

# set(BULLET3_INCLUDE_DIR ${CMAKE_BINARY_DIR}/include/bullet)
# if ((NOT BULLET3_INCLUDE_DIR) OR (NOT BULLET3_DIR))
#     message(FATAL_ERROR "bullet3 (${BULLET3_INCLUDE_DIR}) not found!")
# endif ()
#
# execute_process(
#     COMMAND ${CMAKE_SOURCE_DIR}/scripts/build_extern.sh} ${CMAKE_SOURCE_DIR} ${EXTERN_DIR} "bullet3"
#     RESULT_VARIABLE result
#     WORKING_DIRECTORY ${BULLET3_DIR}
# )
# # execute_process(
# #     COMMAND mkdir -p build_cmake
# #     COMMAND cmake -DBUILD_PYBULLET=ON -DBUILD_PYBULLET_NUMPY=ON -DUSE_DOUBLE_PRECISION=OFF -DBT_USE_EGL=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR} -B./build_cmake -H.
# #     RESULT_VARIABLE result
# #     WORKING_DIRECTORY ${BULLET3_DIR}
# # )
# if(result)
#   message(FATAL_ERROR "CMake step for bullet3 failed: ${result}")
# endif()
# # execute_process(
# #     # COMMAND make -j $(command nproc 2>/dev/null || echo 12)
# #     COMMAND bash "-c" "make -j $(command nproc 2>/dev/null || echo 12)"
# #     # COMMAND make -j4
# #     COMMAND make install
# #     RESULT_VARIABLE result
# #     WORKING_DIRECTORY ${BULLET3_DIR}/build_cmake )
# # if(result)
# #   message(FATAL_ERROR "Build step for bullet3 failed: ${result}")
# # endif()
# #
# #
# # if (WIN32)
# #     file(GLOB_RECURSE BULLET3_LIBRARIES [FOLLOW_SYMLINKS]
# #      [LIST_DIRECTORIES true|false] [RELATIVE <path>] [CONFIGURE_DEPENDS]
# #      [<globbing-expressions>...])
# #     # find_path(BULLET3_LIBRARY_DIR
# #     #     NAMES Bullet3Dynamics.lib
# #     #     PATHS ${BULLET3_DIR} ${CMAKE_INSTALL_PREFIX}/lib
# #     #     PATH_SUFFIXES bullet3 bullet
# #     # )
# # else (WIN32)
# #     # find_path(BULLET3_LIBRARY_DIR
# #     #     NAMES libBulletDynamics.so
# #     #     PATHS ${BULLET3_DIR} ${CMAKE_INSTALL_PREFIX}/lib
# #     #     PATH_SUFFIXES bullet3 bullet
# #     # )
# # endif (WIN32)
# set(BULLET3_LIBRARY_DIR ${CMAKE_BINARY_DIR}/lib)
# if (NOT ${BULLET3_LIBRARY_DIR}/libBulletDynamics.so)
if (NOT ${BULLET_FOUND})
    message(FATAL_ERROR "bullet not build!")
else ()
    message(STATUS "Bullet include: ${BULLET_ROOT_DIR}/${BULLET_INCLUDE_DIR}")
    message(STATUS "Bullet libraries: ${BULLET_LIBRARIES}")
endif ()

add_library(bullet::bullet3 INTERFACE IMPORTED)
set_target_properties(bullet::bullet3 PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${BULLET_ROOT_DIR}/${BULLET_INCLUDE_DIR}"
    INTERFACE_LINK_LIBRARIES "${BULLET_LIBRARIES}"
)

message(STATUS "bullet::bullet3 added as a target.")
