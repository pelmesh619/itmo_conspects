import cv2
import numpy as np
import matplotlib.pyplot as plt

from pathlib import Path

from utils import savefig

def threshold_demo(image_path):
    """
    Демонстрирует различные методы пороговой обработки изображения.
    """
    # Загрузка изображения
    img_bgr = cv2.imread(image_path)
    if img_bgr is None:
        print(f"Ошибка: не удалось загрузить изображение по пути {image_path}")
        return

    # Преобразование в grayscale
    gray = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2GRAY)

    # 1. Простой бинарный порог (фиксированное значение 120)
    ret1, thresh_binary = cv2.threshold(gray, 120, 255, cv2.THRESH_BINARY)

    # 2. Инверсный бинарный порог
    ret2, thresh_binary_inv = cv2.threshold(gray, 120, 255, cv2.THRESH_BINARY_INV)

    # 3. Метод Оцу (автоматическое определение порога)
    ret3, thresh_otsu = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

    # 4. Адаптивный порог (среднее арифметическое окрестности)
    thresh_adaptive_mean = cv2.adaptiveThreshold(
        gray, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 11, 2)

    # 5. Адаптивный порог (взвешенная сумма окрестности по гауссу)
    thresh_adaptive_gaussian = cv2.adaptiveThreshold(
        gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)

    # Подготовка к отображению
    images = [
        gray, thresh_binary,
        thresh_adaptive_mean, thresh_adaptive_gaussian
    ]
    titles = [
        'Черно-белый оригинал',
        'Бинарный ($T=120$)',
        'Адаптивный (среднее)',
        'Адаптивный (гаусс)'
    ]

    plt.figure(figsize=(8, 8))
    for i, (img, title) in enumerate(zip(images, titles)):
        plt.subplot(2, 2, i+1)
        plt.imshow(img, cmap='gray')
        plt.title(title)
        plt.axis('off')

    plt.tight_layout()
    savefig("cvmethods_thresholding")

if __name__ == "__main__":
    # Укажите путь к вашему изображению
    image_path = Path(__file__).parent.parent / 'images' / "cvmethods_thresholding_sample.jpg"  # замените на свой путь
    threshold_demo(image_path)