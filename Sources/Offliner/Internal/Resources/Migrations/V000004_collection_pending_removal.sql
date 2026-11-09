CREATE TABLE offline_collection_pending_removal
(
    resource_type TEXT NOT NULL,
    resource_id   TEXT NOT NULL,
    removed_at    TEXT NOT NULL,

    PRIMARY KEY (resource_type, resource_id)
);
