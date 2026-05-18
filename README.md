# Anti-Theft Guard 🛡️

**Anti-Theft Guard** is a high-security, stealth-focused mobile application built with Flutter. It is designed to covertly protect a user's device if it is stolen by utilizing hidden triggers, silent surveillance, live location tracking, and automated emergency communications.

> **Status:** Phase 2 (UI/UX) Completed. The application currently features a fully functional, static front-end architecture. Backend services and device APIs (camera, GPS, background tasks) are pending integration.

---

## 🎨 Design System

The application utilizes a custom **"Dark Mode First"** aesthetic, emphasizing a premium, tactical feel.
- **Glassmorphism:** Widespread use of frosted glass (`GlassCard`) to create depth.
- **Neon Accents:** Glowing interactive elements (`GlowButton`, `PulseIndicator`) color-coded by context:
  - <span style="color:#00E676">**Green (Success)**</span> for active protection.
  - <span style="color:#FF3131">**Red (Danger)**</span> for critical alerts and video recording.
  - <span style="color:#29B6F6">**Blue (Info)**</span> for location and front-facing cameras.
  - <span style="color:#FFB300">**Orange/Yellow (Warning)**</span> for back cameras and battery alerts.
- **Typography:** Uses Google's `Inter` for clean, modern readability, and `Source Code Pro` for logs/coordinates.
- **Micro-Animations:** Powered by `flutter_animate`, the app heavily utilizes staggered fade-ins and subtle slides (`.fadeIn().slideY()`) to make the interface feel responsive and modern.

---

## 📁 Project Architecture

The app follows a strict **Feature-First modular architecture** to maintain scalability and separation of concerns.

```text
lib/
├── core/                   # Shared resources across the entire app
│   ├── constants/          # AppRoutes, AppStrings
│   ├── theme/              # AppColors, AppTheme, AppTextStyles
│   └── widgets/            # Reusable UI (GlassCard, GlowButton, SectionHeader)
├── features/               # Isolated feature modules
│   ├── auto_start/         # Boot persistence settings
│   ├── battery/            # Battery level monitoring and alerts
│   ├── blackout/           # Fake "dead device" screen simulation
│   ├── dashboard/          # Main status overview hub
│   ├── location/           # Live GPS and timeline history
│   ├── logs/               # Chronological security events
│   ├── onboarding/         # Initial setup and PIN creation
│   ├── settings/           # Global preferences
│   ├── sms/                # Emergency payload configuration
│   ├── splash/             # Initial loading screen
│   ├── stealth/            # Master invisibility controls
│   ├── surveillance/       # Camera and Video capture interfaces
│   └── trigger_settings/   # Activation mechanics (Password, Volume)
├── navigation/             # App routing and shell
│   └── bottom_nav_shell.dart # Main 5-tab IndexedStack navigator
└── main.dart               # Entry point, Theme initialization, Route map
```

---

## 📱 Feature Set (UI Implemented)

### 1. Stealth Mechanics
*   **Stealth Mode:** A master control center to hide the app from the launcher, suppress notifications, disable camera shutter sounds, and keep the screen black during capture.
*   **Blackout Screen:** A fake "dead phone" screen designed to trick thieves into thinking the device is powered off or broken.
*   **Auto-Start:** Ensures the protection sequence survives a device reboot.

### 2. Triggers & Activation
*   **Trigger Settings:** Allows the user to dictate exactly how the anti-theft mode is activated.
*   **Custom Password:** Activates security mode upon entering a specific secret string.
*   **Volume Sequence:** Activates security via hardware button combinations (e.g., Up, Up, Down).

### 3. Surveillance
*   **Front Camera (Blue Theme):** Captures the thief's face silently upon failed unlock attempts. Includes crosshair preview and capture delay settings.
*   **Back Camera (Orange Theme):** Captures the surrounding environment to help identify location context. Includes flash and burst-mode settings.
*   **Video Recording (Red Theme):** Silently records background video without showing the standard system recording indicator.

### 4. Tracking & Communication
*   **Live Location:** A custom GPS interface showing live coordinates, accuracy, speed, and altitude.
*   **Location History:** A timeline view grouping historical location pings by date, showing distance traveled between points.
*   **Emergency SMS:** Configures trusted contacts and builds dynamic message payloads (GPS link, battery info, remote wipe codes) to be sent via SMS.
*   **Battery Monitor:** Visualizes current battery health, temperature, and a 6-hour discharge chart. Configures low-battery SMS triggers.

---

## 🚀 Next Steps (Phase 3: Integration)

To make the app fully functional, the following backend/hardware integrations are required:

1.  **Hardware Sensors:** Connect the Volume Sequence trigger to hardware key event listeners.
2.  **Camera/Media:** Integrate the `camera` package to capture real photos/videos and bypass shutter sounds via native channels.
3.  **Location Services:** Implement `geolocator` and `google_maps_flutter` for real GPS tracking and background location updates.
4.  **Background Tasks:** Utilize `workmanager` or `flutter_background_service` to ensure stealth mode, location pings, and video recording operate even when the app is swiped away.
5.  **Telephony:** Connect the Emergency SMS module to a native SMS sender or third-party API (like Twilio) to bypass standard messaging apps.
6.  **Persistence:** Use `shared_preferences` or `sqflite` to save user settings, PINs, and the Location/Log history.
