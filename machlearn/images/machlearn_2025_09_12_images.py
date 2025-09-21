import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import MinMaxScaler, StandardScaler, RobustScaler

# Генерация двух одномерных выборок с разными характеристиками
np.random.seed(42)
# Синяя выборка (более «нормальная»)
data1 = np.random.normal(loc=50, scale=10, size=1000).reshape(-1, 1)
# Оранжевая выборка с выбросами
normal_part = np.random.normal(loc=80, scale=20, size=950)
outliers = np.random.uniform(low=200, high=300, size=50)  # выбросы
combined = np.concatenate([normal_part, outliers])
data2 = combined.reshape(-1, 1)

# Создаём скейлеры
scalers = {
    'MinMaxScaler': MinMaxScaler(),
    'StandardScaler': StandardScaler(),
    'RobustScaler': RobustScaler()
}

# Масштабированные версии
scaled_data = {
    name: (scaler.fit_transform(data1), scaler.fit_transform(data2))
    for name, scaler in scalers.items()
}

# Построение графиков функций плотности
plt.figure(figsize=(12, 3))

# Оригинальные данные
plt.subplot(1, 4, 1)
sns.kdeplot(data1.ravel(), fill=True)
sns.kdeplot(data2.ravel(), fill=True)
plt.title('Начальные данные')
plt.ylabel('Плотность')

# MinMaxScaler
plt.subplot(1, 4, 2)
sns.kdeplot(scaled_data['MinMaxScaler'][0].ravel(), fill=True)
sns.kdeplot(scaled_data['MinMaxScaler'][1].ravel(), fill=True)
plt.title('Минимальная-максимальная нормализация')
plt.ylabel('Плотность')

# StandardScaler
plt.subplot(1, 4, 3)
sns.kdeplot(scaled_data['StandardScaler'][0].ravel(), fill=True)
sns.kdeplot(scaled_data['StandardScaler'][1].ravel(), fill=True)
plt.title('Стандартизация')
plt.ylabel('Плотность')

# RobustScaler
plt.subplot(1, 4, 4)
sns.kdeplot(scaled_data['RobustScaler'][0].ravel(), fill=True)
sns.kdeplot(scaled_data['RobustScaler'][1].ravel(), fill=True)
plt.title('Robust-масштабирование')
plt.ylabel('Плотность')

plt.tight_layout()
plt.savefig("machlearn/images/machlearn_scalers.png")



# Нормальное распределение
normal_data = np.random.normal(loc=0, scale=1, size=1000)

# Показательное распределение
exp_data = np.random.exponential(scale=1, size=1000)

# Равномерное распределение
uniform_data = np.random.uniform(low=-2, high=2, size=1000)

# Упакуем данные и подписи
samples = [normal_data, exp_data, uniform_data]
labels = ["Нормальное", "Показательное", "Равномерное"]

# Построение графиков: 2 строки (сверху гистограмма, снизу ящик)
fig, axes = plt.subplots(2, 3, figsize=(14, 6), gridspec_kw={"height_ratios": [3, 1]})

for i, (data, label) in enumerate(zip(samples, labels)):
    # Гистограмма как кусочная функция плотности
    axes[0, i].hist(data, bins=30, density=True, color="skyblue", edgecolor="black")
    axes[0, i].set_title(f"{label} распределение")
    axes[0, i].set_ylabel("Плотность")

    # Ящик с усами горизонтально (пониженной высоты)
    axes[1, i].boxplot(data, vert=False, patch_artist=True)
    axes[1, i].set_title(f"Ящик с усами")                  

plt.tight_layout()
plt.savefig("machlearn/images/machlearn_boxplot.png")