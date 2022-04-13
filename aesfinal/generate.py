import secrets
block_num = 10000
text_len = 16 * block_num

with open("long_test.txt", "w") as f:
    f.write(secrets.token_hex(text_len))
f.close()
