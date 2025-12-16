import os
import math
from pathlib import Path
from typing import List, Dict

import numpy as np
import matplotlib.pyplot as plt

from qiskit import QuantumCircuit, QuantumRegister, ClassicalRegister, transpile
from qiskit.visualization import plot_bloch_multivector, plot_bloch_vector
from qiskit.visualization.state_visualization import _bloch_multivector_data
from qiskit.quantum_info import Statevector

def main1():
    qc = QuantumCircuit(1, 1)
    qc.reset(0)
    state1 = Statevector.from_instruction(qc)

    qc = QuantumCircuit(1, 1)
    qc.x(0)
    state2 = Statevector.from_instruction(qc)

    fig = plt.figure(figsize=plt.figaspect(0.5))

    ax = fig.add_subplot(1, 2, 1, projection='3d')
    plot_bloch_vector(
        _bloch_multivector_data(state1), ax=ax
    )
    ax.set_title(r'Состояние $|0\rangle$', y=1.15)
    ax = fig.add_subplot(1, 2, 2, projection='3d')
    plot_bloch_vector(
        _bloch_multivector_data(state2), ax=ax
    )
    ax.set_title(r'Состояние $|1\rangle$', y=1.15)

    plt.savefig('physics3/images/physics3_0_1_states.png')

def main2():
    qc = QuantumCircuit(1, 1)
    qc.h(0)
    state1 = Statevector.from_instruction(qc)

    qc = QuantumCircuit(1, 1)
    qc.x(0)
    qc.h(0)
    state2 = Statevector.from_instruction(qc)

    fig = plt.figure(figsize=plt.figaspect(0.5))

    ax = fig.add_subplot(1, 2, 1, projection='3d')
    plot_bloch_vector(
        _bloch_multivector_data(state1), ax=ax
    )
    ax.set_title(r'Состояние $\frac{1}{\sqrt{2}} |0\rangle + \frac{1}{\sqrt{2}} |1\rangle$', y=1.15)
    ax = fig.add_subplot(1, 2, 2, projection='3d')
    plot_bloch_vector(
        _bloch_multivector_data(state2), ax=ax
    )
    ax.set_title(r'Состояние $\frac{1}{\sqrt{2}} |0\rangle - \frac{1}{\sqrt{2}} |1\rangle$', y=1.15)
    
    plt.savefig('physics3/images/physics3_hadamard_states.png')

if __name__ == "__main__":
    main1()
    main2()
