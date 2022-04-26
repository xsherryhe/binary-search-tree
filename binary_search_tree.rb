class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value, left, right)
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
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
p tree.root
