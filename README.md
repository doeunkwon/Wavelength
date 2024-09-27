# Wavelength

An AI-powered iOS app that helps you curate your social circle based on personalized metrics.

<p align="center">
  <img width="1000" src="https://github.com/user-attachments/assets/43d9ef34-7aa9-4399-9431-5a4cb07bd8a2">
</p>

## Overview

Wavelength is a full-stack iOS app designed to help you build and maintain a social circle that aligns with your personal goals, values, and interests. By leveraging AI and a combination of objective and subjective metrics, Wavelength gamifies the process of surrounding yourself with the best group of people possible.

## Features

- **Personalized Profiles**: Create an account and enter your goals, values, and interests.
- **Friend Alignment Scores**: Add friends and receive AI-generated analysis and scores indicating how aligned you are.
- **Memory Logging**: Log shared memories with friends and assign sentiment scores ranging from -5 to 5.
- **Dynamic Updates**: AI continuously updates alignment scores based on new memories and interactions.
- **Dashboard**: View your overall social circle alignment score.
- **Progress Tracking**: Monitor your scores over time with interactive line graphs using Swift Charts.

### User Profile Creation
https://github.com/user-attachments/assets/0337eae0-b57e-4653-9c7b-137e58af29f9

### Friend Profile Creation

#### Low Alignment
https://github.com/user-attachments/assets/c0bc2671-4918-4f2a-bb02-0867b30a1785

#### High Alignment
https://github.com/user-attachments/assets/3b4701e7-3519-4b81-bb2d-0e5ca5d3a4ac

### Memory Creation
https://github.com/user-attachments/assets/d30b912c-bbc7-4d34-af60-1c9f78edff3f

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

### Backend Setup

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/wavelength.git
   cd wavelength
   ```

2. **Create a Virtual Environment (Optional but Recommended)**

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install Requirements**

   ```bash
   pip install -r requirements.txt
   ```

4. **Run the Backend Server**

   ```bash
   python3 backend/main.py
   ```

### Database Setup

1. **Install Docker** (if not already installed)

   - [Download Docker Desktop](https://www.docker.com/products/docker-desktop)

2. **Run Neo4j Instance**

   ```bash
   docker run \
     --name neo4j-wavelength \
     -p7474:7474 -p7687:7687 \
     -d \
     -e NEO4J_AUTH=neo4j/password \
     neo4j:latest
   ```

   Replace `password` with a secure password of your choice.

3. **Verify Neo4j is Running**

   - Open a web browser and navigate to `http://localhost:7474`.
   - Log in with username `neo4j` and the password you set.

### Frontend Setup

1. **Open the Project in Xcode**

   - Navigate to the `frontend` directory.
   - Open `Wavelength.xcodeproj`.

2. **Run the App**

   - Select your simulator or physical device.
   - Click the **Run** button in Xcode.

## Usage

1. **Create an Account**

   - Open the app and sign up by entering your goals, values, and interests.

2. **Add Friends**

   - Create profiles for your friends to see how aligned you are.

3. **Log Memories**

   - Add shared memories with friends and assign sentiment scores from -5 to 5.

4. **View Alignment Scores**

   - Check the AI-generated alignment percentages on your dashboard.

5. **Monitor Progress**

   - Use the progress chart to track your social circle alignment over time.

## Contact

- **Email**: [dekwooon@gmail.com](mailto:dekwooon@gmail.com)
- **GitHub**: [doeunkwon](https://github.com/doeunkwon)
