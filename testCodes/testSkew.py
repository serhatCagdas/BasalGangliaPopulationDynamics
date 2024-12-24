import numpy as np
import scipy.linalg

# Desired eigenvalues (must be purely imaginary and occur in conjugate pairs)
eigenvalues = np.array([1j, -1j, 2j, -2j])

# Create a diagonal matrix D with these eigenvalues
D = np.diag(eigenvalues)

# Generate a random orthogonal matrix Q
A = np.random.rand(len(eigenvalues), len(eigenvalues))
Q, _ = np.linalg.qr(A)

# Form the skew-symmetric matrix A = Q D Q^T
skew_symmetric_matrix = Q @ D @ Q.T

# Ensure the matrix is real
skew_symmetric_matrix = np.real(skew_symmetric_matrix)

# Print the result
print("Skew-Symmetric Matrix:")
print(skew_symmetric_matrix)
