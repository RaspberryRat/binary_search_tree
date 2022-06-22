require "pry-byebug"

# don't use duplicate values or check for duplicate values before inserting
module Comparable
  # TODO compare nodes using data attributes??
end

class Node
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
  attr_accessor :data, :left, :right
end

class Tree #should have a root attribute which takes from return value
  def initialize(arr)
    @root = build_tree(arr.sort.uniq)
  end
  attr_reader :root

  def build_tree(arr, start = 0, last = arr.length - 1)
    return nil if start > last

    mid = (start.to_i + last.to_i) / 2
    node = Node.new(arr[mid])

    node.left = build_tree(arr, start, mid - 1)
    node.right = build_tree(arr, mid + 1, last)
    print node.data
    node
  end

  def insert(value)
    return "Value '#{value}' already in tree" unless find(value).nil?

    previous_node = last_node(value)

    return previous_node.left = Node.new(value) if value < previous_node.data
    previous_node.right = Node.new(value)
  end

  def delete(value)
    # TODO working here. How to shift up trees if delete with both @left and @right. Ie delete 3
    return "Value '#{value}' not in tree" if find(value).nil?
    # need to fix this it is wrong
    previous_node = find_for_delete(value)
    # find next node
    next_node_left = find(value).left
    next_node_right = find(value).right
    binding.pry


    puts previous_node.left.data unless previous_node.left.nil?
    puts previous_node.right.data unless previous_node.right.nil?

    # if value node has @left and @ right, set to previous node, if they are nil, remove link
  end

  # finds previous node for #delete
  def find_for_delete(value, node = @root, prev_node = node)
    return prev_node if node.data == value

    return find_for_delete(value, node.right, prev_node = node) if node.data < value
    find_for_delete(value, node.left, prev_node = node)
  end

  # finds the last_node before a nil to use with #insert and #delete
  def last_node(value, node = @root, prev_node = node)
    return prev_node if node.nil?

    return last_node(value, node.right, prev_node = node) if node.data < value
    last_node(value, node.left, prev_node = node)
  end

  def find(value, node = @root)
    begin
      node.data
    rescue NoMethodError
      return nil
    else
      return node if node.data == value

      return find(value, node.right) if node.data < value
      return find(value, node.left)
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
arr2 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
arr3 = []
arr4 = []

i = 1
13.times do
  arr3 << i
  i += 1
end

i = 1
13.times do
  arr4 << i unless i.even?
  i += 1
end

tree = Tree.new(arr4)

tree.pretty_print

tree.insert(2)
tree.insert(4)
tree.insert(14)

tree.pretty_print

puts tree.delete(3)

