# PassKit

Crystal shard for creating signed Apple Passes.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     passkit:
       github: red-ant/passkit
   ```

2. Run `shards install`

## Configuration

Configuration is achieved by specifying paths to various certificates private keys.

```bash
# Pass certificate
export SIGNING_CERT=/path/to/cert.pem

# Pass key certificate
export PRIVATE_KEY=/path/to/passkey.pem

# Pass key certificate password (optional)
export PRIVATE_KEY_PASSWORD=purplemonkeydishwasher

# Apple Worldwide Developer Relations Certification Authority certificate
export WWDR_CERT/path/to/wwdr.pem
```

## Usage

```crystal
require "passkit"

# Create a new pass definition
pass = PassKit::Pass.new(
  pass_type_idenitifer: "pass.com.example",
  organization_name: "Willy Wonka",
  serial_number: "12345",
  team_identifier: "TM123",
  description: "The golden ticket",
  logo_text: "Willy Wonka inc."
)

# Or ingest a pass.json
pass = PassKit::Pass.from_json(File.read("pass.json"))

# Now generate a signed .pkpass file
pk_pass = PassKit::PKPass.new(pass)

# Do something with the generated file
File.write("GoldenTicket.pkpass", pk_pass.to_s)
```

## Contributing

1. Fork it (<https://github.com/red-ant/passkit/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
