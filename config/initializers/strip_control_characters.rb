class String
  def strip_extended()
    chars.each_with_object("") do |char, str|
      str << char if char.ord <= 126
    end
  end
end