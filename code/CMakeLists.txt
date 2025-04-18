# Set the minimum required version of CMake for this project
cmake_minimum_required(VERSION 3.10)

# Define the project name
project(FDS25_Project3)

# Include directories for header files
include_directories(.)  

# Add executable targets
# Create an executable named 'main' from main.cpp and Graph.cpp
add_executable(main main.cpp Graph.cpp)
# Create an executable named 'test' from test.cpp and Graph.cpp
add_executable(test test.cpp Graph.cpp)
# Create an executable named 'main_openmp' from main_openmp.cpp and Graph.cpp
add_executable(main_openmp main_openmp.cpp Graph.cpp)
# Create an executable named 'test_openmp' from test_openmp.cpp and Graph.cpp
add_executable(test_openmp test_openmp.cpp Graph.cpp)

# Find and link OpenMP for main_openmp and test_openmp
# OpenMP is used for parallel programming
find_package(OpenMP REQUIRED)
if(OpenMP_CXX_FOUND)
    # Link OpenMP libraries to the 'main_openmp' executable
    target_link_libraries(main_openmp PUBLIC OpenMP::OpenMP_CXX)
    # Link OpenMP libraries to the 'test_openmp' executable
    target_link_libraries(test_openmp PUBLIC OpenMP::OpenMP_CXX)
endif()