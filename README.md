# VST DAW Test App

A Flutter application that integrates with a custom VST plugin for DAW control.

## Project Overview

This project combines a Flutter MIDI controller app with a custom JUCE VST plugin, enabling MIDI control in professional DAWs.

## Components

### Flutter MIDI Controller App

- **Note control** (48-72, C3-C5)
- **Velocity control** (0-127)
- **MIDI Channel selection** (1-16)
- **Pitch Bend control** (0-16383)
- **Modulation control** (0-127)
- **Real-time MIDI message sending**

### JUCE VST Plugin

- **MIDI input reception**
- **Visual keyboard display**
- **Last note played display**
- **Pitch bend visualization**
- **Modulation visualization**
- **VST3 format compatible**

## Project Structure

```bash
lib/
├── domain/            # Core business logic
│   ├── entities/      # MIDI messages, notes
│   └── repositories/  # Abstract MIDI interface
├── application/       # Use cases
│   └── services/      # MIDI service implementation
├── infrastructure/    # External implementations
│   └── repositories/  # MIDI device communication
└── presentation/      # UI components
    └── screens/       # MIDI controller interface
juce_plugin/           # VST plugin implementation
```

## Building the JUCE VST Plugin

To build the JUCE VST plugin, follow these steps:

```bash
# Navigate to juce_plugin directory
cd juce_plugin

# Create and enter build directory
mkdir build
cd build

# Configure with CMake
cmake ..

# Build the plugin
cmake --build . --config Release
```

## Installing the VST3 Plugin

Copy the built VST3 plugin to the standard location:

```bash
# From build directory:
copy "VSTPlugin_artefacts\Release\VST3\VST Plugin.vst3" "C:\Program Files\Common Files\VST3"
```

## Getting Started with Flutter

This project is a starting point for a Flutter application.

### Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
