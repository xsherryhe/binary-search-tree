class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def <=>(other)
    value <=> other.value
  end
end

class Tree
  attr_accessor :root

  def initialize(arr)
    @root = arr.empty? ? nil : build_tree(arr.uniq.sort)
  end

  def build_tree(arr, start = 0, finish = arr.size - 1)
    return if start > finish

    mid = (start + finish) / 2
    Node.new(arr[mid], build_tree(arr, start, mid - 1), build_tree(arr, mid + 1, finish))
  end

  def find(value, node = root)
    return unless node
    return node if value == node.value

    find(value, node.left) if value < node.value
    find(value, node.right) if value > node.value
  end

  module InsertAndDelete
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
      return node.left && node.right ? delete_two_child_node(node) : delete_one_child_node(node) if target_node == node

      node.left = delete_node(target_node, node.left) if target_node < node
      node.right = delete_node(target_node, node.right) if target_node > node
      node
    end

    def delete_one_child_node(node)
      node.left || node.right
    end

    def delete_two_child_node(node)
      successor = min(node.right)
      node.right = delete_node(successor, node.right)
      node.value = successor.value
      node
    end

    def min(node)
      node.left ? min(node.left) : node
    end
  end
  include self::InsertAndDelete

  module Traversal
    def level_order_it(&block)
      return [] unless root

      queue = [root]
      pointer = 0
      while pointer < queue.size
        node = queue[pointer]
        queue += [node.left, node.right].compact
        block&.call(node)
        pointer += 1
      end
      queue
    end

    def level_order_rec(queue = [root], pointer = 0, &block)
      return [] unless root
      return queue if pointer >= queue.size

      node = queue[pointer]
      block&.call(node)
      level_order_rec(queue + [node.left, node.right].compact, pointer + 1, &block)
    end

    alias level_order level_order_it

    def in_order(node = root, &block)
      return [] unless node

      array = []
      array += in_order(node.left, &block)
      block&.call(node)
      array << node
      array += in_order(node.right, &block)
      array
    end

    def pre_order(node = root, &block)
      return [] unless node

      array = []
      block&.call(node)
      array << node
      array += pre_order(node.left, &block)
      array += pre_order(node.right, &block)
      array
    end

    def post_order(node = root, &block)
      return [] unless node

      array = []
      array += post_order(node.left, &block)
      array += post_order(node.right, &block)
      block&.call(node)
      array << node
    end
  end
  include self::Traversal

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
tree.delete(20)
tree.pretty_print
tree.level_order { |node| p node.value }
tree.level_order_rec { |node| p node.value }
tree.in_order { |node| p node.value }
tree.pre_order { |node| p node.value }
tree.post_order { |node| p node.value }
