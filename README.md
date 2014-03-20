# Cassmap

<p><b>Consider this pre-alpha and use at your own risk. This will take at least a month to not suck.</b></p>
<p>Interested in the proof of concept? see <a href="https://github.com/rssvihla/bootcamp_time_series/tree/master/lib/cassmap">here</a></p>

<p>Cassmap provides ActiveRecord like functionality with <b>full query table tracking</b> for those on Rails wishing to use
    the excellent Cassandra distributed data store.
</p>


#What's query table tracking?

<p>Good Cassandra data modeling embraces the distributed nature of the database, and makes heavy use of
materialized views or as I like to refer to them "Query Tables". In this concept you denormalize your data
and model your tables after the queries you need to preform in your application. Denormalization of course has
downsides when it comes to data consistency and performance if you're making roundtrips for each table.
</p>

<p>Cassandra's api helps us solve the data consistency between query tables problem with the BATCH statment. Other
Active Record implmentations do not allow you to batch these updates easily and most people resort to hand CQL and respositories
to keep their data consisten. I aim to eliminate this boilerplate.</p>

## Usage

### ActiveModel Implementation

I'm aiming to be as compatible as possible with ActiveRecord's in syntax, I do not believe this will be 100%
possible

In the simplest case, given a model that looks like this:

    class Trade < Cassmap::Base
        add_query_table :trades_by_price
    end

and two tables that look like this:

    CREATE TABLE trades ( id timeuuid, price decimal, quantity int, symbol text, PRIMARY KEY(id));
    CREATE TABLE trades_by_price ( id timeuuid, price decimal, quantity int, symbol text, PRIMARY KEY(price));

and client code that looks like this:

    #returns all trades with a price of
    Trade.where( price: 100.00)

    #saves data to all related query tables
    #Trade.create( price: 100.00, quantity: 10, symbol: 'AA', id: UUID.timestamp_create )

<p>In more complex cases Cassmap knows when there are columns missing, and knows when there is

#### Pending important features

* Dirty Tracking
* Callback support
* Ability to apply transforms on query tables where columns are stored in a different format or is a combination of values
* Smarter handling of Where. What to do if you have two keys that overlap?

### Migrations support

<p>Typical Rails rule apply. Time format, followed by a file name that matches the class name.

    #file named 2014_01_23_11_43_98_add_trades_by_minute_table_migration.rb
    class AddTradesByMinuteTableMigration < Cassmap::Migration

        def self.up
            execute <<CQL
            CREATE TABLE trades_by_price (
            id timeuuid,
            price decimal,
            quantity int,
            symbol text,
            PRIMARY KEY(price));
    CQL
        end

        def self.down
            execute "drop trades_by_price"
        end
    end

after you've defined your schema files the typical Rake db commands work fine, just with cass as the parameter.

    rake cass:create # creates database for environment based on cassmap.yml
    rake cass:setup
    rake cass:seed
    rake cass:drop
    rake cass:migrate

## Installation

Add this line to your application's Gemfile:

    gem 'cassmap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cassmap

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

