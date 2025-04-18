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
