# frozen_string_literal: true

require_relative './node'

# Logic for a tree class
class Tree
  attr_accessor :root, :data

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  def build_tree(array)
    return nil if array.empty?

    middle = ((array.length - 1) / 2).floor

    node_root = Node.new(array[middle])
    node_root.left_children(build_tree(array[0..middle]))
    node_root.right_children(build_tree(array[(middle+1)..-1]))
    node_root
  end

end
