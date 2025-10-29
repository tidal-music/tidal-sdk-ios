# Format Variant Monitoring - Backend Integration Notes

This document describes how the FormatVariantMonitor integrates with the backend's timed metadata in HLS manifests.

## Backend Implementation Reference

See: https://github.com/tidal-engineering/bits-ilmanifesto/pull/105

## Expected HLS Metadata Format

The backend adds format metadata to HLS playlists using the `EXT-X-DATERANGE` tag with a custom `com.tidal.format` identifier:

```
#EXT-X-DATERANGE:ID="com.tidal.format",START-DATE="2025-10-29T10:30:45Z",DURATION=5.0,X-COM-TIDAL-FORMAT="quality=HIGH,codec=AAC,sampleRate=44100"
```

### Metadata Structure

- **ID**: `com.tidal.format` (fixed identifier that the monitor listens for)
- **START-DATE**: ISO 8601 timestamp when the format variant becomes active
- **DURATION**: How long this variant is active (optional)
- **X-COM-TIDAL-FORMAT**: Custom attribute containing format details

### Format String Format

The `X-COM-TIDAL-FORMAT` attribute contains comma-separated key=value pairs describing the variant:

**Common attributes:**
- `quality`: Quality level (LOW, HIGH, LOSSLESS, HI_RES_LOSSLESS)
- `codec`: Audio codec (AAC, FLAC, ALAC, MP3, eAC3, Opus)
- `sampleRate`: Sample rate in Hz (44100, 96000, 192000)
- `bitDepth`: Bits per sample (16, 24, 32)
- `bitrate`: Bitrate in bps (optional, for reference)
- `audioObjectType`: AAC profile (2=LC, 5=HE, 29=HEv2)

**Example formats:**
```
quality=LOW,codec=AAC,sampleRate=44100
quality=HIGH,codec=AAC,sampleRate=44100,audioObjectType=2
quality=LOSSLESS,codec=FLAC,sampleRate=44100,bitDepth=16
quality=HI_RES_LOSSLESS,codec=FLAC,sampleRate=192000,bitDepth=24
quality=LOSSLESS,codec=eAC3
```

## Client Implementation

### How the Monitor Works

1. **Setup**: When a player item is created, `AVPlayerItemMonitor` automatically creates a `FormatVariantMonitor`
2. **Listening**: The monitor sets up `AVPlayerItemMetadataOutput` with the identifier `"com.tidal.format"`
3. **Detection**: When the HLS stream contains matching `EXT-X-DATERANGE` tags, `metadataOutput(:didOutputTimedMetadataGroups:from:)` is called
4. **Extraction**: Format data is extracted from the metadata item using multiple strategies:
   - Direct string value
   - Dictionary value with `X-COM-TIDAL-FORMAT` key
   - Extra attributes dictionary
5. **Deduplication**: If the format hasn't changed, the update is ignored
6. **Reporting**: Format changes are propagated via `PlayerMonitoringDelegate.formatVariantChanged(asset:variant:)`

### Supported Metadata Item Formats

The implementation supports multiple ways AVFoundation might expose the metadata:

```swift
// Strategy 1: Direct string value
metadataItem.value = "quality=HIGH,codec=AAC,sampleRate=44100"

// Strategy 2: Dictionary with X-COM-TIDAL-FORMAT key
metadataItem.value = ["X-COM-TIDAL-FORMAT": "quality=HIGH,..."]

// Strategy 3: Extra attributes
metadataItem.extraAttributes = ["X-COM-TIDAL-FORMAT": "quality=HIGH,..."]
```

## Testing

The implementation includes 13 comprehensive tests:

- ✅ Format metadata creation and equality
- ✅ Multiple format attribute combinations
- ✅ Timestamp handling
- ✅ Description/logging output
- ✅ Monitor initialization and cleanup
- ✅ Callback integration
- ✅ Deduplication logic
- ✅ Format variant detection

### Test Examples

```swift
// Format extraction with AAC
testExtractsFormatFromStringValue()
// Expected: "quality=HIGH,codec=AAC,sampleRate=44100"

// Multiple attribute combinations
testHandlesMultipleFormatAttributes()
// Handles: LOW, HIGH, LOSSLESS, HI_RES_LOSSLESS variants

// Format change detection
testMonitorDetectsDifferentFormats()
// Correctly identifies when quality/codec changes
```

## Integration Verification Checklist

- [x] Monitor initializes without errors
- [x] Metadata output is properly configured
- [x] Format extraction handles multiple input formats
- [x] Deduplication works (prevents duplicate events)
- [x] Callbacks propagate to delegates correctly
- [x] Proper cleanup on deinit
- [x] Debug logging for troubleshooting

## Debugging

If format variants aren't being detected, the monitor provides detailed debug output:

```
[FormatVariantMonitor] Metadata output initialized for format tracking
[FormatVariantMonitor] Extracted format from direct value: quality=HIGH,codec=AAC
[FormatVariantMonitor] Format changed: quality=HIGH,codec=AAC
```

Or if extraction fails:

```
[FormatVariantMonitor] Could not extract format. Item details:
[FormatVariantMonitor]   - identifier: com.tidal.format
[FormatVariantMonitor]   - key: nil
[FormatVariantMonitor]   - commonKey: nil
[FormatVariantMonitor]   - value type: NSString
[FormatVariantMonitor]   - extraAttributes keys: [...]
```

## Next Steps for Verification

1. **Backend PR Review**: Confirm the exact format of `X-COM-TIDAL-FORMAT` values
2. **Integration Test**: Test with actual HLS streams from bits-ilmanifesto
3. **Attribute Refinement**: Add any additional attributes as needed
4. **Client Usage**: Implement format change handling in PlaybackMonitor

## Related Files

- **Implementation**: `Sources/Player/PlaybackEngine/Internal/AVQueuePlayer/Observers/FormatVariantMonitor.swift`
- **Integration**: `Sources/Player/PlaybackEngine/Internal/AVQueuePlayer/AVPlayerItemMonitor.swift`
- **Delegation**: `Sources/Player/PlaybackEngine/Internal/PlayerMonitoringDelegate.swift`
- **Tests**: `Tests/PlayerTests/Player/PlaybackEngine/Internal/FormatVariantMonitorTests.swift`
