# frozen_string_literal: true

# Represents a node in a linked list
class Node
  attr_accessor :data, :left_children, :right_children
  attr_reader :value

  def initialize(data = nil, left_children = nil, right_children = nil)
    @data = data
    @left_children= left_children
    @right_childre = right_children
  end

  def to_s
    puts @data
  end
end
