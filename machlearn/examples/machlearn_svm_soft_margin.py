import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm
from sklearn.datasets import make_classification

# --- 1. Генерируем двумерные данные ---
X, y = make_classification(
    n_samples=40, n_features=2, n_redundant=0, n_informative=2,
    n_clusters_per_class=1, class_sep=1.0, random_state=42
)
y = 2*y - 1  # Преобразуем метки {0,1} → {-1,1}

# --- 2. Настраиваем 3 модели SVM с разными C ---
Cs = [0.1, 1, 100]
models = [svm.SVC(kernel='linear', C=c) for c in Cs]
for model in models:
    model.fit(X, y)

# --- 3. Функция для построения границ ---
def plot_svm(ax, model, title):
    w = model.coef_[0]
    b = model.intercept_[0]
    
    # Решающее уравнение: w·x + b = 0
    xx = np.linspace(X[:,0].min()-1, X[:,0].max()+1, 100)
    yy = -(w[0]*xx + b)/w[1]
    
    # Границы зазора: w·x + b = ±1
    margin = 1 / np.linalg.norm(w)
    yy_up = yy + (w[0]/w[1]) * margin
    yy_down = yy - (w[0]/w[1]) * margin

    # Рисуем
    ax.scatter(X[:,0], X[:,1], c=y, cmap=plt.cm.bwr, s=30, edgecolors='k')
    ax.plot(xx, yy, 'k-', label='Разделяющая прямая')
    ax.plot(xx, yy_up, 'k--')
    ax.plot(xx, yy_down, 'k--')
    ax.set_title(title)
    
    # Отмечаем опорные векторы
    ax.scatter(model.support_vectors_[:,0],
               model.support_vectors_[:,1],
               s=120, facecolors='none', edgecolors='k', linewidths=1.5)

# --- 4. Визуализация ---
fig, axes = plt.subplots(1, 3, figsize=(15, 4))

for ax, model, c in zip(axes, models, Cs):
    plot_svm(ax, model, f"C = {c}")
    ax.set_xlim(X[:,0].min()-1, X[:,0].max()+1)
    ax.set_ylim(X[:,1].min()-1, X[:,1].max()+1)

plt.tight_layout()

try:
    plt.savefig("machlearn/images/machlearn_svm_soft_margin.png")
except Exception as e:
    print("Image machlearn_svm_soft_margin.png was not saved:", repr(e))

