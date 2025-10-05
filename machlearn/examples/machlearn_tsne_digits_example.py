import numpy as np
import matplotlib.pyplot as plt
from sklearn import datasets
from sklearn.manifold import TSNE
from sklearn.preprocessing import StandardScaler

# Загрузка данных
digits = datasets.load_digits()
X = digits.data
y = digits.target

# Стандартизация данных
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Разные значения perplexity для сравнения
perplexity_values = [1, 5, 30, 100]

# Создаем subplots
fig, axes = plt.subplots(2, 2, figsize=(15, 15))
axes = axes.flatten()

for i, perplexity in enumerate(perplexity_values):
    # Выполнение t-SNE с разными значениями perplexity
    tsne = TSNE(
        n_components=2,
        random_state=42,
        perplexity=perplexity,
        max_iter=1000,
        learning_rate=200.0
    )
    X_tsne = tsne.fit_transform(X_scaled)
    
    # Визуализация на соответствующем subplot
    scatter = axes[i].scatter(X_tsne[:, 0], X_tsne[:, 1], c=y, cmap='tab10', alpha=0.7)
    axes[i].set_title(f't-SNE с perplexity={perplexity}')
    axes[i].set_xlabel('t-SNE компонента 1')
    axes[i].set_ylabel('t-SNE компонента 2')
    axes[i].grid(True, alpha=0.3)
    
    # Добавляем colorbar к каждому subplot
    plt.colorbar(scatter, ax=axes[i], label='Цифры')

plt.tight_layout()
try:
    plt.savefig("machlearn/images/machlearn_tsne_digits_example.png")
except Exception as e:
    print("Image machlearn_tsne_digits_example.png was not saved:", repr(e))
plt.show()
