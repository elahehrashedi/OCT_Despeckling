# A Learnable Despeckling Framework for Optical Coherence Tomography Images

Implemented by: Saba Adabi, Elaheh Rashedi

## Citation

Please cite this work in your publications if it helps your research:

## Abstract

Optical coherence tomography (OCT) is a prevalent, interferometric, high-resolution imaging method with broad biomedical applications. Nonetheless, OCT images suffer from an artifact, called speckle which degrades the image quality. Digital filters offer an opportunity for image improvement in clinical OCT devices where hardware modification to enhance images is expensive. To reduce speckle, a wide variety of digital filters have been proposed; selecting the most appropriate filter for each OCT image/image set is a challenging decision. To tackle this challenge, we propose an expandable learnable despeckling framework, we called LDF. LDF decides which speckle reduction algorithm is most effective on a given image by learning the figure of merit (FOM) as a single quantitative image assessment measure. The architecture of LDF includes two main parts: (i) an autoencoder neural network, (ii) filter classifier. The autoencoder learns the figure of merit based on the quality assessment measures extracted from the OCT image including signal-to-noise ratio (SNR), contrast-to-noise ratio (CNR), equivalent number of looks (ENL), edge preservation index (EPI) and mean structural similarity index (MSSI). Subsequently, the filter classifier identifies the most efficient filter from the following categories: (a) sliding window filters including median, mean, and symmetric nearest neighborhood; (b) adaptive statistical based filters including Wiener, homomorphic Lee, and Kuwahara; and, (c) edge preserved patch or pixel correlation based filters including non-local mean, total variation, and block matching 3D filtering.
