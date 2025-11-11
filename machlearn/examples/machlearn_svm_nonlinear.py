import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm
from sklearn.datasets import make_circles

# --- 1. Генерация данных ---
# Два кольца, идеально разделимые в нелинейном пространстве
X, y = make_circles(n_samples=200, factor=0.5, noise=0.05, random_state=0)
y = np.where(y == 0, -1, 1)  # переводим метки в {-1, +1}

# --- 2. Обучение нелинейного SVM (hard margin = C -> большое) ---
clf = svm.SVC(kernel='rbf', C=1e6, gamma=1)
clf.fit(X, y)

# --- 3. Построение сетки для визуализации ---
xx, yy = np.meshgrid(
    np.linspace(-1.5, 1.5, 500),
    np.linspace(-1.5, 1.5, 500)
)
Z = clf.decision_function(np.c_[xx.ravel(), yy.ravel()])
Z = Z.reshape(xx.shape)

# --- 4. Визуализация ---
plt.figure(figsize=(7, 7))
plt.contourf(xx, yy, Z > 0, alpha=0.2, cmap=plt.cm.coolwarm, label="Гиперплоскость")
plt.contour(xx, yy, Z, levels=[-1, 0, 1], colors=['blue', 'black', 'red'], linestyles=['--', '-', '--'])

# Обучающие точки
plt.scatter(X[y == 1, 0], X[y == 1, 1], c='r', label='Класс +1', s=40)
plt.scatter(X[y == -1, 0], X[y == -1, 1], c='b', label='Класс -1', s=40)

# Опорные векторы
plt.scatter(clf.support_vectors_[:, 0], clf.support_vectors_[:, 1],
            s=120, facecolors='none', edgecolors='k', linewidths=1.5, label='Опорные векторы')

plt.title("Нелинейный метод опорных векторов с мягким зазором с ядром RBF")
plt.xlabel('$x_1$')
plt.ylabel('$x_2$')
plt.legend()
plt.axis('equal')
try:
    plt.savefig("machlearn/images/machlearn_svm_nonlinear.png")
except Exception as e:
    print("Image machlearn_svm_nonlinear.png was not saved:", repr(e))

