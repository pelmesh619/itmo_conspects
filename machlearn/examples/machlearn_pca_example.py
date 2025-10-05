import numpy as np
import pandas as pd
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt

# Создаем данные с контролируемой корреляцией
np.random.seed(42)

# Базовые переменные
n_samples = 10
base = np.random.normal(0, 1, n_samples)

# Создаем три признака с разной степенью корреляции
# Чтобы первая компонента объясняла ~60% дисперсии, 
# нужно чтобы признаки были менее скоррелированы

data = {
    'hours_studied': base + np.random.normal(6, 1.5, n_samples),  # Увеличиваем шум
    'practice_problems': base * 0.7 + np.random.normal(4, 1.2, n_samples),  # Средняя корреляция
    'sleep_hours': np.random.normal(8, 1, n_samples)  # Почти независимый признак
}

df = pd.DataFrame(data)
print("Исходные данные:")
print(df.to_markdown())
print("\nКорреляционная матрица:")
print(df.corr().to_markdown())
print("\n" + "="*50)

# Шаг 1: Стандартизация данных (очень важно для PCA!)
scaler = StandardScaler()
scaled_data = scaler.fit_transform(df)

print("Стандартизированные данные (среднее=0, std=1):")
scaled_df = pd.DataFrame(scaled_data, columns=df.columns)
print(scaled_df)
print("\n" + "="*50)

# Шаг 2: Применяем PCA
pca = PCA()
pca_result = pca.fit_transform(scaled_data)

# Шаг 3: Анализируем результаты
print("Главные компоненты (собственные векторы):")
components_df = pd.DataFrame(
    pca.components_.T,
    columns=[f'PC{i+1}' for i in range(3)],
    index=df.columns
)
print(components_df.to_markdown())
print("\n" + "="*50)

print("Объясненная дисперсия каждой компоненты:")
explained_variance = pca.explained_variance_ratio_
for i, var in enumerate(explained_variance):
    print(f"PC{i+1}: {var:.3f} ({var*100:.1f}%)")

print(f"\nСуммарная объясненная дисперсия:")
print(f"PC1 + PC2: {sum(explained_variance[:2]):.3f} ({sum(explained_variance[:2])*100:.1f}%)")
print(f"Все компоненты: {sum(explained_variance):.3f}")
print("\n" + "="*50)

# Создаем датафрейм с PCA результатами
pca_df = pd.DataFrame(pca_result, columns=[f'PC{i+1}' for i in range(3)])

print("Данные после PCA (новые координаты):")
print(pca_df)
print("\n" + "="*50)

# Визуализация
fig = plt.figure(figsize=(15, 5))

# 1. Объясненная дисперсия
plt.subplot(1, 3, 2)
plt.bar(range(1, 4), explained_variance, alpha=0.7)
plt.plot(range(1, 4), np.cumsum(explained_variance), 'ro-')
plt.xlabel('Главные компоненты')
plt.ylabel('Объясненная дисперсия')
plt.title('Объясненная дисперсия по компонентам')
plt.legend(['Кумулятивная', 'Индивидуальная'])
plt.grid(True, alpha=0.3)

# 2. Данные в пространстве PC1-PC2
plt.subplot(1, 3, 1)
plt.scatter(pca_df['PC1'], pca_df['PC2'], s=100, alpha=0.7)
for i in range(len(pca_df)):
    plt.annotate(f'{i+1}', (pca_df['PC1'][i], pca_df['PC2'][i]), 
                 xytext=(5, 5), textcoords='offset points')
plt.xlabel(f'PC1 ({explained_variance[0]*100:.1f}%)')
plt.ylabel(f'PC2 ({explained_variance[1]*100:.1f}%)')
plt.title('Данные в пространстве PC1-PC2')
plt.grid(True, alpha=0.3)

# 3. Нагрузки признаков (feature loadings)
plt.subplot(1, 3, 3)
colors = ['red', 'blue', 'green']
for i, feature in enumerate(df.columns):
    plt.arrow(0, 0, pca.components_[0, i], pca.components_[1, i], 
              color=colors[i], alpha=0.7, width=0.02, head_width=0.05)
    plt.text(pca.components_[0, i]*1.15, pca.components_[1, i]*1.15, 
             feature, color=colors[i], ha='center', va='center')
plt.xlim(-1, 1)
plt.ylim(-1, 1)
plt.xlabel('PC1')
plt.ylabel('PC2')
plt.title('Направления исходных признаков\nв пространстве PC1-PC2')
plt.grid(True, alpha=0.3)
plt.axhline(y=0, color='k', linestyle='-', alpha=0.3)
plt.axvline(x=0, color='k', linestyle='-', alpha=0.3)

plt.tight_layout()
try:
    plt.savefig("machlearn/images/machlearn_pca_example.png")
except Exception as e:
    print("Image machlearn_pca_example.png was not saved:", repr(e))
plt.show()
