defmodule BexioApiClient.ItemsTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient.Items

  alias BexioApiClient.Items.Item

  import Tesla.Mock

  describe "fetching a list of items" do
    setup do
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/2.0/article"
        } ->
          json([
            %{
              "id" => 4,
              "user_id" => 1,
              "article_type_id" => 1,
              "contact_id" => 14,
              "deliverer_code" => nil,
              "deliverer_name" => nil,
              "deliverer_description" => nil,
              "intern_code" => "wh-2019",
              "intern_name" => "Webhosting",
              "intern_description" => nil,
              "purchase_price" => "11.10",
              "sale_price" => "22.20",
              "purchase_total" => "33.30",
              "sale_total" => "44.40",
              "currency_id" => nil,
              "tax_income_id" => nil,
              "tax_id" => nil,
              "tax_expense_id" => nil,
              "unit_id" => nil,
              "is_stock" => false,
              "stock_id" => nil,
              "stock_place_id" => nil,
              "stock_nr" => 0,
              "stock_min_nr" => 0,
              "stock_reserved_nr" => 0,
              "stock_available_nr" => 0,
              "stock_picked_nr" => 0,
              "stock_disposed_nr" => 0,
              "stock_ordered_nr" => 0,
              "width" => nil,
              "height" => nil,
              "weight" => nil,
              "volume" => nil,
              "html_text" => nil,
              "remarks" => nil,
              "delivery_price" => nil,
              "article_group_id" => nil
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result]} = BexioApiClient.Items.fetch_items(client)

      assert result.id == 4
      assert result.article_type == :physical
      assert result.contact_id == 14
      assert result.user_id == 1
      assert result.intern_code == "wh-2019"
      assert result.intern_name == "Webhosting"
      assert Decimal.equal?(result.purchase_price, Decimal.new("11.10"))
      assert Decimal.equal?(result.sale_price, Decimal.new("22.20"))
      assert Decimal.equal?(result.purchase_total, Decimal.new("33.30"))
      assert Decimal.equal?(result.sale_total, Decimal.new("44.40"))
    end
  end

  describe "searching items" do
    setup do
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/article/search",
          body: _body
        } ->
          json([
            %{
              "id" => 4,
              "user_id" => 1,
              "article_type_id" => 1,
              "contact_id" => 14,
              "deliverer_code" => nil,
              "deliverer_name" => nil,
              "deliverer_description" => nil,
              "intern_code" => "wh-2019",
              "intern_name" => "Webhosting",
              "intern_description" => nil,
              "purchase_price" => "11.10",
              "sale_price" => "22.20",
              "purchase_total" => "33.30",
              "sale_total" => "44.40",
              "currency_id" => nil,
              "tax_income_id" => nil,
              "tax_id" => nil,
              "tax_expense_id" => nil,
              "unit_id" => nil,
              "is_stock" => false,
              "stock_id" => nil,
              "stock_place_id" => nil,
              "stock_nr" => 0,
              "stock_min_nr" => 0,
              "stock_reserved_nr" => 0,
              "stock_available_nr" => 0,
              "stock_picked_nr" => 0,
              "stock_disposed_nr" => 0,
              "stock_ordered_nr" => 0,
              "width" => nil,
              "height" => nil,
              "weight" => nil,
              "volume" => nil,
              "html_text" => nil,
              "remarks" => nil,
              "delivery_price" => nil,
              "article_group_id" => nil
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result]} = BexioApiClient.Items.search_items(client, [])

      assert result.id == 4
      assert result.article_type == :physical
      assert result.contact_id == 14
      assert result.user_id == 1
      assert result.intern_code == "wh-2019"
      assert result.intern_name == "Webhosting"
      assert Decimal.equal?(result.purchase_price, Decimal.new("11.10"))
      assert Decimal.equal?(result.sale_price, Decimal.new("22.20"))
      assert Decimal.equal?(result.purchase_total, Decimal.new("33.30"))
      assert Decimal.equal?(result.sale_total, Decimal.new("44.40"))
    end
  end

  describe "fetching a single item" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/article/1"} ->
          json(%{
            "id" => 4,
            "user_id" => 1,
            "article_type_id" => 1,
            "contact_id" => 14,
            "deliverer_code" => nil,
            "deliverer_name" => nil,
            "deliverer_description" => nil,
            "intern_code" => "wh-2019",
            "intern_name" => "Webhosting",
            "intern_description" => nil,
            "purchase_price" => "11.10",
            "sale_price" => "22.20",
            "purchase_total" => "33.30",
            "sale_total" => "44.40",
            "currency_id" => nil,
            "tax_income_id" => nil,
            "tax_id" => nil,
            "tax_expense_id" => nil,
            "unit_id" => nil,
            "is_stock" => false,
            "stock_id" => nil,
            "stock_place_id" => nil,
            "stock_nr" => 0,
            "stock_min_nr" => 0,
            "stock_reserved_nr" => 0,
            "stock_available_nr" => 0,
            "stock_picked_nr" => 0,
            "stock_disposed_nr" => 0,
            "stock_ordered_nr" => 0,
            "width" => nil,
            "height" => nil,
            "weight" => nil,
            "volume" => nil,
            "html_text" => nil,
            "remarks" => nil,
            "delivery_price" => nil,
            "article_group_id" => nil
          })

        %{method: :get, url: "https://api.bexio.com/2.0/article/2"} ->
          %Tesla.Env{status: 404, body: "Article does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      {:ok, result} = BexioApiClient.Items.fetch_item(client, 1)
      assert result.id == 4
      assert result.article_type == :physical
      assert result.contact_id == 14
      assert result.user_id == 1
      assert result.intern_code == "wh-2019"
      assert result.intern_name == "Webhosting"
      assert Decimal.equal?(result.purchase_price, Decimal.new("11.10"))
      assert Decimal.equal?(result.sale_price, Decimal.new("22.20"))
      assert Decimal.equal?(result.purchase_total, Decimal.new("33.30"))
      assert Decimal.equal?(result.sale_total, Decimal.new("44.40"))
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found, "Article does not exist"} =
               BexioApiClient.Items.fetch_item(client, 2)
    end
  end

  describe "creating an item" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/article", body: _body} ->
          json(%{
            "id" => 4,
            "user_id" => 1,
            "article_type_id" => 1,
            "contact_id" => 14,
            "deliverer_code" => nil,
            "deliverer_name" => nil,
            "deliverer_description" => nil,
            "intern_code" => "wh-2019",
            "intern_name" => "Webhosting",
            "intern_description" => nil,
            "purchase_price" => "11.10",
            "sale_price" => "22.20",
            "purchase_total" => "33.30",
            "sale_total" => "44.40",
            "currency_id" => nil,
            "tax_income_id" => nil,
            "tax_id" => nil,
            "tax_expense_id" => nil,
            "unit_id" => nil,
            "is_stock" => false,
            "stock_id" => nil,
            "stock_place_id" => nil,
            "stock_nr" => 0,
            "stock_min_nr" => 0,
            "stock_reserved_nr" => 0,
            "stock_available_nr" => 0,
            "stock_picked_nr" => 0,
            "stock_disposed_nr" => 0,
            "stock_ordered_nr" => 0,
            "width" => nil,
            "height" => nil,
            "weight" => nil,
            "volume" => nil,
            "html_text" => nil,
            "remarks" => nil,
            "delivery_price" => nil,
            "article_group_id" => nil
          })
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, _record} = BexioApiClient.Items.create_item(client, Item.new())
    end
  end

  describe "editing an item" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/article/4", body: _body} ->
          json(%{
            "id" => 4,
            "user_id" => 1,
            "article_type_id" => 1,
            "contact_id" => 14,
            "deliverer_code" => nil,
            "deliverer_name" => nil,
            "deliverer_description" => nil,
            "intern_code" => "wh-2019",
            "intern_name" => "Webhosting",
            "intern_description" => nil,
            "purchase_price" => "11.10",
            "sale_price" => "22.20",
            "purchase_total" => "33.30",
            "sale_total" => "44.40",
            "currency_id" => nil,
            "tax_income_id" => nil,
            "tax_id" => nil,
            "tax_expense_id" => nil,
            "unit_id" => nil,
            "is_stock" => false,
            "stock_id" => nil,
            "stock_place_id" => nil,
            "stock_nr" => 0,
            "stock_min_nr" => 0,
            "stock_reserved_nr" => 0,
            "stock_available_nr" => 0,
            "stock_picked_nr" => 0,
            "stock_disposed_nr" => 0,
            "stock_ordered_nr" => 0,
            "width" => nil,
            "height" => nil,
            "weight" => nil,
            "volume" => nil,
            "html_text" => nil,
            "remarks" => nil,
            "delivery_price" => nil,
            "article_group_id" => nil
          })
      end)

      :ok
    end

    test "edits a new record" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, _record} =
        BexioApiClient.Items.edit_item(
          client,
          Item.new(%{id: 4})
        )
    end
  end

  describe "deleting an item" do
    setup do
      mock(fn
        %{method: :delete, url: "https://api.bexio.com/2.0/article/4"} ->
          json(%{"success" => true})
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, result} = BexioApiClient.Items.delete_item(client, 4)
      assert result == true
    end
  end

  describe "fetching a list of stock locations" do
    setup do
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/2.0/stock"
        } ->
          json([
            %{
              "id" => 1,
              "name" => "Stock Berlin"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Items.fetch_stock_locations(client)

      assert result[1] == "Stock Berlin"
    end
  end

  describe "searching stock locations" do
    setup do
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/stock/search",
          body: _body
        } ->
          json([
            %{
              "id" => 1,
              "name" => "Stock Berlin"
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Items.search_stock_locations(client, [])

      assert result[1] == "Stock Berlin"
    end
  end

  describe "fetching a list of stock areas" do
    setup do
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/2.0/stock_place"
        } ->
          json([
            %{
              "id" => 1,
              "name" => "Shelf A-06"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Items.fetch_stock_areas(client)

      assert result[1] == "Shelf A-06"
    end
  end

  describe "searching stock areas" do
    setup do
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/stock_place/search",
          body: _body
        } ->
          json([
            %{
              "id" => 1,
              "name" => "Shelf A-06"
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Items.search_stock_areas(client, [])

      assert result[1] == "Shelf A-06"
    end
  end
end
