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
    return "Value already in tree" unless find(value).nil?

    previous_node = last_node(value)

    previous_node.left = Node.new(value)
  end

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

  def delete(value)

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

tree.pretty_print


 