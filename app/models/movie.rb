class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G', 'PG', 'PG-13', 'R', 'NC-17'].map{|a| a}
    end
end
