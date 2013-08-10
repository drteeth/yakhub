class PlayRandom

  def get_note(scale)
    scale.notes.shuffle.first
  end

end
