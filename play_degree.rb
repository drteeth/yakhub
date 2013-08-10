class PlayDegree

  def initialize(degree)
    @degree = degree
  end

  def get_note(scale)
    scale.note_by_degree(@degree)
  end

end
