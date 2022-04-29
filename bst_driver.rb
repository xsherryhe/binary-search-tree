require_relative 'binary_search_tree.rb'

def print_balanced(tree)
  puts "Balanced: #{tree.balanced?}"
end

def print_traversals(tree)
  print_value = ->(node) { puts node.value }
  puts 'Level order:'
  tree.level_order(&print_value)
  puts 'Pre order:'
  tree.pre_order(&print_value)
  puts 'In order:'
  tree.in_order(&print_value)
  puts 'Post order:'
  tree.post_order(&print_value)
end

def print_tree(tree)
  tree.pretty_print
  print_balanced(tree)
  print_traversals(tree)
end

bst = Tree.new(Array.new(15) { rand(1..100) })
print_tree(bst)

3.times do
  num = rand(100..1000)
  bst.insert(num)
  puts "Inserted #{num}"
end

bst.pretty_print
print_balanced(bst)

bst.rebalance
puts 'Rebalanced tree'
print_tree(bst)
