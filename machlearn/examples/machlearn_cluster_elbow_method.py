import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.datasets import make_blobs

import utils

# 1. Генерация данных
X, _ = make_blobs(
    n_samples=1000,
    centers=5,
    cluster_std=0.7,
    random_state=44
)

# 2. Считаем WCSS (inertia) для разных k
wcss = []
K = range(1, 11)

for k in K:
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X)
    wcss.append(kmeans.inertia_)

f, ax = plt.subplots(1, 2, figsize=(11, 5))

# 3. Визуализация метода локтя
ax[0].scatter(X[:, 0], X[:, 1], s=30)
ax[0].grid(True)
ax[0].set_title("Исходная выборка")

ax[1].plot(K, wcss, marker='o', linewidth=2)
ax[1].set_title("Метод локтя для метода $k$ средних")
ax[1].set_xlabel("Количество кластеров $k$")
ax[1].set_ylabel(r"$\mathrm{WCSS}$")
ax[1].grid(True)

plt.tight_layout()

utils.savefig("machlearn_cluster_elbow_method")
