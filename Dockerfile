# Base image for Python application
FROM python:3.6-slim AS app

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create and set a working directory
WORKDIR /app

# Copy only the requirements file first for better caching
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
COPY . /app/

# Run database migrations
RUN python manage.py makemigrations
RUN python manage.py migrate

# Expose the port number
EXPOSE 8000

# Command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# Jenkins image to enable Docker commands
FROM jenkins/jenkins:lts

USER root  # Switch to root user

# Install Docker
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean

USER jenkins  # Switch back to the jenkins user

# Copy the built application from the previous stage
COPY --from=app /app /app

# Set the working directory
WORKDIR /app

# Command to run Jenkins
CMD ["jenkins"]
