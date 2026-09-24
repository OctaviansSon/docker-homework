import os
from datetime import datetime
from flask import Flask, jsonify

app = Flask(__name__)

# Environment variable with a sensible default — demonstrates configurable behavior
APP_ENV = os.environ.get("APP_ENV", "development")
APP_MESSAGE = os.environ.get("APP_MESSAGE", "Hello from inside a Docker container!")


@app.route("/")
def index():
    return jsonify(
        message=APP_MESSAGE,
        environment=APP_ENV,
        time=datetime.utcnow().isoformat() + "Z",
    )


@app.route("/health")
def health():
    return jsonify(status="ok"), 200


if __name__ == "__main__":
    # Port is read from PORT env var so it can be reconfigured without touching code
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
