# PearCoProject
PearCo Swift App

## API
The code for the API can be found at: https://github.com/hectorpablogzz/PearCoFlaskAPI/tree/main

# CafeCare (iOS + Flask API)

## What the app does
**CafeCare** is an iOS app (SwiftUI) that displays relevant information about coffee plant diseases, as well as features a voice agent and machine learning to analyze pictures as well.  
The app consumes a **Flask** API hosted on **Render**.

## Stack Used
- **Mobile App:** Swift 5, SwiftUI, Observation (`@Observable`), URLSession
- **Backend API:** Python 3.12, **Flask**
- **Packaging:** Docker (Dockerfile)
- **Hosting / Deploy:** Render (Free plan)

## API (production)
Base URL: `https://pearcoflaskapi.onrender.com`

**Endpoints**
- `GET /` — health/demo endpoint  
  - Optional query param: `who`  
  - Example: `https://pearcoflaskapi.onrender.com/?who=CafeCare`  
  - Response:
    ```json
    { "message": "it works, CafeCare!" }
    ```
- `GET /reports` — returns raw reports JSON for coffee disease probabilities  
- `GET /summary` — returns aggregated/summary JSON

> JSON shapes can evolve; the iOS app decodes the fields it needs.

## 📱 How to run the iOS app
- **Requirements:** Xcode 15+, iOS 17+
- Open the project in Xcode and run (`Cmd + R`).
- Networking snippet (example):

```swift
enum APIConfig {
    static let base = URL(string: "https://pearcoflaskapi.onrender.com")!
    static var reportsURL: URL { base.appendingPathComponent("/reports") }
    static var summaryURL: URL { base.appendingPathComponent("/summary") }
}
