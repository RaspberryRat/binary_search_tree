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
    node.left = build_tree(arr, mid + 1, last)

    node
  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

tree = Tree.new(arr)
puts tree.root