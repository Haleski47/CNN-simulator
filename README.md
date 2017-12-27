# CNN-simulator
The hardware designed is a simplified version of a Convolutional Neural Network, a
common algorithm used in machine learning. This has been widely used in areas such as
image recognition and object classification which enables successfully identifying faces,
objects apart from powering vision in robots and self driving cars. The most common
architecture proposed for Convolutional Neural Networks are several phases of
Convolution and Pooling followed by a multiple phases of Fully connected phase to
render the output predictions.
This hardware will be implementing two layers, the first layer is a feature extraction
using filter vectors from an input SRAM which will be the convolution phase and the
second layer is a fully connected layer to identify classes. The project input is a 12x12
array of 16-bit twos-complement numbers which can be the details of an image or part of
it. The final output will be an 8x1 vector of 16-bit twos-complement which is a simplified
version of the output class vector.
