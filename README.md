Readmill
================================================================================


Requirements
--------------------------------------------------------------------------------

To use the Readmill gem, you need RestClient ('rest-client') and a class
wrapping an OAuth token, an example on how this could be done is given in
/examples/mill/mill.

If you are implementing your own token object, it needs to respond to three
methods, `public_params`, `public_or_private_params` and `private_params`.

public_params should return a hash on the form `{ :client_id => client_id }`.
private_params should return a hash on the form `{ :client_id => client_id,
:access_token => access_token }`.
public_or_private_params should return the same thing as one of the above,
probably private_params if you are implementing it.


Example
--------------------------------------------------------------------------------

Interacting with the Readmill API via the gem is super-simple, first create an
API wrapper with your token wrapper,

    @client = Readmill::API.new(:token => token)

and after this you are free to explore the world of Readmill!

Maybe check out your current user,

     > @client.users.current
    => <Readmill::User 'jensnockert' (101)>

and what you are reading,

     > @client.users.current.readings
    => [<Readmill::Reading 'Jens Nockert' reading 'Around the World in Eighty Days' (1370)>]

or find an interesting book,

     > @client.books.match(:author => 'Jules Verne', :title => 'Around the world in 80 days')
    => <Readmill::Book 'Around the World in 80 Days' by 'Jules Verne' (459)>

or two,

     > @client.books.find(:id => 9)
    => <Readmill::Book 'Ulysses' by 'James Joyce' (9)>

and mark it as interesting,

     > @client.books.find(:id => 9).add_reading(:state => :interesting, :private => false)
    => <Readmill::Reading 'Jens Nockert' reading 'Ulysses' (1373)>

and so on.


Ruby API Documentation
--------------------------------------------------------------------------------

The connection has three main methods, books, users and readings. These are your
main entry points to the API, and as you can see above the API style is that you
call first the method for the type of object that you want to receive and then
the method to access the specific object or objects.

books is a proxy with the following methods

  - find, to find a specific book by id
  - match, to find a specific book by author, title and ISBN
  - all, to find all books (is actually just the 10 first)
  - search, to search for books
  - create, to add a new book to readmill


users is a proxy with the following methods

  - find, to find a specific user by id
  - current, to retrieve the current user


readings is a proxy with the following methods

  - find, to find a specific reading by id
  - all, to find all readings (is actually just the 10 first)


Of the three main classes of objects, some allow you to to do some additional
actions.

Readmill::Book

  - add_reading, to add a reading to the book

Readmill::User

  - readings, all readings corresponding to this user

Readmill::Reading

  - periods, all the periods you have been reading on this reading
  - locations, all the places where you have been reading on this reading
  - ping, send a ping that you are currently reading on this reading


REST API Documentation
--------------------------------------------------------------------------------

For more information about the Readmill REST API, read
[https://github.com/Readmill/API/wiki](https://github.com/Readmill/API/wiki).


Need an invite?
--------------------------------------------------------------------------------

Send a mail to jens at readmill.com with a little info about what you are
thinking of building and we will send you an invite code as soon as possible.

