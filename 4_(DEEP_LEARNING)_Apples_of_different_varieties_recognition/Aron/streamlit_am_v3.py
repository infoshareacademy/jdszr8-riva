import streamlit as st
from streamlit_option_menu import option_menu
import numpy as np
import cv2
import tensorflow as tf
from tensorflow import keras
import plotly.express as px

def import_and_color_image(image_path:str, image_cat:str):
    img=cv2.imread(image_path + image_cat + ".png")
    img=cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img=cv2.copyMakeBorder(src=img, top=5, bottom=5, left=5, right=5, borderType=cv2.BORDER_CONSTANT, value=[256, 256, 256])
    return img   

def show_droped_image(img):
    img=cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img=cv2.copyMakeBorder(src=img, top=5, bottom=5, left=5, right=5, borderType=cv2.BORDER_CONSTANT, value=[256, 256, 256])
    return img

def processed_image_for_classification(img):
    img=cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
    img=cv2.resize(src=img, dsize=(258, 320), interpolation=cv2.INTER_AREA)
    img=img.astype('float32')
    img = img / 255 
    img = np.expand_dims(img, axis=0)
    return img

image_path = "./pic_examples/"

with st.sidebar:
    selected = option_menu(menu_title=None,
                            options=["Model", "About", "Authors"],
                            icons=["calculator", "clipboard", "people-fill"],
                            default_index=0,
                            styles={"icon": {"font-size": "25px"},
                                    "nav-link": {"font-size": "25px", "--hover-color": "#8EAD7C"}})

if selected == "Model":
    
    title = st.container()
    subtitle = st.container()
    pictures_line_1 = st.container()
    pictures_line_2 = st.container()
    drop_section = st.container()
    results = st.container()


    with title:
        st.markdown("<h1 style='text-align: center;'>Why don't we recognise an Apple? Let's give it a try!</h1>", unsafe_allow_html=True)
        st.markdown("""---""")


    with subtitle:
        
        st.markdown("<h2 style='text-align: center;'>This is how our &#127822 &#127823 categories looks like:</h1>", unsafe_allow_html=True)
        
        
    with pictures_line_1:
        col1, col2, col3 = st.columns(3)
        with col1:
            st.markdown('<h3 style="text-align: center;"> A</h3>', unsafe_allow_html=True)
            st.image(image = import_and_color_image(image_path, "A"))
        with col2:
            st.markdown('<h3 style="text-align: center;"> B</h3>', unsafe_allow_html=True)
            st.image(image = import_and_color_image(image_path, "B"))
        with col3:
            st.markdown('<h3 style="text-align: center;"> C</h3>', unsafe_allow_html=True)
            st.image(image = import_and_color_image(image_path, "C"))


    with pictures_line_2:
        col4, col5, col6 = st.columns(3)
        with col4:
            st.markdown('<h3 style="text-align: center;"> D</h3>', unsafe_allow_html=True)
            st.image(image = import_and_color_image(image_path, "D"))
        with col5:
            st.markdown('<h3 style="text-align: center;"> E</h3>', unsafe_allow_html=True)
            st.image(image = import_and_color_image(image_path, "E"))
        with col6:
            st.markdown('<h3 style="text-align: center;"> F</h3>', unsafe_allow_html=True)
            st.image(image = import_and_color_image(image_path, "F"))
        st.markdown("""---""")


    with drop_section:

    
        st.markdown('<h2 style="text-align: center;"> Insert an image for classification</h2>', unsafe_allow_html=True)
        upload_file= st.file_uploader(label="", type=['png','jpg'])
        

        if upload_file is not None:

            # Convert the file to an opencv image
            file_bytes=np.asarray(bytearray(upload_file.read()), dtype=np.uint8)
            img=cv2.imdecode(file_bytes, 1)
            
            st.markdown('<h4 style="text-align: center;"> Input Image</h4>', unsafe_allow_html=True)
            col7, col8, col9 = st.columns(3)
            with col7:
                st.write(' ')
            with col8:
                st.image(image = show_droped_image(img))
            with col9:
                st.write(' ')
        
        st.markdown("""---""")
        
        
    with results:
        
        
        if upload_file is not None:

            model=tf.keras.models.load_model("model_apples.h5", compile=False)
            model.compile(optimizer=tf.keras.optimizers.Adam(), loss=tf.keras.losses.CategoricalCrossentropy(), metrics=["accuracy"])
            
            y_pred = model.predict(processed_image_for_classification(img)).argmax(axis=1)
            number = y_pred[0]
            classificaiton_dict = {0:"A", 1:"B", 2:"C", 3:"D", 4:"E", 5:"F"}
            apple_class=classificaiton_dict.get(number)
            predictions = model.predict(processed_image_for_classification(img)).flatten()*100
            predictions_int = [str(" ") if int(round(i)) == 0 else str(int(round(i)))+"%" for i in predictions]
            
            st.markdown(f'<h2 style="text-align: center;"> Predicted apple category: {apple_class}</h2>', unsafe_allow_html=True)
            st.markdown('<h4 style="text-align: center;"> Probability in %</h4>', unsafe_allow_html=True)
            fig = px.bar(x=["A","B","C","D","E","F"],
                         y=predictions,
                         text=predictions_int)
            fig.update_traces(textposition='outside')
            fig.update_yaxes(showticklabels=False, showgrid=False, range=[0, 110])
            fig.update_xaxes(showline=True, linewidth=1, linecolor='#8EAD7C')
            fig.update_layout(xaxis_title='Categories', font=dict(size=20),
                              xaxis_tickfont=dict(size=20), yaxis_title=" ", yaxis_tickfont=dict(size=20),
                              xaxis_title_font=dict(size=20))
            st.plotly_chart(fig)


if selected == "About":
    st.text("In progress")
if selected == "Authors":
    st.text("In progress")