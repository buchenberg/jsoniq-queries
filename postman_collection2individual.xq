jsoniq version "1.0";
(:used for file functions:)
import module namespace file = "http://expath.org/ns/file";
(:
Input file to be a param in the Zorba CLI call
For example:
zorba --external-variable json-file:=$INPUT_JSON -f -q $INPUT_QUERY
:)
declare variable $json-file external;
(:Parse the input file:)
let $input-text := parse-json(file:read-text($json-file))
(:iterate over the child collections:)
for $collection in $input-text.item[]
(:build custom object and load into variable:)
let $part :=
{
	"variables": [],
	"info": {
		"name": $collection.name,
		"_postman_id": "82c18dc5-ab0b-b81a-0182-e1c98cbe8921",
		"description": $collection.description,
		"schema": "https://schema.getpostman.com/json/collection/v2.0.0/collection.json"
	},
	"item":
  for $call in $collection.item[] return $call
}
(:choose a file name:)
let $filename := concat(replace($collection.name, " ", "_"),".json")
(:write the file:)
return file:write-text(concat("./out/", $filename), serialize($part))
