defmodule Nova.VariantCommandsTest do
  use Nova.ModelCase
  alias Nova.VariantCommands
  alias Nova.Variant
  alias Nova.Product

  setup do
    variant = fixtures(:variants).variants.base
    {:ok, variant: variant}
  end

  describe "create/1" do
    it "creates a variant", ctx do
      params = %{
        price: 120.5,
        sku: "SKU-ABC",
        product_id: ctx.variant.product_id
      }
      assert {:ok, %Variant{}} = VariantCommands.create(params)
    end

    it "inherits price from product if not provided", ctx do
      params = %{
        sku: "SKU-ABC",
        product_id: ctx.variant.product_id
      }
      product = Repo.get!(Product, ctx.variant.product_id)

      assert {:ok, variant} = VariantCommands.create(params)
      assert %Variant{} = variant
      assert product.price == variant.price
    end
  end

  describe "update/2" do
    it "updates the variant", ctx do
      {:ok, variant} = VariantCommands.update(ctx.variant.id, %{sku: "ABC"})

      assert %Variant{} = variant
      assert variant.sku == "ABC"
    end
  end

  describe "delete/1" do
    it "deletes the variant", ctx do
      assert %Variant{} = VariantCommands.delete(ctx.variant.id)

      refute Repo.get(Variant, ctx.variant.id)
    end
  end

  describe "add_option_value/2" do
    it "adds an option_value to variant", ctx do
      opt_val_id = fixtures(:option_values).option_values.base.id

      assert {:ok, _} = VariantCommands.add_option_value(ctx.variant.id, opt_val_id)
    end
  end
end
