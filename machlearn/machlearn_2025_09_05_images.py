import os
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import binom, poisson, uniform, norm, lognorm, expon, t, f, chi2

colors = ["blue", "red", "green"]

parameters = [
    {
        "title": "Функции распределения биномиального распределения",
        "func": binom.cdf,
        "params": [
            {"n": 10, "p": 0.5},
            {"n": 10, "p": 0.8},
            {"n": 10, "p": 0.3},
        ],
        "domain": (-1, 11, 1000),
        "label": r"$B(n={n}, p={p})$",
        "filename": "machlearn_binom.png"
    },
    {
        "title": "Функции распределения распределения Пуассона",
        "func": poisson.cdf,
        "params": [
            {"mu": 1},
            {"mu": 3},
            {"mu": 10},
        ],
        "domain": (-1, 11, 1000),
        "label": r"$\Pi(\lambda={mu})$",
        "filename": "machlearn_poisson.png"
    },
    {
        "title": "Функции плотности равномерного распределения",
        "func": lambda x, a, b: uniform.pdf(x, loc=a, scale=b - a),
        "params": [
            {"a": 1, "b": 3},
            {"a": 4, "b": 5},
            {"a": 2, "b": 8},
        ],
        "domain": (-1, 11, 1000),
        "label": r"$U(a={a}, b={b})$",
        "filename": "machlearn_uniform.png"
    },
    {
        "title": "Функции плотности нормального распределения",
        "func": lambda x, a, sigma: norm.pdf(x, loc=a, scale=sigma),
        "params": [
            {"a": 0, "sigma": 3},
            {"a": 4, "sigma": 3},
            {"a": 0, "sigma": 2},
        ],
        "domain": (-11, 11, 1000),
        "label": r"$N(a={a}, \sigma={sigma})$",
        "filename": "machlearn_norm.png"
    },
    {
        "title": "Функции плотности логнормального распределения",
        "func": lambda x, a, sigma: lognorm.pdf(x, s=sigma, loc=a),
        "params": [
            {"a": 0, "sigma": 1},
            {"a": 4, "sigma": 3},
            {"a": 0, "sigma": 0.1},
        ],
        "domain": (-1, 11, 1000),
        "label": r"$LN(a={a}, \sigma={sigma})$",
        "filename": "machlearn_lognorm.png"
    },
    {
        "title": "Функции плотности показательного распределения",
        "func": lambda x, a: expon.pdf(x, scale=1 / a),
        "params": [
            {"a": 1},
            {"a": 3},
            {"a": 10},
        ],
        "domain": (-1, 11, 1000),
        "label": r"$E(\alpha={a})$",
        "filename": "machlearn_exp.png"
    },
    {
        "title": "Функции плотности распределения Стьюдента",
        "func": lambda x, k: t.pdf(x, k),
        "params": [
            {"k": 1},
            {"k": 3},
            {"k": 20},
        ],
        "domain": (-11, 11, 1000),
        "label": r"$T(k={k})$",
        "filename": "machlearn_student.png"
    },
    {
        "title": "Функции плотности распределения Фишера",
        "func": lambda x, n, m: f.pdf(x, n, m),
        "params": [
            {"n": 1, "m": 1},
            {"n": 3, "m": 1},
            {"n": 1, "m": 3},
        ],
        "domain": (-1, 11, 1000),
        "label": r"$F(n={n}, m={m})$",
        "filename": "machlearn_fisher.png"
    },
    {
        "title": "Функции плотности распределения \"хи-квадрат\"",
        "func": lambda x, k: chi2.pdf(x, k),
        "params": [
            {"k": 1},
            {"k": 3},
            {"k": 5},
        ],
        "domain": (-1, 11, 1000),
        "label": r"$H(k={k})$",
        "filename": "machlearn_chi2.png"
    },
]

for distr in parameters:
    fig, ax = plt.subplots(figsize=(12, 7))

    title, func, params, label = distr['title'], distr['func'], distr['params'], distr['label']
    domain = distr["domain"]
    ax.set_title(title, fontsize=14)

    ax.grid(alpha=0.3)
    for i, p in enumerate(params):
        x = np.linspace(*domain)
        y = func(x, **p)

        ax.plot(x, y, color=colors[i % len(colors)], label=label.format(**p), linewidth=2, alpha=1)

    ax.legend(fontsize=11)
    ax.axhline(y=0, color='gray', linestyle='-', alpha=0.6)
    ax.axvline(x=0, color='gray', linestyle='-', alpha=0.6)

    plt.tight_layout()
    plt.savefig(os.path.join("machlearn", "images", distr["filename"]))


import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs
from scipy import stats

# Создаем фигуру с двумя подграфиками
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))

# Пример 1: Выбросы в одномерных данных
np.random.seed(52)
# Генерируем нормально распределенные данные
data = np.random.normal(0, 1, 1000)
# Добавляем выбросы
outliers_1d_left = np.random.uniform(-8, -5, 8)
outliers_1d_right = np.random.uniform(5, 8, 8)
data_with_outliers = np.concatenate([data, outliers_1d_left, outliers_1d_right])

# Рисуем гистограмму
ax1.hist(data, bins=30, alpha=0.7, color='blue')
ax1.hist(outliers_1d_left, bins=10, alpha=0.7, color='red')
ax1.hist(outliers_1d_right, bins=10, alpha=0.7, color='red')
ax1.set_xlabel('Значение')
ax1.set_ylabel('Частота')
ax1.grid(alpha=0.3)

# Пример 2: Выбросы в двумерных данных
# Генерируем нормальные данные
X, y = make_blobs(n_samples=100, centers=1, cluster_std=1.0, center_box=(0, 0), random_state=42)

# Добавляем выбросы
outliers_2d = np.random.uniform(-10, 10, (10, 2))
X_with_outliers = np.vstack([X, outliers_2d])
y_with_outliers = np.concatenate([y, np.ones(10) * -1])  # Помечаем выбросы как -1

# Рисуем scatter plot
ax2.scatter(X[:, 0], X[:, 1], c='blue', alpha=0.7)
ax2.scatter(outliers_2d[:, 0], outliers_2d[:, 1], c='red', alpha=0.7)
ax2.set_xlabel('Признак 1')
ax2.set_ylabel('Признак 2')
ax2.grid(alpha=0.3)

# Настраиваем общий заголовок
plt.suptitle('Примеры выбросов в датасетах', fontsize=16)
plt.tight_layout()
plt.savefig("machlearn/images/machlearn_outliers.png")
