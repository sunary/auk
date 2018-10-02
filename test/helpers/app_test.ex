defmodule Helpers.App.Test do
  use ExUnit.Case

  describe "Helpers.App.Test" do
    test "gen_component_name from config path" do
      expected_ouput = :demo_pipeline

      assert Helpers.App.gen_component_name("lib/assemblies/demo_pipeline/app_config.exs") == expected_ouput
    end

    test "gen_module_atom from 2 continuous component" do
      expected_ouput = :B_A

      assert Helpers.App.gen_module_atom(:B, :A) == expected_ouput
    end
  end
end
