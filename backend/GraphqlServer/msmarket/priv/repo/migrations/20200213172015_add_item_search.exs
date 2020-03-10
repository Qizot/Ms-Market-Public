defmodule Msmarket.Repo.Migrations.AddItemSearch do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS unaccent")
    execute("CREATE EXTENSION IF NOT EXISTS pg_trgm")

    execute(
      """
      CREATE MATERIALIZED VIEW item_search AS
      SELECT
        items.id as id,
        items.name as name,
        (
        setweight(to_tsvector('polish', unaccent(items.name)), 'A') ||
        setweight(to_tsvector('polish', unaccent(items.description)), 'D')
        ) AS document
      FROM items;
      """
    )
    # to support full-text searches
    create index("item_search", ["document"], using: :gin)

    # to support substring name matches with ILIKE
    execute("CREATE INDEX item_search_name_trgm_index ON item_search USING gin (name gin_trgm_ops)")

    # to support updating CONCURRENTLY
    create unique_index("item_search", [:id])

    execute(
      """
      CREATE OR REPLACE FUNCTION refresh_item_search()
      RETURNS TRIGGER LANGUAGE plpgsql
      AS $$
      BEGIN
      REFRESH MATERIALIZED VIEW CONCURRENTLY item_search;
      RETURN NULL;
      END $$;
      """
    )


    execute(
      """
      CREATE TRIGGER refresh_item_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON items
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_item_search();
      """
    )

  end

  def down do

    execute("DROP TRIGGER IF EXISTS refresh_item_search on items")

    execute("DROP FUNCTION refresh_item_search")

    drop unique_index("item_search", [:id])

    execute("DROP INDEX item_search_name_trgm_index")

    drop index("item_search", ["document"])

    execute("DROP MATERIALIZED VIEW item_search")

  end
end
