cmake_minimum_required (VERSION 3.8)
PROJECT (DeepMimicCore)

IF (NOT CMAKE_BUILD_TYPE)
    SET(CMAKE_BUILD_TYPE "RelWithDebInfo")
ENDIF (NOT CMAKE_BUILD_TYPE)
SET (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
SET (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
SET (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/")
LIST(APPEND CMAKE_MODULE_PATH "${EXTRA_MODULE}")

FIND_PACKAGE(Eigen3 REQUIRED)
FIND_PACKAGE(Bullet REQUIRED)

## Find Python is the same as Bullet, for using the same version
SET(CMAKE_MODULE_PATH ${EXTERN_DIR}/bullet3/build3/cmake ${CMAKE_MODULE_PATH})
FIND_PACKAGE(PythonInterp 3 REQUIRED)
FIND_PACKAGE(PythonLibs ${PYTHON_VERSION_STRING} EXACT)
message("PYTHONLIBS_VERSION_STRING: ${PYTHONLIBS_VERSION_STRING}")
message("PYTHON_INCLUDE_PATH: ${PYTHON_INCLUDE_PATH}")

FIND_PACKAGE(OpenGL REQUIRED)
FIND_PACKAGE(GLUT REQUIRED)
FIND_PACKAGE(GLEW REQUIRED)

set(CMAKE_CXX_STANDARD 11) # C++11...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11

#set (PROJECT_SRCS_OBJ "${PROJECT_NAME}_SRCS_LIST")
#INCLUDE(${CMAKE_SOURCE_DIR}/srce_list.cmake.in)
#ADD_LIBRARY(${PROJECT_SRCS_OBJ} OBJECT ${CURR_SRCS_LIST})
#ADD_EXECUTABLE(${PROJECT_NAME} "Main.cpp")
#TARGET_LINK_LIBRARIES(${PROJECT_NAME} $<TARGET_OBJECTS:${PROJECT_SRCS_OBJ}>)
##ADD_EXECUTABLE(${PROJECT_NAME} "Main.cpp" $<TARGET_OBJECTS:${PROJECT_SRCS_OBJ}>)
##TARGET_LINK_LIBRARIES(${PROJECT_NAME})

## shared library, so both c++ and swig targets can use
set (PROJECT_SRCS_LIB "${PROJECT_NAME}_SRCS_LIB")
INCLUDE(${CMAKE_SOURCE_DIR}/srce_list.cmake.in)
LINK_DIRECTORIES(${CMAKE_INSTALL_PREFIX}/lib)
ADD_LIBRARY(${PROJECT_SRCS_LIB}
    SHARED ${CURR_SRCS_LIST})
TARGET_INCLUDE_DIRECTORIES(${PROJECT_SRCS_LIB}
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        #${CURR_INCS_LIST} # this cause lots of glibc macro error
        ${OPENGL_INCLUDE_DIRS} ${GLUT_INCLUDE_DIRS} ${GLEW_INCLUDE_DIRS}
)
TARGET_LINK_LIBRARIES(${PROJECT_SRCS_LIB}
    PUBLIC
        eigen::eigen3
        bullet::bullet3
        ${OPENGL_LIBRARIES} ${GLUT_LIBRARY} ${GLEW_LIBRARIES}
)

## c++ target
ADD_EXECUTABLE(${PROJECT_NAME}
    "Main.cpp" "${PROJECT_NAME}.cpp")
TARGET_LINK_LIBRARIES(${PROJECT_NAME}
    PRIVATE ${PROJECT_SRCS_LIB})

## swig preprocessing
FIND_PACKAGE(SWIG REQUIRED)
INCLUDE(${SWIG_USE_FILE})
if(PYTHONLIBS_VERSION_STRING MATCHES "^2.*$" )
    set(CMAKE_SWIG_FLAGS -classic)
else()
    set(CMAKE_SWIG_FLAGS -py3)
endif()
message("CMAKE_SWIG_FLAGS: ${CMAKE_SWIG_FLAGS}")
SET_SOURCE_FILES_PROPERTIES(DeepMimicCore.i PROPERTIES
    CPLUSPLUS ON
    #SWIG_FLAGS "-threads"
    #GENERATED_COMPILE_OPTIONS -Wall"
)
SWIG_ADD_LIBRARY("${PROJECT_NAME}" 
    TYPE SHARED
    LANGUAGE python
    #SOURCES DeepMimicCore.i "${PROJECT_NAME}.cpp" ${CURR_SRCS_LIST}
    SOURCES DeepMimicCore.i "${PROJECT_NAME}.cpp"
)
set (SWIG_TARGET "_${PROJECT_NAME}")
target_include_directories(${SWIG_TARGET}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${OPENGL_INCLUDE_DIRS} ${GLUT_INCLUDE_DIRS} ${GLEW_INCLUDE_DIRS}
        ${PYTHON_INCLUDE_PATH}
)
SWIG_LINK_LIBRARIES("${PROJECT_NAME}"
    ${PYTHON_LIBRARIES}
    eigen::eigen3
    bullet::bullet3
    ${OPENGL_LIBRARIES} ${GLUT_LIBRARY} ${GLEW_LIBRARIES}
    ${PROJECT_SRCS_LIB}
)

## installation
install(TARGETS ${PROJECT_SRCS_LIB} DESTINATION "lib")
install(TARGETS ${PROJECT_NAME} DESTINATION "${CMAKE_SOURCE_DIR}")
install(TARGETS ${SWIG_TARGET} DESTINATION "${CMAKE_SOURCE_DIR}")
install(FILES "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.py" DESTINATION "${CMAKE_SOURCE_DIR}")
