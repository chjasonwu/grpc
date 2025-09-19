# Ruby gRPC Server Docker Container

This directory contains Docker configurations to run the Ruby gRPC Hello World server in a Linux container.

## Prerequisites

- Docker
- Docker Compose (recommended)

## Quick Start

**Start the gRPC server:**
```bash
docker-compose up --build
```

The server will be available on `localhost:50051`

## Usage Options

### Option 1: Docker Compose (Recommended)
```bash
# Start server
docker-compose up -d --build

# Check server status
docker-compose ps
docker-compose logs grpc-server

# Stop server
docker-compose down
```

### Development Mode (Code Mounted)

The container mounts your local code, so you can edit files and see changes immediately:

```bash
# Start server with mounted code
docker-compose up --build

# In another terminal, shell into the running container
docker-compose exec grpc-server sh

# Inside container - your code is live-mounted at /app
/app # ls
Dockerfile             greeter_client.rb      lib/
README-Docker.md       greeter_server.rb      

# Edit code on your host machine, then restart server in container
/app # ruby greeter_server.rb

# Or regenerate protobuf files if needed
/app # grpc_tools_ruby_protoc -I /protos --ruby_out=lib --grpc_out=lib /protos/helloworld.proto
```

### Option 2: Docker directly
```bash
# Build the image
docker build -t ruby-grpc-server .

# Run the server
docker run -d -p 50051:50051 --name grpc-server ruby-grpc-server

# Check logs
docker logs grpc-server

# Stop and remove
docker stop grpc-server && docker rm grpc-server
```

## Testing the Server

### From host machine (if you have Ruby and grpc gems):
```bash
ruby greeter_client.rb "Host Client" "localhost:50051"
```

### From another container:
```bash
docker run --rm --network host ruby-grpc-server ruby greeter_client.rb "Docker Client" "localhost:50051"
```

### Interactive testing:
```bash
# Run interactive container
docker run -it --rm --network host ruby-grpc-server sh

# Inside container:
ruby greeter_client.rb "Interactive Client" "localhost:50051"
```

## Server Features

- **Auto-restart**: Server restarts automatically if it crashes
- **Health checks**: Built-in health monitoring
- **Logging**: Verbose gRPC logging enabled
- **Port binding**: Accessible on localhost:50051

## Files

- `Dockerfile` - Server container definition
- `docker-compose.yml` - Server service configuration  
- `.dockerignore` - Build optimization
- `README-Docker.md` - This documentation

## Container Details

- **Base**: Ruby 3.3 on Alpine Linux
- **Port**: 50051 (gRPC)
- **Gems**: grpc, grpc-tools, google-protobuf
- **Auto-generated**: Protobuf files built during image creation
