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
    # will need to travel down tree and find location where it fits, then redirect each node from before to this value, and redirect node after to next value
    
  end

  def search(value, root = @root)
    return root if root.data == value

    return search(value, root.right) if root.data < value
    return search(value, root.left)
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

tree = Tree.new(arr2)

tree.pretty_print

 