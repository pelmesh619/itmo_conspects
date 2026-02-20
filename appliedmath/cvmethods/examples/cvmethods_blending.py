import cv2
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
from utils import savefig

def blend_simple(img1, img2, alpha):
    """Простое линейное смешивание через cv2.addWeighted."""
    return cv2.addWeighted(img1, alpha, img2, 1 - alpha, 0)

def blend_with_mask(img1, img2, alpha, white_thresh=250):
    """
    Смешивание с удалением белых пикселей на втором изображении.
    img1, img2 – RGB-изображения uint8 одинакового размера.
    """
    # Маска не-белых пикселей для img2 (белые = 0, остальное = 255)
    lower = np.array([white_thresh, white_thresh, white_thresh])
    upper = np.array([255, 255, 255])
    mask = cv2.inRange(img2, lower, upper)          # белые = 255
    mask = cv2.bitwise_not(mask)                    # инвертируем: белые = 0, остальное = 255
    mask = mask.astype(np.float32) / 255.0          # [0,1]

    # Наложение с учётом маски
    mask_3ch = cv2.merge([mask, mask, mask])
    blended = (1 - mask_3ch) * img1 + mask_3ch * cv2.addWeighted(img1, alpha, img2, 1 - alpha, 0)
    return blended.astype(np.uint8)

def load_and_prepare(path):
    """Загружает изображение и возвращает RGB (3 канала, uint8)."""
    img = cv2.imread(str(path), cv2.IMREAD_COLOR)  # всегда 3 канала BGR
    if img is None:
        raise FileNotFoundError(f"Не удалось загрузить {path}")
    return cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

def main(mode='mask', alpha=0.6, white_thresh=250, filename=None):
    # Пути к изображениям
    base = Path(__file__).parent.parent / 'images'
    path1 = base / "cvmethods_blending_1.jpg"
    path2 = base / "cvmethods_blending_2.png"

    # Загрузка и приведение к одному размеру
    img1 = load_and_prepare(path1)
    img2 = load_and_prepare(path2)
    img2 = cv2.resize(img2, (img1.shape[1], img1.shape[0]), interpolation=cv2.INTER_LINEAR)

    # Выбор режима смешивания
    if mode == 'simple':
        blended = blend_simple(img1, img2, alpha)
        title = f'Смешивание $\\alpha={alpha}$'
    else:  # mask
        blended = blend_with_mask(img1, img2, alpha, white_thresh)
        title = f'Смешивание с маской'

    # Отображение
    fig, axes = plt.subplots(1, 3, figsize=(10, 4))
    for ax, im, t in zip(axes, [img1, img2, blended],
                         ['Изображение 1', 'Изображение 2', title]):
        ax.imshow(im)
        ax.set_title(t)
        ax.axis('off')
    plt.tight_layout()
    savefig(filename)
    plt.show()

if __name__ == "__main__":
    main(mode='simple', alpha=0.6, white_thresh=250, filename="cvmethods_blending")
    main(mode='mask', alpha=0.5, white_thresh=250, filename="cvmethods_blending_mask")
