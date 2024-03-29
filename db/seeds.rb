# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Rails.logger.info('Seeding database...')

Rails.logger.info('Creating users')
User.create(
  id: '#SAMPLE_USER',
  name: 'Foo Bar',
  email: 'sampleuser@provider.com',
  password: 'test'
)
