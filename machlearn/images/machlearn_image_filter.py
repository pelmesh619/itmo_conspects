import numpy as np
from PIL import Image
import matplotlib.pyplot as plt

def load_and_prepare_image(image_path):
    """Загружает изображение и преобразует в нужный формат"""
    img = Image.open(image_path)
    
    img = img.convert('RGB')
    
    img_array = np.array(img)
    
    print(f"Изображение загружено: {img_array.shape}")
    print(f"Размер: {img.size}, Режим: {img.mode}")
    
    return img, img_array

def apply_simple_filters(image_array):
    """Применяет несколько базовых фильтров"""
    
    filters = {        
        # Размытие
        'blur': np.ones((5, 5)) / 25,
        
        # Повышение резкости
        'sharpen': np.array([
            [0, -1, 0],
            [-1, 5, -1],
            [0, -1, 0]
        ]),

        # Обнаружение границ
        'edges': np.array([
            [0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0],
            [1, 1, -8, 1, 1],
            [0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0]
        ]),
    }

    def apply_convolution(image, kernel):
        from scipy import signal
        return signal.convolve2d(image, kernel, mode='same', boundary='symm')

    if len(image_array.shape) == 3:
        channels = [image_array[:, :, 0], image_array[:, :, 1], image_array[:, :, 2]]
    else:
        channels = [image_array]

    results = {'original': image_array}
    
    for name, kernel in filters.items():
        result = []
        for ch in channels:
            try:
                filtered = apply_convolution(ch, kernel)
                filtered = np.clip(filtered, 0, 255).astype(np.uint8)
                result.append(filtered)
            except Exception as e:
                print(f"Ошибка с фильтром {name}: {e}")
        print(f"Применен фильтр: {name}")
        
        filtered_color = np.stack(result, axis=2)
        results[name] = filtered_color
    
    return results

def visualize_results(results):
    """Визуализирует результаты"""
    num_filters = len(results)
    cols = 3
    rows = (num_filters + cols - 1) // cols
    
    plt.figure(figsize=(15, 5 * rows))
    
    for idx, (name, image) in enumerate(results.items(), 1):
        plt.subplot(rows, cols, idx)
        if len(image.shape) == 2:
            plt.imshow(image, cmap='gray')
        else:
            plt.imshow(image)
        plt.title(name)
        plt.axis('off')
    
    plt.tight_layout()
    plt.show()

def save_results(results):
    """Сохраняет результаты в файлы"""
    for name, image in results.items():
        if name == 'original':
            continue
        
        if len(image.shape) == 2:
            img_to_save = Image.fromarray(image, mode='L')
        else:
            img_to_save = Image.fromarray(image, mode='RGB')
        
        filename = f"machlearn/images/machlearn_sample_{name}.jpg"
        img_to_save.save(filename)
        print(f"Сохранено: {filename}")

def main():
    image_path = "machlearn/images/machlearn_sample_image.jpg"
    
    try:
        print("Загрузка изображения...")
        img, img_array = load_and_prepare_image(image_path)
        
        print("Применение фильтров...")
        results = apply_simple_filters(img_array)
        
        print("Визуализация...")
        visualize_results(results)
        
        print("Сохранение результатов...")
        save_results(results)
        
    except FileNotFoundError:
        print(f"Ошибка: Файл '{image_path}' не найден!")
        print("Пожалуйста, укажите правильный путь к изображению.")
    except Exception as e:
        print(f"Ошибка: {e}")

if __name__ == "__main__":
    main()