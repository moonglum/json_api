json_api = JsonApi.new('http://localhost:8529/dev/json_api/json_api')

Given(/^I added a todo item to '([^']*)'$/) do |title|
  json_api.add_todos({ 'title' => title })
end

Given(/^I added a todo item to '([^']*)' and '([^']*)'$/) do |first_title, second_title|
  json_api.add_todos({ 'title' => first_title }, { 'title' => second_title })
end

Given(/^I created a person '([^']*)'$/) do |name|
  json_api.add_people({ 'name' => name })
end

Given(/^I assign the todo '([^']*)' to '([^']*)'$/) do |task_title, person_name|
  todo = json_api.todo(json_api.todos.todo_with_title(task_title).href)
  person = json_api.people.person_with_name(person_name)
  todo.add_link_for('assignee', person.id)
end

When(/^I receive all todos$/) do
  @response = json_api.todos
end

When(/^I follow the link to the item to '([^']*)'$/) do |title|
  @response = json_api.todo(json_api.todos.todo_with_title(title).href)
end

When(/^I delete a todo item to '([^']*)'$/) do |title|
  item = json_api.todos.todo_with_title(title)
  json_api.remove_todo(item.href)
end

When(/^I follow the link to the user '([^']*)'$/) do |name|
  @response = json_api.person(json_api.people.person_with_name(name).href)
end

Then(/^I should receive an item to '([^']*)'$/) do |title|
  expect(@response.number_of_todos_with_title(title)).to be 1
end

Then(/^I should receive no item to '([^']*)'$/) do |title|
  expect(@response.number_of_todos_with_title(title)).to be 0
end

Then(/^I should receive a well formed todo item for '([^']*)'$/) do |title|
  expect(@response.todo_with_title(title).well_formed?).to be true
end

Then(/^it should have the assignee '([^']*)'$/) do |name|
  assignee = @response.get_linked('assignee')
  expect(assignee.person.name).to eq name
end

Then(/^he should have an assigned task '([^']*)'$/) do |title|
  assigned = @response.get_linked('assigned')
  expect(assigned.todo.title).to eq title
end
