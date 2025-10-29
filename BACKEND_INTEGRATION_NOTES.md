# Format Variant Monitoring - Backend Integration Notes

This document describes how the FormatVariantMonitor integrates with the backend's timed metadata in HLS manifests.

## Backend Implementation Reference

**Source**: [bits-ilmanifesto PR #105](https://github.com/tidal-engineering/bits-ilmanifesto)
**Commit**: `4ad24ab` - "Write the format as timed metadata in media playlists (#105)"
**File**: `src/main/java/com/tidal/ilmanifesto/manifest/hls/HlsMediaPlaylistFactory.java`

## Expected HLS Metadata Format

The backend adds format metadata to HLS playlists using the `EXT-X-DATERANGE` tag with `com.tidal.format` class identifier:

```
#EXT-X-PROGRAM-DATE-TIME:2025-10-29T10:30:45.123Z
#EXT-X-DATERANGE:ID="HIGH",CLASS="com.tidal.format",START-DATE="2025-10-29T10:30:45.123Z",X-COM-TIDAL-FORMAT="HIGH"
```

### Metadata Structure

From backend implementation (`createFormatMetadataLines`):

```java
var format = traits.format().name();  // Enum name: "HIGH", "LOW", "LOSSLESS", "HI_RES_LOSSLESS"
var extXDaterange = new ExtXDaterange(
    Attribute.createQuoted("ID", format),                          // ID = format name
    Attribute.createQuoted("CLASS", "com.tidal.format"),           // Fixed class identifier
    Attribute.createQuoted("START-DATE", time.toString()),         // ISO 8601 timestamp
    Attribute.createQuoted("X-COM-TIDAL-FORMAT", format));         // Format name again
```

**EXT-X-DATERANGE Attributes**:
- **ID**: Format quality level name (e.g., "HIGH", "LOW", "LOSSLESS", "HI_RES_LOSSLESS")
- **CLASS**: Fixed value `"com.tidal.format"` (identifies this as format metadata)
- **START-DATE**: ISO 8601 timestamp when format becomes active
- **X-COM-TIDAL-FORMAT**: Format quality level name (duplicated from ID)

### Format String Format

The `X-COM-TIDAL-FORMAT` attribute contains the format enum name as a simple string:

**Valid Format Values** (from backend enum):
- `LOW` - Low quality (AAC, ~128 kbps)
- `HIGH` - High quality (AAC, ~320 kbps)
- `LOSSLESS` - Lossless quality (FLAC, 16-bit/44.1 kHz)
- `HI_RES_LOSSLESS` - Hi-Res lossless (FLAC, 24-bit/96+ kHz)

**Example HLS output**:
```
#EXT-X-PROGRAM-DATE-TIME:2025-10-29T10:30:00.000Z
#EXT-X-DATERANGE:ID="HIGH",CLASS="com.tidal.format",START-DATE="2025-10-29T10:30:00.000Z",X-COM-TIDAL-FORMAT="HIGH"
...segments...
#EXT-X-PROGRAM-DATE-TIME:2025-10-29T10:31:00.000Z
#EXT-X-DATERANGE:ID="LOSSLESS",CLASS="com.tidal.format",START-DATE="2025-10-29T10:31:00.000Z",X-COM-TIDAL-FORMAT="LOSSLESS"
...segments...
```

## Client Implementation

### How the Monitor Works

1. **Setup**: When a player item is created, `AVPlayerItemMonitor` automatically creates a `FormatVariantMonitor`
2. **Listening**: The monitor sets up `AVPlayerItemMetadataOutput` with the identifier `"com.tidal.format"`
3. **Detection**: When the HLS stream contains `EXT-X-DATERANGE` tags with `CLASS="com.tidal.format"`, the metadata callback is triggered
4. **Extraction**: Format value is extracted from the metadata item using multiple strategies (to handle AVFoundation variations):
   - Direct string value from `metadataItem.value`
   - Dictionary value with `X-COM-TIDAL-FORMAT` key
   - Extra attributes dictionary
5. **Deduplication**: If the format hasn't changed from the last report, the update is ignored
6. **Reporting**: Format changes are propagated via `PlayerMonitoringDelegate.formatVariantChanged(asset:variant:)`

### FormatVariantMetadata

The monitor reports changes as a `FormatVariantMetadata` struct:

```swift
public struct FormatVariantMetadata: Equatable {
    public let formatString: String      // "HIGH", "LOW", "LOSSLESS", or "HI_RES_LOSSLESS"
    public let timestamp: CMTime         // When format became active (from START-DATE)
}
```

### Supported Metadata Item Formats

The implementation supports multiple ways AVFoundation might expose the metadata:

```swift
// Strategy 1: Direct string value
metadataItem.value = "HIGH"

// Strategy 2: Dictionary with X-COM-TIDAL-FORMAT key
metadataItem.value = ["X-COM-TIDAL-FORMAT": "HIGH"]

// Strategy 3: Extra attributes
metadataItem.extraAttributes = ["X-COM-TIDAL-FORMAT": "HIGH"]
```

## Testing

The implementation includes 13 comprehensive tests:

- ✅ Format metadata creation and equality
- ✅ Multiple format values (LOW, HIGH, LOSSLESS, HI_RES_LOSSLESS)
- ✅ Timestamp handling and comparison
- ✅ Description/logging output
- ✅ Monitor initialization and cleanup
- ✅ Callback integration
- ✅ Deduplication logic (same format not reported twice)
- ✅ Format variant detection (different formats reported)

### Test Examples

```swift
// Format extraction with backend values
testExtractsFormatFromStringValue()
// Examples: "HIGH", "LOW", "LOSSLESS", "HI_RES_LOSSLESS"

// Multiple format variants
testHandlesMultipleFormatAttributes()
// Handles: LOW, HIGH, LOSSLESS, HI_RES_LOSSLESS format values

// Format change detection
testMonitorDetectsDifferentFormats()
// Correctly identifies: "HIGH" → "LOSSLESS" as a change
```

### Example Test Case

From the test suite, simulating backend format metadata:

```swift
let timestamp = CMTime(seconds: 5.0, preferredTimescale: 1000)
let metadata = FormatVariantMetadata(
    formatString: "HIGH",      // Backend sends: X-COM-TIDAL-FORMAT="HIGH"
    timestamp: timestamp
)

XCTAssertEqual(metadata.formatString, "HIGH")
XCTAssertTrue(metadata.formatString == "HIGH")
```

# Client-Backend Verification

## Format String Mapping

Backend Format Enum → Client FormatVariantMetadata:

| Backend Enum | Description | Client Format String |
|---|---|---|
| LOW | Low quality AAC (~128 kbps) | `"LOW"` |
| HIGH | High quality AAC (~320 kbps) | `"HIGH"` |
| LOSSLESS | Lossless FLAC (16-bit/44.1 kHz) | `"LOSSLESS"` |
| HI_RES_LOSSLESS | Hi-Res lossless (24-bit/96+ kHz) | `"HI_RES_LOSSLESS"` |

## Integration Verification Checklist

- [x] Monitor initializes without errors
- [x] Metadata output is properly configured for `"com.tidal.format"` identifier
- [x] Format extraction handles multiple AVFoundation metadata formats
- [x] Deduplication works (prevents duplicate events for same format)
- [x] Callbacks propagate to delegates correctly
- [x] Proper cleanup on deinit
- [x] Debug logging for troubleshooting
- [x] Backend format values tested (HIGH, LOW, LOSSLESS, HI_RES_LOSSLESS)
- [x] Timestamp extraction and conversion working

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
