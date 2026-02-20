import cv2
import numpy as np
import matplotlib.pyplot as plt

from pathlib import Path

from utils import savefig

def compute_gradient(image_path, ksize=3):
    """
    Вычисляет градиент изображения по Собелю и отображает:
    - исходное изображение (grayscale)
    - градиент по оси X
    - градиент по оси Y
    - магнитуду градиента
    """
    # Загрузка изображения
    img_bgr = cv2.imread(image_path)
    if img_bgr is None:
        print(f"Ошибка: не удалось загрузить {image_path}")
        return

    # Преобразование в оттенки серого
    gray = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2GRAY)

    # Вычисление градиента по X и Y с помощью оператора Собеля
    grad_x = cv2.Sobel(gray, cv2.CV_64F, 1, 0, ksize=ksize)
    grad_y = cv2.Sobel(gray, cv2.CV_64F, 0, 1, ksize=ksize)

    # Вычисление магнитуды (абсолютной величины) градиента
    magnitude = np.sqrt(grad_x**2 + grad_y**2)

    # Нормализация для отображения (приводим к диапазону 0-255)
    grad_x_abs = cv2.convertScaleAbs(grad_x)
    grad_y_abs = cv2.convertScaleAbs(grad_y)

    # Отображение результатов
    plt.figure(figsize=(12, 5))

    plt.subplot(1, 3, 1)
    plt.imshow(gray, cmap='gray')
    plt.title('Исходное')
    plt.axis('off')

    plt.subplot(1, 3, 2)
    plt.imshow(grad_x_abs, cmap='gray')
    plt.title('Оператор Собеля по X')
    plt.axis('off')

    plt.subplot(1, 3, 3)
    plt.imshow(grad_y_abs, cmap='gray')
    plt.title('Оператор Собеля по Y')
    plt.axis('off')


    plt.tight_layout()
    savefig("cvmethods_gradient")

if __name__ == "__main__":
    # Укажите путь к вашему изображению
    image_path = Path(__file__).parent.parent / 'images' / "cvmethods_gradient_sample.jpg"
    compute_gradient(image_path, ksize=3)