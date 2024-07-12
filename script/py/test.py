import numpy as np
import matplotlib.pyplot as plt

# Constants
k = 1
omega = 1
t = np.linspace(0, 10, 1000)
x = np.linspace(-2 * np.pi, 2 * np.pi, 1000)  # x in radians

# Specific angle
theta = 1 / np.sqrt(2)

# Wave function components
cos_component = np.cos(k * x[:, np.newaxis] - omega * t)
sin_component = np.sin(k * x[:, np.newaxis] - omega * t)

# Combined wave function
psi_real = np.cos(theta) * cos_component
psi_imag = np.sin(theta) * sin_component

# Plotting the wave function in radians
plt.figure(figsize=(12, 6))
plt.plot(x, psi_real[:, 500], label='Real part')
plt.plot(x, psi_imag[:, 500], label='Imaginary part')
plt.title('Wave Function Components at Angle 1/sqrt(2)')
plt.xlabel('Position x (radians)')
plt.ylabel('Wave Function $\Psi(x)$')
plt.legend()
plt.grid()
plt.show()

# Polar plot for phase shift
plt.figure(figsize=(8, 8))
theta_values = np.linspace(0, 2 * np.pi, 1000)
r_values_real = np.cos(theta) * np.cos(k * theta_values - omega * t[500])
r_values_imag = np.sin(theta) * np.sin(k * theta_values - omega * t[500])

plt.subplot(111, projection='polar')
plt.plot(theta_values, r_values_real, label='Real part')
plt.plot(theta_values, r_values_imag, label='Imaginary part')
plt.title('Polar Plot of Wave Function Components')
plt.legend()
plt.show()