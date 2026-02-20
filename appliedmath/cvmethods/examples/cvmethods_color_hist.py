import cv2
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

from utils import savefig

def plot_image_with_histogram(image_path):
    """
    Загружает изображение по указанному пути, строит его цветовую гистограмму
    и отображает рядом с исходным изображением.
    """
    # Загрузка изображения с помощью OpenCV (BGR порядок каналов)
    img_bgr = cv2.imread(image_path)
    if img_bgr is None:
        print(f"Ошибка: не удалось загрузить изображение по пути {image_path}")
        return

    # Преобразование BGR в RGB для корректного отображения в matplotlib
    img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)

    # Определяем, цветное ли изображение (3 канала) или grayscale (1 канал)
    if len(img_bgr.shape) == 3 and img_bgr.shape[2] == 3:
        channels = ('r', 'g', 'b')
        colors = ('red', 'green', 'blue')
        # Вычисляем гистограммы для каждого канала
        hist_data = []
        for i, color in enumerate(channels):
            hist = cv2.calcHist([img_rgb], [i], None, [256], [0, 256])
            hist_data.append(hist)
    else:
        # Grayscale изображение
        channels = ('gray',)
        colors = ('gray',)
        hist = cv2.calcHist([img_rgb], [0], None, [256], [0, 256])
        hist_data = [hist]

    # Создание фигуры с двумя подграфиками
    fig, (ax_img, ax_hist) = plt.subplots(1, 2, figsize=(12, 5))

    # Отображение изображения
    ax_img.imshow(img_rgb)
    ax_img.set_title('Изображение')
    ax_img.axis('off')

    # Построение гистограммы
    for hist, color in zip(hist_data, colors):
        ax_hist.plot(hist, color=color, label=f'{"Красный" if color.upper() == "RED" else "Зеленый" if color.upper() == "GREEN" else "Синий"} канал')

    ax_hist.set_title('Цветовая гистограмма')
    ax_hist.set_xlabel('Интенсивность пикселя')
    ax_hist.set_ylabel('Количество пикселей')
    ax_hist.legend()
    ax_hist.grid(True, linestyle='--', alpha=0.7)

    plt.tight_layout()
    savefig("cvmethods_color_hist")

def equalize_hist_color(image_path):
    # Загрузка изображения
    img_bgr = cv2.imread(image_path)
    if img_bgr is None:
        print("Ошибка загрузки")
        return

    # Преобразование BGR -> HSV
    img_hsv = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2HSV)

    # Эквализация только канала V (яркость)
    img_hsv[:, :, 2] = cv2.equalizeHist(img_hsv[:, :, 2])

    # Обратное преобразование HSV -> BGR
    img_equalized = cv2.cvtColor(img_hsv, cv2.COLOR_HSV2BGR)

    # Отображение результатов
    img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)
    img_eq_rgb = cv2.cvtColor(img_equalized, cv2.COLOR_BGR2RGB)
    
    
    img_wrong_equalized = img_bgr.copy()

    img_wrong_equalized[:, :, 0] = cv2.equalizeHist(img_wrong_equalized[:, :, 0])
    img_wrong_equalized[:, :, 1] = cv2.equalizeHist(img_wrong_equalized[:, :, 1])
    img_wrong_equalized[:, :, 2] = cv2.equalizeHist(img_wrong_equalized[:, :, 2])

    img_wrong_eq_rgb = cv2.cvtColor(img_wrong_equalized, cv2.COLOR_BGR2RGB)

    plt.figure(figsize=(12,5))
    plt.subplot(1,3,1)
    plt.imshow(img_rgb)
    plt.title('Оригинал')
    plt.axis('off')

    plt.subplot(1,3,2)
    plt.imshow(img_eq_rgb)
    plt.title('После эквализации (V-канал)')
    plt.axis('off')

    plt.subplot(1,3,3)
    plt.imshow(img_wrong_eq_rgb)
    plt.title('После эквализации (RGB-каналы)')
    plt.axis('off')
    savefig("cvmethods_color_hist_equalization")


if __name__ == "__main__":
    # Укажите путь к вашему изображению
    image_path = Path(__file__).parent.parent / 'images' / "cvmethods_color_hist_sample.jpg"
    plot_image_with_histogram(image_path)
    equalize_hist_color(image_path)
    # equalize_wrong_hist_color(image_path)
