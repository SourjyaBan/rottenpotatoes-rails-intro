class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G', 'NC-17', 'PG', 'PG-13', 'R'].map{|a| a}
    end
end
