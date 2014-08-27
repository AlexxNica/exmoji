defmodule ExmojiTest do
  use ExUnit.Case, async: true
  doctest Exmoji

  alias Exmoji.EmojiChar

  # Define a number of known Emoji library characteristics.
  # We should expect to get this many from our data file.
  # This may be manually updated in the future as Emoji evolves.
  @known_chars      845
  @known_doublebyte 21
  @known_variants   107

  test ".all - all #{@known_chars} emoji characters should be present" do
    assert Exmoji.all |> Enum.count == @known_chars
  end

  test ".all - number of doublebyte charcters should match expected" do
    assert Exmoji.all
            |> Enum.count(&EmojiChar.doublebyte?(&1))
            == @known_doublebyte
  end

  test ".all - number of characters with variant encoding should match expected" do
    assert Exmoji.all
            |> Enum.count(&EmojiChar.variant?(&1))
            == @known_variants
  end

  test ".all_doublebyte - convenience method for all doublebyte chars" do
    assert Exmoji.all_doublebyte |> Enum.count == @known_doublebyte
  end

  test ".all_with_variants - convenience method for all variant chars" do
    assert Exmoji.all_with_variants |> Enum.count == @known_variants
  end

  test ".chars - should return an array of all chars in unicode string format" do
    assert is_list(Exmoji.chars)
    assert Enum.all?(Exmoji.chars, fn c -> is_bitstring(c) end)
  end

  test ".chars - should by default return one entry per known EmojiChar" do
    assert Enum.count(Exmoji.chars) == @known_chars
  end

  # test ".chars - should include variants in list when options {include_variants: true}" do
  #   assert Exmoji.chars(include_variants: true) |> Enum.count == @known_chars + @known_variants
  # end

  # test ".chars - should not have any duplicates in list when variants are included" do
    # CS VERSION BELOW
    # results = EmojiData.chars({include_variants: true})
    # results.length.should.equal _.uniq(results).length
  #end

  test ".find_by_unified - should find the proper EmojiChar object" do
    results = Exmoji.find_by_unified("1F680")
    assert results.name == "ROCKET"
  end

  test ".find_by_unified - should normalise capitalization for hex values" do
    assert Exmoji.find_by_unified("1f680") == Exmoji.find_by_unified("1F680")
  end

  test ".find_by_unified - should find via variant encoding ID format as well" do
    assert Exmoji.find_by_unified("2764-fe0f").name == "HEAVY BLACK HEART"
  end

  #
  # #unified_to_char
  #
  test ".unified_to_char - converts normal unified codepoints to unicode strings" do
    assert Exmoji.unified_to_char("1F47E") == "👾"
    assert Exmoji.unified_to_char("1F680") == "🚀"
  end

  test ".unified_to_char - converts doublebyte unified codepoints to unicode strings" do
    assert Exmoji.unified_to_char("1F1FA-1F1F8") == "🇺🇸"
    assert Exmoji.unified_to_char("0023-20E3") == "#⃣"
  end

  test ".unified_to_char - converts variant unified codepoints to unicode strings" do
    assert Exmoji.unified_to_char("2764-fe0f") == "\x{2764}\x{FE0F}"
  end

  test ".unified_to_char - converts variant+doublebyte chars (triplets!) to unicode strings" do
    assert Exmoji.unified_to_char("0030-FE0F-20E3") == "\x{0030}\x{FE0F}\x{20E3}"
  end

end
