#include "MatrixMath.h"

void MatrixMath::add(std::vector<std::vector<int>> &a, std::vector<std::vector<int>> &b) {
    int rows = a.size();
    int cols = a[0].size();
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            a[i][j] += b[i][j];
        }
    }
}

void MatrixMath::subtract(std::vector<std::vector<int>> &a, std::vector<std::vector<int>> &b) {
    int rows = a.size();
    int cols = a[0].size();
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            a[i][j] -= b[i][j];
        }
    }
}

void MatrixMath::multiply(std::vector<std::vector<int>> &a, std::vector<std::vector<int>> &b) {
    int rows = a.size();
    int cols = b[0].size();
    std::vector<std::vector<int>> result(rows, std::vector<int>(cols, 0));
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            for (int k = 0; k < a[0].size(); ++k) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    a = result;
}

void MatrixMath::multiply(std::vector<std::vector<int>> &a, int k) {
    int rows = a.size();
    int cols = a[0].size();
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            a[i][j] *= k;
        }
    }
}

void MatrixMath::transpose(std::vector<std::vector<int>> &a) {
    int rows = a.size();
    int cols = a[0].size();
    std::vector<std::vector<int>> result(cols, std::vector<int>(rows));
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            result[j][i] = a[i][j];
        }
    }
    a = result;
}

std::vector<std::vector<int>> MatrixMath::identity(int n) {
    std::vector<std::vector<int>> result(n, std::vector<int>(n, 0));
    for (int i = 0; i < n; ++i) {
        result[i][i] = 1;
    }
    return result;
}

std::vector<std::vector<int>> MatrixMath::inverse(std::vector<std::vector<int>> &a) {
    int n = a.size();
    std::vector<std::vector<int>> result(n, std::vector<int>(n, 0));
    // Implement matrix inversion logic here

    return result;
}