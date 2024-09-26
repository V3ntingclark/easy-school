# Start from a base image
FROM python:3.9-slim AS app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app/

# Install Docker
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean

# Set the command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
