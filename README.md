# Dockerized Flask App — Homework #1

A minimal Flask web app containerized with Docker.

## Project structure
```
.
├── app/
│   ├── app.py
│   └── requirements.txt
├── Dockerfile
├── .dockerignore
└── README.md
```

## Build the image
```bash
docker build -t flask-docker-app .
```

## Run the container
```bash
docker run -d -p 8080:5000 \
  -e APP_MESSAGE="Hello, Docker homework!" \
  --name flask-app \
  flask-docker-app
```

- `-p 8080:5000` maps host port 8080 to the container's port 5000.
- `-e APP_MESSAGE=...` overrides the default environment variable defined in the Dockerfile.

## Test it
```bash
curl http://localhost:8080/
curl http://localhost:8080/health
```

## Stop and remove
```bash
docker stop flask-app
docker rm flask-app
```

## Environment variables
| Variable      | Default                                   | Purpose                          |
|---------------|--------------------------------------------|-----------------------------------|
| `APP_ENV`     | `production`                              | Reported in the `/` response      |
| `APP_MESSAGE` | `Hello from inside a Docker container!`   | Message returned by the API       |
| `PORT`        | `5000`                                    | Port the app listens on inside the container |
