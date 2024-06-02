# CNN_voice_recognition_resistors
Voice-Controlled Resistor Value Calculator

This MATLAB project enables users to calculate the value of resistors by recognizing the colors of their bands through voice commands. The project combines audio processing, machine learning, and image display functionalities to provide an interactive and user-friendly experience.

Features:

Voice Recognition for Band Colors: Uses a pre-trained neural network to recognize the colors of the resistor bands from voice commands. This allows users to input the color bands by simply speaking.

Audio Processing with MFCCs: Extracts Mel-Frequency Cepstral Coefficients (MFCCs) from the recorded audio to serve as features for the neural network classification.

Pre-trained Neural Network: Utilizes a neural network model (NetAudio.mat) to classify the color of each band based on the extracted MFCCs.

Resistor Value Calculation: Computes the resistor value using the recognized colors, taking into account the color bands and their corresponding values and multipliers.

Image Display: Displays an image of the resistor with the calculated value if available. This enhances the user experience by providing a visual representation of the resistor.

Functions:

calculadora_resistencias_por_voz: Main function that coordinates the voice recognition process, calculates the resistor value, and displays the result.
reconocer_color_por_voz: Handles voice recognition for each color band, records the audio, processes it, and classifies the color using the neural network.
calcular_y_guardar_MFCC_aux: Calculates MFCCs from the audio recording and saves them in a .mat file for classification.
calcular_valor_resistencia: Computes the resistor value based on the recognized colors of the bands.
mostrar_imagen: Displays an image corresponding to the calculated resistor value if available.
Usage:

Initialize Voice Recognition: Start the calculadora_resistencias_por_voz function to begin the process.
Voice Input for Colors: Speak the colors of the resistor bands when prompted. The system will record and process your voice to identify the colors.
Calculate Resistor Value: The application calculates the resistor value based on the identified colors and displays it.
Display Resistor Image: If an image corresponding to the calculated resistor value exists, it will be displayed for visual confirmation.
Dependencies:

MATLAB
Audio Toolbox
Pre-trained neural network model (NetAudio.mat)
Image files corresponding to resistor values (optional)
This project demonstrates an innovative approach to calculating resistor values using voice commands, making it convenient and efficient for users to determine resistor values without manual input.
