class String
  def strip_control_characters()
    chars.each_with_object("") do |char, str|
      str << char unless char.ascii_only? and (char.ord < 32 or char.ord == 127)
    end
  end

  def strip_control_and_extended_characters()
    chars.each_with_object("") do |char, str|
      str << char if char.ord <= 126
    end
  end
end