# Task Manager — CW-03 Firebase w/ CRUD Operations

**CSC 4360 — Mobile App Development**
**Tanaka Makuvaza** | Georgia State University | M.S. Computer Science

A Flutter task management application backed by Firebase Firestore with full CRUD operations, real-time synchronization, and nested subtask support.

## Features

### Core
- Add, read, update, and delete tasks synced to Firestore in real time
- Toggle task completion with visual strikethrough feedback
- Nested subtasks: expand any task to add, toggle, or remove subtask items
- Real-time StreamBuilder updates — no manual refresh required
- Input validation (empty titles rejected with SnackBar feedback)
- Confirmation dialog before task deletion
- Loading spinner and empty-state messaging

### Enhanced Features

**1. Real-Time Search/Filter**
A search bar below the task input filters the displayed task list by title as the user types. I chose this feature because it demonstrates client-side filtering over a live Firestore stream without additional queries, which is a practical pattern for scaling task lists beyond a handful of items.

**2. System Dark Mode (ThemeMode.system)**
The app respects the device's system theme preference using `ThemeMode.system` with Material 3 color schemes. I chose this because it improves accessibility and user comfort without requiring a manual toggle, and it showcases how `MaterialApp` theme configuration works with `ColorScheme.fromSeed` for both light and dark variants.

## Project Structure

```
lib/
  main.dart                  # App entry, Firebase init, theme config
  models/
    task.dart                # Task data model with toMap/fromMap/copyWith
  services/
    task_service.dart        # Firestore CRUD + stream abstraction
  screens/
    task_list_screen.dart    # Main StatefulWidget with StreamBuilder UI
  widgets/
    task_tile.dart           # Reusable task card with expandable subtasks
```

## Setup Instructions

1. **Prerequisites**: Flutter SDK (3.10+), Firebase CLI, FlutterFire CLI
2. Clone the repository
3. Run `flutter pub get` in the `task_manager/` directory
4. Firebase is pre-configured for project `mad-cw03-taskmanager-tmaku`
   - If reconfiguring: `flutterfire configure --project=mad-cw03-taskmanager-tmaku`
5. Run: `flutter run`

## Known Limitations

- Firestore security rules are in open test mode (`allow read, write: if true`) — not suitable for production
- No user authentication; all tasks are shared across all app instances
- Search filtering is case-insensitive but client-side only; large datasets would benefit from Firestore compound queries
- Subtask ordering is array-index based; reordering is not implemented
- No offline persistence configuration beyond Firestore defaults

## Firebase Project

- **Project ID**: `mad-cw03-taskmanager-tmaku`
- **Database**: Firestore Native (nam5 region)
- **Collection**: `tasks`

## Commit History

The repository commit history demonstrates incremental development:
1. Project setup and Firebase configuration
2. Task data model
3. Service layer with Firestore CRUD
4. UI with StreamBuilder, search, and subtask support
5. Polish and documentation
