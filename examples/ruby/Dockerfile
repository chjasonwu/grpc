# Use official Ruby image based on Debian (glibc)
FROM ruby:3.3-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    pkg-config \
    libssl-dev \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Ruby files (includes pre-generated protobuf files in lib/)
COPY . .

# Install Ruby gems with specific versions
RUN gem install grpc -v 1.68.1 --no-document
RUN gem install grpc-tools -v 1.68.1 --no-document
RUN gem install google-protobuf --no-document

# Expose gRPC port
EXPOSE 50051

# Run the gRPC server
CMD ["ruby", "greeter_server.rb"]
