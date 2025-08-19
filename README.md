# Australian Rainfall Prediction System

![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)
![XGBoost](https://img.shields.io/badge/XGBoost-1.7+-orange.svg)
![Flask](https://img.shields.io/badge/Flask-2.0+-lightgrey.svg)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.25+-326CE5.svg)
![GCP](https://img.shields.io/badge/Google_Cloud-4285F4.svg?logo=google-cloud)

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Technical Stack](#technical-stack)
- [Data Description](#data-description)
- [Installation](#installation)
- [Usage](#usage)
- [Model Training](#model-training)
- [API Endpoints](#api-endpoints)
- [Deployment](#deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [License](#license)

## Project Overview
An end-to-end machine learning system that predicts rainfall probability across Australian locations using historical weather data. The system processes 140,000+ records with 23 weather features, trains an XGBoost model, and serves predictions through a Flask API deployed on Google Kubernetes Engine.

## Features
- Handles missing values and outliers in weather data
- Feature engineering including date decomposition
- XGBoost classifier with 85%+ accuracy
- Containerized Flask application
- Automated CI/CD pipeline
- Kubernetes orchestration with auto-scaling
- Health monitoring and logging

## Technical Stack
- **Data Processing**: Pandas, NumPy
- **Machine Learning**: XGBoost, Scikit-learn
- **API**: Flask, Gunicorn
- **Infrastructure**: Docker, GCR, GKE
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus, Grafana

## Data Description
Original 23 columns expanded to 25 through feature engineering:

```
Date,Location,MinTemp,MaxTemp,Rainfall,Evaporation,Sunshine,WindGustDir,WindGustSpeed,
WindDir9am,WindDir3pm,WindSpeed9am,WindSpeed3pm,Humidity9am,Humidity3pm,Pressure9am,
Pressure3pm,Cloud9am,Cloud3pm,Temp9am,Temp3pm,RainToday,RainTomorrow
```

**Sample data rows:**

```
2008-12-01,Albury,13.4,22.9,0.6,NA,NA,W,44,W,WNW,20,24,71,22,1007.7,1007.1,8,NA,16.9,21.8,No,No
2008-12-02,Albury,7.4,25.1,0,NA,NA,WNW,44,NNW,WSW,4,22,44,25,1010.6,1007.8,NA,NA,17.2,24.3,No,No
```

## Installation

### Prerequisites
- Python 3.9+
- Docker
- Google Cloud SDK
- kubectl

### Steps
```bash
git clone https://github.com/yourusername/australian-rainfall-prediction.git
cd australian-rainfall-prediction

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt
```

## Usage


## FLASK UI 
### Before Prediction

<img width="1227" height="877" alt="Screenshot 2025-08-18 at 23 54 22" src="https://github.com/user-attachments/assets/77d37335-89af-465f-82a5-b3d2cfd18d20" />


### After Prediction

<img width="1044" height="819" alt="Screenshot 2025-08-18 at 23 54 03" src="https://github.com/user-attachments/assets/57c709d5-079c-440a-ad83-b8566b25ead2" />


### Local Development
```bash
flask run --port 5001
```

### Production Build
```bash
docker build -t gcr.io/your-project-id/mlops-app .
docker push gcr.io/your-project-id/mlops-app
```

## Model Training

### Preprocessing steps:
- Date column decomposed into Year, Month, Day
- Missing values imputed
- Categorical variables encoded
- Outliers removed using IQR

### Training command:
```bash
python src/train.py --data data/weather.csv --model models/xgboost_model.pkl
```

## API Endpoints

### Health Check
**GET /health**

Response:
```json
{"status": "healthy", "timestamp": "2025-08-19T12:00:00Z"}
```

### Prediction
**POST /predict**

Request:
```json
{
  "Location": "Albury",
  "MinTemp": 13.4,
  "MaxTemp": 22.9,
  "Rainfall": 0.6
}
```

Response:
```json
{
  "prediction": "No",
  "probability": 0.23,
  "model_version": "1.0.0"
}
```

## Deployment

### Kubernetes Manifest
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mlops-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mlops-app
  template:
    metadata:
      labels:
        app: mlops-app
    spec:
      containers:
      - name: mlops-app
        image: gcr.io/your-project/mlops-app:latest
        ports:
        - containerPort: 5001
        resources:
          requests:
            cpu: "500m"
            memory: "512Mi"
```

### GKE Deployment
```bash
gcloud container clusters get-credentials your-cluster --region us-central1
kubectl apply -f kubernetes/deployment.yaml
```

## CI/CD Pipeline
The GitHub Actions workflow:
- Builds Docker image on push to main
- Pushes to Google Container Registry
- Deploys to GKE cluster
- Runs integration tests
- Verifies rollout status

```yaml
name: GKE Deployment
on: [push]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - run: docker build -t gcr.io/${{ secrets.GCP_PROJECT_ID }}/mlops-app .
    - run: gcloud auth configure-docker
    - run: kubectl apply -f kubernetes/deployment.yaml
```

## License
This project is licensed under the MIT License.
