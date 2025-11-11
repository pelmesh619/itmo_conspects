import numpy as np
import matplotlib.pyplot as plt
from sklearn.tree import DecisionTreeRegressor, plot_tree

# --- 1. Данные ---
np.random.seed(42)
X = np.sort(5 * np.random.rand(80, 1), axis=0)
y = np.sin(X).ravel() + np.random.randn(80) * 0.1  # шум

# --- 2. Модели ---
tree2 = DecisionTreeRegressor(max_depth=2, random_state=0)
tree5 = DecisionTreeRegressor(max_depth=5, random_state=0)
tree2.fit(X, y)
tree5.fit(X, y)

# --- 3. Прогноз ---
X_test = np.arange(0.0, 5.0, 0.01)[:, np.newaxis]
y_pred2 = tree2.predict(X_test)
y_pred5 = tree5.predict(X_test)

# --- 4. Визуализация ---
fig, axes = plt.subplots(1, 2, figsize=(12, 5), sharey=True)

# --- Глубина 2 ---
axes[0].scatter(X, y, s=20, edgecolor="k", c="lightblue", label="данные")
axes[0].plot(X_test, np.sin(X_test), color="green", linewidth=2, label="истинная sin(x)")
axes[0].plot(X_test, y_pred2, color="red", linewidth=2, label="дерево глубины 2")
axes[0].set_title("Регрессионное дерево (глубина = 2)")
axes[0].set_xlabel("x")
axes[0].set_ylabel("y")
axes[0].legend()
axes[0].grid(alpha=0.3)

# --- Глубина 5 ---
axes[1].scatter(X, y, s=20, edgecolor="k", c="lightblue", label="данные")
axes[1].plot(X_test, np.sin(X_test), color="green", linewidth=2, label="истинная sin(x)")
axes[1].plot(X_test, y_pred5, color="orange", linewidth=2, label="дерево глубины 5")
axes[1].set_title("Регрессионное дерево (глубина = 5)")
axes[1].set_xlabel("x")
axes[1].legend()
axes[1].grid(alpha=0.3)

plt.tight_layout()
try:
    plt.savefig("machlearn/images/machlearn_regression_tree.png")
except Exception as e:
    print("Image machlearn_regression_tree.png was not saved:", repr(e))

# --- 5. Визуализация самих деревьев ---
fig, axes = plt.subplots(1, 2, figsize=(15, 6))
plot_tree(tree2, filled=True, feature_names=["x"], rounded=True, ax=axes[0])
axes[0].set_title("Структура дерева глубины 2")

plot_tree(tree5, filled=True, feature_names=["x"], rounded=True, ax=axes[1])
axes[1].set_title("Структура дерева глубины 5")
try:
    plt.savefig("machlearn/images/machlearn_regression_tree_structure.png")
except Exception as e:
    print("Image machlearn_regression_tree_structure.png was not saved:", repr(e))

