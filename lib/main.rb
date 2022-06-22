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
    # determine how childs of node
    return "Value '#{value}' not in tree" if find(value).nil?

    number = number_of_childs(value)

    if number == 0
      delete_leaf(value)
    end
    

  
  end

  def delete_leaf(value, node = @root, prev_node = node)
    if node.data == value
      return prev_node.right = nil if value > prev_node.data
      return prev_node.left = nil
    end

    return delete_leaf(value, node.right, prev_node = node) if value > node.data
    return delete_leaf(value, node.left, prev_node = node)
  end


  # determine number of childs of a value, for #delete method
  def number_of_childs(value, node = @root)
    if node.data == value
      if node.left.nil? && node.right.nil?
        return 0
      elsif node.left.nil? && node.right
        return node.right
      elsif node.right.nil? && node.left
        return node.left
      else
        return 2
      end
    end

    return number_of_childs(value, node.right) if node.data < value
    return number_of_childs(value, node.left)

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

tree = Tree.new(arr2)

puts "\n\n"

tree.insert(2)
tree.insert(4)

tree.pretty_print
puts "\n\n"

x = 9
puts "delete value '#{x}'"
tree.delete(x)
tree.pretty_print


