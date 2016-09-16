module EnMasse::Refinements

  refine ::ActiveRecord::Base.singleton_class do

    def insert_collection collection
      if sequence_name.present?
        ids = allocate_ids(collection.count)
        collection.zip(ids).each do |record, id|
          record.id = id
          record.update_foreign_keys
        end
      end
      values = collection.map{|record|
        "(#{ record.values_for_insert(column_names).join(",") })"
      }.join(",")
      ActiveRecord::Base.connection.execute %Q[
        INSERT INTO #{table_name} (#{column_names.join(",")})
        VALUES #{values};
      ]
    end

    def reflect_on_dependent_associations
      [:has_one, :has_many].flat_map { |association_kind|
        reflect_on_all_associations(association_kind).reject(&:through_reflection)
      }
    end

    private

    def primary_key_sequence_update_lock
      1
    end

    def allocate_ids amount
      next_value = connection.execute(%Q[
        SELECT pg_advisory_lock(#{primary_key_sequence_update_lock}),
               setval('#{sequence_name}', greatest(
                                             (select max(id) from #{table_name}),
                                             nextval('#{sequence_name}')-1)
                                          + #{amount}),
               currval('#{sequence_name}'),
               pg_advisory_unlock(#{primary_key_sequence_update_lock});
                                      ]).first["currval"].to_i
      start_value = next_value - amount + 1
      start_value..next_value
    end

  end

  refine ::ActiveRecord::Base do

    def update_foreign_keys
      id = self[self.class.primary_key]
      self.class.reflect_on_dependent_associations.each do |association|
        foreign_key = association.foreign_key
        dependents = [send(association.name)].flatten.compact
        dependents.each do |dependent|
          dependent[foreign_key] = id
        end
      end
    end

    def values_for_insert column_names
      column_names.map{|column_name|
        column = column_for_attribute(column_name)
        if %w(created_at updated_at).include? column_name
          "now()"
        else
          ActiveRecord::Base.connection.quote(self.send(column_name))
        end
      }
    end

    def new_dependents
      dependents.select(&:new_record?)
    end

    def dependents
      direct_dependents = self.class
        .reflect_on_dependent_associations
        .flat_map{|association| self.send(association.name)}
        .compact
        .uniq
      direct_dependents + direct_dependents.flat_map{|dependent| dependent.dependents}
    end

  end
end
