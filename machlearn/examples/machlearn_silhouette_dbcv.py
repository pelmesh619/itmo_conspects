import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs, make_moons
from sklearn.cluster import KMeans, DBSCAN
from sklearn.metrics import silhouette_score, pairwise_distances
import hdbscan


# ================================================================
# 1. Простые данные (blobs)
# ================================================================
X1, _ = make_blobs(
    n_samples=600,
    centers=4,
    cluster_std=0.6,
    random_state=42
)

dist1 = pairwise_distances(X1)

# --- K-Means ---
kmeans1 = KMeans(n_clusters=4, random_state=42)
labels_km1 = kmeans1.fit_predict(X1)
sil_km1 = silhouette_score(X1, labels_km1)
dbcv_km1 = hdbscan.validity.validity_index(dist1, labels_km1)

# --- DBSCAN ---
dbscan1 = DBSCAN(eps=0.7, min_samples=10)
labels_db1 = dbscan1.fit_predict(X1)
mask1 = labels_db1 != -1
sil_db1 = silhouette_score(X1[mask1], labels_db1[mask1]) if len(set(labels_db1[mask1])) > 1 else None
dbcv_db1 = hdbscan.validity.validity_index(dist1, labels_db1)


# ================================================================
# 2. Сложные данные (полумесяцы)
# ================================================================
X2, _ = make_moons(
    n_samples=600,
    noise=0.06,
    random_state=42
)

dist2 = pairwise_distances(X2)

# --- K-Means ---
kmeans2 = KMeans(n_clusters=2, random_state=42)
labels_km2 = kmeans2.fit_predict(X2)
sil_km2 = silhouette_score(X2, labels_km2)
dbcv_km2 = hdbscan.validity.validity_index(dist2, labels_km2)

# --- DBSCAN ---
dbscan2 = DBSCAN(eps=0.2, min_samples=8)
labels_db2 = dbscan2.fit_predict(X2)
mask2 = labels_db2 != -1
sil_db2 = silhouette_score(X2[mask2], labels_db2[mask2]) if len(set(labels_db2[mask2])) > 1 else None
dbcv_db2 = hdbscan.validity.validity_index(dist2, labels_db2)

# ================================================================
# 3. Визуализация всех четырёх кластеризаций
# ================================================================

plt.figure(figsize=(8, 7))

# ---------------- SIMPLE BLOBS ----------------
# -- K-Means --
plt.subplot(2, 2, 1)
plt.scatter(X1[:, 0], X1[:, 1], c=labels_km1, cmap="tab10", s=25)
plt.title(f"Пятна и метод $k$ средних\n$\mathrm{{Silhouette}}={sil_km1:.3f}$, $\mathrm{{DBCV}}={dbcv_km1:.3f}$")
plt.grid(True)

# -- DBSCAN --
plt.subplot(2, 2, 2)
plt.scatter(X1[:, 0], X1[:, 1], c=labels_db1, cmap="tab10", s=25)
plt.title(f"Пятна и DBSCAN\n$\mathrm{{Silhouette}}={sil_db1:.3f}$, $\mathrm{{DBCV}}={dbcv_db1:.3f}$")
plt.grid(True)


# ---------------- MOONS ----------------
# -- K-Means --
plt.subplot(2, 2, 3)
plt.scatter(X2[:, 0], X2[:, 1], c=labels_km2, cmap="tab10", s=25)
plt.title(f"Полумесяцы и метод $k$ средних\n$\mathrm{{Silhouette}}={sil_km2:.3f}$, $\mathrm{{DBCV}}={dbcv_km2:.3f}$")
plt.grid(True)

# -- DBSCAN --
plt.subplot(2, 2, 4)
plt.scatter(X2[:, 0], X2[:, 1], c=labels_db2, cmap="tab10", s=25)
plt.title(f"Полумесяцы и DBSCAN\n$\mathrm{{Silhouette}}={sil_db2:.3f}$, $\mathrm{{DBCV}}={dbcv_db2:.3f}$")
plt.grid(True)

plt.tight_layout()

import utils

utils.savefig('machlearn_silhouette_dbcv')
