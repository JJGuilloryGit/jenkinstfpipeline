from flask import Flask, request, jsonify
import numpy as np
from sklearn.linear_model import LinearRegression
import pandas as pd

app = Flask(__name__)

# Create a simple model instance
model = LinearRegression()

# Sample data to initialize the model
# In a real application, you would load your trained model instead
X_init = np.array([[1], [2], [3], [4], [5]])
y_init = np.array([2, 4, 6, 8, 10])
model.fit(X_init, y_init)

@app.route('/')
def home():
    return "Retail Forecasting API"

@app.route('/health')
def health():
    return {"status": "healthy"}, 200

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get data from request
        data = request.get_json()
        
        if not data or 'values' not in data:
            return jsonify({"error": "No input data provided"}), 400

        # Convert input to numpy array
        input_data = np.array(data['values']).reshape(-1, 1)
        
        # Make prediction
        prediction = model.predict(input_data)
        
        return jsonify({
            "predictions": prediction.tolist(),
            "status": "success"
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/train', methods=['POST'])
def train():
    try:
        # Get training data from request
        data = request.get_json()
        
        if not data or 'x' not in data or 'y' not in data:
            return jsonify({"error": "Missing training data"}), 400

        # Convert input to numpy arrays
        X = np.array(data['x']).reshape(-1, 1)
        y = np.array(data['y'])
        
        # Train the model
        model.fit(X, y)
        
        return jsonify({
            "message": "Model trained successfully",
            "status": "success"
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
