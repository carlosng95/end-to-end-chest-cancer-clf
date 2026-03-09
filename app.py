from flask import Flask, request, jsonify, render_template
import os
import traceback
from flask_cors import CORS, cross_origin
from cnnClassifier.utils.common import decodeImage
from cnnClassifier.pipeline.prediction import PredictionPipeline

os.putenv('LANG', 'en_US.UTF-8')
os.putenv('LC_ALL', 'en_US.UTF-8')

app = Flask(__name__)
CORS(app)

class ClientApp:
    def __init__(self):
        self.filename = 'inputImage.jpg'
        self.classifier = PredictionPipeline(self.filename)

clApp = ClientApp()

@app.route('/', methods=['GET'])
@cross_origin()
def home():
    return render_template('index.html')

@app.route('/train', methods=['GET', 'POST'])
@cross_origin()
def trainRoute():
    os.system('python main.py')
    return 'Training done successfully!'

@app.route('/predict', methods=['POST'])
@cross_origin()
def predictRoute():
    try:
        print("Entró a /predict", flush=True)
        print("Content-Type:", request.content_type, flush=True)
        print("request.json existe:", request.json is not None, flush=True)

        image = request.json['image']
        print("Base64 recibido. Largo:", len(image), flush=True)

        decodeImage(image, clApp.filename)
        print("Imagen decodificada y guardada en:", clApp.filename, flush=True)

        result = clApp.classifier.predict()
        print("Resultado de predict():", result, flush=True)

        return jsonify(result)

    except Exception as e:
        print("ERROR EN /predict:", str(e), flush=True)
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)