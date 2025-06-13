#!/usr/bin/env python3 
import hashlib
import bech32

public_key_hex = "036adc3bdf21e6f9a0f0fb0066bf517e5b7909ed1563d6958a10993849a7554075"
public_key = bytes.fromhex(public_key_hex)

# 1. Hash the Public Key
sha256_hash = hashlib.sha256(public_key).digest()
ripemd160_hash = hashlib.new('ripemd160', sha256_hash).digest()

# 2. Witness Program (hash160)
witness_program = ripemd160_hash

# 3. Encode as Bech32
witness_version = 0  # P2WPKH uses witness version 0
hrp = 'bcrt'  # Use 'bc' for mainnet, 'bcrt' for regtest

bech32_address = bech32.encode(hrp, witness_version, witness_program)

print(f"The Bech32 address is: {bech32_address}")
