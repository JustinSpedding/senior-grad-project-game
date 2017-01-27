# -*- coding: utf-8 -*-
"""
Created on Sun Nov 13 15:56:41 2016

@author: Andrew, Patrick, and Justin
"""

import scipy.io.wavfile as file
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
rate, data = file.read("cool.wav")
framerate = 30
barcount = 10
channel = []
if len(data[0]) > 1:
    channel = (data[:, 0] + data[:, 1]) / 2
else:
    channel = data[:, 0] # this case doesn't work correctly yet
#channel = data   use this if it's a single channel song and above doesn't work
duration = int(len(data) / (rate / framerate))
ys = []
#xs = []
n = rate // framerate
k = np.arange(n)
T = n / rate
frq = k / T
frq = frq[range(n // 2)]
start = -1
stop = -1
for i in range(n // 2):
    if start == -1 and frq[i] >= 20:
        start = i
    if stop == -1 and frq[i] >= 5000:
        stop = i
        break
for i in range(duration):
    piece = channel[rate * i // framerate : rate * (i + 1) // framerate]    
    Y = np.fft.fft(piece) / n
    Y = Y[range(n // 2)]
    data = abs(Y)[start:stop]
    #ys.append(abs(Y)[start:stop])
    #xs.append(frq[start:stop])
    bars = []
    bar = 0
    for j in range(len(data)):
        bar += data[j]
        if (j + 1) % barcount == 0:
            bars.append(bar // barcount)
            bar = 0
    ys.append(bars)
    
finalYs = []
for i in range(duration - 1):
    prevBars = ys[i]
    currentBars = ys[i + 1]
    finalBars = []
    for b in range(len(ys[i])):
        finalBars.append(currentBars[b] - prevBars[b])
    limit = 20
    for b in range(len(finalBars)):
        if finalBars[b] < limit:
            finalBars[b] = 0
    if i > 0:
        for b in range(len(finalYs[i - 1])):
            if (finalYs[i - 1][b] != 0):
                finalBars[b] = 0
    finalYs.append(finalBars)
finalYs.append([])
def animate(i):
    ax.clear()
    x = range(len(finalYs[i]))
    ax.bar(x, finalYs[i])
    ax.set_ylim([0, 500])
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
ani = animation.FuncAnimation(fig, animate, frames=duration, interval=framerate)
plt.rcParams['animation.ffmpeg_path'] = './ffmpeg/bin/ffmpeg.exe'
FFwriter = animation.FFMpegWriter(fps=framerate)
print("saving file")
ani.save('animation.mp4', writer = FFwriter)
print("done writing")