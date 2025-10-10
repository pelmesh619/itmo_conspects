import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
import umap.umap_ as umap  # Добавляем импорт UMAP

# Создаем датасет фруктов
fruits_data = {
    'fruit': [
        'Яблоко Гренни', 'Яблоко Гала', 'Яблоко Фуджи', 'Яблоко Ред Делишес', 'Яблоко Голден',
        'Апельсин Валенсия', 'Апельсин Навел', 'Апельсин Кара-Кара', 'Мандарин Клементин', 'Мандарин Сацума',
        'Лимон', 'Лайм', 'Грейпфрут красный', 'Грейпфрут белый', 'Помело'
    ],
    'sweetness': [6, 7, 8, 7, 8, 9, 7, 9, 8, 7, 2, 3, 3, 3, 4],  # Сладость (1-10)
    'acidity':   [3, 3, 2, 2, 2, 3, 3, 2, 3, 4, 9, 8, 8, 7, 5],    # Кислотность (1-10)
    'juiciness': [7, 6, 7, 5, 6, 8, 9, 9, 8.5, 8, 6, 5, 8, 7, 6],  # Сочность (1-10)
    'type': ['Яблоко'] * 5 + ['Апельсин'] * 3 + ['Мандарин'] * 2 + ['Цитрус'] * 5,
    'color': ['red', 'red', 'red', 'red', 'yellow', 
              'orange', 'orange', 'orange', 'orange', 'orange',
              'yellow', 'green', 'pink', 'white', 'green']
}

df = pd.DataFrame(fruits_data)
print("ДАТАСЕТ ФРУКТОВ:")
print(df.to_markdown(index=False))
print("\n" + "="*60)

# Подготовка данных для UMAP
X = df[['sweetness', 'acidity', 'juiciness']].values
labels = df['fruit'].values
fruit_types = df['type'].values
fruit_colors = df['color'].values

# Стандартизация данных
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

print("СТАНДАРТИЗИРОВАННЫЕ ДАННЫЕ:")
scaled_df = pd.DataFrame(X_scaled, columns=['sweetness', 'acidity', 'juiciness'])
scaled_df['fruit'] = labels
scaled_df['type'] = fruit_types
print(scaled_df.round(3))
print("\n" + "="*60)

# Применяем UMAP вместо t-SNE
print("ПРИМЕНЕНИЕ UMAP:")
umap_model = umap.UMAP(n_components=2, random_state=42, n_neighbors=5, min_dist=0.1)
X_umap = umap_model.fit_transform(X_scaled)

# Создаем DataFrame с результатами
results_df = pd.DataFrame({
    'fruit': labels,
    'type': fruit_types,
    'color': fruit_colors,
    'UMAP1': X_umap[:, 0],  # Меняем TSNE1 на UMAP1
    'UMAP2': X_umap[:, 1],  # Меняем TSNE2 на UMAP2
    'sweetness': df['sweetness'],
    'acidity': df['acidity'],
    'juiciness': df['juiciness']
})

print("РЕЗУЛЬТАТЫ UMAP:")
print(results_df[['fruit', 'type', 'UMAP1', 'UMAP2']].round(3))
print("\n" + "="*60)

# Визуализация 1: Раскраска по типу фрукта
plt.figure(figsize=(24, 6))

# Цвета для разных типов фруктов
type_colors = {
    'Яблоко': 'red',
    'Апельсин': 'orange', 
    'Мандарин': 'darkorange',
    'Цитрус': 'yellow'
}

plt.subplot(1, 4, 1)
for fruit_type in np.unique(fruit_types):
    mask = fruit_types == fruit_type
    plt.scatter(X_umap[mask, 0], X_umap[mask, 1],  # Используем X_umap вместо X_tsne
                c=type_colors[fruit_type], label=fruit_type, s=100, alpha=0.7)

# Подписываем точки
for i, fruit in enumerate(labels):
    plt.annotate(fruit, (X_umap[i, 0], X_umap[i, 1]),  # Используем X_umap
                xytext=(5, 5), textcoords='offset points', fontsize=8)

plt.xlabel('UMAP компонента 1')
plt.ylabel('UMAP компонента 2')
plt.title('UMAP: Группировка фруктов по ТИПУ')
plt.legend()
plt.grid(True, alpha=0.3)

# Визуализация 2: Раскраска по сладости
plt.subplot(1, 4, 2)
scatter = plt.scatter(X_umap[:, 0], X_umap[:, 1], c=df['sweetness'],  # Используем X_umap
                     cmap='RdYlGn', s=100, alpha=0.7)

# Подписываем точки
for i, fruit in enumerate(labels):
    plt.annotate(fruit, (X_umap[i, 0], X_umap[i, 1]),  # Используем X_umap
                xytext=(5, 5), textcoords='offset points', fontsize=8)

