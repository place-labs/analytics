module PlaceOS::Analytics
  # Methods for aggregating individual location metrics into higher level
  # groupings.
  module Tools::Aggregate
    extend self

    # Aggregate a set of single values.
    def mean(value_hash : Hash(String, Float64))
      value_hash.values.sum / value_hash.size.to_f
    end

    # Aggegate a set of values by a location attribute
    # FIXME: implement grouping based on location metadata
    def mean(value_hash : Hash(String, Float64), group_by attr : String)
      {
        workstations: 0.0,
        workpoints:   0.0,
        informal:     0.0,
        formal:       0.0,
        social:       0.0,
        unknown:      mean(value_hash),
      }
    end

    # Aggregate a set of uniform series, producing a single series with each
    # point representing the mean value of all components at that time.
    def mean_series(value_hash : Hash(String, Array(Float64?)))
      value_hash.values.reduce do |acc, i|
        acc.zip(i).map do |a, b|
          if a && b
            (a + b) / 2.0
          elsif a
            a
          elsif b
            b
          else
            nil
          end
        end
      end
    end
  end
end
