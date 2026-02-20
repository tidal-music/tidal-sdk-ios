CREATE TABLE offline_item
(
    resource_type    TEXT NOT NULL,
    resource_id      TEXT NOT NULL,

    catalog_metadata  TEXT NOT NULL,
    playback_metadata TEXT,
    media_bookmark    BLOB,
    license_bookmark BLOB,
    artwork_bookmark BLOB,

    created_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (resource_type, resource_id)
);

CREATE TABLE offline_item_relationship
(
    id INTEGER PRIMARY KEY,

    collection_resource_type TEXT NOT NULL,
    collection_resource_id   TEXT NOT NULL,
    member_resource_type     TEXT NOT NULL,
    member_resource_id       TEXT NOT NULL,

    volume     INTEGER NOT NULL,
    position   INTEGER NOT NULL,

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (collection_resource_type, collection_resource_id, volume, position)
);

CREATE INDEX idx_rel_collection_order_cover
ON offline_item_relationship(
    collection_resource_type,
    collection_resource_id,
    member_resource_type,
    member_resource_id,
    volume,
    position);

CREATE TRIGGER offline_item_set_updated_at
AFTER UPDATE ON offline_item
FOR EACH ROW
WHEN NEW.updated_at = OLD.updated_at
BEGIN
  UPDATE offline_item
  SET updated_at = CURRENT_TIMESTAMP
  WHERE resource_type = OLD.resource_type AND resource_id = OLD.resource_id;
END;

CREATE TRIGGER offline_item_relationship_set_updated_at
AFTER UPDATE ON offline_item_relationship
FOR EACH ROW
WHEN NEW.updated_at = OLD.updated_at
BEGIN
  UPDATE offline_item_relationship
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = OLD.id;
END;
