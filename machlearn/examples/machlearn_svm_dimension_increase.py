import numpy as np
import matplotlib.pyplot as plt
from sklearn.svm import SVC
from mpl_toolkits.mplot3d import Axes3D

# --- 1. Генерация данных ---
np.random.seed(0)
n = 150
X = np.random.uniform(-2, 2, (n, 2))
y = np.where(X[:, 0]**2 + X[:, 1]**2 < 1.5, -1, 1)  # круг: внутри -1, снаружи +1

# --- 2. Определяем φ(x) = (x1², x2², √2·x1·x2) ---
def phi(X):
    x1, x2 = X[:, 0], X[:, 1]
    return np.column_stack([x1**2, x2**2, np.sqrt(2) * x1 * x2])

X_phi = phi(X)

# --- 3. Обучаем линейный SVM в пространстве φ ---
clf = SVC(kernel="linear", C=1e5)
clf.fit(X_phi, y)

# --- 4. Визуализация ---
fig = plt.figure(figsize=(12, 5))

# --- (1) Исходное пространство ---
ax1 = fig.add_subplot(121)
ax1.scatter(X[:, 0], X[:, 1], c=y, cmap="coolwarm", s=40, edgecolors='k')
ax1.set_title("Исходное пространство")
ax1.set_xlabel("$x_1$")
ax1.set_ylabel("$x_2$")
ax1.set_aspect("equal")

# --- (2) Пространство признаков φ(x) ---
ax2 = fig.add_subplot(122, projection="3d")
ax2.scatter(X_phi[:, 0], X_phi[:, 1], X_phi[:, 2], c=y, cmap="coolwarm", s=40, edgecolors='k')
ax2.set_title("Пространство $(x_1^2, x_2^2, \\sqrt{2}x_1x_2)$")
ax2.set_xlabel("$x_1^2$")
ax2.set_ylabel("$x_2^2$")
ax2.set_zlabel("$\\sqrt{2}x_1x_2$")

# --- Плоскость разделения ---
xx, yy = np.meshgrid(np.linspace(0, 4, 50), np.linspace(0, 4, 50))
w = clf.coef_[0]
b = clf.intercept_[0]
zz = (-w[0] * xx - w[1] * yy - b) / w[2]

# Маска по допустимому диапазону z
z_min, z_max = -19, 19
zz_masked = np.ma.masked_outside(zz, z_min, z_max)

# Построение поверхности
ax2.plot_surface(xx, yy, zz_masked, alpha=0.5, color='gray')

# Ограничение осей z
ax2.set_zlim(-4, 4)


plt.tight_layout()
try:
    plt.savefig("machlearn/images/machlearn_svm_dimension_increase.png")
except Exception as e:
    print("Image machlearn_svm_dimension_increase.png was not saved:", repr(e))

