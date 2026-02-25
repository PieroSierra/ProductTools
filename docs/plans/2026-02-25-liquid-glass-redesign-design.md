# Liquid Glass Redesign — PercentCalculator

**Date:** 2026-02-25
**Platform:** macOS only (macOS 15.0 minimum, Liquid Glass on macOS 26+)
**Approach:** Glass Cards Layout (Approach A)

## Window & App Shell

- Remove `AppDelegate`, `WindowAccessor`, `TranslucentBackgroundView`
- Simple `WindowGroup` with `.windowToolbarStyle(.unified)`
- Default size ~480x520, allow resizing (set sensible min size)
- Liquid Glass View extensions (NerdBook pattern): `.glassEffect(.regular)` on macOS 26+, `.thinMaterial` fallback

## Layout

```
Window (resizable, unified toolbar)
├── Toolbar: App logo
└── ScrollView (.vertical)
    └── VStack (spacing: 16, padding)
        ├── Glass Card: "What is X% of Y?"
        ├── Glass Card: "X is what % of Y?"
        ├── Glass Card: "% change from X to Y"
        └── Glass Card: "Strip Formatting" (text editor)
```

Each card: VStack with title label (.secondary), input row (labels + plain text fields + borderedProminent button), result in `.title2.monospacedDigit()` on the glass surface. No green boxes.

## Controls & Interactions

- Text fields: `.textFieldStyle(.plain)` — clean on glass
- Buttons: `.borderedProminent`, `.controlSize(.regular)`
- Auto-copy-to-clipboard on every calculation (unchanged)
- `.onSubmit` on last field per row (unchanged)
- Text strip: same `onChange` behavior in a glass card

## Compatibility

- Deployment target: macOS 15.0
- `if #available(macOS 26.0, *)` for `.glassEffect()`, fallback to `.thinMaterial`
- No new dependencies

## Files Changed

1. `PercentCalculatorApp.swift` — rewrite (~30 lines)
2. `ContentView.swift` — rewrite (card layout, same calc logic)
3. `project.pbxproj` — deployment target bump
