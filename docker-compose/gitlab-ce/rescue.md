# 通过GitLab Rails 控制台​重置管理员密码或禁用2FA密钥


1.​​进入 GitLab Rails 控制台​​：
```bash
docker exec -it [dockerid] /bin/bash

gitlab-rails console

#执行后需等待控制台加载完成（提示符变为 irb(main):001:0>）。

```


2.​​a 禁用符合条件用户的2FA认证：

```ruby

# 根据用户名匹配
users_to_disable = User.where("username LIKE ? AND otp_required_for_login = ?", '%admin%', true)
users_to_disable.each { |user| user.update_attribute(:otp_required_for_login, false) }

# 禁用所有用户的 2FA​​（​​包括 root 用户​​）
User.where(otp_required_for_login: true).each { |u| u.update_attribute(:otp_required_for_login, false) }


```

2.b 重置管理员用户密码
```ruby
# 查找用户
user = User.find_by(username: 'admin')

user.password = 'your_new_secure_password'
user.password_confirmation = 'your_new_secure_password'
# 保存更改到数据库
if user.save!
  puts "密码重置成功！"
else
  puts "密码重置失败，错误信息: #{user.errors.full_messages}"
end

```



3.​退出控制台​​：输入 exit退出 Rails 控制台。