CREATE TABLE offline_resource_operation
(
    resource_type TEXT NOT NULL,
    resource_id   TEXT NOT NULL,
    action        TEXT NOT NULL,
    state         TEXT NOT NULL,
    updated_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (resource_type, resource_id)
);
