import Foundation

/// Well-defined enums for trackManifest API parameters to prevent client errors
public enum TrackManifestParameters {
    
    /// Manifest type for different platforms
    public enum ManifestType: String, CaseIterable {
        case hls = "HLS"            // iOS uses HLS
        case mpegDash = "MPEG_DASH" // Android and web use MPEG_DASH
    }
    
    /// URI scheme for manifest delivery  
    public enum UriScheme: String, CaseIterable {
        case data = "DATA"         // Embeds manifest in response (single roundtrip)
        case http = "HTTP"         // Returns HTTP URL to manifest (two roundtrips)
        case https = "HTTPS"       // Returns HTTPS URL to manifest (two roundtrips)
    }
    
    /// Usage context for the manifest request
    public enum Usage: String, CaseIterable {
        case playback = "PLAYBACK" // For streaming playback
        case download = "DOWNLOAD" // For offline downloads
    }
    
    /// Whether to return adaptive manifest with all formats
    public enum Adaptive: String, CaseIterable {
        case `true` = "true"       // Manifest with all selected formats
        case `false` = "false"     // Manifest with best quality format only
    }
}
