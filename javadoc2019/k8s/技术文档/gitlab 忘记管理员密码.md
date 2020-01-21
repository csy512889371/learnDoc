```
gitlab-rails console production

user = User.where(id: 1).first
user.password = 'loit9527'
user.password_confirmation = 'loit9527'

user.save!
```

