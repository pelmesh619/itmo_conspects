import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_samples, silhouette_score
import matplotlib.cm as cm

# ==========================
# 1. Генерация данных (blobs)
# ==========================
X, _ = make_blobs(n_samples=500, centers=4, cluster_std=0.6, random_state=42)

# ==========================
# 2. KMeans кластеризация
# ==========================
# KMeans с k=4
k1 = 4
kmeans1 = KMeans(n_clusters=k1, random_state=42)
labels1 = kmeans1.fit_predict(X)
sil_values1 = silhouette_samples(X, labels1)
sil_avg1 = silhouette_score(X, labels1)

# KMeans с k=3
k2 = 5
kmeans2 = KMeans(n_clusters=k2, random_state=42)
labels2 = kmeans2.fit_predict(X)
sil_values2 = silhouette_samples(X, labels2)
sil_avg2 = silhouette_score(X, labels2)

# ==========================
# 3. Визуализация
# ==========================
fig, axes = plt.subplots(2, 2, figsize=(9, 8))
fig.suptitle("Оценка силуэта для метода $k$ средних", fontsize=16)

# --------------------------
# 3.1 Scatter plot k=4
# --------------------------
ax = axes[0, 0]
colors = cm.nipy_spectral(labels1.astype(float)/k1)
ax.scatter(X[:, 0], X[:, 1], c=colors, s=30)
ax.scatter(kmeans1.cluster_centers_[:,0], kmeans1.cluster_centers_[:,1], c="red", s=200, marker="x")
ax.set_title(f"k={k1}")
ax.set_xlabel("$x_1$")
ax.set_ylabel("$x_2$")
ax.grid(True)

# --------------------------
# 3.2 Silhouette plot k=4
# --------------------------
ax = axes[0, 1]
y_lower = 10
for i in range(k1):
    cluster_vals = sil_values1[labels1==i]
    cluster_vals.sort()
    size = cluster_vals.shape[0]
    y_upper = y_lower + size
    color = cm.nipy_spectral(float(i)/k1)
    ax.fill_betweenx(np.arange(y_lower, y_upper), 0, cluster_vals, facecolor=color, edgecolor=color, alpha=0.7)
    ax.text(-0.05, y_lower + size/2, str(i))
    y_lower = y_upper + 10
ax.axvline(x=sil_avg1, color="red", linestyle="--", label=f"Среднее ={sil_avg1:.3f}")
ax.set_title("График оценок силуэта")
ax.set_xlabel("Оценка силуэта")
ax.set_ylabel("Кластер")
ax.legend()

# --------------------------
# 3.3 Scatter plot k=3
# --------------------------
ax = axes[1, 0]
colors = cm.nipy_spectral(labels2.astype(float)/k2)
ax.scatter(X[:, 0], X[:, 1], c=colors, s=30)
ax.scatter(kmeans2.cluster_centers_[:,0], kmeans2.cluster_centers_[:,1], c="red", s=200, marker="x")
ax.set_title(f"k={k2}")
ax.set_xlabel("$x_1$")
ax.set_ylabel("$x_2$")
ax.grid(True)

# --------------------------
# 3.4 Silhouette plot k=3
# --------------------------
ax = axes[1, 1]
y_lower = 10
for i in range(k2):
    cluster_vals = sil_values2[labels2==i]
    cluster_vals.sort()
    size = cluster_vals.shape[0]
    y_upper = y_lower + size
    color = cm.nipy_spectral(float(i)/k2)
    ax.fill_betweenx(np.arange(y_lower, y_upper), 0, cluster_vals, facecolor=color, edgecolor=color, alpha=0.7)
    ax.text(-0.05, y_lower + size/2, str(i))
    y_lower = y_upper + 10
ax.axvline(x=sil_avg2, color="red", linestyle="--", label=f"Среднее = {sil_avg2:.3f}")
ax.set_title("График оценок силуэта")
ax.set_xlabel("Оценка силуэта")
ax.set_ylabel("Кластер")
ax.legend()

plt.tight_layout()

import utils

utils.savefig("machlearn_silhouette_plot")
