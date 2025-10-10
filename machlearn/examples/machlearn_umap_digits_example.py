import numpy as np
import matplotlib.pyplot as plt
from sklearn import datasets
from sklearn.preprocessing import StandardScaler
import umap.umap_ as umap  # Добавляем импорт UMAP

# Загрузка данных
digits = datasets.load_digits()
X = digits.data
y = digits.target

# Стандартизация данных
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Разные значения n_neighbors и min_dist для сравнения
n_neighbors_values = [5, 15, 50]  # Малое, среднее, большое
min_dist_values = [0.01, 0.1, 0.5]  # Малое, среднее, большое

# Создаем subplots 3x3
fig, axes = plt.subplots(3, 3, figsize=(18, 15))
axes = axes.flatten()

plot_index = 0
for n_neighbors in n_neighbors_values:
    for min_dist in min_dist_values:
        # Выполнение UMAP с разными параметрами
        umap_model = umap.UMAP(
            n_components=2,
            random_state=42,
            n_neighbors=n_neighbors,
            min_dist=min_dist,
            metric='euclidean'
        )
        X_umap = umap_model.fit_transform(X_scaled)
        
        # Визуализация на соответствующем subplot
        scatter = axes[plot_index].scatter(X_umap[:, 0], X_umap[:, 1], c=y, 
                                         cmap='tab10', alpha=0.7, s=20)
        axes[plot_index].set_title(f'UMAP: n_neighbors={n_neighbors}, min_dist={min_dist}', 
                                 fontsize=11)
        axes[plot_index].set_xlabel('UMAP компонента 1')
        axes[plot_index].set_ylabel('UMAP компонента 2')
        axes[plot_index].grid(True, alpha=0.3)
        
        plot_index += 1

# Добавляем общий colorbar
fig.subplots_adjust(right=0.9)
cbar_ax = fig.add_axes([0.92, 0.15, 0.02, 0.7])
fig.colorbar(scatter, cax=cbar_ax, label='Цифры')

# plt.tight_layout()
try:
    plt.savefig("machlearn/images/machlearn_umap_digits_example.png", 
                bbox_inches='tight', dpi=150)
except Exception as e:
    print("Image machlearn_umap_digits_example.png was not saved:", repr(e))
# plt.show()
