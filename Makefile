FN := GEDEvent_v23_1

world: 
	curl -O -C - https://ucdp.uu.se/downloads/ged/ged231-csv.zip
	unzip -o ged231-csv.zip
	ruby convert.rb $(FN).csv > $(FN).geojsons
	ogr2ogr -f FlatGeobuf $(FN).fgb $(FN).geojsons
	ogr2ogr -f GeoJSON $(FN).geojson $(FN).geojsons
	tippecanoe -f -o $(FN).mbtiles $(FN).geojsons
	pmtiles convert $(FN).mbtiles $(FN).pmtiles
	rm $(FN).csv $(FN).geojsons
