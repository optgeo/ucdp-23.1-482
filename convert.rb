require 'csv'
require 'json'

PATH = ARGV[0]

CSV.foreach(PATH, :headers => true) {|r|
  f = {
    :type => 'Feature'
  }
  properties = r.to_h
  properties.delete('geom_wkt')
  %w{
    id relid year active_year type_of_violence conflict_new_id
    dyad_new_id side_a_new_id side_b_new_id number_of_sources
    where_prec priogrid_gid country_id event_clarity date_prec
    deaths_a deaths_b deaths_civilians deaths_unknown
    best high low 
  }.each {|k|
    properties[k] = properties[k].to_i
  }
  next unless properties['country_id'] == 482
  f[:properties] = properties
  f[:geometry] = {
    :type => 'Point',
    :coordinates => [
      properties.delete('longitude').to_f,
      properties.delete('latitude').to_f
    ]
  }
  maxzoom = 12
  minzoom = properties['best'] == 0 ? 8 : 1
  f[:tippecanoe] = {
    :layer => 'event',
    :minzoom => minzoom,
    :maxzoom => maxzoom
  }
  print "\x1e#{JSON.dump(f)}\n"
}

