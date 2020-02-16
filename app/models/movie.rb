class Movie < ActiveRecord::Base
    def self.all_ratings
        # ['G','PG','PG-13','R']
        Movie.uniq.pluck(:rating).sort
    end
    
    def self.with_ratings(ratings)
        self.where(rating: ratings)
    end
end
