Installation Instructions
=========

Install Required Gems
~~~
  bundle install
~~~

Create the database
~~~
  rake db:create
~~~

Migrate
~~~
  rake db:migrate
~~~
Import the SQL Dump
~~~
  mysql -u root -p
  use sailing_development;
  source sailing_development_2015-03-19.sql;
~~~
Start the server
~~~
  rails s
~~~

Ruby version 2.2.1 required.
