![Screenshot of Mockr](http://mockr-causes.heroku.com/images/mockr-screenshot.png)


## Introduction
Mockr is a beautiful and fun app for managing mock-ups and images associated
with a project. Mockr supports commenting on selections of the mock to enable a
discussion on the topic.


## Try it out!
We've got a demo sandbox up at:
[http://mockr-demo.heroku.com/]

The only difference between this sandbox and a "real" instance is that we allow
any Facebook account to login, as opposed to a whitelist of users.


## Setup - on Heroku
Choose a mockr name -- the app will be at http://$mockrname.heroku.com/


Accounts to set up:

- Facebook (facebook.com/developers)
 - Sign up for an app and set your app domain to $mockrname.heroku.comA
 - You'll need your app_id and key (same) and secret key
- Amazon Web Services S3 (aws.amazon.com)
 - You'll need your access_key and secret_key
- GMail account for notification emails (gmail.com)
 - You'll need your username and password (and domain if it's not @gmail.com)

```bash
git clone git@github.com:causes/mockr.git
bundle install
bundle exec rake db:migrate
heroku create $mockrname
heroku rake db:migrate
heroku config:add \
  GMAIL_SMTP_USER='username' \
  GMAIL_SMTP_PASSWORD='password' \
  GMAIL_SMTP_DOMAIN='domain.com' \
  INSTANCE_NAME="$mockrname" \
  AWS_S3_ACCESS_KEY_ID='access_key' \
  AWS_S3_SECRET_ACCESS_KEY='secret_key' \
  FB_APP_ID=000000000000000 \
  FB_KEY=000000000000000 \
  FB_SECRET=00000000000000000000000000000000
git push heroku master
```

## Setup - custom server
Same steps as above except for the commands with heroku in them. To launch a
local web server, you need to set the environment variables:

```bash
GMAIL_SMTP_USER='username' \
GMAIL_SMTP_PASSWORD='password' \
GMAIL_SMTP_DOMAIN='domain.com' \
INSTANCE_NAME="$mockrname" \
AWS_S3_ACCESS_KEY_ID='access_key' \
AWS_S3_SECRET_ACCESS_KEY='secret_key' \
FB_APP_ID=000000000000000 \
FB_KEY=000000000000000 \
FB_SECRET=00000000000000000000000000000000 \
  bundle exec rails server
```
