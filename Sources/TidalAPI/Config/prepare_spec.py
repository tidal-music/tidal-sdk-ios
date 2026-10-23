"""Add Swift decoding metadata without changing the committed API contract."""

import json
import sys

with open(sys.argv[1]) as source:
    spec = json.load(source)

schemas = spec["components"]["schemas"]
atomic_response = schemas.get("Atomic_Operations_Response")
if atomic_response:
    results = atomic_response["properties"]["atomic:results"]["items"]
    cases = []
    for index, result in enumerate(results["oneOf"]):
        resource = result["properties"]["data"]["$ref"].rsplit("/", 1)[1]
        resource_name = resource.removesuffix("_Resource_Object")
        creation = schemas[resource_name + "CreateOperation_Payload_Data"]
        resource_type = creation["properties"]["type"]["enum"][0]
        suffix = str(index) if index else ""
        model = "AtomicOperationsResponseAtomicResultsInnerOneOf" + suffix
        result["title"] = model
        cases.append({"type": resource_type, "model": model})
    results["x-swift-nested-resource-cases"] = cases

with open(sys.argv[2], "w") as output:
    json.dump(spec, output)
