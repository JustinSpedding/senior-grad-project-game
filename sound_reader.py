# -*- coding: utf-8 -*-
"""
Created on Sun Nov 13 15:56:41 2016

@author: Andrew, Patrick, and Justin
"""

import scipy.io.wavfile as file
import numpy as np
import matplotlib.pyplot as plt
import time
rate, data = file.read("sad.wav")
channel = []
if len(data[0]) > 1:
    channel = (data[:, 0] + data[:, 1]) / 2
else:
    channel = data[:, 0]
#channel = data
duration = int(len(data) / (rate / 20))
fig = plt.figure()
ax = fig.gca()
ax.plot([1])
plt.show()
xs = []
ys = []
for i in range(duration):
    piece = channel[rate * i / 20 : rate * (i + 1) / 20]
    n = len(piece)
    values = np.fft.fft(piece)
    upper_bound = max(values) / 2
    for i in range(n // 2):
        if values[i] < upper_bound // 2:
        #    values[i] = 0
            pass
        values[i] /= ((n // 2) - i) * ((upper_bound * n // 2) - i)
    values = abs(values[2 : 300])
    k = np.arange(n)
    T = len(piece) / rate
    frq = k / T
    frq = frq[2 : 300]
    xs.append(frq)
    ys.append(values)
print("get ready!")
time.sleep(4.75)
print("go!")
sync = 0
for i in range(len(xs)):
    start = time.time()
    ax.clear()
    ax.plot(xs[i], ys[i])
    fig.canvas.draw()
    stop = time.time()
    sync += .05 - (stop - start)
    print(sync)
    if (sync > .05) :
        start = time.time()
        time.sleep(sync)
        stop = time.time()
        sync -= stop - start