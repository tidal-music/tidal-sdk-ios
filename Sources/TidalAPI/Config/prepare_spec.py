"""Preserve quoted media-type parameters that Swift codegen otherwise strips."""

import json
import sys


def prepare_spec(spec):
    for path in spec.get("paths", {}).values():
        for method in ("get", "put", "post", "delete", "options", "head", "patch", "trace"):
            operation = path.get(method, {})
            content = operation.get("requestBody", {}).get("content", {})
            if len(content) == 1:
                media_type = next(iter(content))
                if '"' in media_type:
                    # A vendor extension bypasses Swift5Codegen's quote removal.
                    # JSON escaping also produces a valid Swift string literal for MIME headers.
                    operation["x-swift-content-type"] = json.dumps(media_type)
    return spec


if __name__ == "__main__":
    with open(sys.argv[1]) as source:
        spec = prepare_spec(json.load(source))
    with open(sys.argv[2], "w") as destination:
        json.dump(spec, destination)
