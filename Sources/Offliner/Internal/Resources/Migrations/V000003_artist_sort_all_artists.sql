-- V000002 populated `artist_sort` with only the primary artist (`$.artists[0]`). Re-backfill it with a
-- comma-separated list of every credited artist so collection search matches any of them. The joined list still
-- begins with the primary artist, so sorting by `artist_sort` is unchanged.
UPDATE offline_item_relationship
SET artist_sort = COALESCE((
        SELECT LOWER(group_concat(je.value, ', '))
        FROM offline_item i, json_each(i.catalog_metadata, '$.artists') je
        WHERE i.resource_type = offline_item_relationship.member_resource_type
          AND i.resource_id = offline_item_relationship.member_resource_id
    ), '');
