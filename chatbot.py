import speech_recognition as sr
import pyttsx3

# Función para convertir texto a voz
def SpeakText(command):
    engine = pyttsx3.init()
    engine.say(command)
    engine.runAndWait()

# Loop infinito para que el usuario hable
while True:
    try:
        # Inicializar variables para almacenar los colores de las bandas
        banda1 = ''
        banda2 = ''
        banda3 = ''

        # Pedir al usuario que diga el color de la primera banda
        SpeakText("Por favor, di el color de la primera banda:")
        banda1 = input("Di el color de la primera banda: ").lower()

        # Pedir al usuario que diga el color de la segunda banda
        SpeakText("Por favor, di el color de la segunda banda:")
        banda2 = input("Di el color de la segunda banda: ").lower()

        # Pedir al usuario que diga el color de la tercera banda
        SpeakText("Por favor, di el color de la tercera banda:")
        banda3 = input("Di el color de la tercera banda: ").lower()

        # Guardar los colores en un archivo de texto
        with open('colores.txt', 'w') as file:
            file.write(f"{banda1},{banda2},{banda3}")

        SpeakText("Se han capturado los colores de las bandas y se han guardado en un archivo.")

    except Exception as e:
        print("Ocurrió un error:", e)
