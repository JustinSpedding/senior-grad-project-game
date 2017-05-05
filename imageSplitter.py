# -*- coding: utf-8 -*-
"""
Created on Mon May  1 17:07:04 2017

@author: Andrew
"""
    
def getSubImages(image):
    #120 and 256
    segments = []
    for i in range(5):
        for j in range(4):
            segments.append(splitter(image, 256 * j, 120 * i, 120, 256))
    return segments
    
def convertIndex(x, y):
    newX = int(x) // 256
    newY = int(y) // 120
    index = (4 * newY) + newX
    #print(index, x, y)
    output = [[0] for i in range(5 * 4)]
    output[index] = [1]
    return output
    
def splitter(image, x, y, height, width):
    segment = []
    for i in range(height):
        row = []
        for j in range(width):
            row.append(image[y + i][x + j])
            #print(image[y + i][j + j][1])
        segment.append(row)
    return segment