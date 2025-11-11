import numpy as np
import matplotlib.pyplot as plt
from sklearn.svm import SVC

# --- 1. Генерация спиральных данных ---
def generate_spiral(n_points, noise=0.2):
    n = np.sqrt(np.random.rand(n_points,1)) * 2*np.pi  # радиус -> угол
    d1x = -np.cos(n)*n + noise*np.random.randn(n_points,1)
    d1y = np.sin(n)*n + noise*np.random.randn(n_points,1)
    d2x = np.cos(n)*n + noise*np.random.randn(n_points,1)
    d2y = -np.sin(n)*n + noise*np.random.randn(n_points,1)
    X = np.vstack([np.hstack([d1x,d1y]), np.hstack([d2x,d2y])])
    y = np.array([0]*n_points + [1]*n_points)
    return X, y

X, y = generate_spiral(100)

# --- 2. Обучение SVM с RBF-ядром ---
clf = SVC(kernel='rbf', C=1.0, gamma=0.5)
clf.fit(X, y)

# --- 3. Визуализация границы ---
xx, yy = np.meshgrid(np.linspace(-10, 10, 300), np.linspace(-10, 10, 300))
Z = clf.decision_function(np.c_[xx.ravel(), yy.ravel()]).reshape(xx.shape)

plt.figure(figsize=(7,7))
plt.contourf(xx, yy, Z, levels=50, cmap='coolwarm', alpha=0.5)
plt.contour(xx, yy, Z, levels=[0], colors='k', linewidths=2)  # граница
plt.scatter(X[:,0], X[:,1], c=y, cmap='coolwarm', s=40, edgecolors='k')
plt.title("Нелинейный SVM на спиральных данных")
plt.xlabel("$x_1$")
plt.ylabel("$x_2$")
plt.gca().set_aspect('equal')
try:
    plt.savefig("machlearn/images/machlearn_svm_nonlinear_2.png")
except Exception as e:
    print("Image machlearn_svm_nonlinear_2.png was not saved:", repr(e))

