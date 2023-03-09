# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create a main sample label.
Label.create!(name: "Kids from Vision")

# Create a main sample user.
User.create!(name: "Sam Brownstone", email: "brownstone@hey.com", password: "123456", label_id: 1, role: "label_admin")