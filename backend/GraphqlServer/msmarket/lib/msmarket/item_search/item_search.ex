defmodule Msmarket.ItemSearch do
  import Ecto.Query

  def run(query, search_string) do

    _run(query, search_string |> normalize)
  end



  defmacro matching_item_ids_and_ranks(normalized, original) do
    quote do
      fragment(
        """
        SELECT result.id, ts_rank(
          result.document, to_tsquery('polish', unaccent(?))
        ) AS rank
        FROM
        (
          SELECT item_search.id AS id, item_search.document
          FROM item_search
          WHERE item_search.document @@ to_tsquery('polish', unaccent(?))
          OR item_search.name ILIKE ?
        ) as result
        """,
        ^unquote(normalized),
        ^unquote(normalized),
        ^"%#{unquote(original)}%"
        )
    end
  end

  defp _run(query, ""), do: query
  defp _run(query, search_string) do
    from item in query,
      join: id_and_rank in matching_item_ids_and_ranks(search_string |> parse_search_string, search_string),
      on: id_and_rank.id == item.id,
      order_by: [desc: id_and_rank.rank]
  end


  defp parse_search_string(search_string) do
    result = search_string
    |> String.split(" ")
    |> Enum.join(" | ")
    result <> ":*" # apply asterix to last word as it is the most probable to be unfinished
  end

  defp normalize(search_string) do
    search_string
    |> String.downcase
    |> String.replace(~r/\n/, " ")
    |> String.replace(~r/\t/, " ")
    |> String.replace(~r/\s{2,}/, " ")
    |> String.trim
  end

end
