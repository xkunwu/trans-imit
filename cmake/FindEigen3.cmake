SET(EIGEN3_DIR ${EXTERN_DIR}/eigen
    CACHE PATH "eigen root directory")
message(STATUS "searching eigen in ${EIGEN3_DIR} ...")

find_path(EIGEN3_INCLUDE_DIR
    NAMES signature_of_eigen3_matrix_library
    PATHS ${EIGEN3_DIR} ${CMAKE_INSTALL_PREFIX}/include
    #PATH_SUFFIXES eigen3 eigen
)
if (NOT EIGEN3_INCLUDE_DIR)
    message(FATAL_ERROR "eigen not found!")
else ()
    message(STATUS "Eigen include: ${EIGEN3_DIR}")
endif ()

add_library(eigen::eigen3 INTERFACE IMPORTED)
set_target_properties(eigen::eigen3 PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${EIGEN3_INCLUDE_DIR}"
)

message(STATUS "eigen::eigen3 added as a target.")
