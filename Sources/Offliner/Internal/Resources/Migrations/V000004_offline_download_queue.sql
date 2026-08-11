CREATE TABLE offline_download_queue
(
    resource_type          TEXT NOT NULL,
    resource_id            TEXT NOT NULL,
    parent_collection_type TEXT,
    parent_collection_id   TEXT,
    state                  TEXT NOT NULL,
    progress               DOUBLE,
    updated_at             TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (resource_type, resource_id)
);
