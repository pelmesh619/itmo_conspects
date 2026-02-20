import cv2
import numpy as np
import matplotlib.pyplot as plt

from pathlib import Path

from utils import savefig

def gaussian_blur_demo(image_path, kernel_size=(5, 5), sigma=0):
    """
    Применяет гауссово размытие к изображению и показывает результат.

    Параметры:
        image_path (str): путь к изображению
        kernel_size (tuple): размер ядра (ширина, высота), должен быть нечётным положительным числом
        sigma (float): стандартное отклонение по X; если 0, вычисляется автоматически из kernel_size
    """
    # Загрузка изображения в BGR
    img_bgr = cv2.imread(image_path)
    if img_bgr is None:
        print(f"Ошибка: не удалось загрузить изображение по пути {image_path}")
        return

    # Применение гауссовского размытия
    img_blur_bgr = cv2.GaussianBlur(img_bgr, kernel_size, sigma)

    # Преобразование BGR в RGB для отображения в matplotlib
    img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)
    img_blur_rgb = cv2.cvtColor(img_blur_bgr, cv2.COLOR_BGR2RGB)

    # Создание фигуры с двумя подграфиками
    fig, (ax_orig, ax_blur) = plt.subplots(1, 2, figsize=(12, 5))

    # Исходное изображение
    ax_orig.imshow(img_rgb)
    ax_orig.set_title('Оригинал')
    ax_orig.axis('off')

    # Размытое изображение
    ax_blur.imshow(img_blur_rgb)
    ax_blur.set_title(f'Гауссово размытие (ядро {kernel_size[0]}x{kernel_size[1]})')
    ax_blur.axis('off')

    plt.tight_layout()
    savefig("cvmethods_blur")

if __name__ == "__main__":
    # Укажите путь к изображению
    image_path = Path(__file__).parent.parent / 'images' / "cvmethods_blur_sample.jpg"

    # Настройка параметров размытия
    kernel = (7, 7)   # размер ядра (чем больше, тем сильнее размытие)
    sigma = 0         # 0 означает автоматический расчёт

    gaussian_blur_demo(image_path, kernel, sigma)