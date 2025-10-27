import numpy as np
import matplotlib.pyplot as plt

# параметры сигнала
T = 1.0      # период (нормированный)
N = 1000     # дискретизация для рисования
t = np.linspace(0, T, N, endpoint=False)

# прямоугольный сигнал: 1 в первой половине периода, 0 во второй
x = np.where(t < 0.5, 1.0, 0.0)

# функция для импульса
def rect_pulse(t, start, width, T):
    """Прямоугольный импульс от start до start+width (по модулю T)."""
    t_mod = np.mod(t, T)
    return np.where((t_mod >= start) & (t_mod < start + width), 1.0, 0.0)

signal = [0, 1, 1, 0, 0, 0, 1, 0]
signal *= 1
t_discrete = np.linspace(0, T, len(signal), endpoint=False)
print(t_discrete)

x = np.zeros_like(t)
for i in range(len(signal)):
    if signal[i]:
        x += rect_pulse(t, i*T/len(signal), 1/len(signal)*T, T)



# число гармоник для разложения
Kmax = 16

integrand = x
a_0 = (2/T) * np.trapz(integrand, t)
# считаем коэффициенты ряда Фурье (только синусы)
# формула: b_k = 2/T * ∫_0^T x(t) sin(2π k t / T) dt
b = []
for k in range(1, Kmax+1):
    integrand = x * np.sin(2*np.pi*k*t/T)
    bk = (2/T) * np.trapz(integrand, t)
    b.append(bk)
b = np.array(b)
a = []
for k in range(1, Kmax+1):
    integrand = x * np.cos(2*np.pi*k*t/T)
    ak = (2/T) * np.trapz(integrand, t)
    a.append(ak)
a = np.array(a)

# подготовка холста
fig, axes = plt.subplots(3, 5, figsize=(15, 7))
plt.subplots_adjust(hspace=0.6)

# (a) Исходный сигнал + спектр
axes[0,0].plot(t, x, lw=2)
axes[0,0].set_title("Исходный прямоугольный сигнал")
axes[0,0].set_ylim(-0.2, 1.2)
axes[0,0].set_xlabel("t")

axes[1,0].bar(np.arange(1, Kmax+1), np.abs(a))
axes[1,0].set_xlabel("Номер гармоники")
axes[1,0].set_ylabel("Амплитуда косинусоиды")

axes[2,0].bar(np.arange(1, Kmax+1), np.abs(b))
axes[2,0].set_xlabel("Номер гармоники")
axes[2,0].set_ylabel("Амплитуда синусоиды")

# какие разложения показать
harmonics_list = [1, 2, 8, Kmax]

for i, K in enumerate(harmonics_list, start=1):
    # реконструкция суммой первых K синусов
    x_recon = np.zeros_like(t) + a_0 / 2
    for k in range(1, K+1):
        x_recon += a[k-1] * np.cos(2*np.pi*k*t/T) + b[k-1] * np.sin(2*np.pi*k*t/T)
    
    # слева — сигнал во времени
    axes[0,i].plot(t, x_recon, lw=2)
    axes[0,i].set_title(f"{K} гармоник{'а' if K == 1 else 'и' if 2 <= K < 5 else ''}")
    axes[0,i].set_ylim(-0.2, 1.2)
    axes[0,i].set_xlabel("t")
    axes[0,i].stem(t_discrete + 1/2/len(signal), signal, basefmt=" ", markerfmt="C1o", linefmt="C1-")
    
    # справа — спектр с подсветкой первых K
    bars = axes[1,i].bar(np.arange(1, Kmax+1), np.abs(a), alpha=0.3)
    for idx in range(K):
        bars[idx].set_alpha(1.0)
        bars[idx].set_edgecolor("k")

    # справа — спектр с подсветкой первых K
    bars = axes[2,i].bar(np.arange(1, Kmax+1), np.abs(b), alpha=0.3)
    for idx in range(K):
        bars[idx].set_alpha(1.0)
        bars[idx].set_edgecolor("k")

plt.suptitle("Приближение прямоугольного сигнала синусами", fontsize=16)
plt.savefig("telecomm/images/telecomm_fourier_transform.png")
import numpy as np
import matplotlib.pyplot as plt

# Частотная ось (реальные положительные частоты)
f = np.linspace(0, 10, 1000)

# Основная "гауссовская" форма с асимметрией
center = 4  # частота центра
width = 2   # ширина кривой
curve = np.exp(-((f - center)**2) / (2 * width**2))

# Усиление низких частот
low_freq_boost = 1 + 0.5 * np.exp(-(f/2)**2)
curve *= low_freq_boost

# Максимум для нормализации
curve /= np.max(curve)

# Уровень -3 дБ для полосы пропускания
cutoff = 0.707
indices = np.where(curve >= cutoff)[0]
f_low = f[indices[0]]
f_high = f[indices[-1]]

# Построение графика
plt.figure(figsize=(10,5))
plt.plot(f, curve)
plt.axhline(y=cutoff, color='red', linestyle='--', label='Полоса пропускания')
plt.fill_between(f, 0, curve, where=(f>=f_low) & (f<=f_high), color='red', alpha=0.2)

# Подписи
plt.title("Амплитудно-частотная характеристика")
plt.xlabel("Частота (Гц)")
plt.ylabel("Нормированная амплитуда")
plt.grid(True)
plt.legend()
plt.savefig("telecomm/images/telecomm_bandwidth.png")
