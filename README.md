**Welcome to a BitCamp 2023 Hackathon project**

**SpiralScope - Parkinson's Spiral Disease Detection App
**

This is a web application for detecting Parkinson's disease using spiral drawings. Parkinson's disease is a neurodegenerative disorder that affects movement, 
and one of the symptoms is tremors in the hands. Spiral drawing tests are commonly used to diagnose Parkinson's disease.

**Quick Tour**

CustomCamera Folder- Main App where IOS app is built

Inside CustomCamera, the Shared folder is where all the code was built. The rest of the files are meant for configurations for different
devices.

Custom_CameraApp.Swift runs the main App

ContentView.Swift holds all the SwiftUI components

ParkinsonDetector.mlmodel is the machine learning model built using Python Tensorflow keras approach. It was built using a convolutional neural network.

After many trials and errors, the app has a 96% accuracy to detect Parkinsons from a spiral drawing.


**How it works?
**

Draw a spiral on a white paper, take a picture of it and get your results!!


If the result indicates that you may have Parkinson's disease, please consult a doctor for further evaluation.

**Usage**

Clone the repository

Open the repo on XCode

Just Run the App



DEMO:


