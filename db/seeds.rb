# SPDX-License-Identifier: MIT
# frozen_string_literal: true

puts "Seeding database..."

# Create users
admin = User.find_or_create_by!(email: "admin@taskflow.com") do |u|
  u.name = "Admin User"
  u.password = "password123"
  u.password_confirmation = "password123"
end

demo = User.find_or_create_by!(email: "demo@taskflow.com") do |u|
  u.name = "Demo User"
  u.password = "demo1234"
  u.password_confirmation = "demo1234"
end

# Create projects
project1 = Project.find_or_create_by!(name: "Website Redesign", user: admin) do |p|
  p.description = "Complete redesign of the company website"
  p.status = :active
end

project2 = Project.find_or_create_by!(name: "Mobile App", user: admin) do |p|
  p.description = "Build a mobile application for TaskFlow"
  p.status = :active
end

project3 = Project.find_or_create_by!(name: "Legacy Migration", user: demo) do |p|
  p.description = "Migrate legacy systems to new platform"
  p.status = :archived
end

# Create tasks
[
  { title: "Design homepage mockup", description: "Create wireframes and visual designs",
    project: project1, user: admin, status: :completed, priority: :high },
  { title: "Implement responsive layout", description: "Make the site work on mobile devices",
    project: project1, user: demo, status: :in_progress, priority: :medium },
  { title: "Set up CI/CD pipeline", description: "Configure automated testing and deployment",
    project: project1, status: :pending, priority: :urgent, due_date: Date.today + 3 },
  { title: "API integration", description: "Connect frontend to backend API",
    project: project2, user: admin, status: :pending, priority: :high, due_date: Date.today - 1 },
  { title: "User testing", description: "Run user testing sessions",
    project: project2, status: :pending, priority: :low, due_date: Date.today + 14 },
  { title: "Data migration script", description: "Write scripts to migrate old data",
    project: project3, user: demo, status: :completed, priority: :urgent },
  { title: "Verify data integrity", description: "Check migrated data for consistency",
    project: project3, user: demo, status: :completed, priority: :high }
].each do |attrs|
  Task.find_or_create_by!(title: attrs[:title], project: attrs[:project]) do |t|
    t.description = attrs[:description]
    t.user = attrs[:user]
    t.status = attrs[:status]
    t.priority = attrs[:priority]
    t.due_date = attrs[:due_date]
  end
end

# Create some comments
task = Task.find_by(title: "Design homepage mockup")
Comment.find_or_create_by!(task: task, user: admin, body: "Looking great so far! The color scheme works well.")
Comment.find_or_create_by!(task: task, user: demo, body: "Can we add a dark mode option?")

puts "Seeded #{User.count} users, #{Project.count} projects, #{Task.count} tasks, #{Comment.count} comments"
