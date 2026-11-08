# flutter_thermal_printer 2.3.0 (patched)

Copy of flutter_thermal_printer 2.3.0 from pub.dev (example and tests left out), used through
`dependency_overrides` in the app's pubspec.yaml.

One change: `macos/flutter_thermal_printer/Sources/flutter_thermal_printer/PrinterDiscovery.swift`.
With the macOS 26+ SDK (Xcode 26/27), `PMPrinterGetName` and `PMPrinterGetID` return `CFString?`
instead of `Unmanaged<CFString>?`, so 2.3.0 fails to build:

    error: value of type 'CFString' has no member 'takeUnretainedValue'

The patch adds two `cfString` overloads so the file compiles with old and new SDKs.

Remove this folder and the override once a fixed version is published on pub.dev.
