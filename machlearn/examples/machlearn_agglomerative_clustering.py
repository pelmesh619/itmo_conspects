import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
from sklearn.cluster import AgglomerativeClustering
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster
import matplotlib.image as mpimg

# -----------------------------
# Данные
# -----------------------------
X = np.array([
    (5.1597031034831, 6.5562120239177),
    (4.9544260918946, 5.7607636040125),
    (6.5196633052564, 7.1463834322344),
    (6.84, 6.08),
    (1.9779094238623, 2.5789699243918),
    (1.6956535329282, 1.6039041193467),
    (3.2352311198415, 1.706542625141),
    (11.6561799995282, 4.0366211677058),
    (10.7167711267422, 3.9817590884631),
    (11.6759196134074, 3.256549257082),
    (10.5296202025149, 2.0868559806611)
])

# -----------------------------
# Кластеризация
# -----------------------------
n_clusters = 3
agg = AgglomerativeClustering(n_clusters=n_clusters, linkage='ward')
labels = agg.fit_predict(X)

# Цвета для кластеров
cluster_colors = ["#1f77b4", "#ff7f0e", "#2ca02c"]
leaf_colors = [cluster_colors[l] for l in labels]

# -----------------------------
# Дендрограмма
# -----------------------------
linked = linkage(X, method='ward')

fig = plt.figure(figsize=(10, 5))

plt.subplot(1, 2, 2)
dendrogram(
    linked,
    labels=np.arange(len(X)),
    leaf_rotation=90,
    leaf_font_size=10,
    link_color_func=lambda k: "black"
)

# Перекрашиваем листья
ax = plt.gca()
for lbl in ax.get_xmajorticklabels():
    idx = int(lbl.get_text())
    lbl.set_color(leaf_colors[idx])

plt.title("Дендрограмма")    
plt.xlabel("Объекты")
plt.ylabel("Расстояние")

# -----------------------------
# Scatter plot кластеров
# -----------------------------
plt.subplot(1, 2, 1)
plt.scatter(X[:, 0], X[:, 1], c=[cluster_colors[l] for l in labels], s=70)
plt.title("Агломеративная кластеризация")
plt.grid(True)
plt.xlabel("$x_1$")
plt.ylabel("$x_2$")

# -----------------------------
# Функция для эллипсов
# -----------------------------
def plot_cluster_ellipse(ax, points, color, alpha=0.25):
    if len(points) < 2:
        return

    mean = points.mean(axis=0)
    cov = np.cov(points.T)

    vals, vecs = np.linalg.eigh(cov)
    order = vals.argsort()[::-1]
    vals, vecs = vals[order], vecs[:, order]

    width, height = 2 * np.sqrt(vals)
    angle = np.degrees(np.arctan2(*vecs[:, 0][::-1]))

    ell = Ellipse(mean, width, height, angle=angle,
                  color=color, alpha=alpha, linewidth=2)
    ax.add_patch(ell)

plt.tight_layout()

import utils

utils.savefig("machlearn_agglomerative_clustering1")

