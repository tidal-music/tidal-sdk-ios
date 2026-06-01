ALTER TABLE offline_item_relationship
ADD COLUMN added_at TEXT;

CREATE INDEX idx_rel_collection_position
ON offline_item_relationship(
    collection_resource_type,
    collection_resource_id,
    volume,
    position,
    id);

CREATE INDEX idx_rel_collection_added_at
ON offline_item_relationship(
    collection_resource_type,
    collection_resource_id,
    added_at,
    id);
