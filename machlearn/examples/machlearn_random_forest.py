import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_moons
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier

# --- Генерация данных ---
X, y = make_moons(n_samples=300, noise=0.25, random_state=42)

# --- Модели ---
tree = DecisionTreeClassifier(max_depth=None, random_state=0)
forest = RandomForestClassifier(n_estimators=50, random_state=0)

tree.fit(X, y)
forest.fit(X, y)

# --- Сетка для визуализации ---
xx, yy = np.meshgrid(np.linspace(-1.5, 2.5, 300),
                     np.linspace(-1.0, 1.5, 300))

Z_tree = tree.predict(np.c_[xx.ravel(), yy.ravel()]).reshape(xx.shape)
Z_forest = forest.predict(np.c_[xx.ravel(), yy.ravel()]).reshape(xx.shape)

# --- Визуализация ---
fig, axes = plt.subplots(1, 2, figsize=(10, 4))

# Дерево
axes[0].contourf(xx, yy, Z_tree, alpha=0.3, cmap='coolwarm')
axes[0].scatter(X[:, 0], X[:, 1], c=y, cmap='coolwarm', edgecolor='k')
axes[0].set_title("Одно дерево решений")

# Лес
axes[1].contourf(xx, yy, Z_forest, alpha=0.3, cmap='coolwarm')
axes[1].scatter(X[:, 0], X[:, 1], c=y, cmap='coolwarm', edgecolor='k')
axes[1].set_title("Случайный лес (50 деревьев)")

try:
    plt.savefig("machlearn/images/machlearn_tree_vs_forest.png")
except Exception as e:
    print("Image machlearn_tree_vs_forest.png was not saved:", repr(e))

