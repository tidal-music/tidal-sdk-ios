CREATE TABLE offline_item
(
    id TEXT PRIMARY KEY,

    resource_type    TEXT NOT NULL,
    resource_id      TEXT NOT NULL,

    metadata         TEXT NOT NULL,
    media_bookmark   BLOB,
    license_bookmark BLOB,
    artwork_bookmark BLOB,

    created_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (resource_type, resource_id)
);

CREATE TABLE offline_item_relationship
(
    id INTEGER PRIMARY KEY,

    collection TEXT NOT NULL,
    member     TEXT NOT NULL,

    volume     INTEGER NOT NULL,
    position   INTEGER NOT NULL,

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (collection, volume, position)
);

CREATE INDEX idx_rel_collection_order_cover
ON offline_item_relationship(collection, volume, position, member);

CREATE TRIGGER offline_item_set_updated_at
AFTER UPDATE ON offline_item
FOR EACH ROW
WHEN NEW.updated_at = OLD.updated_at
BEGIN
  UPDATE offline_item
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = OLD.id;
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
