# -*- coding: utf-8 -*-
"""
Created on Sun Apr 30 22:00:48 2017

@author: Andrew
"""
from __future__ import division, print_function, absolute_import

# Import tflearn and some helpers
import tflearn
from tflearn.layers.core import input_data, dropout, fully_connected
from tflearn.layers.conv import conv_2d, max_pool_2d
from tflearn.layers.estimator import regression
from tflearn.data_preprocessing import ImagePreprocessing
from tflearn.data_augmentation import ImageAugmentation
from matplotlib.image import imread
from os import listdir
import imageSplitter
# Load the data set
dirs = [f for f in listdir("./ss/")]
X = []
i = 0
for d in dirs[0:10]:
    print(i)
    i += 1
    X.extend(imageSplitter.getSubImages(imread("./ss/%s" % (d))))
Y = []
dirs = [f for f in listdir("./loc/")]
for d in dirs:
    f = open("./loc/%s" % (d))
    y = f.read().split(' ')
    Y.extend(imageSplitter.convertIndex(float(y[0]), float(y[1])))
    

# Make sure the data is normalized
img_prep = ImagePreprocessing()
img_prep.add_featurewise_zero_center()
img_prep.add_featurewise_stdnorm()

# Create extra synthetic training data by flipping, rotating and blurring the
# images on our data set.
img_aug = ImageAugmentation()
img_aug.add_random_flip_leftright()
img_aug.add_random_rotation(max_angle=25.)
img_aug.add_random_blur(sigma_max=3.)

# Define our network architecture:

# Input is a 32x32 image with 3 color channels (red, green and blue)

network = input_data(shape=[None, 120, 256, 1])

network = max_pool_2d(network, 2)

# Step 1: Convolution
network = conv_2d(network, 32, 3, activation='sigmoid')

# Step 2: Max pooling
network = max_pool_2d(network, 2)

# Step 3: Convolution again
network = conv_2d(network, 64, 3, activation='sigmoid')

# Step 4: Convolution yet again
network = conv_2d(network, 64, 3, activation='sigmoid')

# Step 5: Max pooling again
network = max_pool_2d(network, 2)

# Step 6: Fully-connected 512 node neural network
network = fully_connected(network, 512, activation='sigmoid')

# Step 7: Dropout - throw away some data randomly during training to prevent over-fitting
network = dropout(network, 0.5)

# Step 8: Fully-connected neural network with two outputs (0=isn't a bird, 1=is a bird) to make the final prediction
network = fully_connected(network, 1, activation='sigmoid')

# Wrap the network in a model object
model = tflearn.DNN(network, tensorboard_verbose=0)
model.load("./cnn/image-classifier.tfl")
Y = model.predict(X)
for i in range(len(Y) // 20):
    for j in range(20):
        if (Y[i * 20 + j][0] > .9):
            print(i, 256 * (j % 4), 120 * (j // 5), Y[i * 20 + j])
        else:
            print(Y[i * 20 + j][0])