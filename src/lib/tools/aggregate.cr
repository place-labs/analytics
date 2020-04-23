module PlaceOS::Analytics
  # Methods for aggregating individual location metrics into higher level
  # groupings.
  module Tools::Aggregate
    extend self

    # Calculate the mean of list of values, or nil if empty.
    def mean(values : Enumerable(Float64)) : Float64?
      if values.empty?
        nil
      else
        values.sum / values.size.to_f
      end
    end

    # Calculates the average of a list of values, ignoring nil's.
    def mean(values : Enumerable(Float64?))
      # Note: #compact does not exist on Enumerable for some reason?
      mean values.compact_map { |x| x }
    end

    # Aggregate a set of single values.
    def mean(value_hash : Hash(String, Float64))
      mean value_hash.values
    end

    # Aggegate a set of values by a location attribute
    def mean(value_hash : Hash(String, Float64), group_by attr : String)
      group value_hash, attr, &->mean(Enumerable(Float64))
    end

    # Aggregate a set of uniform series, producing a single series with each
    # point representing the mean value of all components at that time.
    def mean_series(values : Enumerable(Indexable(Float64?)))
      values.reduce do |acc, i|
        acc.zip(i).map &->mean({Float64?, Float64?})
      end
    end

    # Aggregate a set of uniform series, producing a single series with each
    # point representing the mean value of all components at that time.
    def mean_series(value_hash : Hash(String, Array(Float64?)))
      mean_series value_hash.values
    end

    # :ditto:
    def mean_series(value_hash : Hash(String, Array(Float64?)), group_by attr : String)
      group value_hash, attr, &->mean_series(Enumerable(Array(Float64?)))
    end

    # Given a query result *value_hash*, groups these based on location
    # attributes the aggregate each of these groups.
    def group(value_hash : Hash(String, T), attr : String, &op : Enumerable(T) -> U) forall T, U
      # Group the locations in the hash based an the passed attr.
      value_groups = {} of String => Array(T)
      value_hash.each do |id, value|
        location = Model::Location.find id
        group = location ? location[attr].to_s : "unknown"
        value_groups[group] ||= [] of T
        value_groups[group] << value
      end

      # Reduce each of these groups with the specified aggregator
      value_groups.transform_values do |values|
        op.call values.as(Enumerable(T))
      end
    end
  end
end
