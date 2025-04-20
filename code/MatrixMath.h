#include <vector>

namespace MatrixMath
{
    // Function to add two matrices. A = A + B
    void add(std::vector<std::vector<int>> &a, std::vector<std::vector<int>> &b);

    // Function to subtract two matrices. A = A - B
    void subtract(std::vector<std::vector<int>> &a, std::vector<std::vector<int>> &b);

    // Function to multiply two matrices. A = A * B
    void multiply(std::vector<std::vector<int>> &a, std::vector<std::vector<int>> &b);


    // Function to multiply a matrix by a scalar. A = A * k
    void multiply(std::vector<std::vector<int>> &a, int k);

    // Function to transpose a matrix. A = A^T
    void transpose(std::vector<std::vector<int>> &a);

    // Function to calculate the determinant of a matrix
    std::vector<std::vector<int>> identity(int n);

    // Function to calculate the inverse of a matrix
    std::vector<std::vector<int>> inverse(std::vector<std::vector<int>> &a);
}