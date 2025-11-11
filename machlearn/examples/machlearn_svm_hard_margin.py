import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm
from sklearn.datasets import make_blobs

# Генерируем линейно разделимые данные
X, y = make_blobs(n_samples=30, centers=2, random_state=6, cluster_std=1.2)
y = np.where(y == 0, -1, 1)  # Преобразуем метки в {-1, 1}

# Обучаем линейный SVM
clf = svm.SVC(kernel='linear', C=1e5)
clf.fit(X, y)

# Получаем параметры разделяющей гиперплоскости
w = clf.coef_[0]
b = clf.intercept_[0]

# Строим разделяющую линию и margin
xx = np.linspace(X[:, 0].min() - 1, X[:, 0].max() + 1, 100)
yy = -(w[0] / w[1]) * xx - b / w[1]
margin = 1 / np.sqrt(np.sum(w ** 2))
yy_down = yy - np.sqrt(1 + (w[0]/w[1])**2) * margin
yy_up = yy + np.sqrt(1 + (w[0]/w[1])**2) * margin

# Визуализация
plt.figure(figsize=(7, 6))
plt.scatter(X[:, 0], X[:, 1], c=y, cmap=plt.cm.bwr, s=60, edgecolors='k')
plt.scatter(clf.support_vectors_[:, 0], clf.support_vectors_[:, 1],
            s=150, facecolors='none', edgecolors='k', linewidths=1.5, label='Опорные векторы')

plt.plot(xx, yy, 'k-', label='Гиперплоскость')
plt.plot(xx, yy_down, 'k--', label='Зазор')
plt.plot(xx, yy_up, 'k--')

plt.xlim(X[:, 0].min() - 1, X[:, 0].max() + 1)
plt.ylim(X[:, 1].min() - 1, X[:, 1].max() + 1)
plt.xlabel('$x_1$')
plt.ylabel('$x_2$')
plt.title('Линейный метод опорных векторов с жестким зазором')
plt.legend()
plt.grid(alpha=0.3)

try:
    plt.savefig("machlearn/images/machlearn_svm_hard_margin.png")
except Exception as e:
    print("Image machlearn_svm_hard_margin.png was not saved:", repr(e))

print(w, np.linalg.norm(w))
