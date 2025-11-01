import numpy as np
from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_curve, auc, precision_recall_curve, average_precision_score, roc_auc_score
import matplotlib.pyplot as plt

# Генерируем синтетические данные с сильным дисбалансом (пример: 90% негативных, 10% позитивных)
X, y = make_classification(n_samples=1000, n_features=10, n_informative=3, n_redundant=1, 
                           n_clusters_per_class=1, weights=[0.9, 0.1], flip_y=0.03, random_state=42)

# Разделяем на train/test, чтобы симулировать реальную ситуацию
X_train, X_test, y_train, y_test = train_test_split(X, y, stratify=y, test_size=0.3, random_state=42)

# Обучаем простой логистический регрессор
model = LogisticRegression(solver='liblinear', random_state=42)
model.fit(X_train, y_train)

# Получаем вероятности для положительного класса
y_scores = model.predict_proba(X_test)[:, 1]

# ROC
fpr, tpr, roc_thresholds = roc_curve(y_test, y_scores)
roc_auc = auc(fpr, tpr)  # или roc_auc_score(y_test, y_scores)

f, ax = plt.subplots(1, 2, figsize=(12,6))

ax[0].plot(fpr, tpr, label=f'ROC (AUC = {roc_auc:.3f})')
ax[0].plot([0, 1], [0, 1], linestyle='--', label='Random classifier')
ax[0].set_xlabel('Частота ложноположительных')
ax[0].set_ylabel('Частота истинно положительных')
ax[0].set_title('ROC-кривая')
ax[0].grid(True)

# PR (Precision-Recall)
precision, recall, pr_thresholds = precision_recall_curve(y_test, y_scores)
pr_auc = average_precision_score(y_test, y_scores)  # площадь под PR-кривой (average precision)

ax[1].plot(recall, precision, label=f'PR curve (AP = {pr_auc:.3f})')
# добавим горизонтальную линию, показывающую уровень случайного угадывания (доля положительных в тесте)
pos_rate = np.mean(y_test)
ax[1].hlines(pos_rate, xmin=0, xmax=1, linestyle='--', label=f'Baseline (pos_rate = {pos_rate:.3f})')
ax[1].set_xlabel('Запоминание')
ax[1].set_ylabel('Точность')
ax[1].set_title('PR-кривая')
ax[1].grid(True)
try:
    plt.savefig("machlearn/images/machlearn_roc_pr_curve.png")
except Exception as e:
    print("Image machlearn_roc_pr_curve.png was not saved:", repr(e))

# Печатаем ключевые значения для справки
print(f"ROC AUC: {roc_auc:.3f}")
print(f"PR AUC (Average Precision): {pr_auc:.3f}")
print(f"Positive class rate in test set: {pos_rate:.3f}")
