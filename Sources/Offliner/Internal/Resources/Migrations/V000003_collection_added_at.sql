CREATE TABLE offline_collection_added_at
(
    resource_type TEXT NOT NULL,
    resource_id   TEXT NOT NULL,
    added_at      TEXT NOT NULL,

    PRIMARY KEY (resource_type, resource_id)
);

INSERT INTO offline_collection_added_at (resource_type, resource_id, added_at)
SELECT resource_type, resource_id, created_at
FROM offline_item
WHERE resource_type IN ('albums', 'playlists', 'userCollectionTracks');
