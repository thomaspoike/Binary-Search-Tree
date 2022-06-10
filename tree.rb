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
    node_root.right_children(build_tree(array[(middle + 1)..-1]))
    node_root
  end

  def insert(value, node = root)
    return nil if value == node.data

    if value < node.data
      node.left_children.nil? ? node.left_children = Node.new(value) : insert(value, node.left_children)
    else
      node.right_children.nil? ? node.right_children = Node.new(value) : insert(value, node.right_children)
    end
  end

  def delete(value, node = root)
    return nil if value == node.data

    if value < node.data
      node.left_children = delete(value, node.left_children)
    elsif value > node.data
      node.right_children = delete(value, node.right_children)
    else
      # if node has one or no child
      return node.right_children if node.left_children.nil?
      return node.left_children if node.right_children.nil?

      # if node has two children
      leftmost_node = leftmost_leaf(node.right_children)
      node.data = leftmost_node.data
      node.right_children = delete(leftmost_node.data, node.right_children)
    end
  end

  def leftmost_leaf(node = root)
    node = node.left_children until node.left_children.nil?

    node
  end

  def find(value, node = root)
    return node if value == node.data || node.nil?

    value < node.data ? find(value, node.left_children) : find(value, node.right_children)
  end

  def level_oder(node = root, queue = [])
    print "#{node.data} "
    queue << node.left_children unless node.left_children.nil?
    queue << node.right_children unless node.right_children.nil?
    return if queue.empty?

    level_order(queue.shift, queue)
  end

  # 3 ways to traverse the tree

  def preorder(node = root)
    # Root Left Right
    return if node.nil?

    print "#{node.data} "
    preorder(node.left_children)
    preorder(node.right_children)
  end

  def inorder(node = root)
    # Left Root Right
    return if node.nil?

    preorder(node.left_children)
    print "#{node.data} "
    preorder(node.right_children)
  end

  def postorder(node = root)
    # Left Right Root
    return if node.nil?

    preorder(node.left_children)
    preorder(node.right_children)
    print "#{node.data} "
  end

  # height: number of edges from a node to the lowest leaf in its subtree
  # accepts a node and returns its height. Returns -1 if node doesn't exist
  def height(node = root)
    unless node.nil? || node == root
      node = (node.instance_of?(Node) ? find(node.data) : find(node))
    end
    return -1 if node.nil?

    [height(node.left_children), height(node.right_children)].max + 1
  end

  # accepts a node and returns its depth. Returns -1 if node doesn't exist
  # depth: number of edges from the root to the given ndoe
  def depth(node = root, parent = root, edges = 0)
    return 0 if node == parent

    if node < parent.data
      edges += 1
      depth(node, parent.left_children, edges)
    elsif node > parent.data
      edges += 1
      depth(node, parent.right_children, edges)
    else
      edges
    end
  end

  # checks if tree is balanced: the difference between the heights of the left
  # subtree and right subtree of every node is not more than 1
  def balanced?(node = root)
    return true if node.nil?

    left_height = height(node.left_children)
    right_height = height(node.right_children)

    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

    false
  end

  # balances an unbalanced tree
  def rebalance
    self.data = inorder_array
    self.root = build_tree(data)
  end

  # inorder array
  def inorder_array(node = root, array = [])
    unless node.nil?
      inorder_array(node.left, array)
      array << node.data
      inorder_array(node.right, array)
    end
    array
  end
end

# Scripts & testing

array = Array.new(15) { rand(1..100) }
bst = Tree.new(array)

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder

10.times do
  a = rand(100..150)
  bst.insert(a)
  puts "Inserted #{a} to tree."
end

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Rebalancig tree...'
bst.rebalance

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder
