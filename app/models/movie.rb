class Movie < ActiveRecord::Base
    def self.all_ratings
        pluck(:rating).uniq
    end
    
    def self.with_ratings(ratings)
        where(rating: ratings)
    end
end
