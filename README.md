# README

Rales Engine Project
Built by: Norm Schultz

Follow these steps to obtain this project on your computer:

1. Clone the project from this repository, or fork it from this repository to your own using this info:
   git clone
   git@github.com:normanrs/rales_engine.git

2. Once the project has been cloned into your folder, navigate to that folder and run:
   bundle install
   bundle update
3. When the gems finish updating, create the Postgres database and tables by running:
   rake db:{create,migrate}
4. After creating the database, we need to seed the database with the information contained in the CSV files located in db/csv. To do this, we have built a rake task. Run this rake task by running:
   rake import
5. Once the database has been seeded, you can run the RSpec test suite by running:
   rspec
6. To start and interact with the server on your local machine, run
   rails s
7. After running the previous command, open a browser window and type localhost:3000 into the address bar. Once you see the Rails welcome page, you can start to interact with the data using the endpoints located in the rubric and guide linked below.


Rubric: http://backend.turing.io/module3/projects/rails_engine

* Ruby version: 2.4.1
* Database format: Postgres
