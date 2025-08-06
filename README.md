# 🏡 NoBrokerz — Visitor Approval App

NoBrokerz is a Flutter-based mobile application that simplifies visitor management in residential communities. Inspired by apps like NoBrokerHood, it allows **guards to request entry approvals** and **residents to accept or deny them in real-time**, with optional **pre-approval** features.

---

## ✨ Features

### 🛡️ Guard Panel:
- Request visitor approval using resident house number
- View and manage the Resident Log Book
- Receive real-time notifications for approvals/denials

### 🏠 Resident Panel:
- Login with house number
- Submit details (name, phone, etc.) on first login
- View pending visitor requests
- Approve / Deny requests
- Pre-approve expected visitors
- View approval/denial history

---

## 🚀 Tech Stack

| Layer           | Technology                      |
|----------------|----------------------------------|
| Frontend       | Flutter                          |
| Backend        | Firebase Firestore (NoSQL DB)    |
| Auth / State   | Firebase Auth (Anonymous)        |
| Notifications  | Firebase Cloud Messaging (FCM)   |
| UI Components  | Material UI                      |
| Push Handling  | `firebase_messaging` plugin      |

---

<!--  📱 Screenshots

| Resident Dashboard | Guard Screen |
|--------------------|--------------|
| ![Resident UI](path_to_resident_image) | ![Guard UI](path_to_guard_image) |-->

---

## 🔧 Project Structure 
lib/
├── guard/
│ ├── guard_home.dart
│ └── request_visitor.dart
├── resident/
│ ├── resident_login.dart
│ ├── dashboard.dart
│ └── approval_history.dart
├── widgets/
│ └── custom_button.dart
└── main.dart



---

## 🔁 API Integration (Firebase)

- All data (residents, requests, responses) are stored in **Cloud Firestore**.
- **Push notifications** sent using **Firebase Cloud Messaging (FCM)**.
- Realtime updates implemented using `StreamBuilder`.

```dart
StreamBuilder(
  stream: FirebaseFirestore.instance
    .collection('visitor_requests')
    .snapshots(),
  builder: (context, snapshot) {
    // Handle request display
  },
);


