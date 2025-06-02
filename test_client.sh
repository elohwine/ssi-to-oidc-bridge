#!/bin/bash
client=$(docker run --rm -it \
  --network ory-hydra-net \
  oryd/hydra:v2.2.0 \
  create client --skip-tls-verify \
  --name wordpress \
  --secret ^x1dgFBL5XsUDxCWeB \
  --grant-type authorization_code \
  --response-type token,code,id_token \
  --scope openid \
  --redirect-uri http://localhost/wordpress \
  -e http://hydra:4445 \
  --format json)

echo "$client"

client_id=$(echo "$client" | jq -r ".client_id")

docker run --rm -it \
  --network ory-hydra-net \
  oryd/hydra:v2.2.0 \
  perform authorization-code --skip-tls-verify \
  --client-id "$client_id" \
  --client-secret ^x1dgFBL5XsUDxCWeB \
  --redirect http://localhost/wordpress \
  --scope openid \
  --auth-url http://localhost:5004/oauth2/auth \
  --token-url http://hydra:4444/oauth2/token \
  -e http://hydra:4444