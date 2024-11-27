#!/bin/sh

# grants keys
openssl genrsa -out grants_encoding_key 2048
openssl rsa -pubout -in grants_encoding_key -out grants_decoding_key

# public token keys
openssl genrsa -out token_encoding_key 2048
openssl rsa -pubout -in token_encoding_key -out token_decoding_key
