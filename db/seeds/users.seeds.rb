after :levels do
  Faker::Config.locale = :ja

  User.create(name: 'へっど', email: 'headiv94@gmail.com', password: 'password', image: File.open('./db/sample_images/paul.jpg'), direct_mail: [true, false].sample)
  User.create(name: 'らべる', email: 'ravibebi94@gmail.com', password: 'password', image: File.open('./db/sample_images/john.jpg'), direct_mail: [true, false].sample)
  User.create(name: 'あ', email: 'a@gmail.com', password: 'password', direct_mail: [true, false].sample)
  User.create(name: 'あ' * User::MAXIMUM_NAME_LENGTH, email: "#{'a' * User::MAXIMUM_NAME_LENGTH}@gmail.com", password: 'password', direct_mail: [true, false].sample)
  6.times do
    User.create(name: Faker::Name.name[0...User::MAXIMUM_NAME_LENGTH], email: Faker::Internet.email, password: 'password', image: File.open('./db/sample_images/george.jpg'), direct_mail: [true, false].sample)
  end
end