# Microblog

Microblog APP:

 - Like Twitter or maybe Facebook

Users can:
 - Register accounts
 - make posts
 - Follow other users
 - Look a their feed, where they see the posts made by users that they follow.

Kinds of data to store:
 - Users
   - email - string
   - name - string
 - Posts
   - body - string, possibly really long
   - user_id - reference to user

Store the data in a relational database -- PostgreSQL

Data operations for a CRUD application:

  - create
  - retrieve
  - update
  - delete

RESTful Routes:
  - GET new       - form to create a user
  - GET edit      - form to edit
  - POST create   - actually create
  - GET show      - show one user
  - POST update   - actually edit      (PATCH)
  - POST delete   - delete             (DELETE)
  - GET index     - list all Users
