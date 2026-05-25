import matplotlib.pyplot as plt
import numpy

from pathlib import Path

cache = {}

def f(x, c=0):
    if c >= 100:
        return x

    if x not in cache:
        cache[x] = 0 if x <= 0 else \
            1/2 * f(3 * x, c+1) if x <= 1/3 else \
            1/2 if x <= 2/3 else \
            1/2 + 1/2 * f(3 * x - 2, c+1) if x <= 1 else \
            1 

    return cache[x]

x_domain = numpy.arange(0, 1.001, 0.0001)
plt.plot(x_domain, [f(i) for i in x_domain])
plt.title("Канторова лестница")
plt.grid(True)
plt.savefig(Path("probtheory") / "images" / "probtheory_2024_10_22_1.png")
