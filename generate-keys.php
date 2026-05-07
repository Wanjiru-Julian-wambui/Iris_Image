<?php
$config = ['private_key_bits' => 4096, 'private_key_type' => OPENSSL_KEYTYPE_RSA];
$res = openssl_pkey_new($config);
openssl_pkey_export($res, $privateKey);
$publicKey = openssl_pkey_get_details($res)['key'];
file_put_contents('storage/oauth-private.key', $privateKey);
file_put_contents('storage/oauth-public.key', $publicKey);
echo 'Keys generated successfully!';