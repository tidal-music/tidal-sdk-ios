ALTER TABLE offline_item_relationship
ADD COLUMN added_at TEXT;

ALTER TABLE offline_item_relationship
ADD COLUMN added_at_sort TEXT GENERATED ALWAYS AS (COALESCE(added_at, '')) VIRTUAL;

ALTER TABLE offline_item_relationship ADD COLUMN title_sort TEXT NOT NULL DEFAULT '';
ALTER TABLE offline_item_relationship ADD COLUMN album_sort TEXT NOT NULL DEFAULT '';
ALTER TABLE offline_item_relationship ADD COLUMN artist_sort TEXT NOT NULL DEFAULT '';

UPDATE offline_item_relationship
SET title_sort = COALESCE((
        SELECT LOWER(COALESCE(json_extract(i.catalog_metadata, '$.title'), ''))
        FROM offline_item i
        WHERE i.resource_type = offline_item_relationship.member_resource_type
          AND i.resource_id = offline_item_relationship.member_resource_id
    ), ''),
    album_sort = COALESCE((
        SELECT LOWER(COALESCE(json_extract(i.catalog_metadata, '$.albumTitle'), ''))
        FROM offline_item i
        WHERE i.resource_type = offline_item_relationship.member_resource_type
          AND i.resource_id = offline_item_relationship.member_resource_id
    ), ''),
    artist_sort = COALESCE((
        SELECT LOWER(COALESCE(json_extract(i.catalog_metadata, '$.artists[0]'), ''))
        FROM offline_item i
        WHERE i.resource_type = offline_item_relationship.member_resource_type
          AND i.resource_id = offline_item_relationship.member_resource_id
    ), '');

CREATE INDEX idx_rel_collection_position
ON offline_item_relationship(
    collection_resource_type,
    collection_resource_id,
    volume,
    position,
    id);

CREATE INDEX idx_rel_collection_added_at_sort
ON offline_item_relationship(
    collection_resource_type,
    collection_resource_id,
    added_at_sort,
    id);

CREATE INDEX idx_rel_collection_title_sort
ON offline_item_relationship(
    collection_resource_type,
    collection_resource_id,
    title_sort,
    id);

CREATE INDEX idx_rel_collection_album_sort
ON offline_item_relationship(
    collection_resource_type,
    collection_resource_id,
    album_sort,
    id);

CREATE INDEX idx_rel_collection_artist_sort
ON offline_item_relationship(
    collection_resource_type,
    collection_resource_id,
    artist_sort,
    id);
