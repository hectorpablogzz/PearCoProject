# PearCoProject
PearCo Swift App

## API
The code for the API can be found at: https://github.com/hectorpablogzz/PearCoFlaskAPI/tree/main

# CafeCare (PearCoProject)

Based on an iOS + Flask API stack.

## What's in the stack

### Mobile App (iOS)
- Swift 5 / Xcode 15+ / iOS 17 SDK
- SwiftUI (declarative UI)
- Observation (`@Observable`) for state updates
- URLSession for networking
- Codable for JSON parsing
- NavigationStack for navigation
- Charts for data visualization
- XCTest for unit/UI testing
- Clean Code: small, clear views, consistent naming, early guard statements, no dead code

### Backend API (Flask)
- Python 3.12
- Flask for REST API routes
- Docker (containerized deployment)
- Render (Free plan hosting with HTTPS)

## Requirements

### iOS
- macOS with **Xcode 15+**
- iOS 17 or later (target)
- Internet connection to access the Render API

### API (optional, if you develop locally)
- Python 3.12
- `pip` or `uv`
- Docker (optional for container builds)

## Environment Variables

### iOS
No private keys or secrets required. The app connects to the public API via HTTPS.

```swift
enum APIConfig {
    static let base = URL(string: "https://pearcoflaskapi.onrender.com")!
    static var reportsURL: URL { base.appendingPathComponent("/reports") }
    static var summaryURL: URL { base.appendingPathComponent("/summary") }
}.

## API Endpoints (Production)
Base URL:
https://pearcoflaskapi.onrender.com

Routes

Method	Endpoint	Description
GET	/	Health check (optionally add ?who=CafeCare)
GET	/reports	Returns disease probability reports in JSON
GET	/summary	Returns aggregated summary JSON

## Deployment (API on Render)
If the API is already live, skip this section.
To redeploy or fork it under another account:

Prerequisites
Repo must include:

app.py (Flask app exposing /, /reports, /summary)

Dockerfile

requirements.txt (recommended)

## Test:

https://<your-service>.onrender.com/

https://<your-service>.onrender.com/reports

https://<your-service>.onrender.com/summary

## Database / Data
The iOS app doesn’t store data locally; all information is fetched in real time from the API.

## Testing
iOS (XCTest)
Run tests directly in Xcode:
⌘ + U

## Linting / Formatting
Swift: Use built-in Xcode format or SwiftFormat (optional)

Python: Use black or ruff for style consistency

## Clean Code & Practices
Single Responsibility: Views only handle UI; networking logic isolated in API classes.

Consistent Naming: Descriptive variable names, plural nouns for collections.

No Dead Code: Remove unused prints and branches.

Early Guards: Fail fast using guard statements for invalid data or responses.

Friendly UX: Show clear messages for errors and loading states.

Inline Comments: Only where logic is non-obvious.

## Deployment Summary
iOS App

Build & Run in Xcode (Simulator or physical device)

Consumes the Render-hosted Flask API

Flask API

Deployed from GitHub using Docker on Render (Free plan)

## Useful Docs
Render Docs → https://render.com/docs

Flask → https://flask.palletsprojects.com/

SwiftUI → https://developer.apple.com/documentation/swiftui/

Charts → https://developer.apple.com/documentation/charts/
