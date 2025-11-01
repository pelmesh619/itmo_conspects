import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score

# --- 1. Генерация данных ---
np.random.seed(42)
X = np.linspace(0, 10, 60)[:, None]
func = lambda x: 3 * np.sin(x * 1.5 + 2).ravel() + np.random.normal(0, 1, x.shape[0]) + 5 * np.cos(3 * x).ravel()
y = func(X)

# --- 2. Определим функции ядер ---
def uniform_kernel(u):
    return 0.5 * (np.abs(u) <= 1)

def triangular_kernel(u):
    return (1 - np.abs(u)) * (np.abs(u) <= 1)

def epanechnikov_kernel(u):
    return 0.75 * (1 - u**2) * (np.abs(u) <= 1)

kernels = {
    'Равномерное ядро': [uniform_kernel, 'равномерным ядром'],
    'Треугольное ядро': [triangular_kernel, 'треугольным ядром'],
    'Епанечниково ядро': [epanechnikov_kernel, 'Епанечниковым ядром']
}

# --- 3. Реализация KNN-регрессии с ядром ---
def knn_regression(x_query, X_train, y_train, k, kernel, h):
    distances = np.abs(X_train - x_query)
    nearest_indices = np.argsort(distances, axis=0)[:k].flatten()
    nearest_distances = distances[nearest_indices]
    nearest_y = y_train[nearest_indices]

    weights = kernel(nearest_distances / h).ravel()
    if np.sum(weights) == 0:
        return np.mean(nearest_y)
    
    return np.sum(weights * nearest_y) / np.sum(weights)

# --- 4. Визуализация ---
x_grid = np.linspace(0, 10, 200)
true_y = func(x_grid)
k = 7
h = 2.0

plt.figure(figsize=(8, 9))
for i, (name, (kernel, name2)) in enumerate(kernels.items(), 1):
    y_pred = [knn_regression(x, X, y, k, kernel, h) for x in x_grid]
    r2 = r2_score(true_y, y_pred)

    plt.subplot(3, 1, i)
    plt.scatter(X, y, color='gray', alpha=0.6, label='Данные')
    plt.plot(x_grid, y_pred, color='red', lw=2, label=f'{name}\nR² = {r2:.4f}')
    plt.title(f'KNN-регрессия с {name2} (k={k}, h={h})')
    plt.legend()
    plt.grid(True)

plt.tight_layout()

try:
    plt.savefig("machlearn/images/machlearn_knn_regression.png")
except Exception as e:
    print("Image machlearn_knn_regression.png was not saved:", repr(e))

