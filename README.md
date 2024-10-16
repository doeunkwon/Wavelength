# Wavelength

An AI-powered iOS app that helps you curate your social circle based on personalized metrics.

<p align="center">
  <img width="1000" src="https://github.com/user-attachments/assets/6d194444-d5d1-4fe9-afcf-1902c47a49fb">
</p>

## Overview

Wavelength is a full-stack iOS app designed to help you build and maintain a social circle that aligns with your personal goals, values, and interests. By leveraging AI and a combination of objective and subjective metrics, Wavelength gamifies the process of surrounding yourself with the best group of people possible.

## Tech Stack

- **Frontend**: SwiftUI
- **Backend**: FastAPI (Python), LangChain
- **Database**: Neo4j Graph Database
- **AI Model**: Gemini-1.5-flash

## Installation

### Prerequisites

- **Python 3.7+**
- **Swift and Xcode** (for iOS development)
- **Docker** (for Neo4j database)
- **Git**

### Database Setup

1. **Install Docker** (if not already installed)

   - [Download Docker Desktop](https://www.docker.com/products/docker-desktop)

2. **Run Neo4j instance**

   ```bash
   docker run \
     --name neo4j-wavelength \
     -p7474:7474 -p7687:7687 \
     -d \
     -e NEO4J_AUTH=neo4j/password \
     neo4j:latest
   ```

   Replace `password` with a secure password of your choice.

3. **Verify Neo4j is running**

   - Open a web browser and navigate to `http://localhost:7474`.
   - Log in with username `neo4j` and the password you set.

### Backend Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/doeunkwon/wavelength.git
   cd wavelength
   ```

2. **Create a virtual environment (optional but recommended)**

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install requirements**

   ```bash
   pip install -r requirements.txt
   ```
4. **Create config.py in the backend folder**
   ```python
   ACCESS_TOKEN_EXPIRE_MINUTES = 30
   SECRET_KEY = "your_secret_key"
   ```
5. **Create .env in the backend folder**
   ```
   NEO4J_URI=bolt://localhost:7687
   NEO4J_USERNAME=neo4j
   NEO4J_PASSWORD=your_password
   GEMINI_API_KEY=your_gemini_api_key
   ALGORITHM=your_jwt_algorithm
   ```

4. **Run the backend server**

   ```bash
   python3 backend/main.py
   ```

### Frontend Setup

1. **Open the project in Xcode**

   - Navigate to the `frontend` directory.
   - Open `Wavelength.xcodeproj`.

2. **Run the app**

   - Select your simulator or physical device.
   - Click the **Run** button in Xcode.

## Contact

- **Email**: [dekwooon@gmail.com](mailto:dekwooon@gmail.com)
- **GitHub**: [doeunkwon](https://github.com/doeunkwon)
