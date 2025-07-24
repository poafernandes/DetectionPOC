---

# 📱 iOS Pose Detection Proof of Concept (Google ML Kit)

This is a **proof-of-concept (PoC)** iOS native app demonstrating **real-time pose detection** using the **Google MLKit** library on a live camera stream. The app is built using **SwiftUI** and integrates dependencies via **CocoaPods**.

> ⚠️ This project is a **work in progress** and is actively being tested and optimized for performance. Currently, testing has been done **only on an iPhone 13**.

---

## 🚀 Features

* Real-time camera feed using `AVCaptureSession`
* Integration of Google MLKit’s **Pose Detection** API
* SwiftUI-based UI layer
* Modular architecture to separate vision processing and UI

---

## 🔧 Tech Stack

* **SwiftUI** for modern UI declarative layout
* **Google MLKit Pose Detection**
* **CocoaPods** for dependency management
* **AVFoundation** for camera access

---

## ⚙️ Setup

1. Clone the repo:

2. Install dependencies:

   ```bash
   pod install
   ```

3. Open the `.xcworkspace` file in Xcode.

4. Make sure to run on a real device (preferably iPhone 13 or newer) with camera access enabled.

---

## 📋 Current Status

* ✅ Camera stream integration
* ✅ Initial pose detection integration
* ⚠️ Performance optimization still in progress
* ❌ Not yet tested on devices other than iPhone 13

---

## 🛠️ Roadmap

* [ ] Improve real-time performance and frame processing efficiency
* [ ] Support for more iOS devices
* [ ] Frame skipping or throttling for smoother performance
* [ ] Add visual feedback overlays (e.g., pose skeleton)

---

## 📱 Device Support

| Device    | Status            |
| --------- | ----------------- |
| iPhone 13 | ✅ Tested          |
| Others    | ⚠️ Not yet tested |

---