plt.xlabel('UMAP компонента 1')
plt.ylabel('UMAP компонента 2')
plt.title('UMAP: Интенсивность цвета = СЛАДОСТЬ')
plt.colorbar(scatter, label='Сладость (1-10)')
plt.grid(True, alpha=0.3)

# Визуализация 3: Раскраска по кислотности
plt.subplot(1, 4, 3)
scatter = plt.scatter(X_umap[:, 0], X_umap[:, 1], c=df['acidity'],  # Используем X_umap
                     cmap='RdYlBu_r', s=100, alpha=0.7)

# Подписываем точки
for i, fruit in enumerate(labels):
    plt.annotate(fruit, (X_umap[i, 0], X_umap[i, 1]),  # Используем X_umap
                xytext=(5, 5), textcoords='offset points', fontsize=8)

plt.xlabel('UMAP компонента 1')
plt.ylabel('UMAP компонента 2')
plt.title('UMAP: Интенсивность цвета = КИСЛОТНОСТЬ')
plt.colorbar(scatter, label='Кислотность (1-10)')
plt.grid(True, alpha=0.3)

# Визуализация 4: Раскраска по сочности
plt.subplot(1, 4, 4)
scatter = plt.scatter(X_umap[:, 0], X_umap[:, 1], c=df['juiciness'],  # Используем X_umap
                     cmap='RdYlGn', s=100, alpha=0.7)

# Подписываем точки
for i, fruit in enumerate(labels):
    plt.annotate(fruit, (X_umap[i, 0], X_umap[i, 1]),  # Используем X_umap
                xytext=(5, 5), textcoords='offset points', fontsize=8)

plt.xlabel('UMAP компонента 1')
plt.ylabel('UMAP компонента 2')
plt.title('UMAP: Интенсивность цвета = СОЧНОСТЬ')
plt.colorbar(scatter, label='Сочность (1-10)')
plt.grid(True, alpha=0.3)

plt.tight_layout()
try:
    plt.savefig("machlearn/images/machlearn_umap_example2.png")  # Меняем название файла
except Exception as e:
    print("Image machlearn_umap_example.png was not saved:", repr(e))
plt.show()

# Анализ результатов
print("АНАЛИЗ РЕЗУЛЬТАТОВ UMAP:")
print("\n1. ГРУППИРОВКА ПО ТИПУ ФРУКТОВ:")
print("   • Яблоки образуют компактную группу (красные точки)")
print("   • Апельсины и мандарины близко друг к другу (оранжевые)")
print("   • Цитрусы (лимон, лайм, грейпфруты) образуют свою группу")

print("\n2. ВЛИЯНИЕ СЛАДОСТИ:")
print("   • Самые сладкие фрукты (апельсины) - в одной области")
print("   • Кислые фрукты (лимон, лайм) - в другой области")
print("   • Яблоки занимают промежуточное положение")

print("\n3. ВЛИЯНИЕ КИСЛОТНОСТИ:")
print("   • Лимон и лайм (высокая кислотность) - отдельная группа")
print("   • Сладкие фрукты с низкой кислотностью - противоположная сторона")

# Вычисляем расстояния между группами
apple_mask = fruit_types == 'Яблоко'
citrus_mask = fruit_types == 'Цитрус'

apple_center = np.mean(X_umap[apple_mask], axis=0)  # Используем X_umap
citrus_center = np.mean(X_umap[citrus_mask], axis=0)  # Используем X_umap
distance = np.linalg.norm(apple_center - citrus_center)

print(f"\n4. РАССТОЯНИЕ МЕЖДУ ГРУППАМИ:")
print(f"   • Среднее расстояние между яблоками и цитрусами: {distance:.2f}")

# Дополнительная визуализация: 3D исходные данные vs 2D UMAP
fig = plt.figure(figsize=(12, 5))

# 3D plot исходных данных
ax1 = fig.add_subplot(1, 2, 1, projection='3d')

colors_3d = [type_colors[t] for t in fruit_types]
scatter_3d = ax1.scatter(df['sweetness'], df['acidity'], df['juiciness'], 
                        c=colors_3d, s=100, alpha=0.7)

for i, fruit in enumerate(labels):
    ax1.text(df['sweetness'][i], df['acidity'][i], df['juiciness'][i], 
             fruit, fontsize=8)

ax1.set_xlabel('Сладость')
ax1.set_ylabel('Кислотность')
ax1.set_zlabel('Сочность')
ax1.set_title('Исходные данные в 3D пространстве')

