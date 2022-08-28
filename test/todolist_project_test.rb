# RB130
# lesson_2 (testing)

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative '../lib/todolist_project'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  # Your tests go here. Remember they must start with "test_"
  # to_a  
  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  # size
  def test_size
    assert_equal(3, @list.size)
  end

  # first
  def test_first
    assert_equal(@todo1, @list.first)
  end

  # last
  def test_last
    assert_equal(@todo3, @list.last)
  end

  # shift
  def test_shift
    remove_first = @list.shift
    assert_equal(@todo1, remove_first)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  # pop
  def test_pop
    remove_last = @list.pop
    assert_equal(@todo3, remove_last)
    assert_equal([@todo1, @todo2], @list.to_a)
  end
  
  # done?
  def test_done?
    # test none done
    assert_equal(false, @list.done?)
    # test all done
    @list.done!
    assert_equal(true, @list.done?)
    # test some done
    @list.mark_undone_at(1)
    assert_equal(false, @list.done?)
  end

  # verifies a TypeError is raised when adding an item into the list that's not a Todo object.
  def test_add_non_todo_item
    assert_raises(TypeError) { @list.add("Get a job") }
    assert_raises(TypeError) { @list.add(1) }
    assert_raises(TypeError) { @list.add(["Clean the house", 1]) }
  end

  # <<
  def test_shovel
    @todo4 = Todo.new("Get a job")
    @list << @todo4
    @todos << @todo4
    assert_equal(@todos, @list.to_a)
  end

  # add
  def test_add
    @todo4 = Todo.new("Get a job")
    @list.add(@todo4)
    @todos << @todo4
    assert_equal(@todos, @list.to_a)
  end

  # item_at
  # this method should raise IndexError if we specify an index with no element.
  def test_item_at
    assert_equal(@todo2, @list.item_at(1))
    assert_equal(@todo3, @list.item_at(2))
    assert_raises(IndexError) { @list.item_at(50) }
    assert_raises(IndexError) { @list.item_at(-5) }
  end

  # mark_done_at
  # this method should also raise IndexError if we specify an index with no element.
  def test_mark_done_at
    @list.mark_done_at(2)
    assert_equal(false, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_raises(IndexError) { @list.mark_done_at(20) }
  end

  # mark_undone_at
  def test_mark_undone_at
    @todo1.done!
    @todo2.done!
    @todo3.done!
    @list.mark_undone_at(2)
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(false, @todo3.done?)
    assert_raises(IndexError) { @list.mark_undone_at(20) }
  end

  # done!
  def test_done!
    @list.done!
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end

  # remove_at
  # method raises IndexError if argument does not return item.
  def test_remove_at
    @list.remove_at(1)
    assert_equal([@todo1, @todo3], @list.to_a)
    assert_raises(IndexError) { @list.remove_at(50) }
  end


  # to_s
  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
  
    assert_equal(output, @list.to_s)
  end

  def test_to_s_partial_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    @list.mark_done_at(0)
    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    @list.done!
    assert_equal(output, @list.to_s)
  end

  # each
  # test that the each method is actually iterating
  def test_each
    result = []
    @list.each { |todo| result << todo }
    assert_equal([@todo1, @todo2, @todo3], result)
  end

  # each
  # verify that the each method returns the original object
  def test_each_return_value
    assert_equal(@list, @list.each { 'hi' })
  end

  # select
  # verify that select returns the correct item(s)
  def test_select
    @todo1.done!
    assert_equal([@todo1], @list.select { |todo| todo.done? }.to_a)
  end

  # select
  # verify that select returns a new TodoList object
  def test_select_return_object
    @todo1.done!
    new_list = TodoList.new(@list.name)
    new_list.add(@todo1)

    assert_equal(new_list.class, @list.select { |todo| todo.done? }.class)
    assert_equal(new_list.name, @list.select { |todo| todo.done? }.name)
    assert_equal(new_list.to_s, @list.select { |todo| todo.done? }.to_s)
  end

  def test_find_by_title
    assert_equal(@todo1, @list.find_by_title("Buy milk"))
    assert_nil(@list.find_by_title("Get a job"))
  end

  def test_all_done
    @list.mark_done_at(0)
    @list.mark_done_at(1)
    assert_equal([@todo1, @todo2], @list.all_done.to_a)
  end

  def test_all_not_done
    @list.mark_done_at(0)
    assert_equal([@todo2, @todo3], @list.all_not_done.to_a)
  end

  def test_mark_done
    @list.mark_done("Buy milk")
    assert_equal(true, @todo1.done?)
  end

  def test_mark_all_undone
    @list.done!
    @list.mark_all_undone
    assert_equal(false, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end
end