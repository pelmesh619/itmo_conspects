import math
import numpy as np
import matplotlib.pyplot as plt

# Функция с двумя минимумами
def f(x):
    return (x**4 / 120 + x**3 / 90 - x**2 * 5 / 12 - x * 5 / 6) / 1.2

# Производная (градиент)
def df(x):
    return (x + 1) * (x - 5) * (x + 5) / 30 / 1.2

# Параметры градиентного спуска
learning_rates = [0.3, 1, 1.5, 2]
x0 = -8           # начальная точка
n_iter = 8        # число итераций

x_lim = -10, 10

# Подготовим график функции
x = np.linspace(*x_lim, 400)
y = f(x)
plt.figure(figsize=(10, 6))
plt.plot(x, y, 'k-', label='Функция f(x)')

# Для каждой скорости обучения проведем спуск
for lr in learning_rates:
    x_curr = x0
    path = [x_curr]
    for i in range(n_iter):
        if x_curr > 1e9:
            break
        grad = df(x_curr)
        x_curr = x_curr - lr * grad
        path.append(x_curr)
    
    path = np.array(path)
    plt.plot(path, f(path), 'o-', label=f'lr={lr}', alpha=0.7)

plt.xlim(x_lim[0] - 0.5, x_lim[1] + 0.5)
plt.ylim(-10, 20)
plt.title('Градиентный спуск при разных скоростях спуска lr')
plt.xlabel('x')
plt.ylabel('f(x)')
plt.legend()
plt.grid(True)

try:
    plt.savefig("machlearn/images/machlearn_gradient_descent.png")
except Exception as e:
    print("Image machlearn_gradient_descent.png was not saved:", repr(e))



plt.figure(figsize=(10, 6))
plt.plot(x, y, 'k-', label='Функция f(x)')
learning_rates = [
    (lambda i: math.e ** (-i), "$e^{-i}$"), 
    (lambda i: 1 - i / 20, "$1 - \\frac{i}{20}$"), 
    (lambda i: 1 / (1 + i / 5), "$\\frac{1}{1 + 0.2 i}$")
]

for lr in learning_rates:
    x_curr = x0
    path = [x_curr]
    for i in range(n_iter):
        if x_curr > 1e9:
            break
        grad = df(x_curr)
        x_curr = x_curr - lr[0](i) * grad
        path.append(x_curr)
    
    path = np.array(path)
    plt.plot(path, f(path), 'o-', label=f'lr={lr[1]}', alpha=0.7)

plt.xlim(x_lim[0] - 0.5, x_lim[1] + 0.5)
plt.ylim(-10, 20)
plt.title('Градиентный спуск при переменных скоростях спуска')
plt.xlabel('x')
plt.ylabel('f(x)')
plt.legend()
plt.grid(True)

try:
    plt.savefig("machlearn/images/machlearn_gradient_descent_var.png")
except Exception as e:
    print("Image machlearn_gradient_descent_var.png was not saved:", repr(e))

