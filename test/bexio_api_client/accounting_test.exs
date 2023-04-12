defmodule BexioApiClient.AccountingTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient.Accounting

  alias BexioApiClient.SearchCriteria

  import Tesla.Mock

  describe "fetching a list of accounts" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/accounts"} ->
          json([
            %{
              "id" => 1,
              "account_no" => "3201",
              "name" => "Gross proceeds credit sales",
              "account_group_id" => 65,
              "account_type" => 1,
              "tax_id" => 40,
              "is_active" => true,
              "is_locked" => false
            },
            %{
              "id" => 2,
              "account_no" => "3202",
              "name" => "Gross proceeds credit sales 2",
              "account_group_id" => 66,
              "account_type" => 2,
              "tax_id" => 41,
              "is_active" => false,
              "is_locked" => true
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result1, result2]} = BexioApiClient.Accounting.fetch_accounts(client)

      assert result1.id == 1
      assert result1.account_no == 3201
      assert result1.name == "Gross proceeds credit sales"
      assert result1.account_group_id == 65
      assert result1.account_type == :earning
      assert result1.tax_id == 40
      assert result1.active? == true
      assert result1.locked? == false

      assert result2.id == 2
      assert result2.account_no == 3202
      assert result2.name == "Gross proceeds credit sales 2"
      assert result2.account_group_id == 66
      assert result2.account_type == :expenditure
      assert result2.tax_id == 41
      assert result2.active? == false
      assert result2.locked? == true
    end
  end

  describe "searching accounts" do
    setup do
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/accounts/search",
          body: _body
        } ->
          json([
            %{
              "id" => 1,
              "account_no" => "3201",
              "name" => "Gross proceeds credit sales",
              "account_group_id" => 65,
              "account_type" => 1,
              "tax_id" => 40,
              "is_active" => true,
              "is_locked" => false
            },
            %{
              "id" => 2,
              "account_no" => "3202",
              "name" => "Gross proceeds credit sales 2",
              "account_group_id" => 66,
              "account_type" => 2,
              "tax_id" => 41,
              "is_active" => false,
              "is_locked" => true
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result1, result2]} =
               BexioApiClient.Accounting.search_accounts(
                 client,
                 [
                   SearchCriteria.nil?(:account_no),
                   SearchCriteria.part_of(:name, ["fred", "queen"])
                 ]
               )

      assert result1.id == 1
      assert result1.account_no == 3201
      assert result1.name == "Gross proceeds credit sales"
      assert result1.account_group_id == 65
      assert result1.account_type == :earning
      assert result1.tax_id == 40
      assert result1.active? == true
      assert result1.locked? == false

      assert result2.id == 2
      assert result2.account_no == 3202
      assert result2.name == "Gross proceeds credit sales 2"
      assert result2.account_group_id == 66
      assert result2.account_type == :expenditure
      assert result2.tax_id == 41
      assert result2.active? == false
      assert result2.locked? == true
    end
  end
end
