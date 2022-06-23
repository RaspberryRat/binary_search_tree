require_relative "./node"

# Binary search tree class, creates and navigate a BST
class Tree
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
    node
  end

  # inserts value into the binary search tree
  def insert(value)
    return "Value '#{value}' already in tree" unless find(value).nil?

    previous_node = last_node(value)
    return previous_node.left = Node.new(value) if value < previous_node.data

    previous_node.right = Node.new(value)
  end

  # deletes a value in binary search tree but unlinkined @right or @left
  def delete(value)
    return "Value '#{value}' not in tree" if find(value).nil?

    # returns 0 if a leaf, returns 2, if node has two childs, else returns node
    node = number_of_childs(value)
    # has to be == 0, #zero? doesnt work
    return delete_leaf(value) if node == 0

    if node != 2
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

   # determine number of childs of a value, for #delete method
   def number_of_childs(value, node = @root)
    if node.data == value
      return 0 if node.left.nil? && node.right.nil?
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      return 2
    end
    return number_of_childs(value, node.right) if node.data < value

    number_of_childs(value, node.left)
  end

  # used with #delete when node has two childs, updates parents to new childs
  def update_child_node(new_node, old_node)
    new_node.left = old_node.left
    if !new_node.right.nil?
      new_node.right.right = old_node.right
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

    find_parent(value, node.left)
  end

  def delete_leaf(value, node = @root, prev_node = node)
    if node.data == value
      return prev_node.right = nil if value > prev_node.data

      return prev_node.left = nil
    end

    return delete_leaf(value, node.right, prev_node = node) if value > node.data

    delete_leaf(value, node.left, prev_node = node)
  end

 

  # finds the last_node before a nil to use with #insert and #delete
  def last_node(value, node = @root, prev_node = node)
    return prev_node if node.nil?

    return last_node(value, node.right, node) if node.data < value

    last_node(value, node.left, node)
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

  # breath first level order traversal of BST
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
    return "Value: '#{value}' not in the binary tree" if find(value).nil?
    return if node.nil?

    left = height(value, node.left)
    right = height(value, node.right)

    left.to_i > right.to_i ? left.to_i + 1 : right.to_i + 1
  end

  # returns depth of a node
  def depth(value, node = @root, level = 0)
    return "Value: '#{value}' not in the binary tree" if find(value).nil?
    return if node.nil?

    return level if node.data == value

    return depth(value, node.left, level + 1) if value < node.data

    return depth(value, node.right, level + 1) if value > node.data
  end

  # checks if tree is balanced (no node is greater than 1 level)
  def balanced?
    balance_checker != false
  end

  # used with #balanced? to return true, otherwise only returns nil or false
  def balance_checker(node = @root)
    return if node.nil?

    # get height of left tree, and height of right tree
    left_height = node.left.nil? ? return : height(node.left.data)
    right_height = node.right.nil? ? return : height(node.right.data)
    difference = left_height - right_height
    difference *= -1 if difference.negative?
    return false if difference > 2

    balance_checker(node.left)
    balance_checker(node.right)
  end

  # rebalances the binary search tree by calling inorder and build tree
  def rebalance
    return "Tree is already balanced" if balanced?

    unbalanced_tree_arr = inorder
    unbalanced_arr_data = []
    unbalanced_tree_arr.map { |node| unbalanced_arr_data << node.data}
    @root = build_tree(unbalanced_arr_data)
  end

  # prints out BST to terminal
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

array = Array.new(15) { rand(1..100) }

tree = Tree.new(array)

puts "\nBinary search tree balanced?: #{tree.balanced?}\n\n"

print "Binary search tree preorder nodes: "
tree.preorder { |node| print "#{node.data}, " }
puts "\n"
print "Binary search tree inorder nodes: "
tree.inorder { |node| print "#{node.data}, " }
puts "\n"
print "Binary search tree postorder nodes: "
tree.postorder { |node| print "#{node.data}, " }
puts "\n\n"

tree.insert(1323)
tree.insert(232)
tree.insert(123)
tree.insert(3434)
tree.insert(199)
tree.pretty_print
puts "\nBinary search tree balanced?: #{tree.balanced?}\n\n"
tree.rebalance
tree.pretty_print
puts "\nBinary search tree balanced?: #{tree.balanced?}\n\n"
print "Binary search tree preorder nodes: "
tree.preorder { |node| print "#{node.data}, " }
puts "\n"
print "Binary search tree inorder nodes: "
tree.inorder { |node| print "#{node.data}, " }
puts "\n"
print "Binary search tree postorder nodes: "
tree.postorder { |node| print "#{node.data}, " }
puts "\n\n"
