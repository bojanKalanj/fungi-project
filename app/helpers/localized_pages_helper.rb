module LocalizedPagesHelper

  def all_stats
    [['species_count', :species],
     ['genus_count', :systematics],
     ['familia_count', :systematics],
     ['edible_species_count', :edible],
     ['poisonous_species_count', :poisonous],
     ['medicinal_species_count', :medicinal],
     ['cultivated_species_count', :cultivated],
     ['habitats_count', :habitats],
     ['substrates_count', :substrates],
     ['specimens_count', :specimens],
     ['locations_count', :locations],
     ['field_studies_count', :field_studies],
     ['samples_count', :samples],
     ['users_count', :users],
     ['photos_count', :photos],
    ]
  end
end