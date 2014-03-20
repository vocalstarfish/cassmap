Rspec.configure do |config|
  config.before(:each) do
    cql.execute "drop keyspace if exists cassmap_test"
    cql.execute <<-CQLKEYSPACE
      create keyspace if not exists cassmap_test with replication = {
      'class': 'SimpleStrategy',
      'replication_factor':1
      };
CQLKEYSPACE

    cql.execute <<CQLCREATE
    create table cassmap_test.my_models (
    id timeuuid,
    name text,
    date_started timestamp,
    times_visited int,
    primary key(id)
    )
CQLCREATE

  end

  config.after(:each) do
    cql.execute "drop keyspace if exists cassmap_test"
  end

end
