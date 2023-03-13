import streamlit as st
import numpy as np
import cv2
import tensorflow as tf

st.markdown('<h1 style="color:black;">Apple classification model</h1>', unsafe_allow_html=True)
st.markdown('<h2 style="color:gray;">The apple classification model classifies image into one of following categories:</h2>', unsafe_allow_html=True)
st.markdown('<h3 style="color:gray;"> A,B, C, D, E, F</h3>', unsafe_allow_html=True)



upload= st.file_uploader('Insert image for classification', type=['png','jpg'])
c1, c2= st.columns(2)


# Docelowy fromat wszystkich zdjęć
IMG_WIDTH=320
IMG_HEIGHT=258

if upload is not None:

    im= cv2.imread(upload)
    image = cv2.cvtColor(im,cv2.COLOR_BGR2RGB)
    image=cv2.resize(image, (IMG_HEIGHT, IMG_WIDTH), interpolation = cv2.INTER_AREA)
    image=np.array(image)
    image = image.astype('float32')
    image /= 255 
    x = np.expand_dims(image, axis=0)

    c1.header('Input Image')
    c1.image(im)
    c1.write(im.shape)

    model = tf.keras.models.load_model('model_apples')


    prediction = model.predict(x)
    pred_class = np.argmax(prediction, axis=1)
    c2.header('Output')
    c2.subheader('Predicted class:')
    # c2.write(classes[vgg_pred_classes[0]] )
