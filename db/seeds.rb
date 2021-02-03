# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

default_user = User.create!(email: Rails.application.credentials.user[:email], password: Rails.application.credentials.user[:pass])
admin_user = User.create!(email: Rails.application.credentials.admin_user[:email], password: Rails.application.credentials.admin_user[:pass])
