require "active_record_or/version"

module ActiveRecordOr
  class Or
    def initialize(left)
      @left = left
    end

    def method_missing(method, *args, &block)
      last_left_constraint = @left.constraints.last
      return @left.send(method, *args, &block) unless last_left_constraint

      raw_right = @left.unscoped.send(method, *args, &block)

      or_based_constraints = last_left_constraint.or(raw_right.constraints.last)
      right = @left.send(method, *args, &block)
      right.where_values = [or_based_constraints]
      right
    end
  end

  def or
    Or.new(self)
  end
end

ActiveRecord::Relation.send(:include, ActiveRecordOr)
