from flask import Flask, Response
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST, Counter

app = Flask(__name__)

# Simple metric
REQUEST_COUNT = Counter("app_requests_total", "Total number of requests")

@app.route("/")
def home():
    REQUEST_COUNT.inc()
    return "DevOps Flask App Running 🚀"

@app.route("/health")
def health():
    return {"status": "healthy"}

@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)