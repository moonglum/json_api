require 'faraday'
require 'faraday_middleware'

class JsonApi
  def initialize(url)
    @server = Faraday.new(url: url) do |faraday|
      faraday.request :json
      faraday.response :json
      faraday.adapter  Faraday.default_adapter
    end
  end

  def add_todos(*todos)
    @server.post('todos', 'todos' => todos)
  end

  def add_people(*people)
    @server.post('people', 'people' => people)
  end

  def todo(url)
    clean_url = url.match(/\/?(.*)/)[1]
    TodoResponse.new(@server.get(clean_url), @server)
  end

  def person(url)
    clean_url = url.match(/\/?(.*)/)[1]
    PersonResponse.new(@server.get(clean_url), @server)
  end

  def remove_todo(url)
    clean_url = url.match(/\/?(.*)/)[1]
    @server.delete(clean_url)
  end

  def todos
    TodosResponse.new(@server.get('todos'))
  end

  def people
    PeopleResponse.new(@server.get('people'))
  end
end

class TodoResponse
  attr_reader :todo

  def initialize(response, server)
    @todo = Todo.new(response.body['todos'])
    @links = response.body['links']
    @server = server
  end

  def todo_with_title(title)
    @todo if @todo.title == title
  end

  def add_link_for(selector, id)
    clean_url = @todo.href.match(/\/?(.*)/)[1]
    url = "#{clean_url}/links/#{selector}"
    @server.post(url, selector => id)
  end

  def get_linked(selector)
    foreign_id = @todo.links[selector]
    clean_url_template = @links["todos.#{selector}"].match(/\/?(.*)/)[1]
    url = clean_url_template.gsub("{todos.#{selector}}", foreign_id)
    PersonResponse.new(@server.get(url), @server)
  end
end

class PersonResponse
  attr_reader :person

  def initialize(response, server)
    @person = Person.new(response.body['people'])
    @links = response.body['links']
    @server = server
  end

  def person_with_name(name)
    @person if @todo['name'] == name
  end

  def get_linked(selector)
    foreign_ids = @person.links[selector]
    clean_url_template = @links["people.#{selector}"].match(/\/?(.*)/)[1]
    url = clean_url_template.gsub("{people.#{selector}}", foreign_ids.join(','))
    TodoResponse.new(@server.get(url), @server)
  end
end

class TodosResponse
  def initialize(response)
    @todos = response.body['todos']
  end

  def number_of_todos_with_title(title)
    @todos.count { |item| item['title'] == title }
  end

  def todo_with_title(title)
    Todo.new(@todos.find { |item| item['title'] == title })
  end
end

class PeopleResponse
  def initialize(response)
    @people = response.body['people']
  end

  def person_with_name(name)
    Person.new(@people.find { |item| item['name'] == name })
  end
end

class Todo
  attr_reader :href, :title, :links

  def initialize(todo)
    @id = todo['id']
    @type = todo['type']
    @href = todo['href']
    @title = todo['title']
    @links = todo['links']
  end

  # Hardcoded link in here... I don't like it.
  def well_formed?
    @id && @type == 'todo' && @href == "/todos/#{@id}" && @links == {}
  end
end

class Person
  attr_reader :href, :id, :name, :links

  def initialize(todo)
    @id = todo['id']
    @type = todo['type']
    @href = todo['href']
    @links = todo['links']
    @name = todo['name']
  end
end
