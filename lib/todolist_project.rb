# RB130
# lesson_1
# To Do List

# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end

class TodoList
  attr_reader :name

  def initialize(name)
    @name = name
    @tasks = []
  end

  def add(task)
    raise TypeError, "Can only add Todo objects" unless task.instance_of? Todo
    tasks << task  
  end

  def <<(task)
    add(task)
  end

  def size
    tasks.size
  end

  def first
    tasks.first
  end

  def last
    tasks.last
  end

  def to_a
    tasks.clone
  end

  def done?
    tasks.all?(&:done?)
  end

  def item_at(index)
    tasks.fetch(index)
  end

  def mark_done_at(index)
    item_at(index).done!
  end

  def mark_undone_at(index)
    item_at(index).undone!
  end

  def done!
    tasks.each(&:done!)
  end

  def shift
    tasks.shift
  end

  def pop
    tasks.pop
  end

  def remove_at(index)
    tasks.delete_at(index) if item_at(index)
  end

  def to_s
    str = "---- #{@name} ----\n"
    str << tasks.map(&:to_s).join("\n")
    str
  end
  
  def each
    @tasks.each do |task|
      yield(task)
    end
    self
  end

  def select
    result_list = TodoList.new(name)
    tasks.each do |task|
      result_list << task if yield(task)
    end
    result_list 
  end
  
  # takes a string as argument, and returns the first Todo object that matches the argument. Return nil if no todo is found.
  def find_by_title(string)
    select { |task| task.title == string }.first
  end

  # returns new TodoList object containing only the done items
  def all_done
    select { |task| task.done? }
  end

  # returns new TodoList object containing only the not done items
  def all_not_done
    select { |task| !task.done? }
  end

  # takes a string as argument, and marks the first Todo object that matches the argument as done.
  def mark_done(string)
    find_by_title(string) && find_by_title(string).done!
  end

  # mark every todo as done
  # removing because this is the same as done!
  # def mark_all_done
  #   each { |task| task.done! }
  # end

  # mark every todo as not done
  def mark_all_undone
    each { |task| task.undone! }
  end

  private

  attr_accessor :tasks
end

# todo1 = Todo.new("Buy milk")
# todo2 = Todo.new("Clean room")
# todo3 = Todo.new("Go to gym")

# todo1.done!

# puts todo1
# puts todo2
# puts todo3

# [ ] Buy milk
# [ ] Clean room
# [ ] Go to gym


# given
# todo1 = Todo.new("Buy milk")
# todo2 = Todo.new("Clean room")
# todo3 = Todo.new("Go to gym")
# list = TodoList.new("Today's Todos")

# ---- Adding to the list -----

# add
# list.add(todo1)                 # adds todo1 to end of list, returns list
# list.add(todo2)                 # adds todo2 to end of list, returns list
# list.add(todo3)                 # adds todo3 to end of list, returns list
# list.add(1)                     # raises TypeError with message "Can only add Todo objects"

# <<
# same behavior as add
# list<<(todo1)                 # adds todo1 to end of list, returns list
# list<<(todo2)                 # adds todo2 to end of list, returns list
# list<<(todo3)                 # adds todo3 to end of list, returns list
# list<<(1)                     # raises TypeError with message "Can only add Todo objects"

# ---- Interrogating the list -----

# size
# p list.size                       # returns 3

# first
# p list.first                      # returns todo1, which is the first item in the list

# last
# p list.last                       # returns todo3, which is the last item in the list

#to_a
# p list.to_a                      # returns an array of all items in the list

#done?
# p list.done?                     # returns true if all todos in the list are done, otherwise false

# ---- Retrieving an item in the list ----

# item_at
# p list.item_at                    # raises ArgumentError
# p list.item_at(1)                 # returns 2nd item in list (zero based index)
# p list.item_at(100)               # raises IndexError

# ---- Marking items in the list -----

# mark_done_at
# p list.mark_done_at               # raises ArgumentError
# p list.mark_done_at(1)            # marks the 2nd item as done
# p list.mark_done_at(100)          # raises IndexError

# mark_undone_at
# p list.mark_undone_at             # raises ArgumentError
# p list.mark_undone_at(1)          # marks the 2nd item as not done,
# p list.mark_undone_at(100)        # raises IndexError

# done!
# p list.done!                      # marks all items as done

# ---- Deleting from the list -----

# shift
# p list.shift                      # removes and returns the first item in list

# pop
# p list.pop                        # removes and returns the last item in list

# remove_at
# p list.remove_at                  # raises ArgumentError
# p list.remove_at(1)               # removes and returns the 2nd item
# p list.remove_at(100)             # raises IndexError

# ---- Outputting the list -----

# to_s
# puts list.to_s                      # returns string representation of the list

# ---- Today's Todos ----
# [ ] Buy milk
# [ ] Clean room
# [ ] Go to gym

# or, if any todos are done

# ---- Today's Todos ----
# [ ] Buy milk
# [X] Clean room
# [ ] Go to gym

# puts list

# list.pop

# puts list

# list.mark_done_at(1)

# puts list

# implement an each method

# todo1 = Todo.new("Buy milk")
# todo2 = Todo.new("Clean room")
# todo3 = Todo.new("Go to gym")
# todo4 = Todo.new("Buy milk")

# list = TodoList.new("Today's Todos")
# list.add(todo1)
# list.add(todo2)
# list.add(todo3)
# list.add(todo4)

# list.each do |todo|
#   puts todo                   # calls Todo#to_s
# end

# todo1.done!

# results = list.select { |todo| todo.done? }    # you need to implement this method

# puts results.inspect

# testing

# p list.find_by_title("Buy")
# todo1.done!
# todo4.done!
# p list.all_done

# p list.all_not_done

# list.mark_done("Buy")
# puts list

# list.mark_all_done
# puts list

# list.mark_all_undone
# puts list

# p list.find_by_title("Buy milk")
# p list.find_by_title("Get a job")