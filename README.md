ActiveRecord OR
===============

Let's say you were trying to implement a SOPA enforcement tool:

    class Blog < ActiveRecord::Base
      has_one :author
      ...
      scope :infringing,         where("artist_mentions_count > 0")
      scope :main_competition,   where("competition_rank > 7")
      scope :generally_disliked, where("subjective_dislike_rating > 3")
      ...
    end

This would let you write handy things like

    to_blacklist = Blog.infringing.or.main_competition.or.generally_disliked
    to_harass    = Blog.joins(:author).where('authors.name' => 'Julian')\
                                      .or.generally_disliked

Also, if you call `or` on a condition-less scope, it will be ignored:

    Blog.scoped.or.where(:name => 'Julian')

This means you can start off the query with an `or`, in case you don't
know the state of the scope.

The end.

Credits
=======

Gem extracted from (i.e. mostly sponsored by) http://www.hfa3.org/

TODO
====

Dispite the name of the gem, I'll probably add `not` logic also. Seems
like `or` and `not` are really all that's missing from AR scopes.
