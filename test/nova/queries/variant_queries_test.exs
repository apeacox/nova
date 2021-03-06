defmodule Nova.VariantQueriesTest do
  use Nova.ModelCase
  alias Nova.VariantQueries
  alias Nova.Variant
  alias Nova.OptionValueVariant

  setup do
    variant = fixtures(:variants).variants.base
    option_value = fixtures(:option_values).option_values.base

    {:ok, variant: variant, option_value: option_value}
  end

  describe "find_by_id/1" do
    context "when variant exists" do
      it "returns the variant", ctx do
        assert %Variant{} = VariantQueries.find_by_id(ctx[:variant].id)
      end
    end
  end

  describe "all/1" do
    it "returns a list of variants" do
      assert [%Variant{}] = VariantQueries.all
    end
  end

  describe "by_option_value/2" do
    it "returns a list of variants with given option_value", ctx do
      OptionValueVariant.changeset(
        %OptionValueVariant{},
        %{option_value_id: ctx.option_value.id, variant_id: ctx.variant.id})
      |> Repo.insert

      results = Variant
                |> VariantQueries.by_option_value(ctx.option_value)
                |> Repo.all

      assert hd(results).id == ctx.variant.id
    end
  end
end
