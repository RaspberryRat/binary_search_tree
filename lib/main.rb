require_relative "./node"
require "pry-byebug"

# don't use duplicate values or check for duplicate values before inserting
module Comparable
  # TODO compare nodes using data attributes??
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
    return "Value '#{value}' not in tree" if find(value).nil?

    # returns 0 if a leaf, returns 2, if node has two childs, else returns node
    node = number_of_childs(value)
    if node == 0
      delete_leaf(value)
    elsif node != 2
      parent = find_parent(value)
      return parent.left = node if parent.data > node.data

      parent.right = node
    else
      moved_node = find_new_parent(find(value).right)
      update_child_node(moved_node, find(value))
      return @root = moved_node if @root.data == value
      parent = find_parent(value)
      parent.left = moved_node if parent.data > moved_node.data
      parent.right = moved_node if parent.data < moved_node.data
    end
  end

  # used with #delete when node has two childs, updates parents to new childs
  def update_child_node(new_node, old_node)

    new_node.left = old_node.left
    #TODO CLEAN UP CODE
    right_value = last_node_right(new_node)
    unless right_value == new_node
      right_value.right = old_node.right
    else
      right_value = old_node.right
      new_node.right = old_node.right unless right_value.data == new_node.data
    end
    remove_parent(new_node)
  end

  # finds leaf node on right, for #delete with two childs, needed when replacement node of node deleted has a right child
  def last_node_right(node)
    return node if node.right.nil?

    last_node_right(node.right)
  end

  # removes previous parent connection when node deleted with 2 childs
  def remove_parent(node)
    former_parent = find_parent(node.data)
    return former_parent.left = nil if former_parent.left == node 
    former_parent.right = nil if former_parent.left == node
  end

  # finds new parent node if #delete node has two childs
  def find_new_parent(node)
    return node if node.left.nil?

    find_new_parent(node.left)
  end

  # finds parent node if #delete node has 1 child
  def find_parent(value, node = @root)
    return node if value == node.left.data || value == node.right.data

    return find_parent(value, node.right) if value > node.data
    return find_parent(value, node.left)
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
      nil
    else
      return node if node.data == value

      return find(value, node.right) if node.data < value
      return find(value, node.left)
    end
  end

  # accepts a block, method should traverse in breadth first lqueuevel order and yield each node to provided block, either iteration or recursion
  def level_order(queue = [@root], &block)
    return if queue.length.zero?

    node = queue.shift
    yield(node) if block_given?
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?
    level_order(queue, &block)
  end

  # prints root, left node, right node in depth-first traversal
  def preorder(node = @root, arr = [], &block)
    return arr if node.nil?

    arr << node
    yield(node) if block_given?
    preorder(node.left, arr, &block) unless node.left.nil?
    preorder(node.right, arr, &block)
  end

  # prints left node, root, right node in depth-first traversal
  def inorder(node = @root, arr = [], &block)
    return if node.nil?

    inorder(node.left, arr, &block)
    arr << node unless node.nil?
    yield(node) if block_given? && !node.nil?
    inorder(node.right, arr, &block)
    arr
  end

  # prints left node, right node, root in depth-first traversal
  def postorder(node = @root, arr = [], &block)
    return if node.nil?

    postorder(node.left, arr, &block)
    postorder(node.right, arr, &block)
    arr << node unless node.nil?
    yield(node) if block_given? && !node.nil?
    arr
  end

  # returns number or nodes between value and a leaf node
  def height(value = @root.data.to_i, node = find(value))

    return if node.nil?

    left = height(value, node.left)
    right = height(value, node.right)
    left.to_i > right.to_i ? left.to_i + 1 : right.to_i + 1
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
arr5 = [50, 30, 20, 40, 32, 34, 36, 70, 60, 65, 75, 80, 85]

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

# tree.insert(2)
# tree.insert(4)

tree.pretty_print
puts "\n\n"

# x = 2
# puts "delete value '#{x}'"
# tree.delete(x)
# tree.pretty_print

# tree2 = Tree.new(arr5)
# puts "\n\n"

# tree2.pretty_print
print "\n\nlevel order: "
tree.level_order { |node| print "#{node.data}, "}
print "\n\npreorder: "
tree.preorder { |node| print "#{node.data}, "}
# puts "\n\n"
# tree2.delete(65)
# tree2.pretty_print
# puts "\n\n"
print "\n\ninorder: "
tree.inorder { |node| print "#{node.data}, "}

print "\n\npostorder: "
tree.postorder { |node| print "#{node.data}, "}
puts "\n\n"

print tree.height(8)
puts "\n\n"

