require_relative 'test_helper'

ActiveRecord::Base.silence_stream(STDOUT) do
  ActiveRecord::Schema.define do

    create_table :authors do |t|
      t.string :name
    end

    create_table :blogs do |t|
      t.string  :name
      t.integer :artist_mentions_count
      t.integer :competition_rank
      t.integer :subjective_dislike_rating
    end

  end
end

class Blog < ActiveRecord::Base
  belongs_to :author

  scope :infringing,         where("artist_mentions_count > 0")
  scope :main_competition,   where("competition_rank > 7")
  scope :generally_disliked, where("subjective_dislike_rating > 3")
end

class Author < ActiveRecord::Base
  has_many :blogs
end

describe ActiveRecord::Relation do
  describe '#or' do
    it 'can combine conditions with OR' do
      to_blacklist = Blog.infringing.or.main_competition.or.generally_disliked
      # don't know what's up with all the extra parens, but I can't see how they
      # hurt anything other than my eyes
      to_blacklist.where_sql.must_equal(
        "WHERE (((((artist_mentions_count > 0)"\
        " OR (competition_rank > 7)))"\
        " OR (subjective_dislike_rating > 3)))")

    end

    it 'preserves joins' do
      to_harass = Blog.joins(:author).where(:name => 'Julian')\
                                     .or.generally_disliked
      to_harass.join_sql.must_equal(
       %(INNER JOIN "authors" ON "authors"."id" = "blogs"."author_id") )
    end
  end
end
