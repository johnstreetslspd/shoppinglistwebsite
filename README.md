# Einkaufsliste / Shopping List

Eine Einkaufslisten-App – als Web-Version und als native iOS/iPadOS/macOS App mit SwiftUI.

## Web-Version

Die Datei `index.html` enthält die vollständige Web-App. Einfach im Browser öffnen – keine Installation nötig.

## Native SwiftUI App (iOS / iPadOS / macOS)

Im Ordner `Einkaufsliste/` befindet sich ein vollständiges Xcode-Projekt für eine native Apple App.

### Features

- 📝 **Artikel hinzufügen & verwalten** – Schnelles Hinzufügen neuer Artikel zur Liste
- ✅ **Abhaken & Erledigen** – Artikel als erledigt markieren mit Streicheffekt
- 🗂️ **Kategorien mit Priorität** – Artikel in Kategorien einordnen und Reihenfolge anpassen
- 🗑️ **Swipe zum Löschen** – Native Swipe-Geste zum Entfernen von Artikeln
- 📳 **Haptic Feedback** – Taktiles Feedback bei Interaktionen
- 🌙 **Dark Mode** – Vollständige Unterstützung für helles und dunkles Design
- 📱 **iPhone & iPad** – Optimiert für alle Apple-Geräte
- 💻 **Mac Catalyst** – Läuft auch als native Mac-App
- 💾 **Lokale Speicherung** – Daten werden automatisch in UserDefaults gespeichert
- 🎨 **SF Symbols** – Native Apple Icons für ein konsistentes Design
- ⚡ **SwiftUI Animationen** – Flüssige Spring-Animationen für alle Interaktionen

### Voraussetzungen

- **Xcode 15** oder neuer
- **iOS 17.0** / **iPadOS 17.0** / **macOS 14.0** oder neuer
- **Swift 5.9** oder neuer

### Projekt öffnen

1. Öffne `Einkaufsliste/Einkaufsliste.xcodeproj` in Xcode
2. Wähle ein Zielgerät (Simulator oder echtes Gerät)
3. Drücke `Cmd + R` zum Starten

### Projektstruktur

```
Einkaufsliste/
├── Einkaufsliste.xcodeproj/     # Xcode Projekt-Datei
└── Einkaufsliste/
    ├── EinkaufslisteApp.swift    # App-Einstiegspunkt
    ├── Models/
    │   ├── ShoppingItem.swift    # Datenmodell: Einkaufsartikel
    │   └── Category.swift        # Datenmodell: Kategorie
    ├── ViewModels/
    │   └── ShoppingListStore.swift # Zentraler Store mit Persistenz
    ├── Views/
    │   ├── ContentView.swift     # Hauptansicht mit Eingabe & Navigation
    │   ├── ShoppingListView.swift # Listenansicht mit Gruppierung
    │   └── CategoryManagementView.swift # Kategorie-Verwaltung (Sheet)
    ├── Assets.xcassets/          # App-Icons & Farben
    └── Preview Content/          # SwiftUI Preview Assets
```
