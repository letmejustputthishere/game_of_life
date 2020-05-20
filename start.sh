ID=$(xxd -u -p canisters/game_of_life/_canister.id)
CRC=$(python2 -c "import crc8;h=crc8.crc8();h.update('$ID'.decode('hex'));print(h.hexdigest())")

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
xdg-open "http://127.0.0.1:8000/?canisterId=ic:$ID$CRC"
elif [[ "$OSTYPE" == "darwin"* ]]; then
open "http://127.0.0.1:8000/?canisterId=ic:$ID$CRC"
fi
