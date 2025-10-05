# PearCoProject (CafeCare)

PearCo Swift App — iOS + Flask API stack

---

## 📡 API Repository

The Flask API code is available here:  
👉 [https://github.com/hectorpablogzz/PearCoFlaskAPI](https://github.com/hectorpablogzz/PearCoFlaskAPI)

Production base URL:  
`https://pearcoflaskapi.onrender.com`

---

## ⚙️ What's in the stack

### 🧭 Mobile App (iOS)
- Swift 5 / Xcode 15+ / iOS 17 SDK  
- SwiftUI (declarative UI)  
- Observation (`@Observable`) for state management  
- URLSession for networking  
- Codable for JSON parsing  
- NavigationStack for navigation  
- Charts for data visualization  
- XCTest for unit/UI testing  
- Clean Code: small, clear views, consistent naming, early `guard` statements, no dead code  

### ☕ Backend API (Flask)
- Python 3.12  
- Flask for REST API routes  
- Docker (containerized deployment)  
- Render (Free plan hosting with HTTPS)  

---

## 🧩 Requirements

### iOS
- macOS with **Xcode 15+**  
- iOS 17 or later (target)  
- Internet connection to access the Render API  

### API (optional, if you develop locally)
- Python 3.12  
- `pip` or `uv`  
- Docker *(optional for container builds)*  

---

## 🔐 Environment Variables

### iOS
No private keys or secrets required.  
The app connects directly to the public API via HTTPS.

```swift
enum APIConfig {
    static let base = URL(string: "https://pearcoflaskapi.onrender.com")!
    static var reportsURL: URL { base.appendingPathComponent("/reports") }
    static var summaryURL: URL { base.appendingPathComponent("/summary") }
}
```

---

## 🌐 API Endpoints (Production)

**Base URL:**  
`https://pearcoflaskapi.onrender.com`

| Method | Endpoint | Description |
|--------|-----------|-------------|
| `GET` | `/` | Health check (optional `?who=CafeCare`) |
| `GET` | `/reports` | Returns disease probability reports in JSON |
| `GET` | `/summary` | Returns aggregated summary JSON |

Example:  
```bash
curl https://pearcoflaskapi.onrender.com/summary
```

---

## 🚀 Deployment (API on Render)

If the API is already live, skip this section.  
To redeploy or fork it under another account:

### Prerequisites
Your repo must include:
- `app.py` (Flask app exposing `/`, `/reports`, `/summary`)
- `Dockerfile`
- `requirements.txt` *(recommended)*

### 🐳 Example Dockerfile
```dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
ENV PORT=8000

WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

COPY . /app
EXPOSE 8000

# Flask app exposed as "app:app"
CMD ["sh","-c","flask run --host=0.0.0.0 --port=${PORT}"]
```

### 🧾 Example requirements.txt
```
flask==3.0.0
# Add any libraries used for reports or data processing
```

### Steps to Deploy
1. Push your repo to GitHub.  
2. Go to [Render](https://render.com).  
3. Click **New + → Web Service**.  
4. Choose your repo and select **Docker** runtime (auto-detected).  
5. Choose the **Free Plan**.  
6. Wait for build → once live, test your endpoints:
   - `https://<your-service>.onrender.com/`
   - `https://<your-service>.onrender.com/reports`
   - `https://<your-service>.onrender.com/summary`

---

## 🗄️ Database / Data
The iOS app doesn’t store data locally; all information is fetched in real time from the API.  

---

## 🧪 Testing

### iOS (XCTest)
Run tests directly in Xcode:
```
⌘ + U
```
Example test names:
- `testReportsDecoding_validPayload_returnsModels()`
- `testSummaryRequest_http500_showsFriendlyError()`
- `testOffline_showsNoInternetMessage_andDoesNotCrash()`

---

## 🧹 Linting / Formatting
- **Swift:** Use Xcode’s built-in formatter or SwiftFormat  
- **Python:** Use `black` or `ruff` for style consistency  

---

## 🧼 Clean Code Practices
- **Single Responsibility:** Views handle UI only; networking isolated in API layer.  
- **Consistent Naming:** Descriptive variable names, plural nouns for collections.  
- **No Dead Code:** Remove unused prints and logic branches.  
- **Early Guards:** Use `guard` to fail fast on invalid responses.  
- **Friendly UX:** Clear messages for errors and loading states.  
- **Inline Comments:** Only when logic isn’t obvious.  

---

## 📦 Deployment Summary

**iOS App**
- Build & run in Xcode (Simulator or device)  
- Connects to `https://pearcoflaskapi.onrender.com`

**Flask API**
- Deployed via Docker from GitHub to Render (Free plan)  
- HTTPS public endpoint ready to use  

---

## 📚 Useful Docs
- Render → [https://render.com/docs](https://render.com/docs)  
- Flask → [https://flask.palletsprojects.com/](https://flask.palletsprojects.com/)  
- SwiftUI → [https://developer.apple.com/documentation/swiftui/](https://developer.apple.com/documentation/swiftui/)  
- Charts → [https://developer.apple.com/documentation/charts/](https://developer.apple.com/documentation/charts/)  


