module Fungiorbis
  class Statistics

    def initialize(name)
      @name = name
    end

    def get
      @stat = Stat.where(name: @name).first
      unless @stat && !@stat.update_needed?
        @stat = Stat.new name: @name unless @stat
        self.send(@name.to_sym)
      end
      data_with_localized_labels
    end

    private

    def monthly_specimens_count
      first_specimen = Specimen.order('date ASC').first.date

      data_array = []

      total = 0
      previous_total = 0
      start_month = first_specimen.month

      (first_specimen.year..Date.today.year).each do |current_year|
        end_month = current_year == Date.today.year ? Date.today.month : 12
        yearly = 0

        (start_month..end_month).each do |current_month|
          monthly = Specimen.where('extract(month from date) = ?', current_month).where('extract(year from date) = ?', current_year).count
          yearly += monthly
          total += yearly

          data_array << {
            'period' => "#{current_year}-#{current_month}",
            # 'monthly' => monthly,
            # 'yearly' => yearly,
            'total' => total
          } unless previous_total == total
          previous_total = total
        end

        start_month = 1
      end

      set_moris_data data_array, [:total]
    end


    def general_db_stats
      c = Characteristic.first
      habitats_count = c.all_habitat_keys.count
      c.all_habitat_keys.each { |h| habitats_count += c.subhabitat_keys(h).to_a.count }

      @stat.data = {
        'species_count' => Species.count,
        'genus_count' => Species.pluck(:genus).uniq.count,
        'familia_count' => Species.pluck(:familia).uniq.count,
        'edible_species_count' => Characteristic.group(:species_id).pluck(:edible).compact.count,
        'poisonous_species_count' => Characteristic.group(:species_id).pluck(:poisonous).compact.count,
        'medicinal_species_count' => Characteristic.group(:species_id).pluck(:medicinal).compact.count,
        'cultivated_species_count' => Characteristic.group(:species_id).pluck(:cultivated).compact.count,
        'specimens_count' => Specimen.count,
        'locations_count' => Location.count,
        'field_studies_count' => Specimen.all.pluck(:date).uniq.count,
        'users_count' => User.count,
        'habitats_count' => habitats_count,
        'substrates_count' => c.all_substrate_keys.count
      }
      @stat.data['labels'] = @stat.data.keys.map { |key| "stats.general_db_stats.label.#{key}" }
      @stat.save
    end


    def yearly_field_studies
      first_specimen = Specimen.order('date ASC').first.date

      data_array = []

      (first_specimen.year..Date.today.year).each do |current_year|
        specimens = Specimen.where('extract(year from date) = ?', current_year)

        field_studies = specimens.pluck(:date).uniq.count
        locations = specimens.pluck(:location_id).uniq.count
        specimens_count = specimens.count

        data_array << {
          'period' => current_year,
          'field_studies' => field_studies,
          'locations' => locations,
          'specimens_count' => specimens_count
        } unless field_studies == 0 || locations == 0 || specimens_count == 0
      end

      set_moris_data data_array, [:field_studies, :locations, :specimens_count], {'parseTime' => false }
    end


    def set_moris_data(data_array, ykeys, options={})
      @stat.data = {
        'element' => @name,
        'data' => data_array,
        'xkey' => :period,
        'ykeys' => ykeys,
        'labels' => ykeys.map { |key| "stats.#{@name}.label.#{key}" },
        'pointSize' => 1,
        'hideHover' => 'auto',
        'resize' => false
      }
      @stat.data.merge! options
      @stat.save
    end

    def data_with_localized_labels
      @stat.data['labels'] = @stat.data['labels'].map { |label| I18n.t(label) }
      @stat.data
    end
  end
end