# 2D UMAP проекция
ax2 = fig.add_subplot(1, 2, 2)
for fruit_type in np.unique(fruit_types):
    mask = fruit_types == fruit_type
    ax2.scatter(X_umap[mask, 0], X_umap[mask, 1],  # Используем X_umap
               c=type_colors[fruit_type], label=fruit_type, s=100, alpha=0.7)

for i, fruit in enumerate(labels):
    ax2.annotate(fruit, (X_umap[i, 0], X_umap[i, 1]),  # Используем X_umap
                xytext=(5, 5), textcoords='offset points', fontsize=8)

ax2.set_xlabel('UMAP компонента 1')
ax2.set_ylabel('UMAP компонента 2')
ax2.set_title('UMAP проекция в 2D')
ax2.legend()
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.show()

# Сравнение расстояний между конкретными фруктами
print("СРАВНЕНИЕ РАССТОЯНИЙ МЕЖДУ ФРУКТАМИ:")
print("\n" + "="*50)

# Выбираем несколько пар для сравнения
pairs_to_compare = [
    ('Яблоко Гренни', 'Яблоко Гала'),
    ('Яблоко Гренни', 'Лимон'),
    ('Апельсин Валенсия', 'Мандарин Клементин'),
    ('Апельсин Валенсия', 'Лимон'),
    ('Лимон', 'Лайм')
]

print("Пара фруктов\t\tРасстояние в UMAP\tПохожесть")
print("-" * 60)

for fruit1, fruit2 in pairs_to_compare:
    idx1 = np.where(labels == fruit1)[0][0]
    idx2 = np.where(labels == fruit2)[0][0]
    
    distance = np.linalg.norm(X_umap[idx1] - X_umap[idx2])  # Используем X_umap
    
    # Вычисляем похожесть в исходном пространстве (евклидово расстояние)
    original_distance = np.linalg.norm(X_scaled[idx1] - X_scaled[idx2])
    similarity = 1 / (1 + original_distance)  # Преобразуем в меру похожести
    
    print(f"{fruit1:15} - {fruit2:20} {distance:8.3f}\t\t{similarity:.3f}")

print("\nВЫВОДЫ:")
print("• Близкие в UMAP фрукты имеют похожие характеристики")
print("• Разные типы фруктов хорошо разделяются")
print("• UMAP сохранил как локальные, так и глобальные отношения между фруктами")

# Интерактивное исследование характеристик
print("ДЕТАЛЬНЫЙ АНАЛИЗ ХАРАКТЕРИСТИК:")
print("\n" + "="*50)

# Создаем таблицу с характеристиками и позициями в UMAP
analysis_df = results_df.copy()
analysis_df['sweetness_category'] = pd.cut(analysis_df['sweetness'], 
                                         bins=[0, 4, 7, 10], 
                                         labels=['Кислый', 'Средний', 'Сладкий'])
analysis_df['acidity_category'] = pd.cut(analysis_df['acidity'], 
                                       bins=[0, 3, 6, 10], 
                                       labels=['Низкая', 'Средняя', 'Высокая'])

print("СВОДНАЯ ТАБЛИЦА:")
display_cols = ['fruit', 'type', 'sweetness_category', 'acidity_category', 
                'juiciness', 'UMAP1', 'UMAP2']  # Меняем TSNE на UMAP
print(analysis_df[display_cols].round(3).to_string(index=False))

print("\nЗАКОНОМЕРНОСТИ:")
print("1. СЛАДКИЕ ФРУКТЫ (сладость > 7):")
sweet_fruits = analysis_df[analysis_df['sweetness_category'] == 'Сладкий']
print("   " + ", ".join(sweet_fruits['fruit'].values))

print("\n2. КИСЛЫЕ ФРУКТЫ (кислотность > 6):")
sour_fruits = analysis_df[analysis_df['acidity_category'] == 'Высокая']
print("   " + ", ".join(sour_fruits['fruit'].values))

print("\n3. САМЫЕ СОЧНЫЕ (сочность > 8):")
juicy_fruits = analysis_df[analysis_df['juiciness'] > 8]
print("   " + ", ".join(juicy_fruits['fruit'].values))

# Дополнительный анализ: сравнение с исходными характеристиками
print("\nКОРРЕЛЯЦИЯ С ИСХОДНЫМИ ПРИЗНАКАМИ:")
print("="*50)

# Проверяем корреляцию между осями UMAP и исходными признаками
for i, feature in enumerate(['sweetness', 'acidity', 'juiciness']):
    corr1 = np.corrcoef(X_scaled[:, i], X_umap[:, 0])[0, 1]
    corr2 = np.corrcoef(X_scaled[:, i], X_umap[:, 1])[0, 1]
    print(f"{feature:10} | Корреляция с UMAP1: {corr1:.3f} | с UMAP2: {corr2:.3f}")