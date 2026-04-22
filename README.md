# ArvyaX – Immersive Journaling App

A calm, minimal Flutter app for immersive audio sessions and post-session journaling.

---

## How to Run

1. Clone the repository
2. Run `flutter pub get`
3. Run `dart run build_runner build`
4. Run `flutter run`

> Requires Flutter 3.x and Dart 3.x

---

## Architecture

### Folder Structure

    lib/
      data/
        models/        # Ambience, JournalEntry (Hive)
        repositories/  # AmbienceRepository, JournalRepository
      features/
        ambience/      # Home + Details screens + Cubit
        player/        # Session Player screen + Cubit
        journal/       # Reflection + History screens + Cubit
      shared/
        theme/         # AppTheme (dark tokens)
        widgets/       # MiniPlayer (global)
      main.dart        # Hive init + entry point
      app.dart         # MultiBlocProvider + MaterialApp

### State Management

Cubit (flutter_bloc) was chosen for its simplicity and clear separation between business logic and UI. Each feature has its own Cubit and State class.

### Data Flow

    JSON File / Hive
          ↓
      Repository   ← only layer that knows the data source
          ↓
        Cubit      ← calls repo, transforms data, emits states
          ↓
       Screen      ← BlocBuilder listens and rebuilds
          ↓
       Widgets     ← receive data only, no Cubit knowledge

---

## Packages

| Package | Reason |
|---|---|
| `flutter_bloc` | Predictable state management with Cubit |
| `just_audio` | Stable audio playback with loop support |
| `hive_flutter` | Fast local persistence, minimal boilerplate |
| `uuid` | Unique IDs for journal entries |

## Bonus
**Haptic Feedback** — added on play/pause and save reflection for a more tactile, premium feel.
## Tradeoffs


If I had two more days, I would:
- Add proper app lifecycle handling (pause/resume session in background)
- Improve seek bar with smoother audio seeking
- Add date grouping in History screen
- Add onboarding screen for first-time users
- Add error state UI with snackbars and retry buttons
- Write unit tests for Cubits and Repositories
