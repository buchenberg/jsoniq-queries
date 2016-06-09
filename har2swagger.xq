jsoniq version "1.0";

import module namespace file = "http://expath.org/ns/file";
(:
import module namespace functx = "http://www.functx.com";
:)

declare variable $json-file external;

let $input-text := parse-json(file:read-text($json-file))

for $log in $input-text.log
return
{
	"swagger": "2.0",
	"info": {
		"version": "1.0.0",
		"title": "Swagger Test",
		"description": "A test swagger-2.0 specification",
		"termsOfService": "http://swagger.io/terms/",
		"contact": {
			"name": "G. Buchenberger"
			},
			"license": {
				"name": "MIT"
			}
			},
			"host": "petstore.swagger.io",
			"basePath": "/api",
			"schemes": [
			"https"
			],
			"consumes": [
			"application/json"
			],
			"produces": [
			"application/json"
			],
			"paths":
				(:process request and response:)
				for $entry in $log.entries[][1]

				(:let $url := substring-after($entry.request.url, "https:/"):)
				let $url := replace($entry.request.url, "(?:https:/)(.*)(?:/.*)", "$1")
				(:
				where starts-with($url, "/c")
				:)
				return

					{
						$url: {
						lower-case($entry.request.method): {
							"description": "A description",
							"produces": [
							"application/json"
							],
							"responses": {
								$entry.response.status: {
									"description": $entry.response.statusText,
									"schema": {
										"type": "array",
										"items": {}
										}
									}
								}
							}
						}
					}
				}
