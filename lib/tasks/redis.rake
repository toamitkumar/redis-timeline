  desc "create users"
namespace :redis do
  task :create_users => [:environment] do
    bloggers = [
      {:name => 'Amit Kumar', :person_id => 1, :vendor_individual_id => 2},
      {:name => 'Thomas Newton', :person_id => 3, :vendor_individual_id => 4},
      {:name => 'Marianne Blum', :person_id => 5, :vendor_individual_id => 6},
      {:name => 'Dipen Shah', :person_id => 7, :vendor_individual_id => 8},
      {:name => 'Yashasree Barve', :person_id => 9, :vendor_individual_id => 10}
    ]  
    ::Blogger.initialize_all(bloggers)
  end
end