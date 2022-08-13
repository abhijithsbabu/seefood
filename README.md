# See Food
### Overview:
This project is inspired by HBO's Silicon Valley [SeeFood](https://silicon-valley.fandom.com/wiki/SeeFood) application by Jian Yang. In this application we are taking the image of the food from the user and then we are using a model, which is trained to recognize 101 food dishes, to get the prediction. Then based on the result we are fetching its nutritious value. The nutritious values shown by this application are not based on any medical research and can be wrong, so it is advised to not use these values for any medical purpose. This application is made soley for the purpose of learning and not for any public use.

### Dataset Used:
The dataset used to train the model is [Food101](https://www.tensorflow.org/datasets/catalog/food101). This dataset consists of 101 food categories, with 101000 images. For each class, 250 manually reviewed test images are provided as well as 750 training images. All images were rescaled to have a maximum side length of 512 pixels.
- **Classes (Categories):** 101 different classes
- **Download Size:** 5GB

### Model Architecture:
The architecture of the model is based on [MobileNetV3](https://arxiv.org/abs/1905.02244v5).
- **Input:** This model takes images as input. Inputs are expected to be 3-channel RGB color images of size 224 x 224, scaled to [0, 1].
- **Output:** A probability vector of dimension 101, corresponding to 101 food dishes in the labelmap.

### Application UI Design:
