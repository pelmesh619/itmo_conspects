import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# --- Простая волнистая функция ---
def f(xy):
    x, y = xy
    return x**2 + y**2 + 5*np.sin(x)*np.sin(y)

def grad_f(xy):
    x, y = xy
    dx, dy = 1e-7, 1e-7
    dfdx = (f((x + dx, y)) - f((x, y))) / dx
    dfdy = (f((x, y + dy)) - f((x, y))) / dy
    return np.array([dfdx, dfdy])

# --- Градиентный спуск ---
def gradient_descent(start, lr=0.05, n_iter=200, method='full', noise_scale=0.5, batch_size=10):
    x = np.array(start, dtype=float)
    trajectory = [x.copy()]
    for _ in range(n_iter):
        g = grad_f(x)
        if method == 'full':
            noisy_g = g
        elif method == 'sgd':
            noisy_g = g + np.random.normal(scale=noise_scale, size=2)
        elif method == 'minibatch':
            noises = np.random.normal(scale=noise_scale, size=(batch_size, 2))
            noisy_g = g + noises.mean(axis=0)
        x = x - lr * noisy_g
        trajectory.append(x.copy())
    return np.array(trajectory)

# --- Запуск трёх вариантов ---
np.random.seed(42)
start = lambda: np.random.randn(2) * 0.8 + np.array([1.5, -1.5])

traj_full = gradient_descent(start(), lr=0.05, n_iter=100, method='full')
traj_sgd  = gradient_descent(start(), lr=0.04, n_iter=100, method='sgd', noise_scale=0.8)
traj_mb   = gradient_descent(start(), lr=0.045, n_iter=100, method='minibatch', noise_scale=0.8, batch_size=20)

# --- Сетка для визуализации ---
xs = np.linspace(-1, 3, 400)
ys = np.linspace(-3, 1, 400)
X, Y = np.meshgrid(xs, ys)
Z = f((X, Y))

fig = plt.figure(figsize=(12, 6))

# ===== 3D ПЛОТ =====
ax1 = fig.add_subplot(1, 2, 1, projection='3d')
ax1.plot_surface(X, Y, Z, cmap='viridis', alpha=0.4, linewidth=0)
ax1.set_title("3D поверхность функции")
ax1.set_xlabel("x")
ax1.set_ylabel("y")
ax1.set_zlabel("f(x,y)")
ax1.set_box_aspect([1, 1, 0.6])  # растягиваем ось Z
ax1.plot(traj_full[:,0], traj_full[:,1], [f(p) for p in traj_full], color='r', label='Полный')
ax1.plot(traj_sgd[:,0], traj_sgd[:,1], [f(p) for p in traj_sgd], color='orange', label='Стохастический')
ax1.plot(traj_mb[:,0], traj_mb[:,1], [f(p) for p in traj_mb], color='g', label='Пакетный')
ax1.legend()

# ===== КОНТУРНЫЙ ПЛОТ (вид сверху) =====
ax2 = fig.add_subplot(1, 2, 2)
CS = ax2.contour(X, Y, Z, levels=40, cmap='viridis')
ax2.clabel(CS, inline=1, fontsize=8)
ax2.set_title('Вид сверху')
ax2.set_xlabel('x'); ax2.set_ylabel('y')
ax2.plot(traj_full[:,0], traj_full[:,1], 'r-', label='Полный')
ax2.plot(traj_sgd[:,0], traj_sgd[:,1], 'orange', label='Стохастический')
ax2.plot(traj_mb[:,0], traj_mb[:,1], 'g-', label='Пакетный')
ax2.legend()
ax2.set_aspect('equal', adjustable='box')

plt.show()