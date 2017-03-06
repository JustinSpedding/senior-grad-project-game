# -*- coding: utf-8 -*-
"""
Created on Sun Nov 13 15:56:41 2016

@author: Andrew, Patrick, and Justin
"""
#tomorrow, remember to fix the scaling of the music to account for the exponential scale of real life instruments.
import scipy.io.wavfile as file
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import json
rate, data = file.read("cool.wav")
framerate = 30
barcount = 8
channel = []
if len(data[0]) > 1:
    channel = (data[:, 0] + data[:, 1]) / 2
else:
    channel = data[:, 0] # this case doesn't work correctly yet
#channel = data   #use this if it's a single channel song and above doesn't work
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
    if start == -1 and frq[i] >= 27:
        start = i
    if stop == -1 and frq[i] >= 4187:
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
    width = 0
    keyWidth = 88 / (barcount + 1)
    b = 1
    for j in range(len(data)):
        bar += data[j]
        width += 1
        if frq[j + start] >= pow(1.05946, (b * keyWidth) - 49) * 440:
        #if (j + 1) % width == 0:
            bars.append(bar // width)
            bar = 0
            b += 1
    ys.append(bars)
    
finalYs = []
for i in range(duration - 1):
    prevBars = ys[i]
    currentBars = ys[i + 1]
    finalBars = []
    for b in range(len(ys[i])):
        finalBars.append(currentBars[b] - prevBars[b])
    finalYs.append(finalBars)
for i in range(duration // framerate):
    bars = []
    for j in range(framerate):
        bars.extend(finalYs[i * framerate + j])
    limit = sorted(bars)[-6]
    if limit < 20:
        limit = 20
    for j in range(framerate):
        for b in range(len(finalYs[i * framerate + j])):
            if finalYs[i * framerate + j][b] < limit:
                finalYs[i * framerate + j][b] = 0
finalYs.append([])
def animate(i):
    #ax.clear()
    x = range(len(finalYs[i]))
    #ax.bar(x, finalYs[i])
    #ax.set_ylim([0, 500])
def writeJSON():
    formattedYs = []
    for i in range(barcount):
        formattedYs.append([])
    for i in range(len(finalYs)):
        for j in range(len(finalYs[i])):
            if finalYs[i][j] != 0:
                formattedYs[j].append(i / framerate)
    with open('data.txt', 'w') as outfile:
        json.dump(formattedYs, outfile)
writeJSON()
#fig = plt.figure()
#ax = fig.add_subplot(1, 1, 1)
#ani = animation.FuncAnimation(fig, animate, frames=duration, interval=framerate)
#plt.rcParams['animation.ffmpeg_path'] = './ffmpeg/bin/ffmpeg.exe'
#FFwriter = animation.FFMpegWriter(fps=framerate)
print("saving file")
#ani.save('animation.mp4', writer = FFwriter)
print("done writing")