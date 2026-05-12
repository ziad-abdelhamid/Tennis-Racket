# 🎾 TenniSwing — Flutter Tennis Racket App

Use your phone as a Wii-style tennis racket. Swing it and see the physics in real time:  
**Force (N), Acceleration (m/s²), and Rotation Angle (°/s)** — all calculated live.

---

## 📱 Screenshots / Feature Overview

| Screen | Description |
|--------|-------------|
| **Play** | Live racket visual + 3 sensor meters + swing result card |
| **Stats** | Force chart, swing type breakdown, full swing log |

---

## ⚙️ Setup & Installation

### Prerequisites
- Flutter SDK ≥ 3.10 ([install](https://docs.flutter.dev/get-started/install))
- Android Studio or Xcode (for running on device)
- **Physical device required** — emulators don't have real sensors

### 1. Clone / copy the project
```bash
cd tennis_racket_app
```

### 2. Add fonts (required)
Download these free fonts and place them in `assets/fonts/`:
- **Rajdhani** (Regular, SemiBold, Bold) — [Google Fonts](https://fonts.google.com/specimen/Rajdhani)
- **Space Mono** (Regular, Bold) — [Google Fonts](https://fonts.google.com/specimen/Space+Mono)

Create the directories:
```bash
mkdir -p assets/fonts assets/sounds
```

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Run on device
```bash
# Android
flutter run --release

# iOS (requires Mac + Xcode)
flutter run --release
```

---

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry, orientation lock, wakelock
├── theme/
│   └── app_theme.dart           # Dark court aesthetic, color tokens, typography
├── models/
│   └── swing_data.dart          # SwingData, SwingSession, enums + physics
├── services/
│   └── sensor_service.dart      # Accelerometer + gyroscope fusion, swing detection
├── screens/
│   ├── home_screen.dart         # Bottom nav shell
│   ├── play_screen.dart         # Live play: racket + meters + result card
│   └── stats_screen.dart        # Session analytics + charts
└── widgets/
    ├── racket_painter.dart       # Custom canvas racket with glow/strings
    ├── live_meter.dart           # Animated bar meter (accel / force / ω)
    └── swing_result_card.dart   # Post-swing breakdown card
```

---

## 🧮 Physics Engine

### Force Calculation
```
F = m × a

Where:
  m = 0.19 kg  (average smartphone mass)
  a = √(ax² + ay² + az²)  (total linear acceleration magnitude, m/s²)
  F = Force in Newtons
```

The app uses `userAccelerometer` (gravity-compensated) so only your hand motion contributes to `a`.

### Rotation Angle
```
ω = √(gx² + gy² + gz²)   [rad/s — instantaneous angular velocity]
θ = ∫ω dt                  [degrees — accumulated during swing]
```

Gyroscope readings are integrated over time to give total rotation during each swing.

### Swing Detection Algorithm
```
State machine:
  IDLE → SWINGING  when |a| > 12 m/s²  (threshold = start of swing)
  SWINGING → IDLE  when |a| < 4 m/s²   (threshold = follow-through end)
  Peak values captured during SWINGING state
  Valid swing requires peak |a| ≥ 15 m/s²
  800 ms cooldown between swings
```

### Swing Type Classification
| Type | Detection Logic |
|------|----------------|
| **Forehand** | Dominant X-axis, positive direction |
| **Backhand** | Dominant X-axis, negative direction |
| **Serve** | Strong upward Z-axis (> 5 m/s²) |
| **Smash** | Dominant Y-axis (forward) |

### Swing Power Tiers
| Power | Force Range |
|-------|------------|
| Soft | < 3 N |
| Medium | 3–8 N |
| Hard | 8–15 N |
| SMASH | > 15 N |

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `sensors_plus` | Accelerometer + gyroscope streams |
| `vibration` | Haptic feedback scaled to swing force |
| `flutter_animate` | Swing flash, slide-in animations |
| `fl_chart` | Force-over-time line chart |
| `wakelock_plus` | Keep screen on during play |

---

## 🎮 How to Play

1. **Grip your phone** firmly like a tennis racket (landscape works too but portrait preferred)
2. Tap **START SESSION**
3. **Swing your arm** like hitting a tennis ball — forehand, backhand, serve motions all work
4. After each swing the **result card** shows:
   - Swing type detected
   - Force in Newtons (F = m × a)
   - Peak acceleration
   - Rotation speed (°/s)
   - Full formula breakdown
5. Check **STATS** tab for your session history and charts

---

## 🔧 Calibration Tips

- The phone mass constant (`phoneMassKg = 0.19`) can be changed in `swing_data.dart` to your phone's actual mass for accurate force readings
- Swing detection thresholds in `sensor_service.dart` can be tuned if the app is too sensitive or misses swings
- Sampling rate depends on device hardware (~100 Hz typical)

---

## 📄 License

MIT — free to use, modify, and share.
