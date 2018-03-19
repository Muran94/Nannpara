Faker::Config.locale = :ja

User.create(name: 'へっど', email: 'headiv94@gmail.com', password: 'password')
User.create(name: 'らべる', email: 'ravibebi94@gmail.com', password: 'password')
User.create(name: 'あ', email: 'a@gmail.com', password: 'password')
User.create(name: 'あ' * 64, email: "#{'a' * 64}@gmail.com", password: 'password')
6.times do
  User.create(name: Faker::Name.name[0..64], email: Faker::Internet.email, password: 'password')
end