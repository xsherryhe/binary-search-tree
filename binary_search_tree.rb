class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def <=>(other_node)
    value <=> other_node.value
  end
end

class Tree
  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr.uniq.sort)
  end

  def build_tree(arr, start = 0, finish = arr.size - 1)
    return if start > finish

    mid = (start + finish) / 2
    Node.new(arr[mid], build_tree(arr, start, mid - 1), build_tree(arr, mid + 1, finish))
  end

  def insert(value)
    self.root = insert_node(Node.new(value), root)
  end

  def insert_node(new_node, node)
    return new_node unless node

    node.left = insert_node(new_node, node.left) if new_node < node
    node.right = insert_node(new_node, node.right) if new_node > node
    node
  end

  def delete(value)
    self.root = delete_node(Node.new(value), root)
  end

  def delete_node(target_node, node)
    return unless node

    node.left = delete_node(target_node, node.left) if target_node < node
    node.right = delete_node(target_node, node.right) if target_node > node
    return node unless target_node == node

    node.left && node.right ? delete_two_child_node(node) : delete_one_child_node(node)
  end

  def delete_one_child_node(node)
    node.left || node.right
  end

  def delete_two_child_node(node)
    successor = min(node.right)
    successor.right = delete_node(successor, node.right)
    successor.left = node.left
    successor
  end

  def min(node)
    node.left ? min(node.left) : node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree.insert(6)
tree.pretty_print
tree.insert(321)
tree.pretty_print
tree.delete(67)
tree.pretty_print
tree.delete(8)
tree.pretty_print
